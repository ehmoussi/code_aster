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

subroutine gdliva(kp, vari, ca)
!
! FONCTION: POUR UN ELEMENT DE POUTRE EN GRAND DEPLACEMENT, LIT  , DANS
!           LES VARIABLES INTERNES 'PVARIMR', LE VECTEUR-COURBURE AU
!           POINT DE GAUSS KP A L'ITERATION PRECEDENTE
!
!     IN  : KP        : NUMERO DU POINT DE GAUSS
!           VARI      : CHAMP DES 'PVARIMR'
!
!     OUT : CA        : VECTEUR-COURBURE (3)
! ------------------------------------------------------------------
    implicit none
    real(kind=8) :: vari(*), ca(3)
!
!-----------------------------------------------------------------------
    integer :: i, k, kp
!-----------------------------------------------------------------------
    k = (kp-1) * 3
    do 1 i = 1, 3
        k = k + 1
        ca(i) = vari(k)
 1  end do
end subroutine
