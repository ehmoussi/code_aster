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

subroutine irgmpf(ifi, versio)
    implicit none
    integer :: ifi, versio
!
!     BUT :   ECRITURE D'UN RESULTAT AU FORMAT GMSH
!
!     ENTREE:
!       IFI    : NUMERO D'UNITE LOGIQUE DU FICHIER GMSH
!     ------------------------------------------------------------------
!
    write(ifi,101) '$PostFormat'
!
    if (versio .eq. 1) then
        write(ifi,102) 1.0d0 , 0, 8
    else if (versio.eq.2) then
        write(ifi,102) 1.2d0 , 0, 8
    endif
!
    write(ifi,103) '$EndPostFormat'
!
    101 format(a11)
    102 format(f4.1,1x,i1,1x,i1)
    103 format(a14)
!
end subroutine
