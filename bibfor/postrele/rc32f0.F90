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

subroutine rc32f0(nbsigr, nocc, saltij, saltm, trouve,&
                  isk, isl, nk, nl)
    implicit none
#include "asterf_types.h"
    integer :: nbsigr, nocc(*), isk, isl, nl, nk
    real(kind=8) :: saltij(*), saltm
    aster_logical :: trouve
!
!     CALCUL DU FACTEUR D'USAGE POUR LES SITUATIONS DE PASSAGE
!     RECHERCHE DU SALT MAXI SUPERIEUR A 0.
! OUT : SALTM : VALEUR MAXIMUM DANS LA MATRICE DES SALT
! OUT : ISK   : SITATION K DONNANT LE SALT MAXI
! OUT : ISL   : SITATION L DONNANT LE SALT MAXI
! OUT : NK    : NB D'OCCURENCE DE LA SITATION K
! OUT : NL    : NB D'OCCURENCE DE LA SITATION L
!
!     ------------------------------------------------------------------
    integer :: k, l
    real(kind=8) :: salt
!     ------------------------------------------------------------------
!
! --- RECHERCHE DU SALT MAXI
!
    do 20 k = 1, nbsigr
!
        if (nocc(k) .eq. 0) goto 20
!
        do 22 l = 1, nbsigr
!
            if (nocc(l) .eq. 0) goto 22
!
            salt = saltij(nbsigr*(k-1)+l)
!
            if (salt .gt. saltm) then
                trouve = .true.
                saltm = salt
                isk = k
                isl = l
                nl = nocc(isl)
                nk = nocc(isk)
            endif
!
 22     continue
!
 20 end do
!
end subroutine
