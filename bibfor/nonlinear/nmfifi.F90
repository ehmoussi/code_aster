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

subroutine nmfifi(npg, typmod, geom, sigma, fint)
!
!
    implicit none
#include "asterf_types.h"
#include "asterfort/nmfisa.h"
#include "asterfort/r8inir.h"
    integer :: npg
    real(kind=8) :: geom(2, 4), sigma(2, npg), fint(8)
    character(len=8) :: typmod(2)
!
!-----------------------------------------------------------------------
!
! BUT:
!      CALCUL DES FINT = ( B_T SIGMA) POUR L'OPTION FORC_NODA
!      SUBROUTINE APPELEE DANS LE TE0202
!
! IN  : GEOM,SIGMA,NPG,TYPMOD
! OUT : FINT
!-----------------------------------------------------------------------
!
    aster_logical :: axi
    integer :: i, j, kpg
    real(kind=8) :: b(2, 8), poids
!-----------------------------------------------------------------------
!
!
!    INITIALISATION
    axi = typmod(1).eq.'AXIS'
    call r8inir(8, 0.d0, fint, 1)
!
!
!    BOUCLE SUR LES POINTS DE GAUSS
!
    do 11 kpg = 1, npg
!
!      CALCUL DU POIDS ET DE LA MATRICE B
        call nmfisa(axi, geom, kpg, poids, b)
!
!      CALCUL DES FINT = ( B_T SIGMA ) :
        do 20 i = 1, 8
            do 40 j = 1, 2
                fint(i) = fint(i) + poids*b(j,i)*sigma(j,kpg)
 40         continue
 20     continue
!
 11 end do
end subroutine
