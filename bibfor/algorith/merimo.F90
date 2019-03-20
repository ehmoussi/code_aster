! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
subroutine merimo(base           , l_xfem   , l_macr_elem,&
                  model          , cara_elem, mate       , iter_newt,&
                  ds_constitutive, varc_refe,&
                  hval_incr      , hval_algo,&
                  optioz         , merigi   , vefint     ,&
                  ldccvg         , sddynz_)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/calcul.h"
#include "asterfort/inical.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/memare.h"
#include "asterfort/merimp.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmiret.h"
#include "asterfort/reajre.h"
#include "asterfort/redetr.h"
!
character(len=1), intent(in) :: base
aster_logical, intent(in) :: l_xfem, l_macr_elem
character(len=24), intent(in) :: model, cara_elem
character(len=*), intent(in) :: mate
integer, intent(in) :: iter_newt
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
character(len=24), intent(in) :: varc_refe
character(len=19), intent(in) :: hval_incr(*), hval_algo(*)
character(len=*), intent(in) :: optioz
character(len=19), intent(in) :: merigi, vefint
integer, intent(out) :: ldccvg
character(len=*), optional, intent(in) :: sddynz_
!
! --------------------------------------------------------------------------------------------------
!
! Nonlinear mechanics (algorithm)
!
! Computation of rigidity matrix and internal forces
!
! --------------------------------------------------------------------------------------------------
!
! In  base             : JEVEUX base to create objects
! In  l_xfem           : flag for XFEM elements
! In  l_macr_elem      : flag for macro-elements
! In  model            : name of model
! In  cara_elem        : name of elementary characteristics (field)
! In  mate             : name of material characteristics (field)
! In  iter_newt        : index of current Newton iteration
! In  ds_constitutive  : datastructure for constitutive laws management
! In  varc_refe        : name of reference command variables vector
! In  hval_incr        : hat-variable for incremental values fields
! In  hval_algo        : hat-variable for algorithms fields
! In  option           : name of option to compute
! In  merigi           : name of elementary matrices for tangent matrix
! In  vefint           : elementary vectors for internal forces
! Out ldccvg           : return code from integration of behaviour
!                       -1 - no integration of behaviour
!                        0 - OK
!                        1 - Failure
!                        2 - Failure but not fatal during Newton's iterations
!                        3 - De Borst not converged
!                        4 - Using law outside bounds (VERI_BORNE)
! In  sddyna           : datastructure for dynamic
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: mxchout = 11
    integer, parameter :: mxchin = 57
    character(len=8) :: lpaout(mxchout), lpain(mxchin)
    character(len=19) :: lchout(mxchout), lchin(mxchin)
    aster_logical :: l_merigi, l_vefint, l_sigmex
    aster_logical :: l_codret, l_codpre
    integer :: ires, iret, nbin, nbout
    character(len=24) :: caco3d, ligrmo
    character(len=19) :: sigm_extr, sigm_curr, vari_curr, strx_curr, sddyna
    character(len=16) :: option
    integer :: ich_matrixs, ich_matrixn, ich_vefint, ich_codret
    character(len=24), pointer :: v_rerr(:) => null()
    aster_logical :: tabret(0:10)
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    option    = optioz
    sddyna    = ' '
    if (present(sddynz_)) then
        sddyna = sddynz_
    endif
    ligrmo    = model(1:8)//'.MODELE'
    caco3d    = '&&MERIMO.CARA_ROTA_FICTI'
    tabret(:) = ASTER_FALSE
    ldccvg    = 0
!
! - Get fields from hat-variables
!
    call nmchex(hval_incr, 'VALINC', 'SIGEXT', sigm_extr)
    call nmchex(hval_incr, 'VALINC', 'SIGPLU', sigm_curr)
    call nmchex(hval_incr, 'VALINC', 'VARPLU', vari_curr)
    call nmchex(hval_incr, 'VALINC', 'STRPLU', strx_curr)
!
! - Input fields
!
    call merimp(l_xfem         ,&
                model          , cara_elem, mate  , sddyna, iter_newt,&
                ds_constitutive, varc_refe,&
                hval_incr      , hval_algo, caco3d,&
                mxchin         , lpain    , lchin , nbin)
