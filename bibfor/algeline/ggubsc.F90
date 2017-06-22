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

subroutine ggubsc(dseed, nr, cr)
    implicit none
    real(kind=8) :: dseed
    complex(kind=8) :: cr(*)
    integer :: nr
!     GENERATEUR DE NOMBRES (PSEUDO-)ALEATOIRES UNIFORMEMENT REPARTIS
!     ENTRE (0,1)                                     (CF GGUBS DE IMSL)
!     ------------------------------------------------------------------
!     CETTE VERSION NE FONCTIONNE QUE SUR DES MACHINES CODANT REELS OU
!     ENTIERS SUR AU MOINS 32 BITS.
!     ------------------------------------------------------------------
! VAR DSEED  - EN ENTREE UNE VALEUR ENTRE (1.E0, 2147483647.E0).
!            - EN SORTIE UNE AUTRE VALEUR POUR LE PROCHAIN TIRAGE.
! IN  NR     - NOMBRE DE VALEUR A TIRER
! OUT CR     - TABLEAU CONTENANT LES VALEURS TIREES
!     ------------------------------------------------------------------
!             D2P31M=(2**31)-1,    D2P31 =(2**31)
    real(kind=8) :: d2p31m, d2p31
!-----------------------------------------------------------------------
    integer :: i, idseed
    real(kind=8) :: dseed0
!-----------------------------------------------------------------------
    data    d2p31m/2147483647.d0/, d2p31/2147483648.d0/
!     ------------------------------------------------------------------
    do 10 i = 1, nr
        idseed = int(16807.d0*dseed/d2p31m)
        dseed = 16807.d0*dseed-idseed*d2p31m
        dseed0 = dseed
        idseed = int(16807.d0*dseed/d2p31m)
        dseed = 16807.d0*dseed-idseed*d2p31m
        cr(i) = dcmplx(dseed0/d2p31,dseed / d2p31)
10  end do
end subroutine
