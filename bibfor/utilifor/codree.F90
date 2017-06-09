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

subroutine codree(reel, mode, chaine)
    implicit none
#include "asterf_types.h"
    real(kind=8) :: reel
    character(len=*) :: mode, chaine
!     CONVERSION D'UN REEL EN CHAINE
!     ------------------------------------------------------------------
! IN   REEL   : R8 : REEL A ECRIRE
! IN   MODE   : K  : MODE DE CONVERSION (ECRITURE) DU REEL
!                     'E' : FORMAT EXPOSANT
!                     'F' : FORMAT FLOTTANT
!                     'G' : FORMAT GENERALISE
! OUT  CHAINE : K* : CHAINE RECEPTACLE
!     ------------------------------------------------------------------
!     REMARQUE: ON A TOUJOURS LE POINT DECIMAL ET UN CHIFFRE POUR LA
!               PARTIE ENTIERE
!     ------------------------------------------------------------------
!     CONVENTION : SI LA CONVERSION EST IMPOSSIBLE ON METS DES ETOILES
!     ------------------------------------------------------------------
!     CONVENTION EN MODE 'E' :
!         - ON A TOUJOURS UN CHIFFRE POUR LA PARTIE ENTIERE
!         - L'EXPOSANT EST SUPPOSE ETRE A DEUX CHIFFRES
!     EXEMPLE  0.25 SERA CONVERTI EN 2.50 ... 0E-01
!     ------------------------------------------------------------------
    character(len=2) :: p
    character(len=10) :: format
    integer :: long, nbchif
    real(kind=8) :: valeur
    aster_logical :: marktr
!     ------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: ient, ii, il, im, ndec
!-----------------------------------------------------------------------
    long = len(chaine)
    if (long .lt. 2) goto 900
    nbchif = long-1
    if (reel .ge. 0.d0) then
        valeur = reel
    else
        valeur = -reel
        nbchif = nbchif-1
    endif
    if (nbchif .lt. 1) goto 900
!     VERIFIER QUE NBCHIF <= NB_CHIF_MAX_MACHINE
!
!
    if (mode .eq. 'E') then
        p = '1P'
        ndec = nbchif-6
        if (ndec .lt. 0) goto 900
    else if (mode .eq. 'F') then
!        NOMBRE DE CHIFFRE DE LA PARTIE ENTIERE
        p = '  '
        ient = int( log10(valeur)) + 1
        if (ient .ge. 0) then
            ndec = nbchif - ient
        else
            ndec = nbchif
        endif
        if (ndec .lt. 0) goto 900
    else if (mode .eq. 'G') then
        p = '  '
        ndec = nbchif-5
        if (ndec .lt. 0) goto 900
    else
        goto 900
    endif
    write( format, '( ''('',A2,A1,I2,''.'',I2,'')'' )' ) p,mode,&
     &      nbchif,ndec
    write( chaine, format ) reel
    if (mode .eq. 'E') then
        im = 0
        marktr = .false.
        do 50 il = 1, long
            ii = long-il+1
            if (((chaine(ii:ii).eq.'+').or.(chaine(ii:ii).eq.'-')) .and. (.not.marktr)) then
                im = ii
                marktr = .true.
            endif
            if (chaine(ii:ii) .eq. 'E') goto 999
 50     continue
        if (im .gt. 1) chaine(im-1:im-1) = 'E'
    endif
    goto 999
!     ------------------------------------------------------------------
900 continue
    do 910 il = 1, long
        chaine(il:il) = '*'
910 end do
!     ------------------------------------------------------------------
999 continue
end subroutine
