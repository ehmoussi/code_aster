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
    subroutine utno3d(ifm, niv, nsomm, ifa, tymvol,&
                      igeom, xn, yn, zn, jac,&
                      idfdx, idfdy, hf, poids3, npgf,&
                      noe)
        integer :: ifm
        integer :: niv
        integer :: nsomm
        integer :: ifa
        integer :: tymvol
        integer :: igeom
        real(kind=8) :: xn(9)
        real(kind=8) :: yn(9)
        real(kind=8) :: zn(9)
        real(kind=8) :: jac(9)
        integer :: idfdx
        integer :: idfdy
        real(kind=8) :: hf
        real(kind=8) :: poids3(9)
        integer :: npgf
        integer :: noe(9, 6, 4)
    end subroutine utno3d
end interface
