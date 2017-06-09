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

subroutine pmfpti(num,poids,vff, xl, xi,&
                  wi, b, g)
    implicit none
    integer :: num
    real(kind=8) :: poids(*), vff(2,*), xl, xi, wi, b(4), g
! -----------------------------------------------------------
! ---  POSITION ET POIDS DES POINTS DE GAUSS + MATRICE B
!         DE L'ELEMENT POUTRE EULER (HERMITE)
! --- IN : LONGUEUR DE L'ELEMENT XL
! --- IN : NUMERO DU POINT DE GAUSS
! --- IN : POIDS DU POINT DE GAUSS SUR L'ELEMENT DE REFERENCE
! --- IN : NUMERO DU POINT DE GAUSS
! --- OUT : XI POSITION DU POINT
!           WI POIDS DE CE POINT
!           B MATRICE B (4 VALEURS DIFFERENTES NON NULLES)
! -----------------------------------------------------------
    
    integer :: ino
    real(kind=8) :: un, deux, quatre, six, douze
    parameter (un=1.d0,deux=2.d0,quatre=4.d0,six=6.d0,douze=12.d0)
    real(kind=8) :: xp(2)
    data xp /0.d0 , 1.d0/
!
    xi = 0.d0
    if (num .gt. 0) then
!       NUM=1 OU 2 : POINTS DE GAUSS
        do ino = 1,2
            xi = xi + xp(ino)*vff(ino,num)
        enddo
!       LE JACOBIEN L/2 EST MIS DIRECTEMENT DANS LE POIDS
        wi=poids(num)*xl/deux
    else
!       NUM=-1 OU -2 : NOEUDS
        xi=xp(-num)
    endif
!     -- ON NE STOCKE PAS LES 0. DE LA MATRICE B,
!        ON NE CALCULE PAS LES OPPOSES
    b(1)=un/xl
    b(2)=(-six+douze*xi)/xl/xl
    b(3)=(-quatre+six*xi)/xl
    b(4)=(-deux+six*xi)/xl
!
    g=(-deux*xi+un)*quatre/xl
!
end subroutine
