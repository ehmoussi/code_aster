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
#include "asterf_types.h"
!
interface
    subroutine iremed(nomcon, ifichi, nocham, novcmp, partie,&
                      liordr, lresu, nbnoec, linoec, nbmaec,&
                      limaec, nomcmp, lvarie, carael, linopa)
        character(len=*) :: nomcon
        integer :: ifichi
        character(len=*) :: nocham
        character(len=*) :: novcmp
        character(len=*) :: partie
        character(len=*) :: liordr
        aster_logical :: lresu
        integer :: nbnoec
        integer :: linoec(*)
        integer :: nbmaec
        integer :: limaec(*)
        character(len=*) :: nomcmp
        aster_logical :: lvarie
        character(len=8) :: carael
        character(len=19) :: linopa
    end subroutine iremed
end interface
