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
    subroutine mmtgeo(phasep,ndim  ,nne   ,nnm   ,mprt1n, &
              mprt2n,mprojn,mprt11,mprt21,mprt22, &
          wpg   ,ffe   ,ffm   ,dffm  ,ddffm,jacobi, &
          coefac,jeu   ,dlagrc,kappa ,vech1 , &
          vech2 ,h        ,hah  ,norm, &
          matree,matrmm,matrem, matrme)
          
        character(len=9) :: phasep
    
        integer :: ndim
        integer :: nne
        integer :: nnm
        
    real(kind=8) :: mprojn(3, 3)
        
        real(kind=8) :: wpg
        real(kind=8) :: ffe(9)
        real(kind=8) :: ffm(9)
        real(kind=8) :: dffm(2, 9)
        real(kind=8) :: ddffm(3, 9)
        real(kind=8) :: jacobi
        real(kind=8) :: coefac        
        real(kind=8) :: jeu
        real(kind=8) :: dlagrc
    
        real(kind=8) :: mprt1n(3, 3)
        real(kind=8) :: mprt2n(3, 3)
        real(kind=8) :: mprt11(3, 3)
        real(kind=8) :: mprt21(3, 3)
    real(kind=8) :: mprt22(3, 3)
        
    real(kind=8) ::  kappa(2, 2)
    real(kind=8) ::  h(2,2)  
    real(kind=8) ::  hah(2,2)    
    
    real(kind=8) :: vech1(3)
    real(kind=8) :: vech2(3)
    real(kind=8) :: norm(3)
        
    real(kind=8) :: matree(27, 27)
        real(kind=8) :: matrmm(27, 27)
        real(kind=8) :: matrem(27, 27)
        real(kind=8) :: matrme(27, 27)
    end subroutine mmtgeo
end interface
