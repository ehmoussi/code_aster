! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------
! person_in_charge: mickael.abbas at edf.fr
!
module HHO_statcond_module
!
use HHO_type
use HHO_size_module
use HHO_utils_module
use NonLin_Datastructure_type
!
implicit none
!
private
#include "asterf_types.h"
#include "asterfort/HHO_size_module.h"
#include "asterfort/assert.h"
#include "asterfort/calcul.h"
#include "asterfort/celces.h"
#include "asterfort/cesexi.h"
#include "asterfort/copisd.h"
#include "asterfort/detrsd.h"
#include "asterfort/getResuElem.h"
#include "asterfort/infniv.h"
#include "asterfort/inical.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jevech.h"
#include "asterfort/jeveuo.h"
#include "asterfort/megeom.h"
#include "asterfort/memare.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmdebg.h"
#include "asterfort/nmtime.h"
#include "asterfort/readMatrix.h"
#include "asterfort/readVector.h"
#include "asterfort/reajre.h"
#include "asterfort/redetr.h"
#include "asterfort/sdmpic.h"
#include "asterfort/utmess.h"
#include "asterfort/vrrefe.h"
#include "asterfort/writeMatrix.h"
#include "asterfort/writeVector.h"
#include "blas/daxpy.h"
#include "blas/dcopy.h"
#include "blas/dgemm.h"
#include "blas/dgemv.h"
#include "blas/dpotrf.h"
#include "blas/dpotrs.h"
#include "blas/dgetrf.h"
#include "blas/dgetrs.h"
#include "jeveux.h"
!
! --------------------------------------------------------------------------------------------------
!
! HHO - Static condensation
!
! Routine to compute static condensation or decondensation
!
! --------------------------------------------------------------------------------------------------
    public :: hhoCondStaticMeca, hhoDecondStaticMeca
    public :: hhoMecaDecondOP, hhoMecaCondOP
    private :: hhoUpdateCellValues, hhoCodeRet
!
contains
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoCodeRet(codret, index_success)

    implicit none
!
        character(len=19), intent(in) :: codret
        integer, intent(out)          :: index_success
!
! ----------------------------------------------------------------------
!
! HHO - mechanics
!
! Summarize error of static condensation
!
! ----------------------------------------------------------------------
!
!
! In  codret  : CHAM_ELEM from TE
! Out index_success :  0 if success / 1  if fails
!
        integer :: iret, jcesd, jcesl, nbmail, icmp
        integer :: ima, iad
        character(len=8) :: nomgd
        character(len=19) :: chamns
        integer, pointer :: cesv(:) => null()
        character(len=8), pointer :: cesk(:) => null()
!
! ----------------------------------------------------------------------
!
        call jemarq()
!
        index_success = 0
!
! --- ON TRANSFORME LE "CHAM_ELEM" EN UN "CHAM_ELEM_S"
!
        chamns = '&&HHO.CHAMNS'
!
! -- EN ATTENDANT DE FAIRE MIEUX, POUR PERMETTRE MUMPS/DISTRIBUE :
        call sdmpic('CHAM_ELEM', codret)
!
        call celces(codret, 'V', chamns)
