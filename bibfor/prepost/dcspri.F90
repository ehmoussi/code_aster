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

subroutine dcspri(coorp, coori, sprim)
!
!*******************************************************************
!              BUT DE CETTE ROUTINE :                              *
! CALCUL DE LA SURFACE D UN TRIANGLE                               *
!*******************************************************************
!
! IN   COOR*  : COORDONNEES DES NOEUDS DU TRIANGLE
! OUT  SPRIM  : AIRE DU TRIANGLE
!
    implicit none
!
! DECLARATION GLOBALE
!
    real(kind=8) :: coorp(2), coori(2, 2), sprim
!
! DECLARATION LOCALE
!
    real(kind=8) :: xc, yc, xi, yi, xj, yj
!
    xc = coorp(1)
    yc = coorp(2)
    xi = coori(1,1)
    yi = coori(2,1)
    xj = coori(1,2)
    yj = coori(2,2)
!
    sprim=abs((xj-xi)*(yc-yi)-(yj-yi)*(xc-xi))
    sprim=sprim/2.d+0
!
end subroutine
