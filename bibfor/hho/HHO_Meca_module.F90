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
!
module HHO_Meca_module
!
use NonLin_Datastructure_type
use HHO_type
use HHO_Dirichlet_module
use NonLin_Datastructure_type
use HHO_size_module
use HHO_LargeStrainMeca_module
use HHO_SmallStrainMeca_module
use HHO_quadrature_module
use HHO_utils_module
use HHO_stabilization_module, only : hhoStabVec, hdgStabVec, hhoStabSymVec
use HHO_gradrec_module, only : hhoGradRecVec, hhoGradRecFullMat, hhoGradRecSymFullMat, &
                             & hhoGradRecSymMat, hhoGradRecFullMatFromVec
!
implicit none
!
private
#include "asterf_types.h"
#include "asterfort/HHO_size_module.h"
#include "asterfort/alchml.h"
#include "asterfort/assert.h"
#include "asterfort/calcul.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/get_elas_id.h"
#include "asterfort/get_elas_para.h"
#include "asterfort/imprsd.h"
#include "asterfort/infniv.h"
#include "asterfort/inical.h"
#include "asterfort/isfonc.h"
#include "asterfort/jevech.h"
#include "asterfort/megeom.h"
#include "asterfort/nbsigm.h"
#include "asterfort/nmtime.h"
#include "asterfort/rcangm.h"
#include "asterfort/readVector.h"
#include "asterfort/tecach.h"
#include "asterfort/utmess.h"
#include "blas/daxpy.h"
#include "blas/dcopy.h"
#include "blas/dsymv.h"
#include "jeveux.h"
!
! --------------------------------------------------------------------------------------------------
!
! HHO - mechanics
!
! Specific routines for mechanics
!
! --------------------------------------------------------------------------------------------------
!
!
    public :: hhoMecaInit, hhoPreCalcMeca, hhoLocalContribMeca
    public :: hhoCalcOpMeca, isLargeStrain, hhoReloadPreCalcMeca
    private :: YoungModulus
!
contains
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoMecaInit(model, list_load, list_func_acti, hhoField)
!
    implicit none
!
        character(len=24), intent(in) :: model
        character(len=19), intent(in) :: list_load
        integer, intent(in) :: list_func_acti(*)
        type(HHO_Field), intent(out) :: hhoField
!
! --------------------------------------------------------------------------------------------------
!
! HHO - Non-linear mechanics
!
! Initializations
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  list_load        : name of datastructure for list of loads
! In  list_func_acti   : list of active functionnalities
! Out hhoField         : fields for HHO
!
! --------------------------------------------------------------------------------------------------
!
        integer :: iret, ifm, niv
        character(len=19) :: ligrmo
        aster_logical :: l_load_cine
!
! --------------------------------------------------------------------------------------------------
!
        call infniv(ifm, niv)
        if (niv .ge. 2) then
            call utmess('I', 'HHO2_8')
        endif
!
! --- Initializations
!
        l_load_cine = isfonc(list_func_acti, 'DIRI_CINE')
!
! --- Prepare fields for algorithm
!
        ligrmo = model(1:8)//'.MODELE'
        hhoField%fieldOUT_cell_MT = '&&HHOMECA.OU.CELLMT'
        hhoField%fieldOUT_cell_RT = '&&HHOMECA.OU.CELLRT'
        hhoField%fieldOUT_cell_GT = '&&HHOMECA.OU.CELLGT'
        hhoField%fieldOUT_cell_ST = '&&HHOMECA.OU.CELLST'
!
        hhoField%fieldIncr_cell = '&&HHOMECA.I.CELL'
        call detrsd('CHAM_ELEM', hhoField%fieldIncr_cell)
        call alchml(ligrmo, 'RIGI_MECA_TANG', 'PCELLIR', 'V', hhoField%fieldIncr_cell, iret, ' ')
        ASSERT(iret .eq. 0)
        if (hhoField%l_debug) then
            call imprsd('CHAMP', hhoField%fieldIncr_cell, 6, 'hhoField%fieldIncr_cell:')
        endif
