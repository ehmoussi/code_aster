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

subroutine trfmot(mot, field, ifield)
    implicit  none
    character(len=*) :: mot, field
    integer :: ifield
!
!     EXTRACTION DU CHAMP IFIELD DE L'ENREGISTREMENT
!
! IN  : MOT    : K80  : ENREGISTREMENT CONTENANT LE CHAMP A TRAITER
! OUT : FIELD  : K80  : CHAMP DE NUMERO IFIELD EXTRAIT DE
!                       L'ENREGISTREMENT
! IN  : IFLIED : I    : NUMERO DU CHAMP RECHERCHE
!
!-----------------------------------------------------------------------
    integer :: nbmot, nbcar, ideb, i, j
!
!- INITIALISATION
!
    do 10 i = 1, 80
        field(i:i) = ' '
10  end do
!
    nbmot = 0
    nbcar = 0
    j = 0
!
!- RECHERCHE DU MOT A TRAITER
!
    do 20 i = 1, 80
        if (mot(i:i) .ne. ' ') then
            nbcar = nbcar + 1
            if (nbcar .eq. 1) ideb = i
        else
            if (nbcar .ne. 0) then
                nbmot = nbmot + 1
                if (nbmot .eq. ifield) goto 30
                nbcar = 0
            endif
        endif
20  end do
!
!-TRANSFERT DU CHAMP IFIELD A TRAITER
!
30  continue
    do 40 i = 1, nbcar
        j = ideb - 1 + i
        if (mot(j:j) .ne. ' ') then
            field(i:i) = mot(j:j)
        else
            goto 50
        endif
40  end do
50  continue
!
end subroutine
