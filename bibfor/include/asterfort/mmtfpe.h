! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
    subroutine mmtfpe(phasep,iresof,ndim  ,nne   ,nnm   , &
                  nnl   ,nbcps ,wpg   ,jacobi, ffl  , &
                  ffe   ,ffm    ,norm  ,tau1  , &
                  tau2  ,mprojn,mprojt,rese  ,nrese , &
                  lambda,coefff,coefaf,coefac, &
                  dlagrf,djeut ,matree,matrmm, &
                  matrem,matrme,matrec,matrmc,matref, &
                  matrmf)
        character(len=9) :: phasep
        integer :: iresof
        integer :: ndim
        integer :: nne
        integer :: nnm
        integer :: nnl
        integer :: nbcps
        real(kind=8) :: wpg
        real(kind=8) :: jacobi
        real(kind=8) :: ffl(9)
        real(kind=8) :: ffe(9)
        real(kind=8) :: ffm(9)
        real(kind=8) :: norm(3)
        real(kind=8) :: tau1(3)
        real(kind=8) :: tau2(3)
        real(kind=8) :: mprojn(3, 3)
        real(kind=8) :: mprojt(3, 3)
        real(kind=8) :: rese(3)
        real(kind=8) :: nrese
        real(kind=8) :: lambda
        real(kind=8) :: jeu
        real(kind=8) :: coefff
        real(kind=8) :: coefaf
        real(kind=8) :: coefac
        real(kind=8) :: dlagrf(2)
        real(kind=8) :: djeut(3)
        real(kind=8) :: matree(27, 27)
        real(kind=8) :: matrmm(27, 27)
        real(kind=8) :: matrem(27, 27)
        real(kind=8) :: matrme(27, 27)
        real(kind=8) :: matrec(27, 9)
        real(kind=8) :: matrmc(27, 9)
        real(kind=8) :: matref(27, 18)
        real(kind=8) :: matrmf(27, 18)
    end subroutine mmtfpe
end interface
