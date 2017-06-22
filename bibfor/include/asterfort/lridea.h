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
    subroutine lridea(resu, typres, linoch, nbnoch, nomcmd,&
                      listrz, listiz, precis, crit, epsi,&
                      acces, mfich, noma, ligrez, nbvari)
        character(len=8) :: resu
        character(len=*) :: typres
        character(len=*) :: linoch(*)
        integer :: nbnoch
        character(len=*) :: nomcmd
        character(len=*) :: listrz
        character(len=*) :: listiz
        integer :: precis
        character(len=*) :: crit
        real(kind=8) :: epsi
        character(len=*) :: acces
        integer :: mfich
        character(len=8) :: noma
        character(len=*) :: ligrez
        integer :: nbvari
    end subroutine lridea
end interface
