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

subroutine irvcmp(ncmpmx, nomcgd, nomcmp, nbcmpt)
    implicit   none
    integer :: ncmpmx, nbcmpt
    character(len=*) :: nomcgd(*), nomcmp
!     BUT :   TROUVER SI UNE COMPOSANTE EST PRESENTE DANS LA GRANDEUR
!     ENTREES:
!        NCMPMX : NOMBRE DE COMPOSANTES DE LA GRANDEUR
!        NOMCGD : NOMS DES COMPOSANTES DE LA GRANDEUR
!        NOMCMP : NOM D'UNE COMPOSANTE
!     SORTIES:
!        NBCMPT : COMPOSANTE PRESENTE DANS LA GRANDEUR
! ----------------------------------------------------------------------
    integer :: icmp
!
    do 10 icmp = 1, ncmpmx
        if (nomcmp .eq. nomcgd(icmp)) then
            nbcmpt=nbcmpt+1
            goto 12
        endif
10  end do
12  continue
!
end subroutine
