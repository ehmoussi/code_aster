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

subroutine lcprsn(n, x, y, p)
    implicit none
    integer :: n
    real(kind=8) :: x(n), y(n), p
!
! LOI DE COMPORTEMENT - PRODUIT SCALAIRE DE 2 VECTEURS - VERSION NORMALE
! *      *              **      *                                *
!
! ----------------------------------------------------------------------
!
! IN  N    : DIMENSION DES VECTEURS X ET Y
! IN  X    : VECTEUR X
! IN  Y    : VECTEUR Y
! OUT P    : PRODUIT SCALAIRE DE X ET Y
!
! ----------------------------------------------------------------------
!
    integer :: i
!
    p = 0.d0
    do 1 i = 1, n
        p = p + x(i)*y(i)
 1  continue
end subroutine
