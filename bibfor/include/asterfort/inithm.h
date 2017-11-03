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
interface 
    subroutine inithm(angl_naut, tbiot , phi0 ,&
                      epsv     , depsv ,&
                      epsvm    , cs0   , mdal , dalal,&
                      alpha0   , alphfi, cbiot, unsks)
        real(kind=8), intent(in) :: angl_naut(3)
        real(kind=8), intent(in) :: tbiot(6)
        real(kind=8), intent(in) :: phi0
        real(kind=8), intent(in) :: epsv, depsv
        real(kind=8), intent(out) :: epsvm
        real(kind=8), intent(out) :: cs0
        real(kind=8), intent(out) :: dalal, mdal(6)
        real(kind=8), intent(out) :: alphfi, alpha0
        real(kind=8), intent(out) :: cbiot, unsks
    end subroutine inithm
end interface 
