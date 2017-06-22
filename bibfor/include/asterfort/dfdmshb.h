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
interface 
    subroutine dfdmshb(nno,ipg,ipoids,idfde,coor,invjac,jac,dfdx,dfdy,dfdz)
        integer, intent(in) :: nno
        integer, intent(in) :: ipg
        integer, intent(in) :: ipoids
        integer, intent(in) :: idfde
        real(kind=8), intent(in) :: coor(*)
        real(kind=8), intent(out) ::  invjac(3, 3)
        real(kind=8), intent(out) :: jac
        real(kind=8) ,optional, intent(out) :: dfdx(*)
        real(kind=8) ,optional, intent(out) :: dfdy(*)
        real(kind=8) ,optional, intent(out) :: dfdz(*)
    end subroutine dfdmshb
end interface 
