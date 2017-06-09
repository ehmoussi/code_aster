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

subroutine mtdscr(nommat)
    implicit none
#include "jeveux.h"
!
#include "asterc/ismaem.h"
#include "asterfort/assert.h"
#include "asterfort/jecreo.h"
#include "asterfort/jedema.h"
#include "asterfort/jeecra.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jeveut.h"
#include "asterfort/wkvect.h"
    character(len=*) :: nommat
!     ALLOCATION DES DESCRIPTEURS D'UNE MATRICE
!     ------------------------------------------------------------------
!
! IN  NOMMAT  : K19 : NOM DE LA MATRICE
!     ------------------------------------------------------------------
!     CETTE ROUTINE CREE 2 OBJETS DE TRAVAIL SUR LA BASE VOLATILE
!
!     DE NOM  NOMMAT//'.&INT'   VECTEUR D'ENTIER
!             NOMMAT//'.&IN2'   VECTEUR DE K24
!
!     ZI(+0) : INUTILISE
!     ZK24(ZI(+1) : NOM DEVELOPPEUR DE LA MATRICE
!     ZI(+2) : NOMBRE GLOBAL D'EQUATIONS
!     ZI(+3) : TYPE DE VALEURS
!                1 : REELLE
!                2 : COMPLEXE
!     ZI(+4) : PROPRIETE DE SYMETRIE DE LA MATRICE
!                0 : QUELCONQUE
!                1 : SYMETRIQUE
!     ZI(+5) : NOMBRE LOCAL D'EQUATIONS
!     ZI(+6) : INUTILISE
!     ZI(+7) : NOMBRE DE DDLS IMPOSES PAR DES CHARGES CINEMATIQUES DANS
!              LA MATRICE ASSEMBLEE = NELIM
!
!     ZI(+10) : INUTILISE
!     ZI(+11) : INUTILISE
!     ZI(+12) : INUTILISE
!     ZI(+13) : INUTILISE
!     ZI(+14) : LONGUEUR DU BLOC POUR LA MATRICE MORSE
!     ZI(+15) : INUTILISE
!     ZI(+16) : INUTILISE
!     ZI(+17) : INUTILISE
!     ZI(+18) : INUTILISE
!     ------------------------------------------------------------------
!
!
!
!     ----- PARAMETRES DE DEFINITION DES MATRICES ----------------------
    integer :: imatd
    character(len=2) :: tyma
    character(len=4) :: kbid
    character(len=14) :: nu
    character(len=19) :: mat19, nomsto
!     ------------------------------------------------------------------
!
!
!-----------------------------------------------------------------------
    integer ::  ier, iret,  jnequ
    integer ::   k, lccid, lmat, lnom, nb1
    integer :: nb2
    integer, pointer :: ccid(:) => null()
    integer, pointer :: scde(:) => null()
    character(len=24), pointer :: refa(:) => null()
    integer, pointer :: smde(:) => null()
!-----------------------------------------------------------------------
    call jemarq()
    mat19 = nommat
!
!
!        ------ ALLOCATION DES OBJETS SI NECESSAIRE :
    call jeexin(mat19//'.&INT', ier)
    if (ier .eq. 0) then
        call jecreo(mat19//'.&INT', ' V V I')
        call jeecra(mat19//'.&INT', 'LONMAX', 19)
    endif
!
    call jeveuo(mat19//'.&INT', 'E', lmat)
    do 10,k = 1,19
    zi(lmat-1+k) = ismaem()
    10 end do
!
    call jeexin(mat19//'.&IN2', ier)
    if (ier .eq. 0) then
        call wkvect(mat19//'.&IN2', ' V V K24', 1, lnom)
    endif
!
    call jeveut(mat19//'.&IN2', 'E', lnom)
    zk24(lnom) = mat19
!
!
!     -- LMAT+1 :
!     ------------
    zi(lmat+1) = lnom
!
!
    call jeexin(mat19//'.REFA', ier)
    ASSERT(ier.ne.0)
!
!
    call jeveuo(mat19//'.REFA', 'L', vk24=refa)
    nu = refa(2)
    nomsto = nu//'.SMOS'
!
!     -- LMAT+2 ET +5 :
!     ------------
    call jeveuo(nomsto//'.SMDE', 'L', vi=smde)
    call jeveuo(nu//'.NUME.NEQU', 'L', jnequ)
    zi(lmat+2) = zi(jnequ-1+1)
    call jeexin(nu//'.NUML.NULG', imatd)
    if (imatd .ne. 0) then
        call jeveuo(nu//'.NUML.NEQU', 'L', jnequ)
        zi(lmat+5) = zi(jnequ-1+1)
    else
        zi(lmat+5) = zi(lmat+2)
    endif
!
!
!     -- LMAT+3 :
!     ------------
    call jeexin(mat19//'.VALM', iret)
!     -- POUR TRAITER LE CAS OU ON A DETRUIT VOLONTAIREMENT LE .VALM
    if (iret .gt. 0) then
        call jelira(mat19//'.VALM', 'TYPE', cval=kbid)
    else
        call jelira(mat19//'.UALF', 'TYPE', cval=kbid)
    endif
!
    ASSERT(kbid(1:1).eq.'R' .or. kbid(1:1).eq.'C')
    if (kbid(1:1) .eq. 'R') zi(lmat+3) = 1
    if (kbid(1:1) .eq. 'C') zi(lmat+3) = 2
!
!
!     -- LMAT+4 :
!     ------------
    call jeexin(mat19//'.VALM', iret)
!     -- POUR TRAITER LE CAS OU ON A DETRUIT VOLONTAIREMENT LE .VALM
    if (iret .gt. 0) then
        tyma = refa(9)
        if (tyma .eq. 'MS') then
            zi(lmat+4) = 1
!
        else if (tyma.eq.'MR') then
            zi(lmat+4) = 0
!
        else
            ASSERT(.false.)
        endif
!
    else
        call jelira(mat19//'.UALF', 'NMAXOC', nb1)
        call jeveuo(nu//'.SLCS.SCDE', 'L', vi=scde)
        nb2 = scde(3)
        if (nb1 .eq. nb2) then
            zi(lmat+4) = 1
!
        else if (nb1.eq.2*nb2) then
            zi(lmat+4) = 0
!
        else
            ASSERT(.false.)
        endif
!
    endif
!
!
!     -- LMAT+7    (SI CHARGES CINEMATIQUES) :
!     -------------------------------------------------
    call jeexin(mat19//'.CCID', ier)
    if (ier .ne. 0) then
        call jeveuo(mat19//'.CCID', 'L', vi=ccid)
        call jelira(mat19//'.CCID', 'LONMAX', lccid)
        zi(lmat+7) = ccid(lccid+1)
    else
        zi(lmat+7) = 0
    endif
!
!
!     -- LMAT+14
!     ----------
    zi(lmat+14) = smde(2)
!
!
    call jedema()
end subroutine