!
        hhoField%fieldPrev_cell = '&&HHOMECA.M.CELL'
        call detrsd('CHAM_ELEM', hhoField%fieldPrev_cell)
        call alchml(ligrmo, 'RIGI_MECA_TANG', 'PCELLMR', 'V', hhoField%fieldPrev_cell, iret, ' ')
        ASSERT(iret .eq. 0)
        if (hhoField%l_debug) then
            call imprsd('CHAMP', hhoField%fieldPrev_cell, 6, 'hhoField%fieldPrev_cell:')
        endif
!
        hhoField%fieldCurr_cell = '&&HHOMECA.P.CELL'
        call detrsd('CHAM_ELEM', hhoField%fieldCurr_cell)
        call alchml(ligrmo, 'RIGI_MECA_TANG', 'PCELLIR', 'V', hhoField%fieldCurr_cell, iret, ' ')
        ASSERT(iret .eq. 0)
        if (hhoField%l_debug) then
            call imprsd('CHAMP', hhoField%fieldCurr_cell, 6, 'hhoField%fieldCurr_cell:')
        endif
!
! --- Prepare fields for error
!
        hhoField%stat_cond_error = '&&HHOMEC.ERROR'
!
! --- Prepare fields for Dirichlet loads
!
        hhoField%fieldCineFunc = '&&HHOMEC.CINEFUNC'
        hhoField%fieldCineVale = '&&HHOMEC.CINEVALE'
        if (l_load_cine) then
            call hhoDiriFuncPrepare(model, list_load, hhoField)
        endif
!
        hhoField%vectcomb = '&&HHOMECA.VCOMB'
        hhoField%matrcomb = '&&HHOMECA.MCOMB'
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoPreCalcMeca(model,  hhoField, ds_constitutive, ds_measure)
!
    implicit none
!
        character(len=24), intent(in)           :: model
        type(HHO_Field), intent(in)             :: hhoField
        type(NL_DS_Constitutive), intent(in)    :: ds_constitutive
        type(NL_DS_Measure), intent(inout)      :: ds_measure
!
! --------------------------------------------------------------------------------------------------
!
! HHO - Mechanics
!
! Precomputation of the operators
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  hhoField         : fields for HHO
! In  ds_constitutive  : datastructure for constitutive laws management
! IO  ds_measure       : datastructure for measure and statistics management
!
! --------------------------------------------------------------------------------------------------
!
        integer, parameter :: nbin = 2
        integer, parameter :: nbout = 2
        character(len=8)  :: lpain(nbin), lpaout(nbout)
        character(len=19) :: lchin(nbin), lchout(nbout)
        character(len=19) :: ligrel_model
        character(len=16) :: option
        character(len=1)  :: base
        character(len=24) :: chgeom
!
! --------------------------------------------------------------------------------------------------
!
        base         = 'V'
        option       = 'HHO_PRECALC_MECA'
        ligrel_model = model(1:8)//'.MODELE'
!
! - Timer
!
        call nmtime(ds_measure, 'Init', 'HHO_Prep')
        call nmtime(ds_measure, 'Launch', 'HHO_Prep')
!
! --- Init fields
!
        call inical(nbin, lpain, lchin, nbout, lpaout, lchout)
!
! --- Geometry field
!
        call megeom(model, chgeom)
!
! --- Input fields
!
        lpain(1) = 'PGEOMER'
        lchin(1) = chgeom(1:19)
        lpain(2) = 'PCOMPOR'
        lchin(2) = ds_constitutive%compor(1:19)
!
! --- Output fields
!
        lpaout(1) = 'PCHHOGT'
        lchout(1) = hhoField%fieldOUT_cell_GT
        lpaout(2) = 'PCHHOST'
        lchout(2) = hhoField%fieldOUT_cell_ST
