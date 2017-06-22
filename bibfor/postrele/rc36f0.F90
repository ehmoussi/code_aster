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

subroutine rc36f0(nbsigr, nocc, saltij, saltm, trouve,&
                  isk, isl, i1a4, nk, nl)
    implicit none
#include "asterf_types.h"
    integer :: nbsigr, nocc(*), isk, isl, i1a4, nl, nk
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
! OUT : I1A4  : INDICE 1,2, 3 OU 4 CORESPONDANT AUX INDICES A ET B
!
!     ------------------------------------------------------------------
    integer :: i, k, l, i1, i2
    real(kind=8) :: salt
!     ------------------------------------------------------------------
!
! --- RECHERCHE DU SALT MAXI
!
    do 20 k = 1, nbsigr
!
        if (( nocc(2*(k-1)+1) .eq. 0 ) .and. ( nocc(2*(k-1)+2) .eq. 0 )) goto 20
        i1 = 4*nbsigr*(k-1)
!
        do 22 l = 1, nbsigr
!
            if (( nocc(2*(l-1)+1) .eq. 0 ) .and. ( nocc(2*(l-1)+2) .eq. 0 )) goto 22
            i2 = 4*(l-1)
!
            do 24 i = 1, 4
                salt = saltij(i1+i2+i)
                if (salt .gt. saltm) then
                    trouve = .true.
                    saltm = salt
                    i1a4 = i
                    isk = k
                    isl = l
                    if (i1a4 .eq. 1 .or. i1a4 .eq. 2) then
                        nl = nocc(2*(isl-1)+1)
                    else if (i1a4.eq.3 .or. i1a4.eq.4) then
                        nl = nocc(2*(isl-1)+2)
                    endif
                    if (i1a4 .eq. 1 .or. i1a4 .eq. 3) then
                        nk = nocc(2*(isk-1)+1)
                    else if (i1a4.eq.2 .or. i1a4.eq.4) then
                        nk = nocc(2*(isk-1)+2)
                    endif
                endif
 24         continue
!
 22     continue
!
 20 end do
!
end subroutine
