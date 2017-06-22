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

subroutine utlisi(motcle, a, na, b, nb,&
                  c, nc, ntrou)
    implicit none
!
!     ARGUMENTS:
!     ----------
#include "asterfort/indiis.h"
#include "asterfort/utmess.h"
    character(len=*) :: motcle
    integer :: a(*), b(*), c(*), na, nb, nc, ntrou
! ----------------------------------------------------------------------
!     BUT :
!
!     UTILITAIRE D'OPERATION LOGIQUE SUR DES LISTES D'ENTIERS:
!          C = SINGLETON(A)
!          C = INTERSECTION (A,B)
!          C = UNION        (A,B)
!          C = A - B
!
!     ATTENTION AUX EFFETS DE BORD :
!     -------------------------------
!     LA PROGRAMMATION SUPPOSE QUE LES TABLEAUX A, B, C SONT DISTINCTS.
!
!     ATTENTION AUX DOUBLONS :
!     ------------------------
!     (SI LES LISTES A ET B CONTIENNENT DES ELEMENTS MULTIPLES) :
!     ALGORITHMES :
!       * SINGL :  ON RECOPIE DANS C LES ELEMENTS DE A DANS L'ORDRE
!                  DE A EN RECOPIANT PAS PLUSIEURS FOIS UN MEME
!                  ELEMENT. LES ELEMENTS DE C SONT DONC TOUS DIFF.
!       * UNION :  ON RECOPIE A DANS C, PUIS ON RECOPIE LES ELEMENTS
!                  DE B QUI NE SONT PAS DANS A.
!                  (ON A DONC OTE LES DOUBLONS (A,B) MAIS PAS
!                    CEUX DE (A,A) NI (B,B)!)
!       * INTER :  ON RECOPIE DANS C LES ELEMENTS DE A QUI EXISTENT
!                  DANS B. LES DOUBLONS (A,A) PEUVENT PERSISTER.
!       * A - B :  ON RECOPIE DANS C LES ELEMENTS DE A QUI N'EXISTENT
!                  PAS DANS B. LES DOUBLONS (A,A) PEUVENT PERSISTER.
!
!
!     ENTREES:
!       MOTCLE : ACTION DEMANDEE :  / 'SINGL'(ETON)
!                                   / 'UNION'
!                                   / 'INTER'(SECTION)
!                                   / 'DIFFE'(RENCE)
!       A,B    : LISTES D'ENTIER.
!       NA,NB  : DIMENSIONS DES LISTES A ET B
!       NC     : DIMENSION DE LA LISTE C.
!
!     SORTIES:
!       C  : LISTE D'ENTIERS TROUVEE.
!     NTROU: "+" NB D'ENTIERS DS LA LISTE C (SI NC "IN" SUFFISANT).
!     NTROU: "-" NB D'ENTIERS DS LA LISTE C (SI NC "IN" INSUFFISANT).
!
! ----------------------------------------------------------------------
    character(len=5) :: motcl2
    integer :: ia, ib, ic, ii
! DEB-------------------------------------------------------------------
    motcl2=motcle
!
!
    if (motcl2 .eq. 'SINGL') then
!     ---------------------------
        ic=0
        do 1, ia=1,na
        ii= indiis(a,a(ia),1,ia-1)
        if (ii .eq. 0) then
            ic=ic+1
            if (ic .le. nc) c(ic)=a(ia)
        endif
 1      continue
        ntrou=ic
        if (ic .gt. nc) ntrou= -ntrou
!
!
    else if (motcl2.eq.'UNION') then
!     ---------------------------------
        ic=0
        do 21, ia=1,na
        ic=ic+1
        if (ic .le. nc) c(ic)=a(ia)
21      continue
        do 22, ib=1,nb
        ii= indiis(a,b(ib),1,na)
        if (ii .eq. 0) then
            ic=ic+1
            if (ic .le. nc) c(ic)=b(ib)
        endif
22      continue
        ntrou=ic
        if (ic .gt. nc) ntrou= -ntrou
!
!
    else if (motcl2.eq.'INTER') then
!     ---------------------------------
        ic=0
        do 31, ia=1,na
        ii= indiis(b,a(ia),1,nb)
        if (ii .gt. 0) then
            ic=ic+1
            if (ic .le. nc) c(ic)=a(ia)
        endif
31      continue
        ntrou=ic
        if (ic .gt. nc) ntrou= -ntrou
!
!
    else if (motcl2(1:5).eq.'DIFFE') then
!     ---------------------------------
        ic=0
        do 41, ia=1,na
        ii= indiis(b,a(ia),1,nb)
        if (ii .eq. 0) then
            ic=ic+1
            if (ic .le. nc) c(ic)=a(ia)
        endif
41      continue
        ntrou=ic
        if (ic .gt. nc) ntrou= -ntrou
!
!
    else
!     -----
        call utmess('F', 'UTILITAI5_47', sk=motcl2)
    endif
!
end subroutine
