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

function padist(ndim, coor1, coor2)
    implicit none
    real(kind=8) :: padist
    integer :: ndim, i
    real(kind=8) :: coor1(*), coor2(*), d, x
!     BUT: CALCULER LA DISTANCE ENTRE 2 NOEUDS
!
! IN   NDIM   : DIMENSION DES COORDONNEES
! IN   COOR1  : COORDONNEES DU NOEUD 1
! IN   COOR1  : COORDONNEES DU NOEUD 2
! OUT  PADIST : DISTANCE ENTRE LES 2 NOEUDS
!---------------------------------------------------------------------
    d = 0.d0
    do 10 i = 1, ndim
        x = coor1(i) - coor2(i)
        d = d + x*x
10  end do
    if (d .ne. 0.d0) d = sqrt( d )
    padist = d
end function
