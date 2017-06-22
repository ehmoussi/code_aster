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

subroutine dcqpri(coorp1, coorp2, coori, sprim)
!
!************************************
!          BUT DE CETTE ROUTINE :   *
! CALCUL LA SURFACE D UN QUADRANGLE *
!************************************
!
! IN   COOR*  : COORDONNEES DES NOEUDS DU QUADRANGLE
! OUT  SPRIM  : AIRE DU QUADRANGLE
!
    implicit none
!
! DECLARATION GLOBALE
!
    real(kind=8) :: coorp1(2), coorp2(2), coori(2, 2), sprim
!
! DECLARATION LOCALE
!
    real(kind=8) :: x1, y1, x2, y2, x3, y3, x4, y4
!
    x1 = coorp1(1)
    y1 = coorp1(2)
    x2 = coori(1,1)
    y2 = coori(2,1)
    x3 = coori(1,2)
    y3 = coori(2,2)
    x4 = coorp2(1)
    y4 = coorp2(2)
!
    sprim =((x2-x1)*(y4-y1)-(y2-y1)*(x4-x1))&
     &     +((x4-x3)*(y2-y3)-(y4-y3)*(x2-x3))
!
    sprim = abs(sprim)/2.d+0
!
end subroutine
