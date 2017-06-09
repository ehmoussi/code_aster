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

subroutine op0098()
    implicit none
!  P. RICHARD   DATE 09/07/91
!-----------------------------------------------------------------------
!  BUT : OPERATEUR DE DEFINITION DE LISTE INTERFACE POUR SUPERPOSITION
!        OU SYNTHESE MODALE : DEFI_INTERF_DYNA
!        LISTE_INTERFACE CLASSIQUE ( MIXTE CRAIG-BAMPTON MAC-NEAL)
!-----------------------------------------------------------------------
!
!
!
!
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/calc98.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvid.h"
#include "asterfort/imbint.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/wkvect.h"
    character(len=8) :: nomres, mailla, nomgd
    character(len=19) :: numddl
    character(len=16) :: nomope, nomcon
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!
! --- PHASE DE VERIFICATION
!
!-----------------------------------------------------------------------
    integer :: iadref, ifm, lddesc, nbcmp
    integer :: nbec, nbid, niv, numgd
!-----------------------------------------------------------------------
    call jemarq()
!
    call infmaj()
    call infniv(ifm, niv)
!
! --- RECUPERATION NOM ARGUMENT
!
    call getres(nomres, nomcon, nomope)
!
! --- CREATION .REFE
!
    call getvid('   ', 'NUME_DDL', iocc=1, scal=numddl, nbret=nbid)
    numddl(15:19)='.NUME'
    call dismoi('NOM_MAILLA', numddl, 'NUME_DDL', repk=mailla)
    call wkvect(nomres//'.IDC_REFE', 'G V K24', 3, iadref)
    zk24(iadref)=mailla
    zk24(iadref+1)=numddl
    zk24(iadref+2)='              '
!
! --- CREATION DU .DESC
!
    call dismoi('NOM_GD', numddl, 'NUME_DDL', repk=nomgd)
    call dismoi('NUM_GD', nomgd, 'GRANDEUR', repi=numgd)
    call dismoi('NB_CMP_MAX', nomgd, 'GRANDEUR', repi=nbcmp)
    call dismoi('NB_EC', nomgd, 'GRANDEUR', repi=nbec)
!
    call wkvect(nomres//'.IDC_DESC', 'G V I', 5, lddesc)
    zi(lddesc)=1
    zi(lddesc+1)=nbec
    zi(lddesc+2)=nbcmp
    zi(lddesc+3)=numgd
    zi(lddesc+4)=0
!
! CETTE DERNIERE VALEUR SERA REACTUALISEE PAR LE NOMBRE DE DEFORMEE
! STATIQUE A CALCULER
!
! --- CAS D'UNE LISTE_INTERFACE CONNUE
!
    call calc98(nomres, mailla, numddl)
!
! --- IMPRESSION SUR FICHIER
!
    if (niv .gt. 1) call imbint(nomres, ifm)
!
    call jedema()
end subroutine
