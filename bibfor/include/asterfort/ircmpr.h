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
    subroutine ircmpr(nofimd, typech, nbimpr, ncaimi, ncaimk,&
                      ncmprf, ncmpve, ntlcmp, nbvato, nbenec,&
                      lienec, adsd, adsl, nomaas, modele,&
                      typgeo, nomtyp, ntproa, chanom, sdcarm)
        character(len=*) :: nofimd
        character(len=8) :: typech
        integer :: nbimpr
        character(len=24) :: ncaimi
        character(len=24) :: ncaimk
        integer :: ncmprf
        integer :: ncmpve
        character(len=*) :: ntlcmp
        integer :: nbvato
        integer :: nbenec
        integer :: lienec(*)
        integer :: adsd
        integer :: adsl
        character(len=8) :: nomaas
        character(len=8) :: modele
        integer :: typgeo(*)
        character(len=8) :: nomtyp(*)
        character(len=*) :: ntproa
        character(len=19) :: chanom
        character(len=8) :: sdcarm
    end subroutine ircmpr
end interface
