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

function dis2no(geom, ino1, ino2)
    implicit none
    real(kind=8) :: dis2no
#include "asterfort/padist.h"
    integer :: ino1, ino2
    real(kind=8) :: geom(*)
!
!
!     BUT : CALCULER LA DISTANCE ENTRE 2 NOEUDS
!           A PARTIR DES NUMEROS DES NOEUDS
!
! IN   GEOM   : VALEURS DES COORDONNEES DES NOEUDS DU MAILLAGE
! IN   INO1   : INDICE DU PREMIER NOEUD
! IN   INO2   : INDICE DU DEUXIEME NOEUDS
! OUT  DIS2NO : DISTANCE ENTRE LES 2 NOEUDS
!
!---------------------------------------------------------------------
!
    real(kind=8) :: a(3), b(3)
    integer :: i
!
!---------------------------------------------------------------------
!
    do 10 i = 1, 3
        a(i) = geom(3*(ino1-1)+i)
        b(i) = geom(3*(ino2-1)+i)
10  end do
    dis2no = padist(3,a,b)
!
end function
