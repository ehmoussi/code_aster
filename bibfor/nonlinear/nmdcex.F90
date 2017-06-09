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

subroutine nmdcex(sddisc, insref, durdec, ievdac, deltac,&
                  retdex)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/diinst.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/nmdcdc.h"
#include "asterfort/nmdecc.h"
#include "asterfort/nmdecv.h"
#include "asterfort/nmfinp.h"
#include "asterfort/utmess.h"
    character(len=19) :: sddisc
    integer :: ievdac, retdex
    real(kind=8) :: durdec, insref, deltac
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (GESTION DES EVENEMENTS - DECOUPE)
!
! EXTENSION DE LA DECOUPE AUX INSTANTS SUIVANTS - MANUEL
!
! ----------------------------------------------------------------------
!
!
! IN  SDDISC : SD DISCRETISATION TEMPORELLE
! IN  INSREF : INSTANT AU-DELA DUQUEL ON ETEND LA DECOUPE
! IN  DURDEC : DUREEE DE L'EXTENSION DE LA DECOUPE
! IN  DELTAC : INCREMENT DE TEMPS CIBLE
! IN  IEVDAC : INDICE DE L'EVENEMENT ACTIF
! OUT RETDEC : CODE RETOUR DECOUPE
!     0 - ECHEC DE LA DECOUPE
!     1 - ON A DECOUPE
!     2 - PAS DE DECOUPE
!
!
!
!
    integer :: numins
    aster_logical :: lstop
    real(kind=8) :: instam, instap, deltat, insfin
    real(kind=8) :: dtmin, ratio
    real(kind=8) :: valr(2)
    integer :: nbrpas
    aster_logical :: ldeco
    character(len=4) :: typdec
    character(len=24) :: nomlis
    character(len=16) :: optdec
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    optdec = ' '
    ldeco = .false.
    nbrpas = -1
    typdec = 'DELT'
    ratio = 1.d0
    nomlis = '&&NMDCEX.NOMLIS'
    retdex = 0
    ASSERT(durdec.gt.0.d0)
    insfin = insref+durdec
!
! --- AFFICHAGE
!
    valr(1) = insref
    valr(2) = durdec
    call utmess('I', 'SUBDIVISE_13', nr=2, valr=valr)
!
    numins = 1
!
 10 continue
!
! ----- INFORMATIONS SUR LE PAS DE TEMPS
!
    instam = diinst(sddisc,numins-1)
    instap = diinst(sddisc,numins)
    deltat = instap-instam
    if ((instam.ge.insref) .and. (instam.le.insfin)) then
        if (deltat .gt. deltac) then
            if (instap .gt. insfin) then
                optdec = 'DEGRESSIF'
                ratio = (instap-insfin)/deltat
            else
                optdec = 'UNIFORME'
            endif
!
! --------- DECOUPE
!
            call nmdecc(nomlis, .false._1, optdec, deltat, instam,&
                        ratio, typdec, nbrpas, deltac, dtmin,&
                        retdex)
            if (retdex .eq. 0) goto 999
            if (retdex .eq. 2) goto 888
!
! --------- VERIFICATIONS DE LA DECOUPE
!
            call nmdecv(sddisc, numins, ievdac, dtmin, retdex)
            if (retdex .eq. 0) goto 999
!
! --------- MISE A JOUR DES SD APRES DECOUPE
!
            call nmdcdc(sddisc, numins, nomlis, nbrpas)
            ldeco = .true.
888         continue
            call jedetr(nomlis)
        endif
    endif
!
    call nmfinp(sddisc, numins, lstop)
    if (lstop) goto 99
    numins = numins + 1
    goto 10
!
 99 continue
!
    if (ldeco) then
        retdex = 1
    else
        retdex = 2
    endif
!
999 continue
!
    if (retdex .eq. 0) then
!
    else if (retdex.eq.1) then
        call utmess('I', 'SUBDIVISE_14', sr=insfin)
    else if (retdex.eq.2) then
        call utmess('I', 'SUBDIVISE_15', sr=insref)
    else
        ASSERT(.false.)
    endif
!
    call jedema()
end subroutine
