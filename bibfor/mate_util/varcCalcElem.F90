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
subroutine varcCalcElem(modelz    , cara_elemz, matez     ,&
                        nume_harm , time_comp , l_new     ,&
                        varc_refez, varc_prevz, varc_currz,&
                        comporz   , mult_compz,&
                        base      , vect_elemz,&
                        sigmz_    , variz_    )
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/calcul.h"
#include "asterfort/codent.h"
#include "asterfort/infdbg.h"
#include "asterfort/varcDetect.h"
#include "asterfort/varcCalcPrep.h"
#include "asterfort/maveElemCreate.h"
#include "asterfort/varcCalcComp.h"
#include "asterfort/detrsd.h"
!
character(len=*), intent(in) :: modelz, cara_elemz, matez
integer, intent(in) :: nume_harm
character(len=1), intent(in) :: time_comp
aster_logical, intent(in) :: l_new
character(len=*), intent(in) :: varc_refez, varc_prevz, varc_currz
character(len=*), intent(in) :: comporz, mult_compz
character(len=1), intent(in) :: base
character(len=*), intent(in) :: vect_elemz
character(len=*), optional, intent(in) :: sigmz_, variz_
!
! --------------------------------------------------------------------------------------------------
!
! Material - External state variables (VARC)
!
! Compute elementary vectors
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  cara_elem        : name of elementary characteristics (field)
! In  mate             : name of material characteristics (field)
! In  nume_harm        : Fourier harmonic number
! In  time_comp        :  '-' or '+' for command variables evaluation
! In  l_new            : flag to create a NEW elementary vector
! In  varc_refe        : name of reference command variables vector
! In  varc_prev        : command variables at previous step
! In  varc_curr        : command variables at current step
! In  compor           : name of comportment definition (field)
! In  mult_comp        : multi-comportment (DEFI_COMPOR for PMF)
! In  base             : JEVEUX base to create objects
! In  vect_elem        : name of elementary vectors
! In  sigm             : stress
! In  vari             : internal variables
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: mxchin = 25, mxchout = 2
    character(len=8) :: lpain(mxchin), lpaout(mxchout)
    character(len=19) :: lchin(mxchin), lchout(mxchout)
    character(len=8) :: newnom
    character(len=19) :: resu_elem, ligrmo
    character(len=19) :: compor, mult_comp, vari, sigm, chsith
    integer :: nbout, nbin
    aster_logical :: l_temp, l_hydr, l_ptot
    aster_logical :: l_sech, l_epsa, l_meta
!
! --------------------------------------------------------------------------------------------------
!
    ligrmo    = modelz(1:8)//'.MODELE'
    newnom    = '.0000000'
    resu_elem = '&&VECTME.???????'
    chsith    = '&&VECTME.CHSITH'
    compor    = comporz
    mult_comp = mult_compz
    sigm      = ' '
    if (present(sigmz_)) then
        sigm = sigmz_
    endif
    vari      = ' '
    if (present(variz_)) then
        vari = variz_
    endif
!
! - Detect external state variables
!
    call varcDetect(matez, l_temp, l_hydr, l_ptot, l_sech, l_epsa, l_meta)
!
! - Prepare computation of elementary vector
!
    call varcCalcPrep(modelz    , cara_elemz, matez     ,&
                      nume_harm , time_comp ,&
                      l_temp    , l_meta    ,&
                      varc_refez, varc_prevz, varc_currz,&
                      compor    , mult_comp , chsith    ,&
                      sigm      , vari      ,&
                      mxchin    , mxchout   ,&
                      nbin      , nbout     ,&
                      lpain     , lchin     ,&
                      lpaout    , lchout)
!
! - Suppress old vect_elem result
!
    if (l_new) then
        call detrsd('VECT_ELEM', vect_elemz)
        call maveElemCreate(base, 'MECA', vect_elemz, modelz, matez, cara_elemz)
    endif
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
end subroutine
