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

subroutine nmdcax(sddisc, insref, numins, durdec, deltac)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterc/r8vide.h"
#include "asterfort/assert.h"
#include "asterfort/diinst.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
    character(len=19) :: sddisc
    integer :: numins
    real(kind=8) :: durdec, insref, deltac
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (GESTION DES EVENEMENTS - DECOUPE)
!
! EXTENSION DE LA DECOUPE AUX INSTANTS SUIVANTS - AUTOMATIQUE
!
! ----------------------------------------------------------------------
!
!
! IN  SDDISC : SD DISCRETISATION TEMPORELLE
! IN  INSREF : INSTANT AU-DELA DUQUEL ON ETEND LA DECOUPE
! IN  DURDEC : DUREEE DE L'EXTENSION DE LA DECOUPE
! IN  DELTAC : INCREMENT DE TEMPS CIBLE
!
!
!
!
    real(kind=8) :: valr(2)
    character(len=24) :: tpsext, tpsdit
    integer :: jtpsex
    real(kind=8) :: instap, instam, inst
    real(kind=8) :: insfin
    real(kind=8) :: oldref
    integer :: nummax, nbrpas
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- PROCHAIN INSTANT INSTAP
!
    tpsdit = sddisc(1:19)//'.DITR'
    call jelira(tpsdit, 'LONMAX', ival=nummax)
    instam = diinst(sddisc,numins)
    if (numins .eq. nummax) then
        instap = instam+deltac
    else
        instap = diinst(sddisc,numins+1)
    endif
!
! --- VALEURS STOCKEES
!
    tpsext = sddisc(1:19)//'.AEXT'
    call jeveuo(tpsext, 'E', jtpsex)
    ASSERT(durdec.gt.0.d0)
    oldref = zr(jtpsex-1+1)
!
! --- PREMIERE EXTENSION
!
    if (oldref .eq. r8vide()) then
        nbrpas = 1
        insfin = insref+durdec
!
! ----- RECHERCHE DE LA "VRAIE FIN"
!
11      continue
        inst = insref + nbrpas*deltac
        if (inst .gt. insfin) then
            nbrpas = nbrpas - 1
            goto 12
        else
            nbrpas = nbrpas + 1
        endif
        goto 11
!
12      continue
        insfin = insref+deltac*nbrpas
    endif
!
! --- EXTENSION
!
    if (oldref .ne. r8vide()) then
        insfin = zr(jtpsex-1+3)
        if (instap .le. insfin) then
            insref = instap
        endif
    endif
!
! --- SAUVEGARDE
!
    zr(jtpsex-1+1) = insref
    zr(jtpsex-1+2) = deltac
    zr(jtpsex-1+3) = insfin
!
! --- AFFICHAGE
!
    valr(1) = insref
    valr(2) = durdec
    call utmess('I', 'SUBDIVISE_18', nr=2, valr=valr)
!
    call jedema()
end subroutine
