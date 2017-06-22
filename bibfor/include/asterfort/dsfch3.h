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
    subroutine dsfch3(nno, nnf, poids, dpdef, dpdnf,&
                      dpdkf, dsdeef, dsdnnf, dsdkkf, dsdenf,&
                      dsdekf, dsdnkf, coor, dpdeg, dpdng,&
                      dpdkg, dsdeeg, dsdnng, dsdkkg, dsdeng,&
                      dsdekg, dsdnkg, dsdxxf, dsdyyf, dsdzzf,&
                      dsdxyf, dsdyzf, dsdxzf, jac)
        integer :: nno
        integer :: nnf
        real(kind=8) :: poids
        real(kind=8) :: dpdef(1)
        real(kind=8) :: dpdnf(1)
        real(kind=8) :: dpdkf(1)
        real(kind=8) :: dsdeef(1)
        real(kind=8) :: dsdnnf(1)
        real(kind=8) :: dsdkkf(1)
        real(kind=8) :: dsdenf(1)
        real(kind=8) :: dsdekf(1)
        real(kind=8) :: dsdnkf(1)
        real(kind=8) :: coor(1)
        real(kind=8) :: dpdeg(1)
        real(kind=8) :: dpdng(1)
        real(kind=8) :: dpdkg(1)
        real(kind=8) :: dsdeeg(1)
        real(kind=8) :: dsdnng(1)
        real(kind=8) :: dsdkkg(1)
        real(kind=8) :: dsdeng(1)
        real(kind=8) :: dsdekg(1)
        real(kind=8) :: dsdnkg(1)
        real(kind=8) :: dsdxxf(1)
        real(kind=8) :: dsdyyf(1)
        real(kind=8) :: dsdzzf(1)
        real(kind=8) :: dsdxyf(1)
        real(kind=8) :: dsdyzf(1)
        real(kind=8) :: dsdxzf(1)
        real(kind=8) :: jac
    end subroutine dsfch3
end interface
