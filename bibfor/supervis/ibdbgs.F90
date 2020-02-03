! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

subroutine ibdbgs()
    implicit none
!     TRAITEMENT DES MOTS CLE DEBUG/MESURE_TEMPS/MEMOIRE
!     DES COMMANDES DEBUT ET POURSUITE
!     ------------------------------------------------------------------
!            0 TOUT C'EST BIEN PASSE
!            1 ERREUR DANS LA LECTURE DE LA COMMANDE
!     ------------------------------------------------------------------
!     ----- DEBUT COMMON DE DEBUG JEVEUX
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterc/jdcget.h"
#include "asterc/jdcset.h"
#include "asterfort/assert.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/impvem.h"
#include "asterfort/iunifi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/utmess.h"
    integer :: lundef, idebug
    common /undfje/  lundef,idebug
    real(kind=8) :: tbloc, tgrel
    common /rtblje/  tbloc,tgrel
!
!     -- COMMON MESTP1 POUR MESURE_TEMPS
    integer :: mtpniv, mtpsta
    common /mestp1/  mtpniv,mtpsta
!
! ----------------------------------------------------------------------
    character(len=3) :: repons
    integer :: l, i1
!
!     --- OPTIONS PAR DEFAUT ---
!-----------------------------------------------------------------------
    integer :: ifi
!-----------------------------------------------------------------------
    call jemarq()
    tbloc = 800.d0
!
!     -- DEBUG / ENVIMA :
!     -----------------------------------------------------
    repons = ' '
    call getvtx('DEBUG', 'ENVIMA', iocc=1, scal=repons, nbret=l)
    if (l .eq. 1 .and. repons .eq. 'TES') then
        ifi = iunifi ( 'RESULTAT' )
        call impvem(ifi)
    endif
!
!     -- MESURE_TEMPS:
!     -----------------------------------------------------
    call getvis('MESURE_TEMPS', 'NIVE_DETAIL', iocc=1, scal=mtpniv)
    repons = 'NON'
    call getvtx('MESURE_TEMPS', 'MOYENNE', iocc=1, scal=repons)
    if (repons .eq. 'OUI') then
        mtpsta = 1
    else
        mtpsta = 0
    endif
!
!     -- MEMOIRE  :
!     -----------------------------------------------------
!
    call getvr8('MEMOIRE', 'TAILLE_BLOC', iocc=1, scal=tbloc)
    call getvis('MEMOIRE', 'TAILLE_GROUP_ELEM', iocc=1, scal=i1)
    tgrel=dble(i1)
!
    call jedema()
end subroutine
