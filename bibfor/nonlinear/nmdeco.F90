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

subroutine nmdeco(sddisc, nume_inst, iterat, i_event_acti, retdec)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/r8gaem.h"
#include "asterfort/assert.h"
#include "asterfort/diinst.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/nmdcax.h"
#include "asterfort/nmdcdc.h"
#include "asterfort/nmdcex.h"
#include "asterfort/nmdeca.h"
#include "asterfort/nmdecm.h"
#include "asterfort/nmdecv.h"
#include "asterfort/utdidt.h"
#include "asterfort/utmess.h"
    integer :: i_event_acti
    integer :: nume_inst, iterat
    character(len=19) :: sddisc
    integer :: retdec
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! GESTION DE L'ACTION DECOUPE DU PAS DE TEMPS
!
! ----------------------------------------------------------------------
!
!
! In  sddisc           : datastructure for time discretization
! In  i_event_acti     : index of active event
! IN  NUMINS : NUMERO D'INSTANTS
! IN  ITERAT : NUMERO D'ITERATION DE NEWTON
! OUT RETDEC : CODE RETOUR DECOUPE
!     0 - ECHEC DE LA DECOUPE
!     1 - ON A DECOUPE
!     2 - PAS DE DECOUPE
!
! ----------------------------------------------------------------------
!
    character(len=16) :: submet, metlis
    real(kind=8) :: dtmin, durdec
    integer :: nbrpas
    real(kind=8) :: deltat, instam, instap
    real(kind=8) :: insref, deltac
    character(len=24) :: nomlis
    aster_logical :: ldcext
    integer :: retdex
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    retdec = 0
    retdex = -1
    dtmin = r8gaem()
    nomlis = '&&NMDECO.LISTE'
    ldcext = .false.
    durdec = -1.d0
!
! --- INFORMATIONS SUR LE PAS DE TEMPS
!
    call utdidt('L', sddisc, 'LIST', 'METHODE',&
                valk_ = metlis)
    instam = diinst(sddisc,nume_inst-1)
    instap = diinst(sddisc,nume_inst)
    deltat = instap-instam
    insref = instap
!
! --- METHODE DE SUBDIVISION
!
    call utdidt('L', sddisc, 'ECHE', 'SUBD_METHODE', index_ = i_event_acti, &
                valk_ = submet)
!
! --- TYPE DE SUBDIVISION
!
    if (submet .eq. 'MANUEL') then
        call utmess('I', 'SUBDIVISE_1')
    else if (submet.eq.'AUTO') then
        call utmess('I', 'SUBDIVISE_2')
    else if (submet .eq. 'AUCUNE') then
        call utmess('I', 'SUBDIVISE_3')
        retdec = 0
        goto 999
    else
        ASSERT(.false.)
    endif
!
! --- DECOUPE DU PAS DE TEMPS
!
    if (submet .eq. 'MANUEL') then
        call nmdecm(sddisc, i_event_acti, nomlis, instam, deltat,&
                    nbrpas, dtmin, retdec)
        ldcext = .false.
        durdec = -1.d0
    else if (submet.eq.'AUTO') then
        call nmdeca(sddisc, iterat, i_event_acti, nomlis, instam,&
                    deltat, nbrpas, dtmin, ldcext, durdec,&
                    retdec)
    else
        ASSERT(.false.)
    endif
!
! --- PAS DE DECOUPE: ON SORT
!
    if (retdec .eq. 0) then
        goto 999
    else if (retdec.eq.2) then
!
! ----- EN GESTION AUTO, IL EST NECESSAIRE D'ACTIVER LA POST-DECOUPE
!
        if ((retdec.eq.2) .and. (metlis.eq.'AUTO')) then
            goto 888
        else
            goto 999
        endif
    endif
!
! --- VERIFICATIONS DE LA DECOUPE
!
    call nmdecv(sddisc, nume_inst, i_event_acti, dtmin, retdec)
    if (retdec .eq. 0) goto 999
!
! --- MISE A JOUR DES SD APRES DECOUPE
!
    call nmdcdc(sddisc, nume_inst, nomlis, nbrpas)
!
! --- EXTENSION DE LA DECOUPE AUX PAS SUIVANTS
!
888 continue
    if (ldcext) then
        instam = diinst(sddisc,nume_inst-1)
        instap = diinst(sddisc,nume_inst)
        deltac = instap-instam
        if (metlis .eq. 'MANUEL') then
            call nmdcex(sddisc, insref, durdec, i_event_acti, deltac,&
                        retdex)
        else if (metlis.eq.'AUTO') then
            call nmdcax(sddisc, insref, nume_inst, durdec, deltac)
            retdex = 1
        else
            ASSERT(.false.)
        endif
        if (retdex .eq. 0) retdec = 0
    endif
!
999 continue
!
! --- AFFICHAGE
!
    if (retdec .eq. 0) then
        call utmess('I', 'SUBDIVISE_50')
    else if (retdec.eq.1) then
        call utmess('I', 'SUBDIVISE_51')
    else if (retdec.eq.2) then
        call utmess('I', 'SUBDIVISE_52')
    endif
!
    call jedetr(nomlis)
!
    call jedema()
end subroutine
