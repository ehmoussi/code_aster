! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nmcrar(result, sddisc, fonact)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/utmess.h"
#include "asterfort/isfonc.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/nmarex.h"
#include "asterfort/nmarnr.h"
#include "asterfort/nmarpr.h"
#include "asterfort/nmcrpx.h"
#include "asterfort/nmdide.h"
#include "asterfort/wkvect.h"
!
character(len=19) :: sddisc
character(len=8) :: result
integer :: fonact(*)
!
! ----------------------------------------------------------------------
!
! ROUTINE *_NON_LINE (STRUCTURES DE DONNES)
!
! CREATION SD ARCHIVAGE
!
! ----------------------------------------------------------------------
!
!
! IN  RESULT : NOM DE LA SD RESULTAT
! IN  FONACT : FONCTIONNALITES ACTIVEES (VOIR NMFONC)
! IN  SDDISC : SD DISCRETISATION
!
! ----------------------------------------------------------------------
!
    integer :: nocc, iocc
    integer :: numder, numrep
    character(len=16) :: motfac, motpas
    integer :: numarc, numreo
    character(len=24) :: arcinf
    integer :: jarinf
    character(len=19) :: sdarch
    integer :: ifm, niv
    aster_logical :: lreuse
    character(len=1) :: base
    real(kind=8) :: insder
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I','MECANONLINE13_14')
    endif
!
! --- FONCTIONNALITES ACTIVEES
!
    lreuse = isfonc(fonact,'REUSE')
!
! --- INITIALISATIONS
!
    motfac = 'ARCHIVAGE'
    motpas = 'PAS_ARCH'
    base = 'V'
    iocc = 1
    numarc = -1
    numreo = -1
    numrep = -1
    call getfac(motfac, nocc)
    ASSERT(nocc.le.1)
!
! --- NOM SD ARCHIVAGE
!
    sdarch = sddisc(1:14)//'.ARCH'
    arcinf = sdarch(1:19)//'.AINF'
!
! --- DERNIER NUMERO ARCHIVE DANS L'EVOL  SI REUSE
!
    call nmdide(lreuse, result, numder, insder)
!
! --- LECTURE LISTE INSTANTS D'ARCHIVAGE
!
    call nmcrpx(motfac, motpas, iocc, sdarch, base)
!
! --- CONSTRUCTION CHAMPS EXCLUS DE L'ARCHIVAGE
!
    call nmarex(motfac, sdarch)
!
! --- RECUPERATION DU PREMIER NUMERO A ARCHIVER
!
    call nmarpr(result, sddisc, lreuse, numder, insder,&
                numarc)
!
! --- RECUPERATION NUMERO REUSE - TABLE OBSERVATION
!
    call nmarnr(result, 'OBSERVATION', numreo)
!
! --- RECUPERATION NUMERO REUSE - TABLE PARA_CALC
!
    call nmarnr(result, 'PARA_CALC', numrep)
!
! --- NUMERO D'ARCHIVE COURANT ET NUMERO DE REUSE
!
    ASSERT(numarc.ge.0)
    ASSERT(numreo.ge.0)
    ASSERT(numrep.ge.0)
    call wkvect(arcinf, 'V V I', 3, jarinf)
    zi(jarinf-1+1) = numarc
    zi(jarinf-1+2) = numreo
    zi(jarinf-1+3) = numrep
!
    call jedema()
!
end subroutine
