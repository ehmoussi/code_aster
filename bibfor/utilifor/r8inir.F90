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

subroutine r8inir(n, sa, sx, incx)
    implicit none
    integer :: n, incx
    real(kind=8) :: sa, sx(*)
!     INITIALISATION D'UN VECTEUR SX A LA VALEUR SA.
!     ------------------------------------------------------------------
! IN  N    : I :  NOMBRE D'ELEMENTS DANS LE VECTEUR
! IN  SA   : R :  VALEUR D'INITIALISATION
! OUT SX   : R :  VECTEUR A INITIALISER
! IN  INCX : I :  INCREMENT  POUR  LE  VECTEUR  X
!     ------------------------------------------------------------------
!     LES  ARGUMENTS SX ET SY  CORRESPONDENT AU PREMIER TERME DE CHAQUE
!     VECTEUR  UTILISE  DANS  LA  BOUCLE .
!     EXEMPLE:
!     -  INCX EST POSITIF , CETTE  UNITE  PART  DE  X(1)  ET  DESCEND
!     EN  UTILISANT  X(1+INCX) , X(1+2*INCX) , ETC....
!     -  INCX EST NEGATIF , PRENONS -2 , CETTE   UNITE  VA  UTILISER
!     SUCCESSIVEMENT  X(1) , X(-1) , X(-3) , ETC....
!     ------------------------------------------------------------------
    integer :: i
!-----------------------------------------------------------------------
    do 1 i = 1, n
        sx( 1+(i-1)*incx ) = sa
 1  end do
end subroutine
