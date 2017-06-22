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

subroutine utacli(x, liste, indmax, tole, indice)
!
!
    implicit none
    integer :: indmax, indice
    real(kind=8) :: x, liste(0:indmax-1), tole
!
! ----------------------------------------------------------------------
!               RECHERCHE DANS UNE LISTE DE REELS MONOTONE
! ----------------------------------------------------------------------
! IN  X      : REEL RECHERCHE
! IN  LISTE  : LISTE (0:INDMAX-1) DE TAILLE INDMAX
! IN  INDMAX : INDICE MAXIMUM DANS LA LISTE
! IN  TOLE   : TOLERANCE ABSOLUE AUTORISEE
! OUT INDICE : INDICE DU REEL LE PLUS PROCHE DANS LE SEUIL DE TOLERANCE
!               INDICE = -1 : REEL NON TROUVE
! ----------------------------------------------------------------------
!
    integer :: i
    real(kind=8) :: delta, delmin
! ----------------------------------------------------------------------
!
!
!    RECHERCHE DU PREMIER INDICE CORRESPONDANT
    do 10 i = 0, indmax-1
        delta = abs(x-liste(i))
        if (delta .le. tole) goto 100
10  end do
!
!    AUCUN INDICE TROUVE
    indice = -1
    goto 9999
!
!    RECHERCHE DE L'INDICE OPTIMAL (CARACTERE MONOTONE DE LA LISTE)
100  continue
    indice = i
    delmin = delta
    do 110 i = indice+1, indmax-1
        delta = abs(x-liste(i))
        if (delta .gt. delmin) goto 9999
        delmin = delta
        indice = i
110  end do
!
!
9999  continue
end subroutine
