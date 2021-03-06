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
    subroutine deltau(jrwork, jnbpg, nbpgt, nbordr, ordini,&
                      nmaini, nbmap, numpaq, tspaq, nommet,&
                      nomcri, nomfor, grdvie, forvie,forcri, cesr)
        integer :: jrwork
        integer :: jnbpg
        integer :: nbpgt
        integer :: nbordr
        integer :: ordini
        integer :: nmaini
        integer :: nbmap
        integer :: numpaq
        integer :: tspaq
        character(len=16) :: nommet
        character(len=16) :: nomcri
        character(len=16) :: nomfor
        character(len=16) :: grdvie
        character(len=16) :: forvie
        character(len=16) :: forcri
        character(len=19) :: cesr
    end subroutine deltau
end interface
