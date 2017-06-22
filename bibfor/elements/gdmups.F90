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

subroutine gdmups(ne, kp, ajacob, en, enprim,&
                  ups)
!
! FONCTION: POUR UN ELEMENT DE POUTRE EN GRAND DEPLACEMENT, CALCULE LA
!           CONTRIBUTION DU NOEUD NE A LA MATRICE UPSILON AU POINT DE
!           GAUSS KP. CETTE MATRICE UPSILON INTERVIENT DANS LA RIGIDITE
!           GEOMETRIQUE COMME LA MATRICE DE DEFORMATION B INTERVIENT
!           DANS LA RIGIDITE MATERIELLE.
!
!     IN  : NE        : NUMERO DU NOEUD
!           KP        : NUMERO DU POINT DE GAUSS
!           AJACOB    : JACOBIEN
!           EN        : FONCTIONS DE FORME
!           ENPRIM    : DERIVEES DES FONCTIONS DE FORME
!
!     OUT : UPS       : MATRICE 9*6
! ------------------------------------------------------------------
    implicit none
    real(kind=8) :: en(3, 2), enprim(3, 2), ups(9, 6)
!
!-----------------------------------------------------------------------
    integer :: i, j, kp, ne
    real(kind=8) :: ajacob, form, formpr, un, unsurj, zero
!-----------------------------------------------------------------------
    zero = 0.d0
    un = 1.d0
    do 2 j = 1, 6
        do 1 i = 1, 9
            ups(i,j) = zero
 1      end do
 2  end do
    unsurj = un / ajacob
    form = en(ne,kp)
    formpr = unsurj * enprim(ne,kp)
    do 3 i = 1, 6
        ups(i,i) = formpr
 3  end do
    do 4 i = 1, 3
        ups(6+i,3+i) = form
 4  end do
end subroutine
