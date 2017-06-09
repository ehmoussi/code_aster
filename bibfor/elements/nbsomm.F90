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

subroutine nbsomm(typema, nbso)
    implicit none
    character(len=8) :: typema
    integer :: nbso
!
!     DONNE LE NOMBRE DE SOMMETS POUR UN TYPE DE MAILLES
!
    if (typema(1:4) .eq. 'HEXA') then
        nbso=8
    else if (typema(1:4).eq.'PENT') then
        nbso=6
    else if (typema(1:4).eq.'TETR') then
        nbso=4
    else if (typema(1:4).eq.'QUAD') then
        nbso=4
    else if (typema(1:4).eq.'TRIA') then
        nbso=3
    else if (typema(1:3).eq.'SEG') then
        nbso=2
    else
! CONDITIONS AUX LIMITES PONCTUELLES (POUR MODELE ENDO_HETEROGENE)
        nbso=1
!
    endif
end subroutine
