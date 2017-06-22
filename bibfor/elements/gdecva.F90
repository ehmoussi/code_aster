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

subroutine gdecva(kp, ca, vari)
!
! FONCTION: POUR UN ELEMENT DE POUTRE EN GRAND DEPLACEMENT, ECRIT, DANS
!           LES VARIABLES INTERNES 'PVARIPR', LE VECTEUR-COURBURE ACTUA-
!           LISE AU POINT DE GAUSS KP
!
!     IN  : KP        : NUMERO DU POINT DE GAUSS
!           CA        : VECTEUR-COURBURE (3)
!
!     OUT : VARI      : CHAMP DES 'PVARI(M OU P)R'
! ------------------------------------------------------------------
    implicit none
    real(kind=8) :: ca(3), vari(*)
!
!-----------------------------------------------------------------------
    integer :: i, k, kp
!-----------------------------------------------------------------------
    k = (kp-1) * 3
    do 1 i = 1, 3
        k = k + 1
        vari(k) = ca(i)
 1  end do
end subroutine
