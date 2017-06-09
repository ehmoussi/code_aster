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

subroutine rotati(euler, rot)
    implicit none
!    M. CORUS     DATE 03/02/10
!-----------------------------------------------------------------------
!  BUT:      < CALCUL DE MATRICE DE ROTATION >
!
!  CONSTRUIRE LA MATRICE DE ROTATION COMPLETE A PARTIR DES ANGLES
!  NAUTIQUES
!
!   NB : Equations de passage : un vecteur de coordonnees initiales
!       (X,Y,Z) a pour image le vecteur (X1,Y1,Z1), tel que
!    _                  _    _                  _
!   | 1    0      0     |   | cos(B)  0  sin(B) |
!   | 0  cos(G) -sin(G) | x |   0     1   0     | x ...
!   |_0  sin(G)  cos(G)_|   |_-sin(B) 0 cos(B) _|
!
!   _                   _    _  _    _   _
!  | cos(A) -sin(A)  0  |   | X |   | X1 |
!  | sin(A)  cos(A)  0  | x | Y | = | Y1 |
!  |_ 0       0      1 _|   |_Z_|   |_Z1_|
!
!   A (alpha), B(beta), gamma (G) sont les angle nautiques
!
!  ON CONSTRUIT ROT TELLE QUE :
!
!   _    _ _  _    _   _
!  |     || X |   | X1 |
!  | ROT || Y | = | Y1 |
!  |_   _||_Z_|   |_Z1_|
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!
! EULER    /I/: VECTEUR CONTENANT LES 3 ANGLES NAUTIQUES
! ROT      /I/: MATRICE 3x3 DE LA ROTATION
!
!-- VARIABLES EN ENTREES / SORTIE
    real(kind=8) :: euler(3), rota(3, 3)
!
!-- VARIABLES DE LA ROUTINE
    real(kind=8) :: rotb(3, 3), rotc(3, 3), rotd(3, 3), rot(3, 3)
    integer :: i1, j1, k1
!
    rota(1,1)=cos(euler(1))
    rota(1,2)=-sin(euler(1))
    rota(1,3)=0.d0
    rota(2,1)=-rota(1,2)
    rota(2,2)=rota(1,1)
    rota(2,3)=0.d0
    rota(3,1)=0.d0
    rota(3,2)=0.d0
    rota(3,3)=1.d0
!
    rotb(1,1)=cos(euler(2))
    rotb(1,2)=0.d0
    rotb(1,3)=sin(euler(2))
    rotb(2,1)=0.d0
    rotb(2,2)=1.d0
    rotb(2,3)=0.d0
    rotb(3,1)=-rotb(1,3)
    rotb(3,2)=0.d0
    rotb(3,3)=rotb(1,1)
!
    rotc(1,1)=1.d0
    rotc(1,2)=0.d0
    rotc(1,3)=0.d0
    rotc(2,1)=0.d0
    rotc(2,2)=cos(euler(3))
    rotc(2,3)=-sin(euler(3))
    rotc(3,1)=0.d0
    rotc(3,2)= -rotc(2,3)
    rotc(3,3)=rotc(2,2)
!
    rotd(1,1)=0.d0
    rotd(1,2)=0.d0
    rotd(1,3)=0.d0
    rotd(2,1)=0.d0
    rotd(2,2)=0.d0
    rotd(2,3)=0.d0
    rotd(3,1)=0.d0
    rotd(3,2)=0.d0
    rotd(3,3)=0.d0
!
    rot(1,1)=0.d0
    rot(1,2)=0.d0
    rot(1,3)=0.d0
    rot(2,1)=0.d0
    rot(2,2)=0.d0
    rot(2,3)=0.d0
    rot(3,1)=0.d0
    rot(3,2)=0.d0
    rot(3,3)=0.d0
!
    do 20 j1 = 1, 3
        do 30 i1 = 1, 3
            do 40 k1 = 1, 3
                rotd(i1,j1)=rotd(i1,j1)+rotb(i1,k1)*rota(k1,j1)
40          continue
30      continue
20  end do
!
    do 50 j1 = 1, 3
        do 60 i1 = 1, 3
            do 70 k1 = 1, 3
                rot(i1,j1)=rot(i1,j1)+rotc(i1,k1)*rotd(k1,j1)
70          continue
60      continue
50  end do
!
end subroutine
