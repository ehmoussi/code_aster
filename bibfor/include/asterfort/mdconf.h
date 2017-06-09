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
    subroutine mdconf(typflu, base, noma, nbm, lnoe,&
                      nuor, iimpr, indic, veci1, vecr1,&
                      vecr2, vecr3, vecr4, vecr5)
        character(len=8) :: typflu
        character(len=8) :: base
        character(len=8) :: noma
        integer :: nbm
        integer :: lnoe
        integer :: nuor(*)
        integer :: iimpr
        integer :: indic
        integer :: veci1(*)
        real(kind=8) :: vecr1(*)
        real(kind=8) :: vecr2(*)
        real(kind=8) :: vecr3(*)
        real(kind=8) :: vecr4(*)
        real(kind=8) :: vecr5(*)
    end subroutine mdconf
end interface
