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
!
#include "asterf_types.h"
!
interface
    subroutine nmrebo(f, mem, sens, rho, rhoopt,&
                      ldcopt, ldccvg, fopt, fcvg, opt,&
                      act, rhomin, rhomax, rhoexm, rhoexp,&
                      stite, echec)
        real(kind=8) :: f
        real(kind=8) :: mem(2, *)
        real(kind=8) :: sens
        real(kind=8) :: rho
        real(kind=8) :: rhoopt
        integer :: ldcopt
        integer :: ldccvg
        real(kind=8) :: fopt
        real(kind=8) :: fcvg
        integer :: opt
        integer :: act
        real(kind=8) :: rhomin
        real(kind=8) :: rhomax
        real(kind=8) :: rhoexm
        real(kind=8) :: rhoexp
        aster_logical :: stite
        aster_logical :: echec
    end subroutine nmrebo
end interface
