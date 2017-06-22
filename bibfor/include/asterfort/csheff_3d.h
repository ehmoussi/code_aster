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
    subroutine csheff_3d(dcash, dcsheff, dalpha, sic, csh,&
                         alsol, dalsol, csheff, xidtot, xidtot1,&
                         nasol, vnasol, dt, alpha, cash,&
                         alc, sc, id0, id1, id2)
        real(kind=8) :: dcash
        real(kind=8) :: dcsheff
        real(kind=8) :: dalpha
        real(kind=8) :: sic
        real(kind=8) :: csh
        real(kind=8) :: alsol
        real(kind=8) :: dalsol
        real(kind=8) :: csheff
        real(kind=8) :: xidtot
        real(kind=8) :: xidtot1
        real(kind=8) :: vnasol
        real(kind=8) :: nasol
        real(kind=8) :: dt
        real(kind=8) :: alpha
        real(kind=8) :: cash
        real(kind=8) :: alc
        real(kind=8) :: sc
        real(kind=8) :: id0
        real(kind=8) :: id1
        real(kind=8) :: id2
    end subroutine csheff_3d
end interface 