!
! --- ACCES AU CHAM_ELEM_S
!
        call jeveuo(chamns//'.CESK', 'L', vk8=cesk)
        call jeveuo(chamns//'.CESD', 'L', jcesd)
        call jeveuo(chamns//'.CESV', 'L', vi=cesv)
        call jeveuo(chamns//'.CESL', 'L', jcesl)
!
!     CHAM_ELEM/ELGA MAIS EN FAIT : 1 POINT ET 1 SOUS_POINT PAR ELEMENT
        if ((zi(jcesd-1+3).ne.1) .or. (zi(jcesd-1+4).ne.1)) then
            ASSERT(ASTER_FALSE)
        endif
!
        nomgd = cesk(2)
        if (nomgd .ne. 'CODE_I') then
            ASSERT(ASTER_FALSE)
        endif
!
        nbmail = zi(jcesd-1+1)
        icmp = zi(jcesd-1+2)
        if (icmp .ne. 1) then
            ASSERT(ASTER_FALSE)
        endif
!
        do ima = 1, nbmail
!
            call cesexi('C', jcesd, jcesl, ima, 1,&
                        1, icmp, iad)
            if (iad > 0) then
                iret = cesv(iad)
                if (iret > 0) then
                    index_success = 1
                    go to 999
                else if (iret < 0) then
                    call utmess('A', 'HHO1_14', si=iret)
                endif
            end if
        end do
!
999 continue
!
        call detrsd('CHAM_ELEM_S', chamns)
!
        call jedema()
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoCondStaticMeca(hhoCell, hhoData, lhs, rhs, l_lhs_sym, lhs_local, rhs_local, &
                                 codret)
!
    implicit none
!
        type(HHO_Cell), intent(in) :: hhoCell
        type(HHO_Data), intent(in) :: hhoData
        real(kind=8), intent(in)   :: lhs(MSIZE_TDOFS_VEC, MSIZE_TDOFS_VEC)
        real(kind=8), intent(in)   :: rhs(MSIZE_TDOFS_VEC)
        aster_logical, intent(in)  :: l_lhs_sym
        real(kind=8), intent(out)  :: lhs_local(MSIZE_FDOFS_VEC, MSIZE_FDOFS_VEC)
        real(kind=8), intent(out)  :: rhs_local(MSIZE_FDOFS_VEC)
        integer, intent(out)       :: codret
!
! --------------------------------------------------------------------------------------------------
!   HHO - mechanics
!
!   Compute the static condensation for mechanics
!   In hhoCell      : the current HHO Cell
!   In hhoDta       : information on HHO methods
!   In lhs          : lhs with cell and faces terms (is symmetric)
!   In rhs          : rhs with cell and faces terms
!   In l_lhs_sym    : lhs is symmetric ?
!   Out lhs_local   : lhs after static condensation (is symmetric)
!   Out rhs_local   : rhs after static condensation
!   Out codret      : sucess - 0 / fail - index of the line
! --------------------------------------------------------------------------------------------------
!
! ----- Local variables
        integer :: faces_dofs, info, cbs, fbs, total_dofs, ipiv(MSIZE_CELL_VEC)
        real(kind=8) :: rhs_T(MSIZE_CELL_VEC), rhs_F(MSIZE_FDOFS_VEC)
        real(kind=8) :: K_TT(MSIZE_CELL_VEC, MSIZE_CELL_VEC)
        real(kind=8) :: K_FT(MSIZE_FDOFS_VEC, MSIZE_CELL_VEC)
        real(kind=8) :: K_TF(MSIZE_CELL_VEC, MSIZE_FDOFS_VEC)
        real(kind=8) :: K_FF(MSIZE_FDOFS_VEC, MSIZE_FDOFS_VEC)
!
! ---- Number of dofs
        call hhoMecaDofs(hhoCell, hhoData, cbs, fbs, total_dofs)
        faces_dofs = total_dofs - cbs
!
        K_TT = 0.d0
        K_TF = 0.d0
        K_FT = 0.d0
        K_FF = 0.d0
        rhs_T = 0.d0
        rhs_F = 0.d0
        codret = 0
!
        K_TT(1:cbs, 1:cbs) = lhs((faces_dofs+1):total_dofs, (faces_dofs+1):total_dofs)
        K_TF(1:cbs, 1:faces_dofs) = lhs((faces_dofs+1):total_dofs, 1:faces_dofs)
        K_FF(1:faces_dofs, 1:faces_dofs) = lhs(1:faces_dofs, 1:faces_dofs)
        K_FT(1:faces_dofs, 1:cbs) = lhs(1:faces_dofs, (faces_dofs+1):total_dofs)
        rhs_T(1:cbs) = rhs((faces_dofs+1):total_dofs)
        rhs_F(1:faces_dofs) = rhs(1:faces_dofs)
!
        info = 0
        if(l_lhs_sym) then
! ---- factorize K_TT
            info = 0
            call dpotrf('U', cbs, K_TT, MSIZE_CELL_VEC, info)
!
! ---- Sucess ?
            if(info .ne. 0) then
                codret = info
                call utmess('A', 'HHO1_8', si = info)
                go to 999
            end if
!
! ---- Solve K_TF = K_TT^-1 * K_TF
            info = 0
            call dpotrs('U', cbs, faces_dofs, K_TT, MSIZE_CELL_VEC, K_TF, MSIZE_CELL_VEC, info)
!
! ---- Sucess ?
            if(info .ne. 0) then
                call utmess('F', 'HHO1_9', si = info)
            end if
!
! ---- Solve rhs_T = K_TT^-1 * rhs
            info = 0
            call dpotrs('U', cbs, 1, K_TT, MSIZE_CELL_VEC, rhs_T, MSIZE_CELL_VEC, info)
!
! ---- Sucess ?
            if(info .ne. 0) then
                call utmess('F', 'HHO1_9', si = info)
            end if
        else
! ---- factorize K_TT
            info = 0
            ipiv = 0
            call dgetrf(cbs, cbs, K_TT, MSIZE_CELL_VEC, ipiv, info)
!
! ---- Sucess ?
            if(info .ne. 0) then
                call utmess('E', 'HHO1_13', si = info)
            end if
!
! ---- Solve K_TF = K_TT^-1 * K_TF
            info = 0
            call dgetrs('N', cbs, faces_dofs, K_TT, MSIZE_CELL_VEC, ipiv, K_TF, MSIZE_CELL_VEC,info)
!
! ---- Sucess ?
            if(info .ne. 0) then
                call utmess('F', 'HHO1_9', si = info)
            end if
!
! ---- Solve rhs_T = K_TT^-1 * rhs
            info = 0
            call dgetrs('N', cbs, 1, K_TT, MSIZE_CELL_VEC, ipiv, rhs_T, MSIZE_CELL_VEC, info)
!
! ---- Sucess ?
            if(info .ne. 0) then
                call utmess('F', 'HHO1_9', si = info)
            end if
        end if
!
! ---- Copy of rhs_T in PCSRTIR ('OUT' to fill)
        call writeVector('PCSRTIR', cbs, rhs_T)
!
! ---- Copy of K_TF in PCSMTIR ('OUT' to fill)
        call writeMatrix('PCSMTIR', cbs, faces_dofs, ASTER_FALSE, K_TF)
!
! ---- Compute K_FF = K_FF - K_FT * K_TF
!
        call dgemm('N', 'N', faces_dofs, faces_dofs, cbs, -1.d0, K_FT, MSIZE_FDOFS_VEC, &
                    & K_TF, MSIZE_CELL_VEC, 1.d0, K_FF, MSIZE_FDOFS_VEC)
!
! ---- Compute rhs_F = rhs_F - K_FT * rhs_T
        call dgemv('N', faces_dofs, cbs, -1.d0, K_FT, MSIZE_FDOFS_VEC, rhs_T, 1, 1.d0, rhs_F, 1)
!
! ---- local matrix and vector
        lhs_local = 0.d0
        lhs_local(1:faces_dofs, 1:faces_dofs) = K_FF(1:faces_dofs, 1:faces_dofs)
!
        rhs_local = 0.d0
        rhs_local(1:faces_dofs) = rhs_F(1:faces_dofs)
!
999 continue
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoDecondStaticMeca(hhoCell, hhoData)
!
    implicit none
!
        type(HHO_Cell), intent(in) :: hhoCell
        type(HHO_Data), intent(in) :: hhoData
!
! --------------------------------------------------------------------------------------------------
!   HHO - mechanics
!
!   Compute the static decondensation for mechanics
!   In hhoCell      : the current HHO Cell
!   In hhoDta       : information on HHO methods
! --------------------------------------------------------------------------------------------------
!
! ----- Local variables
        integer :: faces_dofs, cbs, fbs, total_dofs, jincm
        real(kind=8) :: K_TF(MSIZE_CELL_VEC, MSIZE_FDOFS_VEC)
        real(kind=8) :: rhs_T(MSIZE_CELL_VEC), sol_F(MSIZE_FDOFS_VEC)
!
! ---- Number of dofs
        call hhoMecaDofs(hhoCell, hhoData, cbs, fbs, total_dofs)
        faces_dofs = total_dofs - cbs
!
        K_TF = 0.d0
        rhs_T = 0.d0
        sol_F = 0.d0
!
! ---- We get the solution on the faces (!! respect the order of faces)
        call readVector('PDEPLPR', faces_dofs, sol_F)
!
! ---- Get the volumetric vertor: rhs_T in PCSRTIR ('IN' to read)
        call readVector('PCSRTIR', cbs, rhs_T)
!
! ---- Get the K_TF matrix in PCSMTIR ('IN' to read)
        call readMatrix('PCSMTIR', cbs, faces_dofs, ASTER_FALSE, K_TF)
!
! ---- Find solT: sol_T = rhs_T - K_TF*sol_F
        call dgemv('N', cbs, faces_dofs, -1.d0, K_TF, MSIZE_CELL_VEC, sol_F, 1, 1.d0, rhs_T, 1)
!
! ---- Copy of solT in PCELLIR ('OUT' to fill)
!       Delta u_T += delta_ut
        call jevech('PCELLIM', 'L', jincm)
!
        call daxpy(cbs, 1.d0, zr(jincm), 1, rhs_T, 1)
        call writeVector('PCELLIR', cbs, rhs_T)
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoUpdateCellValues(hhoField)
!
    implicit none
!
        type(HHO_Field), intent(in) :: hhoField
!
! --------------------------------------------------------------------------------------------------
!
! HHO - Non-linear mechanics
!
! Update cell values (Newton algorithm)
!
! --------------------------------------------------------------------------------------------------
!
! In  hhoField         : fields for HHO
!
! --------------------------------------------------------------------------------------------------
!
        integer :: ifm, niv, ier
        integer :: nb_comp, nb_comp1, nb_comp2, jvale, jvale1, jvale2, i
        character(len=4) :: scal
!
! --------------------------------------------------------------------------------------------------
!
        call infniv(ifm, niv)
        if (niv .ge. 2) then
            call utmess('I', 'HHO2_17')
        endif
!
! --- Verify that the two field are compatible (the only difference is the type of the field)
!
        call vrrefe(hhoField%fieldPrev_cell, hhoField%fieldIncr_cell, ier)
        ASSERT(ier <= 3)
!
! --- Update the cell field
!
        call jelira(hhoField%fieldPrev_cell//'.CELV', 'TYPE', cval=scal)
        ASSERT(scal(1:1) .eq. 'R')
        call jelira(hhoField%fieldCurr_cell//'.CELV', 'LONMAX', nb_comp)
        call jelira(hhoField%fieldPrev_cell//'.CELV', 'LONMAX', nb_comp1)
        call jelira(hhoField%fieldIncr_cell//'.CELV', 'LONMAX', nb_comp2)
        ASSERT(nb_comp == nb_comp1 .and. nb_comp == nb_comp2)
!
        call jeveuo(hhoField%fieldCurr_cell//'.CELV', 'E', jvale)
        call jeveuo(hhoField%fieldPrev_cell//'.CELV', 'L', jvale1)
        call jeveuo(hhoField%fieldIncr_cell//'.CELV', 'L', jvale2)
!
        do i = 1, nb_comp
            zr(jvale-1+i) = zr(jvale1-1+i) + zr(jvale2-1+i)
        end do
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoMecaDecondOP(model, solalg, hhoField, ds_measure)
!
    implicit none
!
        character(len=24), intent(in) :: model
        character(len=19), intent(in) :: solalg(*)
        type(HHO_Field), intent(in)   :: hhoField
        type(NL_DS_Measure), intent(inout) :: ds_measure
!
! --------------------------------------------------------------------------------------------------
!
! HHO - Mechanics
!
! Decondensation (option)
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  solalg           : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
! In  hhoField         : fields for HHO
! IO  ds_measure       : datastructure for measure and statistics management
!
! --------------------------------------------------------------------------------------------------
!
        integer, parameter :: nbin = 5
        integer, parameter :: nbout = 1
        character(len=8)  :: lpain(nbin), lpaout(nbout)
        character(len=19) :: lchin(nbin), lchout(nbout), Incr_cell_db
        character(len=19) :: ligrel_model, disp_iter
        character(len=16) :: option
        character(len=1)  :: base
        character(len=24) :: chgeom
        integer :: ifm, niv
!
! --------------------------------------------------------------------------------------------------
!
        call infniv(ifm, niv)
        if (niv .ge. 2) then
            call utmess('I', 'HHO2_16')
        endif
!
! - Timer
!
        call nmtime(ds_measure, 'Init', 'HHO_Cond')
        call nmtime(ds_measure, 'Launch', 'HHO_Cond')
!
        base         = 'V'
        option       = 'HHO_DECOND_MECA'
        ligrel_model = model(1:8)//'.MODELE'
!
! - Init fields
!
        call inical(nbin, lpain, lchin, nbout, lpaout, lchout)
!
! - Geometry field
!
        call megeom(model, chgeom)
!
! - Displacement field
        call nmchex(solalg, 'SOLALG', 'DDEPLA', disp_iter)
!
! - Copy the hho Cell Field at the begin of the increment in a temporary champ
!
        Incr_cell_db = '&&HHOMECA.I.CELL.DB'
        call copisd('CHAMP_GD', 'V', hhoField%fieldIncr_cell, Incr_cell_db)
!
! - Input fields
!
        lpain(1) = 'PGEOMER'
        lchin(1) = chgeom(1:19)
        lpain(2) = 'PDEPLPR'
        lchin(2) = disp_iter(1:19)
        lpain(3) = 'PCSMTIR'
        lchin(3) = hhoField%fieldOUT_cell_MT
        lpain(4) = 'PCSRTIR'
        lchin(4) = hhoField%fieldOUT_cell_RT
        lpain(5) = 'PCELLIM'
        lchin(5) = Incr_cell_db
!
! - Output fields
!
        lpaout(1) = 'PCELLIR'
        lchout(1) = hhoField%fieldIncr_cell
!
! - Compute
!
        call calcul('S'  , option, ligrel_model, nbin  , lchin,&
                    lpain, nbout , lchout      , lpaout, base ,&
                    'OUI')
!
! - Update cell values
!
        call hhoUpdateCellValues(hhoField)
!
        call nmtime(ds_measure, 'Stop', 'HHO_Cond')
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoMecaCondOP(model, hhoField, merigi, vefint, index_success)
!
    implicit none
!
        character(len=24), intent(in) :: model
        type(HHO_Field), intent(in)   :: hhoField
        character(len=19), intent(in) :: merigi, vefint
        integer, intent(out)          :: index_success
!
! --------------------------------------------------------------------------------------------------
!
! HHO - Mechanics
!
! Condensation (option)
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  hhoField         : fields for HHO
! In  merigi           : elementary matrix for rigidity
! In  vefint           : elementary vector for internal forces
! Out index_success    :  0 if success / 1  if fails
! --------------------------------------------------------------------------------------------------
!
        integer, parameter :: nbin = 4
        integer, parameter :: nbout = 6
        character(len=8)  :: lpain(nbin), lpaout(nbout)
        character(len=19) :: lchin(nbin), lchout(nbout)
        character(len=19) :: ligrel_model, resu_elem
        character(len=16) :: option
        character(len=1)  :: base
        character(len=24) :: chgeom
        integer :: isym, ifm, niv
!
! --------------------------------------------------------------------------------------------------
!
        call infniv(ifm, niv)
        if (niv .ge. 2) then
            call utmess('I', 'HHO2_15')
        endif
!
        base         = 'V'
        option       = 'HHO_COND_MECA'
        ligrel_model = model(1:8)//'.MODELE'
!
! - Init fields
!
        call inical(nbin, lpain, lchin, nbout, lpaout, lchout)
!
! - Geometry field
!
        call megeom(model, chgeom)
!
! - Input fields
!
        lpain(1) = 'PGEOMER'
        lchin(1) = chgeom(1:19)
        lpain(2) = 'PVEELE1'
        lchin(2) = getResuElem(vect_elem_=hhoField%vectcomb)
!
! ---- Select Matrix
!
        call hhoGetMatrElem(hhoField%matrcomb, resu_elem, isym)
!
        if(isym == 1) then
            lpain(3) = 'PMAELS1'
            lchin(3) = resu_elem
            lpain(4) = 'PMAELNS1'
            lchin(4) = ' '
        elseif(isym == 0) then
            lpain(3) = 'PMAELS1'
            lchin(3) = ' '
            lpain(4) = 'PMAELNS1'
            lchin(4) = resu_elem
        else
            ASSERT(ASTER_FALSE)
        end if
!
! ----- Prepare RESU_ELEM
!
        call jedetr(merigi//'.RERR')
        call jedetr(merigi//'.RELR')
        call jedetr(vefint//'.RERR')
        call jedetr(vefint//'.RELR')
        call memare(base, merigi, model, ' ', ' ', ' ')
        call memare(base, vefint, model, ' ', ' ', ' ')
!
! - Output fields
!
        lpaout(1) = 'PCSMTIR'
        lchout(1) = hhoField%fieldOUT_cell_MT
        lpaout(2) = 'PCSRTIR'
        lchout(2) = hhoField%fieldOUT_cell_RT
        lpaout(3) = 'PMATUNS'
        lchout(3) = merigi(1:15)//'.M02'
        lpaout(4) = 'PMATUUR'
        lchout(4) = merigi(1:15)//'.M01'
        lpaout(5) = 'PVECTUR'
        lchout(5) = vefint(1:15)//'.R01'
        lpaout(6) = 'PCODRET'
        lchout(6) = hhoField%stat_cond_error
!
! - Compute
!
        call calcul('S'  , option, ligrel_model, nbin  , lchin,&
                    lpain, nbout , lchout      , lpaout, base ,&
                    'OUI')
!
! - Set RESU_ELEM
!
        call reajre(merigi, lchout(3), base)
        call reajre(merigi, lchout(4), base)
        call redetr(merigi)
        call reajre(vefint, lchout(5), base)
!
        call hhoCodeRet(hhoField%stat_cond_error, index_success)
!
    end subroutine
!
end module