!
! - Compute
!
        call calcul('S'  , option, ligrel_model, nbin  , lchin,&
                    lpain, nbout , lchout      , lpaout, base ,&
                    'OUI')
!
        call nmtime(ds_measure, 'Stop', 'HHO_Prep')
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoReloadPreCalcMeca(hhoCell, hhoData, l_largestrains, gradsav, stabsav, &
                                    gradfull, stab)
!
    implicit none
!
        type(HHO_Data), intent(in) :: hhoData
        type(HHO_Cell), intent(in) :: hhoCell
        aster_logical, intent(in) :: l_largestrains
        real(kind=8), intent(in) :: gradsav(*)
        real(kind=8), intent(in) :: stabsav(*)
        real(kind=8), dimension(MSIZE_CELL_MAT, MSIZE_TDOFS_VEC), intent(out)   :: gradfull
        real(kind=8), dimension(MSIZE_TDOFS_VEC, MSIZE_TDOFS_VEC), intent(out)  :: stab
!
! --------------------------------------------------------------------------------------------------
!  HHO
!  Mechanics - Reload Precomputation of operators
!
! In  hhoCell         : hho Cell
! In hhoData          : information about the HHO formulation
! In l_largestrains   : large strains ?
! In gradsav          : full gradient for mechanics (precomputed)
! In stabsav          : stabilization for mechanics (precomputed)
! Out gradfull        : full gradient for mechanics
! Out stab            : stabilization for mechanics
! --------------------------------------------------------------------------------------------------
!
! --- Local variables
!
        integer :: cbs, fbs, total_dofs, gbs, gbs_sym, gbs2, j
        real(kind=8), dimension(MSIZE_CELL_VEC, MSIZE_TDOFS_SCAL)  :: gradfullvec
        real(kind=8), dimension(MSIZE_TDOFS_SCAL, MSIZE_TDOFS_SCAL):: stabvec
!
        if(hhoCell%ndim == 2) then
!
! ---- if ndim = 2, we save the full operator
!
            call hhoMecaNLDofs(hhoCell, hhoData, cbs, fbs, total_dofs, gbs, gbs_sym)
            gradfull = 0.d0
!
            if(l_largestrains) then
                gbs2 = gbs
            else
                gbs2 = gbs_sym
            endif
!
            do j = 1, total_dofs
                call dcopy(gbs2, gradsav((j-1) * gbs2+1), 1, gradfull(1,j), 1)
            end do
!
        elseif(hhoCell%ndim == 3) then
!
! ---- if ndim = 3, we save the scalar operator for large_strain (not for small strains)
!
            call hhoTherNLDofs(hhoCell, hhoData, cbs, fbs, total_dofs, gbs2)
!
            if(l_largestrains) then
                gradfullvec = 0.d0
!
                do j = 1, total_dofs
                    call dcopy(gbs2, gradsav((j-1) * gbs2+1), 1, gradfullvec(1,j), 1)
                end do
!
! ------- Compute vectoriel Gradient reconstruction
                call hhoGradRecFullMatFromVec(hhoCell, hhoData, gradfullvec, gradfull)
!
            else
! -------- Compute Operators
                call hhoCalcOpMeca(hhoCell, hhoData, l_largestrains, gradfull)
            endif
        else
            ASSERT(ASTER_FALSE)
        end if
!
! -------- Reload stabilization
        stab = 0.d0
        stabvec = 0.d0
        call hhoTherNLDofs(hhoCell, hhoData, cbs, fbs, total_dofs, gbs2)
        do j = 1, total_dofs
            call dcopy(total_dofs, stabsav((j-1) * total_dofs+1), 1, stabvec(1,j), 1)
        end do
        call MatScal2Vec(hhoCell, hhoData, stabvec, stab)
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoLocalContribMeca(hhoCell, hhoData, hhoQuadCellRigi, gradrec, stab, &
                                  fami, typmod, compor, option, deplfm, deplfd, l_largestrain, &
                                  lhs, rhs, codret)