!
! - Prepare flags
!
    if (option(1:9) .eq. 'FULL_MECA') then
        l_merigi = ASTER_TRUE
        l_vefint = ASTER_TRUE
        l_codret = ASTER_TRUE
        l_sigmex = ASTER_FALSE
        l_codpre = ASTER_FALSE
    else if (option(1:10) .eq. 'RIGI_MECA ') then
        l_merigi = ASTER_TRUE
        l_vefint = ASTER_FALSE
        l_codret = ASTER_FALSE
        l_sigmex = ASTER_FALSE
        l_codpre = ASTER_FALSE
    else if (option(1:16) .eq. 'RIGI_MECA_IMPLEX') then
        l_merigi = ASTER_TRUE
        l_vefint = ASTER_FALSE
        l_codret = ASTER_FALSE
        l_sigmex = ASTER_TRUE
        l_codpre = ASTER_FALSE
    else if (option(1:10) .eq. 'RIGI_MECA_') then
        l_merigi = ASTER_TRUE
        l_vefint = ASTER_TRUE
        l_codret = ASTER_TRUE
        l_sigmex = ASTER_FALSE
        l_codpre = ASTER_TRUE
    else if (option(1:9) .eq. 'RAPH_MECA') then
        l_merigi = ASTER_FALSE
        l_vefint = ASTER_TRUE
        l_codret = ASTER_TRUE
        l_sigmex = ASTER_FALSE
        l_codpre = ASTER_FALSE
    else
        ASSERT(ASTER_FALSE)
    endif
!
! - Prepare vector and matrix
!
    if (l_merigi) then
        call jeexin(merigi//'.RELR', iret)
        if (iret .eq. 0) then
            call jeexin(merigi//'.RERR', ires)
            if (ires .eq. 0) then
                call memare(base, merigi, model, mate, cara_elem, 'RIGI_MECA')
            endif
            if (l_macr_elem) then
                call jeveuo(merigi//'.RERR', 'E', vk24=v_rerr)
                v_rerr(3) = 'OUI_SOUS_STRUC'
            endif
        endif
        call jedetr(merigi//'.RELR')
        call reajre(merigi, ' ', base)
    endif
!
    if (l_vefint) then
        call jeexin(vefint//'.RELR', iret)
        if (iret .eq. 0) then
            call memare(base, vefint, model, mate, cara_elem, 'CHAR_MECA')
        endif
        call jedetr(vefint//'.RELR')
        call reajre(vefint, ' ', base)
    endif
!
! - Output fields
!
    lpaout(1) = 'PCONTPR'
    lchout(1) = sigm_curr(1:19)
    lpaout(2) = 'PVARIPR'
    lchout(2) = vari_curr(1:19)
    lpaout(3) = 'PCACO3D'
    lchout(3) = caco3d(1:19)
    lpaout(4) = 'PSTRXPR'
    lchout(4) = strx_curr(1:19)
    nbout = 4
    if (l_merigi) then
        nbout = nbout+1
        lpaout(nbout) = 'PMATUUR'
        lchout(nbout) = merigi(1:15)//'.M01'
        ich_matrixs = nbout
        nbout = nbout+1
        lpaout(nbout) = 'PMATUNS'
        lchout(nbout) = merigi(1:15)//'.M02'
        ich_matrixn = nbout
    endif
    if (l_vefint) then
        nbout = nbout+1
        lpaout(nbout) = 'PVECTUR'
        lchout(nbout) = vefint(1:15)//'.R01'
        ich_vefint = nbout
    endif
    if (l_sigmex) then
        nbout = nbout+1
        lpaout(nbout) = 'PCONTXR'
        lchout(nbout) = sigm_extr(1:19)
    endif
    if (l_codret) then
        nbout = nbout+1
        lpaout(nbout) = 'PCODRET'
        lchout(nbout) = ds_constitutive%comp_error(1:19)
        ich_codret = nbout
    endif
    if (l_codpre) then
        nbout = nbout+1
        lpaout(nbout) = 'PCOPRED'
        lchout(nbout) = ds_constitutive%code_pred(1:19)
        ich_codret = nbout
    endif
    ASSERT(nbout.le.mxchout)
    ASSERT(nbin.le.mxchin)
!
! - Compute
!
    call calcul('S', option, ligrmo, nbin, lchin,&
                lpain, nbout, lchout, lpaout, base,&
                'NON')
!
! - Save
!
    if (l_merigi) then
        call reajre(merigi, lchout(ich_matrixs), base)
        call reajre(merigi, lchout(ich_matrixn), base)
        call redetr(merigi)
    endif
    if (l_vefint) then
        call reajre(vefint, lchout(ich_vefint), base)
    endif
!
! - Errors
!
    if (l_codret) then
        call nmiret(lchout(ich_codret), tabret)
        if (tabret(0)) then
            if (tabret(4)) then
                ldccvg = 4
            else if (tabret(3)) then
                ldccvg = 3
            else if (tabret(2)) then
                ldccvg = 2
            else
                ldccvg = 1
            endif
            if (tabret(1)) then
                ldccvg = 1
            endif
        endif
    endif
!
    call jedema()
end subroutine
