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
subroutine nmvcpr_elem(modelz    , matez     , cara_elemz,&
                       nume_harm , time_comp , hval_incr ,&
                       varc_refez, comporz   ,&
                       base      , vect_elemz)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/detrsd.h"
#include "asterfort/maveElemCreate.h"
#include "asterfort/nmchex.h"
#include "asterfort/varcCalcComp.h"
#include "asterfort/varcCalcMeta.h"
#include "asterfort/varcCalcPrep.h"
#include "asterfort/varcDetect.h"
!
character(len=*), intent(in) :: modelz, cara_elemz, matez
integer, intent(in) :: nume_harm
character(len=1), intent(in) :: time_comp
character(len=*), intent(in) :: varc_refez, comporz
character(len=19), intent(in) :: hval_incr(*)
character(len=1), intent(in) :: base
character(len=*), intent(in) :: vect_elemz
!
! --------------------------------------------------------------------------------------------------
!
! Nonlinear mechanics (algorithm)
!
! Command variables - Elementary vectors
!
! --------------------------------------------------------------------------------------------------
!
! In  model          : name of model
! In  mate           : name of material characteristics (field)
! In  cara_elem      : name of elementary characteristics (field)
! In  nume_harm      : Fourier harmonic number
! In  time_comp        :  '-' or '+' for command variables evaluation
! In  hval_incr      : hat-variable for incremental values
! In  varc_refe      : name of reference command variables vector
! In  compor         : name of comportment definition (field)
! In  base           : JEVEUX base to create objects
! In  vect_elem      : elementary vectors
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: mxchin = 32, mxchout = 2
    character(len=8) :: lpain(mxchin), lpaout(mxchout)
    character(len=19) :: lchin(mxchin), lchout(mxchout)
    aster_logical :: l_temp, l_hydr, l_ptot
    aster_logical :: l_sech, l_epsa, l_meta
    character(len=19) :: sigm_prev, vari_prev, varc_prev, varc_curr
    integer :: nbin, nbout
    character(len=24) :: mult_comp, chsith
!
! --------------------------------------------------------------------------------------------------
!
    mult_comp = comporz
    chsith    = '&&VECTME.CHSITH'
!
! - Get fields from hat-variables - Begin of time step
!
    call nmchex(hval_incr, 'VALINC', 'SIGMOI', sigm_prev)
    call nmchex(hval_incr, 'VALINC', 'VARMOI', vari_prev)
    call nmchex(hval_incr, 'VALINC', 'COMMOI', varc_prev)
    call nmchex(hval_incr, 'VALINC', 'COMPLU', varc_curr)
!
! - Detect external state variables
!
    call varcDetect(matez, l_temp, l_hydr, l_ptot, l_sech, l_epsa, l_meta)
!
! - Prepare elementary vectors
!
    call detrsd('VECT_ELEM', vect_elemz)
    call maveElemCreate(base, 'MECA', vect_elemz, modelz, matez, cara_elemz)
!
! - Preparation
!
    call varcCalcPrep(modelz    , cara_elemz, matez    ,&
                      nume_harm , time_comp ,&
                      l_temp    , l_meta    ,&
                      varc_refez, varc_prev , varc_curr,&
                      comporz   , mult_comp , chsith   ,&
                      sigm_prev , vari_prev ,&
                      mxchin    , mxchout   ,&
                      nbin      , nbout     ,&
                      lpain     , lchin     ,&
                      lpaout    , lchout)
!
! - Calls to CALCUL
!
    call varcCalcComp(modelz, chsith    ,&
                      l_temp, l_hydr    , l_ptot,&
                      l_sech, l_epsa    ,&
                      nbin  , nbout     ,&
                      lpain , lchin     ,&
                      lpaout, lchout    ,&
                      base  , vect_elemz)
!
! - Call to CALCUL special for metallurgy (non-incremental)
!
    if (time_comp .eq. '+' .and. l_meta) then
        call varcCalcMeta(modelz,&
                          nbin  , nbout     ,&
                          lpain , lchin     ,&
                          lpaout, lchout    ,&
                          base  , vect_elemz)
    endif
!
end subroutine
