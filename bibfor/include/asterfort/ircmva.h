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
    subroutine ircmva(numcmp, ncmpve, ncmprf, nvalec, nbpg,&
                      nbsp, adsv, adsd, adsl, adsk,&
                      partie, tymast, modnum, nuanom, typech,&
                      val, profas, ideb, ifin, codret)
        integer :: nbsp
        integer :: nbpg
        integer :: nvalec
        integer :: ncmprf
        integer :: ncmpve
        integer :: numcmp(ncmprf)
        integer :: adsv
        integer :: adsd
        integer :: adsl
        integer :: adsk
        character(len=*) :: partie
        integer :: tymast
        integer :: modnum(69)
        integer :: nuanom(69, *)
        character(len=8) :: typech
        real(kind=8) :: val(ncmpve, nbsp, nbpg, nvalec)
        integer :: profas(*)
        integer :: ideb
        integer :: ifin
        integer :: codret
    end subroutine ircmva
end interface
