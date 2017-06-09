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
    subroutine dgfassefibres(nboccasf, iinbgf, tousgroupesnom, tousgroupesnbf, maxmailgrp, &
                             ulnbnoeuds, ulnbmailles, nbfibres2, maxfibre2, ncarfi2, nbocctype1)
        integer :: nboccasf
        integer :: iinbgf
        integer :: maxmailgrp
        integer :: ulnbnoeuds
        integer :: ulnbmailles
        integer :: nbfibres2
        integer :: tousgroupesnbf(*)
        integer :: maxfibre2
        integer :: ncarfi2
        integer :: nbocctype1
        character(len=24) :: tousgroupesnom(*)
    end subroutine dgfassefibres
end interface
