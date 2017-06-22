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

subroutine mtdsc3(nommat)
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
!     ALLOCATION DES DESCRIPTEURS D'UNE MATRICE de CONTACT-FROTTEMENT
!     PLEINE SYMETRIQUE, REELLE SANS DDLS ELIMINES
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
!     ZK24(ZI(+1) : NOM DEVELOPPEUR DE LA MATRICE + 4 BLANCS
!     ZI(+2) : NOMBRE D'EQUATIONS
!     ZI(+3) : 1 (REELLE)
!     ZI(+4) : 1 (SYMETRIQUE)
!     ZI(+7) : 0
!     ZI(+14) : TAILLE DES BLOCS DE LA MATRICE
!     ------------------------------------------------------------------
!
!
!
!     ----- PARAMETRES DE DEFINITION DES MATRICES ----------------------
    character(len=4) :: kbid
    character(len=14) :: nu
    character(len=19) :: mat19, nomsto
!     ------------------------------------------------------------------
!
!
!-----------------------------------------------------------------------
    integer ::  ier,   k, lmat
    integer :: lnom
    integer, pointer :: scde(:) => null()
    character(len=24), pointer :: refa(:) => null()
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
    call jeveuo(mat19//'.REFA', 'L', vk24=refa)
    nu = refa(2)
    nomsto = nu//'.SLCS'
!
!
!     -- LMAT+2 :
!     ------------
    call jeveuo(nomsto//'.SCDE', 'L', vi=scde)
    zi(lmat+2) = scde(1)
!
!
!     -- LMAT+3 :
!     ------------
    call jelira(mat19//'.UALF', 'TYPE', cval=kbid)
    ASSERT(kbid(1:1).eq.'R')
    zi(lmat+3) = 1
!
!
!     -- LMAT+4 :
!     ------------
    zi(lmat+4) = 1
!
!
!     -- LMAT+14
!     ----------
    zi(lmat+14) = scde(2)
!
!
!     -- LMAT+7 ET LMAT+18  (SI CHARGES CINEMATIQUES) :
!     -------------------------------------------------
    call jeexin(mat19//'.CCID', ier)
    ASSERT(ier.eq.0)
    zi(lmat+7) = 0
    zi(lmat+18) = 0
!
!
    call jedema()
end subroutine
