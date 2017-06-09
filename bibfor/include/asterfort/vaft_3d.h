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
    subroutine vaft_3d(khi, casol, alsol, ssol, ohsol,&
                       kaft, gam1, gam2, daft)
        real(kind=8) :: khi
        real(kind=8) :: casol
        real(kind=8) :: alsol
        real(kind=8) :: ssol
        real(kind=8) :: ohsol
        real(kind=8) :: kaft
        real(kind=8) :: gam1
        real(kind=8) :: gam2
        real(kind=8) :: daft
    end subroutine vaft_3d
end interface 
