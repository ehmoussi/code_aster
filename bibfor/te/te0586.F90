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
subroutine te0586(option, nomte)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/assert.h"
#include "asterfort/tufull.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: TUYAU
!
! Options: FULL_MECA_*, RIGI_MECA_*, RAPH_MECA
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option to compute
! In  nomte            : type of finite element
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nbrddm=156
    integer :: nFourier, nbrddl, nno
    real(kind=8) :: deplm(nbrddm), deplp(nbrddm), vtemp(nbrddm)
    real(kind=8) :: b(4, nbrddm)
    real(kind=8) :: ktild(nbrddm, nbrddm), effint(nbrddm)
    real(kind=8) :: pass(nbrddm, nbrddm)
!
! --------------------------------------------------------------------------------------------------
!
    call elrefe_info(fami='RIGI', nno=nno)
!
! - Number of Fourier modes
!
    nFourier = 3
    if (nomte .eq. 'MET6SEG3') then
        nFourier = 6
    endif
!
! - Number of DOF
!
    nbrddl = nno* (6+3+6* (nFourier-1))
    ASSERT(nbrddl .le. nbrddm)
    if (nomte .eq. 'MET3SEG3') then
        ASSERT(nbrddl .eq. 63)
    else if (nomte.eq.'MET6SEG3') then
        ASSERT(nbrddl .eq. 117)
    else if (nomte.eq.'MET3SEG4') then
        ASSERT(nbrddl .eq. 84)
    else
        ASSERT(ASTER_FALSE)
    endif
!
! - Compute option
!
    call tufull(option, nFourier, nbrddl, deplm, deplp,&
                b, ktild, effint, pass, vtemp)
!
end subroutine
