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

subroutine matdn(nb1, xr, intsn, madn, nks1,&
                 nks2)
!
!
! ......................................................................
!     FONCTION :  CALCUL DE
!
!                 MADN ( 3 ,  6 * NB1  + 3 ) = TRANSLATION SEULEMENT
!
!                 AUX POINTS D INTEGRATION NORMALE
!
! ......................................................................
!
!
!
    implicit none
!
#include "asterfort/r8inir.h"
    real(kind=8) :: madn ( 3 , 51 )
    real(kind=8) :: nks1 ( 3 , 51 )
    real(kind=8) :: nks2 ( 3 , 51 )
    real(kind=8) :: xr ( * )
!
    integer :: jn
!
    integer :: intsn
!
    integer :: nb1
    integer :: ii
!
!DEB
!
!---- INITIALISATION
!
    call r8inir(3 * 51, 0.d0, madn, 1)
    call r8inir(3 * 51, 0.d0, nks1, 1)
    call r8inir(3 * 51, 0.d0, nks2, 1)
!
!---- LES ADRESSES DES FONCTIONS DE FORME ET DE LEURS DERIVEES
!     DECALAGE DE 8 NOEUDS DE SERENDIP ET 9 NOEUDS DE LAGRANGE
!
!---------- NOEUDS DE SERENDIP
!
    do 100 jn = 1, nb1
!
!------- PARTIE TRANSLATION
!
        do 400 ii = 1, 3
!
            madn ( ii , ( jn - 1 ) * 6 + ii ) = xr ( 135 + 8 * (&
            intsn - 1 ) + jn )
!
            nks1 ( ii , ( jn - 1 ) * 6 + ii ) = xr ( 207 + 8 * (&
            intsn - 1 ) + jn )
!
            nks2 ( ii , ( jn - 1 ) * 6 + ii ) = xr ( 279 + 8 * (&
            intsn - 1 ) + jn )
!
400      continue
!
100  end do
!
!FIN
!
end subroutine
