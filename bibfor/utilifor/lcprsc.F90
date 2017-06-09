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

subroutine lcprsc(x, y, p)
    implicit none
!       PRODUIT SCALAIRE DE 2 VECTEURS P = <X Y>
!       UTILISABLE COMME PRODUIT TENSORIEL CONTRACTE 2 FOIS A CONDITION
!       QUE LES TENSEURS SOIT REPRESENTES SOUS FORME DE VECTEURS V :
!       V = ( V1 V2 V3 SQRT(2)*V12 SQRT(2)*V13 SQRT(2)*V23 )
!       IN  X      :  VECTEUR
!       IN  Y      :  VECTEUR
!       OUT P      :  SCALAIRE RESULTAT
!       ----------------------------------------------------------------
    integer :: n, nd
    real(kind=8) :: x(6), y(6), p
    common /tdim/   n , nd
!-----------------------------------------------------------------------
    integer :: i
!-----------------------------------------------------------------------
    p = 0.d0
    do 1 i = 1, n
        p = p + x(i)*y(i)
 1  continue
end subroutine