!
    implicit none
!
        type(HHO_Cell), intent(in)      :: hhoCell
        type(HHO_Data), intent(inout)   :: hhoData
        type(HHO_Quadrature), intent(in):: hhoQuadCellRigi
        real(kind=8), intent(in)        :: gradrec(MSIZE_CELL_MAT, MSIZE_TDOFS_VEC)
        real(kind=8), intent(in)        :: stab(MSIZE_TDOFS_VEC, MSIZE_TDOFS_VEC)
        character(len=*), intent(in)    :: fami
        character(len=8), intent(in)    :: typmod(*)
        character(len=16), intent(in)   :: compor(*)
        character(len=16), intent(in)   :: option
        real(kind=8), intent(in)        :: deplfm(*), deplfd(*)
        aster_logical, intent(in)       :: l_largestrain
        real(kind=8), intent(out)       :: lhs(MSIZE_TDOFS_VEC, MSIZE_TDOFS_VEC)
        real(kind=8), intent(out)       :: rhs(MSIZE_TDOFS_VEC)
        integer, intent(out)            :: codret
!
! --------------------------------------------------------------------------------------------------
!   HHO - mechanics
!
!   Compute the local contribution for mechanics
!   In hhoCell      : the current HHO Cell
!   In hhoData       : information on HHO methods
!   In hhoQuadCellRigi : quadrature rules from the rigidity family
!   In gradrec      : local gradient reconstruction
!   In stab         : local stabilisation
!   In fami         : familly of quadrature points (of hhoQuadCellRigi)
!   In typmod       : type of modelization
!   In compor       : type of behavior
!   In option       : option of computations
!   In deplfm       : displecement at T- of faces
!   In deplfd       : displacement increment between T- and T+ of faces
!   In largestrain  : large strain ?
!   Out lhs         : local contribution (lhs)
!   Out rhs         : local contribution (rhs)
!   Out codret      : info of the LDC integration
! --------------------------------------------------------------------------------------------------
!
        aster_logical :: axi, cplan, deborst, resi, rigi
        integer:: cbs, fbs, total_dofs, j, faces_dofs
        integer :: imate, jmate, lgpg, iret, jtab(7), icarcr, iinstm, iinstp, icontm, ivarim
        integer :: icontp, ivarip, jv_mult_comp
        character(len=16) :: mult_comp, option_inte
        real(kind=8), dimension(MSIZE_TDOFS_VEC) :: deplm, deplp, deplincr, angl_naut(7)
!
! --- Verif compor
!
        axi     = typmod(1) .eq. 'AXIS'
        cplan   = typmod(1) .eq. 'C_PLAN'
        deborst = compor(5)(1:7) .eq. 'DEBORST'
!
        if (axi .or. cplan .or. deborst) then
            ASSERT(ASTER_FALSE)
        endif
!
! --- Because of the static condensation, we have to compute the rigidity matrix even with RAPH_MECA
!     but with RAPH_MECA, the tangent modulus is not computed by the behavior laws then
!     we have to force this computation in replacing RAPH_MECA by FULL_MECA
!
        resi    = (option.eq.'RAPH_MECA') .or. (option(1:4).eq.'FULL')
        rigi    = ASTER_TRUE
!
        if (option.eq.'RAPH_MECA') then
            option_inte = "FULL_MECA"
        else
            option_inte = option
        end if
!
! --- Get input fields
!
        call jevech('PMATERC', 'L', jmate)
        call jevech('PCARCRI', 'L', icarcr)
        call jevech('PINSTMR', 'L', iinstm)
        call jevech('PINSTPR', 'L', iinstp)
        call jevech('PCONTMR', 'L', icontm)
        call jevech('PVARIMR', 'L', ivarim)
        call jevech('PMULCOM', 'L', jv_mult_comp)
        call jevech('PCONTPR', 'E', icontp)
        call jevech('PVARIPR', 'E', ivarip)
