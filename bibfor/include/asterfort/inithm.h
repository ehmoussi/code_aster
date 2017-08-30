! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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
#include "asterf_types.h"
!
interface 
    subroutine inithm(yachai, yamec, phi0, em,&
                      cs0, tbiot, epsv, depsv,&
                      epsvm, angmas, mdal, dalal,&
                      alphfi, cbiot, unsks, alpha0)
        aster_logical :: yachai
        integer :: yamec
        real(kind=8) :: phi0
        real(kind=8) :: em
        real(kind=8), intent(out) :: cs0
        real(kind=8) :: tbiot(6)
        real(kind=8) :: epsv
        real(kind=8) :: depsv
        real(kind=8) :: epsvm
        real(kind=8) :: angmas(3)
        real(kind=8) :: mdal(6)
        real(kind=8) :: dalal
        real(kind=8), intent(out) :: alphfi
        real(kind=8) :: cbiot
        real(kind=8) :: unsks
        real(kind=8) :: alpha0
    end subroutine inithm
end interface 
