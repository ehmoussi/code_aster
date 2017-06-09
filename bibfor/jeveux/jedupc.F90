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

subroutine jedupc(clain, schin, ipos, claout, schout,&
                  dupcol)
    implicit none
#include "asterf_types.h"
#include "jeveux_private.h"
#include "asterfort/jedupo.h"
#include "asterfort/utmess.h"
    character(len=*) :: clain, schin, claout, schout
    integer :: ipos
    aster_logical :: dupcol
! ----------------------------------------------------------------------
!     RECOPIE LES OBJETS DE LA CLASSE CLAIN POSSEDANT LA SOUS-CHAINE
!     SCHIN EN POSITION IPOS DANS LA CLASSE CLAOUT AVEC LA SOUS-CHAINE
!     DISTINCTE SCHOUT
!
! IN  CLAIN  : NOM DE LA CLASSE EN ENTREE (' ' POUR TOUTES LES BASES)
! IN  SCHIN  : SOUS-CHAINE EN ENTREE
! IN  IPOS   : POSITION DE LA SOUS-CHAINE
! IN  CLAOUT : NOM DE LA CLASSE EN SORTIE
! IN  SCHOUT : SOUS-CHAINE EN SORTIE
! IN  DUPCOL : .TRUE. DUPLIQUE LES OBJETS PARTAGEABLES D'UNE COLLECTION
!              .FALSE. S'ARRETE SUR ERREUR
!
! ----------------------------------------------------------------------
    character(len=6) :: pgma
    common /kappje/  pgma
!-----------------------------------------------------------------------
    integer :: jdocu, jgenr, jorig, jrnom, jtype, n, ncla1
    integer :: ncla2
!-----------------------------------------------------------------------
    parameter  ( n = 5 )
    character(len=2) :: dn2
    character(len=5) :: classe
    character(len=8) :: nomfic, kstout, kstini
    common /kficje/  classe    , nomfic(n) , kstout(n) , kstini(n) ,&
     &                 dn2(n)
    integer :: nrhcod, nremax, nreuti
    common /icodje/  nrhcod(n) , nremax(n) , nreuti(n)
    common /jkatje/  jgenr(n), jtype(n), jdocu(n), jorig(n), jrnom(n)
    integer :: l1, l2, j, icin
    character(len=32) :: nomin, nomout, schin2, schou2
    character(len=1) :: kclas
!
! DEB ------------------------------------------------------------------
    pgma = 'JEDUPC'
!
    l1 = len ( schin )
    if (ipos + l1 .gt. 25 .or. ipos .lt. 0 .or. l1 .eq. 0) then
        call utmess('F', 'JEVEUX_92', sk=schin)
    endif
    schin2=schin
    l2 = len ( schout)
    schou2=schout
!
    if (l1 .ne. l2) then
        call utmess('F', 'JEVEUX_93', sk=schou2//' '//schin2)
    endif
!
    if (ipos + l2 .gt. 25 .or. ipos .lt. 0 .or. l2 .eq. 0) then
        call utmess('F', 'JEVEUX_92', sk=schout)
    endif
    if (schin(1:l1) .eq. schout(1:l2)) then
        call utmess('F', 'JEVEUX_94', sk=schin2//' : '//schou2)
    endif
!
    kclas = clain (1:min(1,len(clain)))
    if (kclas .eq. ' ') then
        ncla1 = 1
        ncla2 = index ( classe , '$' ) - 1
        if (ncla2 .lt. 0) ncla2 = n
    else
        ncla1 = index ( classe , kclas)
        ncla2 = ncla1
    endif
    do 100 icin = ncla1, ncla2
        kclas = classe(icin:icin)
        do 150 j = 1, nremax(icin)
            nomin = rnom(jrnom(icin)+j)
            if (nomin(1:1) .eq. '?' .or. nomin(25:32) .ne. '        ') goto 150
            if (schin .eq. nomin(ipos:ipos+l1-1)) then
                nomout = nomin
                nomout = nomout(1:ipos-1)//schou2(1:l2)//nomout(ipos+ l1:32)
                call jedupo(nomin, claout, nomout, dupcol)
            endif
150     continue
100 end do
! FIN ------------------------------------------------------------------
!
!
end subroutine
