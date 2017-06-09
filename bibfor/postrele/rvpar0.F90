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

subroutine rvpar0(nomtab, mcf, nbpost)
! IN  NOMTAB  : NOM DE LA TABLE PRINCIPALE PRODUITE PAR LA COMMANDE
! IN  MCF     : MOT-CLE FACTEUR
! IN  NBPOST  : NOMBRE DE POST-TRAITEMENT A CONSIDERER
!     ------------------------------------------------------------------
!
!     INITIALISE LES TABLES DE POST_RELEVE_T
!
!     ------------------------------------------------------------------
!
    implicit none
!
! 0.1. ==> ARGUMENTS
!
#include "jeveux.h"
#include "asterfort/getvid.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeecra.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/juveca.h"
#include "asterfort/rvpara.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
    character(len=6) :: mcf
    character(len=8) :: nomtab
    integer :: nbpost
!
!
! 0.3. ==> VARIABLES LOCALES
!
    character(len=6) :: nompro
    parameter ( nompro = 'RVPAR0' )
!
    integer :: ifm, niv
    integer :: iocc, iaux
    integer :: nbtbmx, admemo, nbtabl
    integer :: nbresu
!
    character(len=18) :: nomstr
!     ------------------------------------------------------------------
!
!====
! 1. PREALABLES
!====
!
    call jemarq()
!
    call infmaj()
    call infniv(ifm, niv)
!
    if (niv .ge. 2) then
        call utmess('I', 'POSTRELE_8', sk=nomtab)
    endif
!
    nomstr = '&&'//nompro//'.NOMPARAMS'
!
!====
! 2. ON REPERE LE NOMBRE DE TABLES QU'IL FAUDRA INITIALISER :
!====
!
! 2.1. ==> ON ALLOUE LE TABLEAU DE MEMORISATION POUR 20 TABLES.
!          S'IL S'AVERE QU'IL Y EN A BESOIN DE DAVANTAGE, ON ALLONGERA.
!
    nbtbmx = 20
    call wkvect(nomstr, 'G V K8', 2*nbtbmx, admemo)
!
! 2.2. ==> ON PARCOURT TOUTES LES ACTIONS DEMANDEES
!
    nbtabl = 0
!
    do 22 , iocc = 1, nbpost
!
! 2.2.1. ==> EST-CE UN RESULTAT ?
!
    call getvid(mcf, 'RESULTAT', iocc=iocc, nbval=0, nbret=nbresu)
!
!
! 2.2.2.1. ==> ON CHERCHE SI CETTE CONFIGURATION EST DEJA ENREGISTREE ;
!              SI OUI, ON PASSE AU PARAMETRE SUIVANT (GOTO 220)
!
    do 222 , iaux = 1 , nbtabl
    if (zk8(admemo+2*iaux-2) .eq. nomtab) goto 220
222  continue
!
! 2.2.2.2. ==> LA CONFIGURATION EST NOUVELLE
!              ON L'ENREGISTRE, EN ALLONGEANT EVENTUELLEMENT SI LA PLACE
!              RESERVEE EST TROP PETITE
!
    if (nbtabl .ge. nbtbmx) then
        nbtbmx = nbtbmx + 50
        iaux = 2*nbtbmx
        call juveca(nomstr, iaux)
        call jeveuo(nomstr, 'E', admemo)
    endif
    call jelira(nomstr, 'LONUTI', iaux)
    iaux = iaux + 2
    call jeecra(nomstr, 'LONUTI', iaux)
!
    nbtabl = nbtabl + 1
    zk8(admemo+2*nbtabl-2) = nomtab
!
    22 end do
!
220  continue
!
!====
! 3. ON INITIALISE LES TABLES DEMANDEES
!====
!
    do 30 , iaux = 1 , nbtabl
!
    nomtab = zk8(admemo+2*iaux-2)
    call rvpara(nomtab, mcf, nbpost)
!
    30 end do
!
!====
! 4. MENAGE
!====
!
    call jedetr(nomstr)
!
    call jedema()
!
end subroutine
