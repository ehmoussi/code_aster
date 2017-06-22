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

subroutine nmcrpa(motfaz, iocc, sdlist, base, nbinst,&
                  dtmin)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/getvid.h"
#include "asterfort/getvr8.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nmcrpm.h"
#include "asterfort/wkvect.h"
    character(len=24) :: sdlist
    character(len=*) :: motfaz
    character(len=1) :: base
    integer :: iocc
    real(kind=8) :: dtmin
    integer :: nbinst
!
! ----------------------------------------------------------------------
!
! ROUTINE *_NON_LINE (UTILITAIRE - SELEC. INST.)
!
! LECTURE LISTE INSTANTS
!
! ----------------------------------------------------------------------
!
!
! IN  SDLIST : NOM DE LA SD DANS LAQUELLE ON CONSERVERA LA LISTE
!               ON CREE UN VECTEUR DE LONGUEUR NBINST SUR BASE
! NB: LA LISTE N'EST PAS FORCEMENT CROISSANTE
! IN  BASE   : NOM DE LA BASE POUR CREATION SD
! IN  MOTFAC : MOT-FACTEUR POUR LIRE (LIST_INST/INST)
! IN  IOCC   : OCCURRENCE DU MOT-CLEF FACTEUR MOTFAC
! OUT NBINST : NOMBRE D'INSTANTS DANS LA LISTE
! OUT DTMIN  : INCREMENT DE TEMPS MINIMUM DANS LA LISTE
!
!
!
!
    integer :: n2, n3, i, iret
    character(len=19) :: list
    integer ::  jslist
    character(len=16) :: motfac
    real(kind=8), pointer :: vale(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    nbinst = 0
    motfac = motfaz
    dtmin = 0.d0
!
! --- CREATION ET INITIALISATION SD
!
    call getvid(motfac, 'LIST_INST', iocc=iocc, scal=list, nbret=n2)
    call getvr8(motfac, 'INST', iocc=iocc, nbval=0, nbret=n3)
    n3 = -n3
!
! --- RECUPERATION DU NOMBRE D'INSTANTS
!
    if ((n2.ge.1) .and. (n3.ge.1)) then
        ASSERT(.false.)
    endif
!
    if (n3 .ge. 1) then
        nbinst = n3
    else if (n2.ge.1) then
        call jelira(list//'.VALE', 'LONMAX', ival=nbinst)
    else
        nbinst = 0
        goto 99
    endif
!
! --- CREATION DE LA LISTE
!
    call wkvect(sdlist, base//' V R', nbinst, jslist)
!
! --- REMPLISSAGE DE LA LISTE
!
    if (n3 .ge. 1) then
        call getvr8(motfac, 'INST', iocc=iocc, nbval=nbinst, vect=zr(jslist),&
                    nbret=iret)
    else
        call jeveuo(list//'.VALE', 'L', vr=vale)
        do 43 i = 1, nbinst
            zr(jslist+i-1) = vale(i)
43      continue
    endif
!
! --- CALCUL DU DELTA MINIMUM DE LA LISTE
!
    call nmcrpm(zr(jslist), nbinst, dtmin)
!
99  continue
!
    call jedema()
!
end subroutine
