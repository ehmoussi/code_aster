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
    subroutine vp1pro(optiom, lraide, lmasse, ldynam, neq,&
                      nfreq, nfreqb, tolv, nitv, iexcl,&
                      fcorig, vec, resufi, resufr, resufk,&
                      nbrssa, nbpari, nbparr, nbpark, typres,&
                      optiof, solveu)
        integer :: nbpark
        integer :: nbparr
        integer :: nbpari
        integer :: nfreqb
        integer :: neq
        character(len=*) :: optiom
        integer :: lraide
        integer :: lmasse
        integer :: ldynam
        integer :: nfreq
        real(kind=8) :: tolv
        integer :: nitv
        integer :: iexcl(*)
        real(kind=8) :: fcorig
        real(kind=8) :: vec(neq, *)
        integer :: resufi(nfreqb, nbpari)
        real(kind=8) :: resufr(nfreqb, nbparr)
        character(len=*) :: resufk(nfreqb, nbpark)
        integer :: nbrssa
        character(len=16) :: typres
        character(len=16) :: optiof
        character(len=19) :: solveu
    end subroutine vp1pro
end interface