!
        call tecach('OOO', 'PVARIMR', 'L', iret, nval=7, itab=jtab)
        ASSERT(iret .eq. 0)
        lgpg = max(jtab(6),1)*jtab(7)
        imate = zi(jmate -1 + 1)
        mult_comp = zk16(jv_mult_comp-1+1)
!
! --- Get orientation
!
        call rcangm(hhoCell%ndim, hhoCell%barycenter, angl_naut)
!
! --- number of dofs
!
        call hhoMecaDofs(hhoCell, hhoData, cbs, fbs, total_dofs)
        faces_dofs = total_dofs - cbs
!
! -- initialization
!
        lhs = 0.d0
        rhs = 0.d0
!
! --- get displacement in T-
!
        deplm = 0.d0
        call readVector('PCELLMR', cbs, deplm)
        call dcopy(faces_dofs, deplfm, 1, deplm(cbs+1), 1)
!
! --- get increment displacement beetween T- and T+
!
        deplincr = 0.d0
        call readVector('PCELLIR', cbs, deplincr)
        call dcopy(faces_dofs, deplfd, 1, deplincr(cbs+1), 1)
!
! --- compute displacement in T+
!
        deplp = 0.d0
        call dcopy(total_dofs, deplm, 1, deplp, 1)
        call daxpy(total_dofs, 1.d0, deplincr, 1, deplp, 1)
!
    ! print*,"sol debut"
    ! print*, deplm(1:total_dofs)
    ! print*,"sol incr"
    ! print*, deplincr(1:total_dofs)
    ! print*,"sol fin"
    ! print*, deplp(1:total_dofs)
!
        if(l_largestrain) then
!
! --- large strains and use gradient
!
            call hhoLargeStrainLCMeca(hhoCell, hhoData, hhoQuadCellRigi, gradrec, &
                                      fami, typmod, imate, compor, option_inte, zr(icarcr), lgpg, &
                                      nbsigm(), zr(iinstm), zr(iinstp), deplm, deplp, &
                                    zr(icontm), zr(ivarim), angl_naut, mult_comp, resi, rigi, &
                                      cplan, lhs, rhs, zr(icontp), zr(ivarip), codret)
        else
!
! --- small strains and use symmetric gradient
!
            call hhoSmallStrainLCMeca(hhoCell, hhoData, hhoQuadCellRigi, gradrec, &
                                      fami, typmod, imate, compor, option_inte, zr(icarcr), lgpg, &
                                      nbsigm(), zr(iinstm), zr(iinstp), deplm, deplincr, &
                                      zr(icontm), zr(ivarim), angl_naut, mult_comp, &
                                      lhs, rhs, zr(icontp), zr(ivarip), codret)
        end if
!
! --- test integration of the behavior
!
        if (codret .ne. 0) goto 999
!
! --- add stabilization
!
        if(hhoData%adapt()) then
             call hhoData%setCoeffStab(10.d0 * YoungModulus(fami, imate, &
                                                             hhoQuadCellRigi%nbQuadPoints))
        end if
!
        call dsymv('U', total_dofs, -hhoData%coeff_stab(), stab, MSIZE_TDOFS_VEC,&
                   deplp, 1, 1.d0, rhs,1)
!
        do j = 1, total_dofs
            call daxpy(total_dofs, hhoData%coeff_stab(), stab(1,j), 1, lhs(1,j), 1)
        end do

    !  print*, "lhs", hhoNorm2Mat(lhs(1:total_dofs,1:total_dofs))
    ! print*, "rhs", norm2(rhs)
!
    999 continue
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoCalcOpMeca(hhoCell, hhoData, l_largestrains, gradfull, stab)
!
    implicit none
!
        type(HHO_Cell), intent(in) :: hhoCell
        type(HHO_Data), intent(in) :: hhoData
        aster_logical, intent(in)  :: l_largestrains
        real(kind=8), dimension(MSIZE_CELL_MAT, MSIZE_TDOFS_VEC), intent(out)   :: gradfull
        real(kind=8), dimension(MSIZE_TDOFS_VEC, MSIZE_TDOFS_VEC), intent(out), optional  :: stab
