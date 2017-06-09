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
    subroutine conini(ma, noecon, maicon, marcon, nbmar,&
                      nbnoe, nbmarc, nommar, jmicor, mbcor,&
                      nomtyr, nbgco, io8gco)
        integer :: nbnoe
        integer :: nbmar
        character(len=8) :: ma
        integer :: noecon(nbnoe)
        integer :: maicon(nbmar)
        integer :: marcon(nbmar)
        integer :: nbmarc
        character(len=8) :: nommar(nbmar)
        integer :: jmicor(nbmar)
        integer :: mbcor(nbmar)
        character(len=8) :: nomtyr(nbmar)
        integer :: nbgco
        integer :: io8gco
    end subroutine conini
end interface
