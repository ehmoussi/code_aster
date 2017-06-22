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
    subroutine lceib1(fami, kpg, ksp, imate, compor,&
                      ndim, epsm, sref, sechm, hydrm,&
                      t, lambda, deuxmu, epsthe, kdess,&
                      bendo, gamma, seuil)
        character(len=*) :: fami
        integer :: kpg
        integer :: ksp
        integer :: imate
        character(len=16) :: compor(*)
        integer :: ndim
        real(kind=8) :: epsm(6)
        real(kind=8) :: sref
        real(kind=8) :: sechm
        real(kind=8) :: hydrm
        integer :: t(3, 3)
        real(kind=8) :: lambda
        real(kind=8) :: deuxmu
        real(kind=8) :: epsthe(2)
        real(kind=8) :: kdess
        real(kind=8) :: bendo
        real(kind=8) :: gamma
        real(kind=8) :: seuil
    end subroutine lceib1
end interface
