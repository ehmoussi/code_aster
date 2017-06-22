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
    subroutine pacouc(typflu, vecr1, vecr2, vite, vecr3,&
                      masg, freq, amor, nbno, indic,&
                      nbpv, w, veci1, vecr4, vecr5,&
                      ier)
        character(len=8) :: typflu
        real(kind=8) :: vecr1(*)
        real(kind=8) :: vecr2(*)
        real(kind=8) :: vite(*)
        real(kind=8) :: vecr3(*)
        real(kind=8) :: masg(*)
        real(kind=8) :: freq(*)
        real(kind=8) :: amor(*)
        integer :: nbno
        integer :: indic
        integer :: nbpv
        real(kind=8) :: w(*)
        integer :: veci1(*)
        real(kind=8) :: vecr4(*)
        real(kind=8) :: vecr5(*)
        integer :: ier
    end subroutine pacouc
end interface
