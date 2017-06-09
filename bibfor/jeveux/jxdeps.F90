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

subroutine jxdeps(iadini, iadfin, lso)
! person_in_charge: j-pierre.lefebvre at edf.fr
!     DEPLACEMENT D'UNE ZONE MEMOIRE
!     ------------------------------------------------------------------
! IN  IADINI : ADRESSE INITIALE
! IN  IADFIN : ADRESSE CIBLE
! IN  LSO : LONGUEUR DE LA ZONE A DEPLACER
!     ------------------------------------------------------------------
    implicit none
!             ROUTINE AVEC ADHERENCE SYSTEME    CRAY
!             FONCTION(S) UTILISEE(S) : IAND
!
#include "jeveux_private.h"
    integer :: iadini, iadfin, lso
!     ------------------------------------------------------------------
    integer :: lk1zon, jk1zon, liszon, jiszon
    common /izonje/  lk1zon , jk1zon , liszon , jiszon
!     ------------------------------------------------------------------
    integer :: mslois
    common /jenvje/  mslois
    integer :: lbis, lois, lols, lor8, loc8
    common /ienvje/  lbis , lois , lols , lor8 , loc8
! DEB ------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: i, jfin, jini
!-----------------------------------------------------------------------
    if (iand ( jk1zon + iadini - 1 , mslois ) .eq. 0 .and.&
        iand ( jk1zon + iadfin - 1 , mslois ) .eq. 0 .and. iand ( lso , mslois ) .eq. 0) then
        jini = ( jk1zon + iadini - 1 ) / lois + 1
        jfin = ( jk1zon + iadfin - 1 ) / lois + 1
        if (jini .gt. jfin) then
            do 20 i = 0, (lso / lois) - 1
                iszon( jfin + i ) = iszon( jini + i )
20          continue
        else if (jini .lt. jfin) then
            do 21 i = (lso / lois) - 1, 0, -1
                iszon( jfin + i ) = iszon( jini + i )
21          continue
        endif
    else
        if (iadini .gt. iadfin) then
            do 30 i = 0, lso - 1
                k1zon(jk1zon + iadfin + i) = k1zon(jk1zon + iadini + i)
30          continue
        else if (iadini .lt. iadfin) then
            do 31 i = lso-1, 0, - 1
                k1zon(jk1zon + iadfin + i) = k1zon(jk1zon + iadini + i)
31          continue
        endif
    endif
! FIN ------------------------------------------------------------------
end subroutine