!
! --------------------------------------------------------------------------------------------------
!
! HHO - Mechanic
!
! Compute operators for mechanic
!
! --------------------------------------------------------------------------------------------------
!
! In  hhoCell         : hho Cell
! In hhoData          : information about the HHO formulation
! In l_largestrains   : large strains ?
! Out gradfull        : full gradient for mechanics
! Out stab            : stabilization for mechanics
! --------------------------------------------------------------------------------------------------
!
        real(kind=8), dimension(MSIZE_CELL_SCAL, MSIZE_TDOFS_SCAL) :: gradrec_scal
!        real(kind=8), dimension(MSIZE_CELL_VEC, MSIZE_TDOFS_VEC)   :: gradrec_sym
!
! --------------------------------------------------------------------------------------------------
!
        if(l_largestrains) then
!
! ----- Compute Gradient reconstruction
            call hhoGradRecFullMat(hhoCell, hhoData, gradfull)
        else
!
! ----- Compute Symmetric Gradient reconstruction
            call hhoGradRecSymFullMat(hhoCell, hhoData, gradfull)
        end if
!
! ----- Compute Stabilizatiion
        if(present(stab)) then
            if (hhoData%cell_degree() <= hhoData%face_degree()) then
                call hhoGradRecVec(hhoCell, hhoData, gradrec_scal)
                call hhoStabVec(hhoCell, hhoData, gradrec_scal, stab)
!               call hhoGradRecSymMat(hhoCell, hhoData, gradrec_sym)
!               call hhoStabSymVec(hhoCell, hhoData, gradrec_sym, stab)
            else if (hhoData%cell_degree() == (hhoData%face_degree() + 1)) then
                call hdgStabVec(hhoCell, hhoData, stab)
            else
                ASSERT(ASTER_FALSE)
            end if
        end if
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    function isLargeStrain(defo_comp) result(bool)
!
    implicit none
!
        character(len=16), intent(in) :: defo_comp
        aster_logical :: bool
!
! --------------------------------------------------------------------------------------------------
!
!   To know if the model is in large deformations
!   In defo_comp : type of deformation
! --------------------------------------------------------------------------------------------------
!
        bool = ASTER_FALSE
!
        if (defo_comp(1:5) .eq. 'PETIT') then
            bool = ASTER_FALSE
        elseif (defo_comp .eq. 'GDEF_LOG') then
            bool = ASTER_TRUE
        elseif (defo_comp .eq. 'SIMO_MIEHE') then
            bool = ASTER_TRUE
        elseif (defo_comp .eq. 'GROT_GDEP') then
            bool = ASTER_TRUE
        else
            ASSERT(ASTER_FALSE)
        end if
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    function YoungModulus(fami, imate, npg) result(coeff)
!
    implicit none
!
        character(len=*), intent(in)  :: fami
        integer, intent(in)           :: imate, npg
        real(kind=8) :: coeff
!
! --------------------------------------------------------------------------------------------------
!
!   Compute the average Young modulus
!   In fami         : familly of quadrature points (of hhoQuadCellRigi)
!   In npg          : number of quadrature points
!   In imate        : materiau code
! --------------------------------------------------------------------------------------------------
!
        character(len=16) :: elas_keyword
        integer :: elas_id, ipg
        real(kind=8) :: e
!
        coeff = 0.d0
! - Get type of elasticity (Isotropic/Orthotropic/Transverse isotropic)
!
        call get_elas_id(imate, elas_id, elas_keyword)
!
        do ipg = 1, npg
            call get_elas_para(fami, imate, '+', ipg, 1, elas_id , elas_keyword, e_ = e)
            coeff = coeff + e
        end do
!
        coeff = coeff / real(npg, kind=8)
!
    end function
!
end module
