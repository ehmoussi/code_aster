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
    subroutine  mmgnee(ndim  ,nne   ,wpg   ,ffe   , &
               jacobi,coefac,jeu   ,dlagrc,vech1 , &
               vech2 ,hah   ,kappa ,mprt11,mprt21, &
               mprt22,matree)
         
         
        integer :: ndim
        integer :: nne

    
        real(kind=8) :: wpg
        real(kind=8) :: ffe(9)
        real(kind=8) :: jacobi
        real(kind=8) :: coefac
        real(kind=8) :: jeu
        real(kind=8) :: dlagrc
    
        real(kind=8) :: mprt11(3, 3)
        real(kind=8) :: mprt21(3, 3)
    real(kind=8) :: mprt22(3, 3)

    real(kind=8) :: kappa(2,2)
    real(kind=8) :: hah(2,2)
    
    real(kind=8) :: vech1(3)
    real(kind=8) :: vech2(3)

        real(kind=8) :: matree(27, 27)
    end subroutine mmgnee
end interface
