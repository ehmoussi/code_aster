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
    subroutine ircam1(nofimd, nochmd, existc, ncmprf, numpt,&
                      instan, numord, adsd, adsv, adsl,&
                      adsk, partie, ncmpve, ntlcmp, ntncmp,&
                      ntucmp, ntproa, nbimpr, caimpi, caimpk,&
                      typech, nomamd, nomtyp, modnum, nuanom,&
                      codret)
        integer :: nbimpr
        character(len=*) :: nofimd
        character(len=64) :: nochmd
        integer :: existc
        integer :: ncmprf
        integer :: numpt
        real(kind=8) :: instan
        integer :: numord
        integer :: adsd
        integer :: adsv
        integer :: adsl
        integer :: adsk
        character(len=*) :: partie
        integer :: ncmpve
        character(len=24) :: ntlcmp
        character(len=24) :: ntncmp
        character(len=24) :: ntucmp
        character(len=24) :: ntproa
        integer :: caimpi(10, nbimpr)
        character(len=*) :: caimpk(3, nbimpr)
        character(len=8) :: typech
        character(len=*) :: nomamd
        character(len=8) :: nomtyp(*)
        integer :: modnum(69)
        integer :: nuanom(69, *)
        integer :: codret
    end subroutine ircam1
end interface
