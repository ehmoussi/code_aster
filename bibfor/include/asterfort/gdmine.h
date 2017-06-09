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
    subroutine gdmine(kp, nno, pjacob, en, grani,&
                      alfnmk, delnmk, pas, rot0, rotm,&
                      rotkm1, rotk, rmkm1, rmk, omgkm,&
                      ompgkm, omgk, ompgk, rigi)
        integer :: kp
        integer :: nno
        real(kind=8) :: pjacob
        real(kind=8) :: en(3, 2)
        real(kind=8) :: grani(4)
        real(kind=8) :: alfnmk
        real(kind=8) :: delnmk
        real(kind=8) :: pas
        real(kind=8) :: rot0(3, 3)
        real(kind=8) :: rotm(3, 3)
        real(kind=8) :: rotkm1(3, 3)
        real(kind=8) :: rotk(3, 3)
        real(kind=8) :: rmkm1(3)
        real(kind=8) :: rmk(3)
        real(kind=8) :: omgkm(3)
        real(kind=8) :: ompgkm(3)
        real(kind=8) :: omgk(3)
        real(kind=8) :: ompgk(3)
        real(kind=8) :: rigi(18, 18)
    end subroutine gdmine
end interface
