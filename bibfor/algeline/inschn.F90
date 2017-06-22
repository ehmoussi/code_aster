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

subroutine inschn(andi, ndi, xadj, adjncy, chaine,&
                  nouv, place, debut)
! person_in_charge: olivier.boiteau at edf.fr
    implicit none
    integer :: andi, xadj(*), ndi, chaine(*), nouv(*), adjncy(*)
    integer :: place(*)
!     INSERTION DANS LA CHAINE,
!     DES VOISINS DE NDI,(DE NUMERO SUPERIEUR)
!     QUI NE SONT PAS ENCORE DANS LA CHAINE (PLACE(NDJ)=0)
    integer :: j, suiv, cour, ndj
    integer :: debut
!
    do 150 j = xadj(andi), xadj(andi+1) - 1
        ndj = nouv(adjncy(j))
        if (ndj .gt. ndi) then
            if (place(ndj) .eq. 0) then
                suiv= debut
145              continue
                if (suiv .lt. ndj) then
                    cour = suiv
                    suiv = chaine(cour)
                    goto 145
                endif
                if (suiv .gt. ndj) then
                    chaine(cour) = ndj
                    chaine(ndj) = suiv
                    place(ndj)=1
                endif
            endif
        endif
150  continue
end subroutine
