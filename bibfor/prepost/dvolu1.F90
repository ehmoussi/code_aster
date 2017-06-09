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

function dvolu1(numele, coord, norm, volt)
!
!**********************************************************
!              BUT DE CETTE ROUTINE :                     *
! CALCULER LE VOLUME DE L INTERSECTION CYLINDRE-TETRAEDRE *
!**********************************************************
!
! IN   NUMELE : NUMERO DE L ELEMENT
! IN   COORD  : COORDONNEES DES NOEUDS DU TETRA
!               ET DES INTERSECTIONS AVEC LE CYLINDRE
! IN   NORM   : POSITION DES NOEUDS PAR RAPPORT AU CYLINDRE
! IN   VOLT   : VOLUME DES ELEMENTS
! OUT  DVOLU1 : VOLUME DE L INTERSECTION
!
    implicit none
!
! DECLARATION GLOBALE
!
    integer :: numele, norm(2, 4)
    real(kind=8) :: coord(3, 12), volt(*), dvolu1
!
! DECLARATION LOCALE
!
    integer :: i, j, k, l
!
! 1 - RECHERCHE DU POINT INTERNE (NUMELE<0) OU EXTERNE (NUMELE>0)
!
    do 10 j = 1, 4
        if (norm(1,j) .eq. 1 .and. numele .lt. 0) i = j
        if (norm(1,j) .eq. -1 .and. numele .gt. 0) i = j
10  end do
!
! 2 - DETERMINATION DANS LE TABLEAU DES POSITIONS DES INTERSECTIONS
!
    if (i .eq. 1) then
        j = 5
        k = 6
        l = 7
    else if (i.eq.2) then
        j = 8
        k = 5
        l = 9
    else if (i.eq.3) then
        j = 6
        k = 8
        l = 10
    else
        j = 10
        k = 9
        l = 7
    endif
!
! 3 - CALCUL DU VOLUME
!
    dvolu1 =(coord(1,l)-coord(1,i))*&
     &       ((coord(2,j)-coord(2,i))*(coord(3,k)-coord(3,i)) -&
     &        (coord(3,j)-coord(3,i))*(coord(2,k)-coord(2,i)) )
    dvolu1 = dvolu1 +(&
             coord(2,l)-coord(2,i))* ((coord(1,k)-coord(1,i))*(coord(3,j)-coord(3,i)) - (coord(3,&
             &k)-coord(3,i))*(coord(1,j)-coord(1,i))&
             )
    dvolu1 = dvolu1 +(&
             coord(3,l)-coord(3,i))* ((coord(1,j)-coord(1,i))*(coord(2,k)-coord(2,i)) - (coord(2,&
             &j)-coord(2,i))*(coord(1,k)-coord(1,i))&
             )
!
    dvolu1 = dvolu1 / 6.d0
    if (dvolu1 .lt. 0.0d0) dvolu1 = -dvolu1
!
    if (numele .gt. 0) then
        dvolu1 = volt(numele) - dvolu1
    endif
    if (abs(dvolu1) .lt. 1.0d-10) dvolu1 = 0.0d0
    if (dvolu1 .lt. 0.d0) then
        dvolu1 = -dvolu1
    endif
!
end function
