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

subroutine op0006()
    implicit none
!
!     COMMANDE AFFE_MATERIAU
!
! ----------------------------------------------------------------------
!
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/afvarc.h"
#include "asterfort/assert.h"
#include "asterfort/cmtref.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvid.h"
#include "asterfort/imprsd.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/rccomp.h"
#include "asterfort/rcmate.h"
#include "asterfort/utmess.h"
    character(len=8) :: chmat, nomail, nomode, nomai2
    character(len=16) :: nomcmd, type
    character(len=24) :: valk(3)
    integer ::  ifm, n1, niv
! ----------------------------------------------------------------------
!
    call jemarq()
    call infmaj()
    call infniv(ifm, niv)
!
    nomode = ' '
    call getres(chmat, type, nomcmd)

!   -- noms du maillage et du modele :
!   ----------------------------------
    nomode = ' '
    nomai2 = ' '
    call getvid(' ', 'MODELE', scal=nomode, nbret=n1)
    if (n1.eq.1) then
        call dismoi('NOM_MAILLA', nomode, 'MODELE', repk=nomail)
        call getvid(' ', 'MAILLAGE', scal=nomai2, nbret=n1)
        if (n1.eq.1 .and. nomail.ne.nomai2) then
            valk(1)=nomode
            valk(2)=nomai2
            valk(3)=nomail
            call utmess('F', 'MODELISA2_11', nk=3, valk=valk)
        endif
    else
        call getvid(' ', 'MAILLAGE', scal=nomail, nbret=n1)
        ASSERT(n1.eq.1)
    endif
!
!
!     1- TRAITEMENT DU MOT-CLE AFFE :
!     -----------------------------------------
    call rcmate(chmat, nomail, nomode)
!
!
!     2- TRAITEMENT DU MOT-CLE AFFE_COMPOR :
!     -----------------------------------------
    call rccomp(chmat, nomail)
!
!
!     3- TRAITEMENT DU MOT-CLE AFFE_VARC :
!     -----------------------------------------
    call afvarc(chmat, nomail, nomode)
!
!
!     4- IL FAUT RECONSTRUIRE LA CARTE .CHAMP_MAT POUR OBTENIR :
!     1 VALEUR DANS LA CARTE => 1 (OU PLUS) MATERIAU(X) + 1 TEMP_REF
!     C'EST UNE CONSEQUENCE DE RCMACO / ALFINT
!     -----------------------------------------------------------------
    call cmtref(chmat, nomail)
!
!
!     5- IMPRESSION DU CHAMP PRODUIT SI INFO=2 :
!     ------------------------------------------
    if (niv .gt. 1) then
        call imprsd('CHAMP', chmat//'.CHAMP_MAT', ifm, 'CHAM_MATER:')
    endif
!
!
    call jedema()
end subroutine
