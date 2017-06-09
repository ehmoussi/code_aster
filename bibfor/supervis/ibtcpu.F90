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

subroutine ibtcpu(ier)
    implicit none
#include "asterc/getres.h"
#include "asterc/gtoptr.h"
#include "asterc/rdtmax.h"
#include "asterfort/assert.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/ibcode.h"
#include "asterfort/utmess.h"
    integer :: ier
!     OPTION DE MODIFICATION DE LA LIMITE DE TEMPS CPU POUR CONSERVER
!     UNE MARGE SUFFISANTE AFIN DE TERMINER PROPREMENT UNE EXECUTION
!     ------------------------------------------------------------------
!            0 TOUT C'EST BIEN PASSE
!            1 ERREUR DANS LA LECTURE DE LA COMMANDE
!     ------------------------------------------------------------------
!
    integer :: l1, l2, l3, lcpu, iborne, itpmax, iret, vali(3)
    real(kind=8) :: pccpu, tpmax, dix, ntmax
    parameter(dix=10.d0)
    character(len=16) :: cbid, nomcmd
!
    ier = 0
    tpmax = 0.d0
    ntmax = 0.d0
    l1=0
    l2=0
!     RECUPERATION DU TEMPS LIMITE DE L'EXECUTION
    call gtoptr('tpmax', tpmax, iret)
    ASSERT(iret.eq.0)
    itpmax = nint(tpmax)
!
    call ibcode(iret)
!
    call getvis('RESERVE_CPU', 'VALE', iocc=1, scal=lcpu, nbret=l1)
    call getvr8('RESERVE_CPU', 'POURCENTAGE', iocc=1, scal=pccpu, nbret=l2)
    call getvis('RESERVE_CPU', 'BORNE', iocc=1, scal=iborne, nbret=l3)
!
!     PERMET D'AFFECTER DES VALEURS PAR DEFAUT EN FONCTION DE LA
!     PRESENCE DE CODE
!
!     SI CODE PRESENT
!
    if (iret .gt. 0 .and. l1 .eq. 0 .and. l2 .eq. 0) then
        ntmax = tpmax - dix
        call rdtmax(itpmax-ntmax)
        goto 100
    endif
!
!     SI CODE ABSENT
!
    if (iret .eq. 0 .and. l1 .eq. 0 .and. l2 .eq. 0) then
        pccpu=0.1d0
        ntmax = max ( tpmax*(1-pccpu) , tpmax-iborne )
        call rdtmax(itpmax-ntmax)
        goto 100
    endif
!
    if (l1 .gt. 0) then
        if (lcpu .gt. tpmax) then
            call getres(cbid, cbid, nomcmd)
            call utmess('F', 'SUPERVIS_31')
            ier = 1
        endif
        ntmax = tpmax - lcpu
        call rdtmax(itpmax-ntmax)
    endif
!
    if (l2 .gt. 0) then
        ntmax = max ( tpmax*(1-pccpu) , tpmax-iborne )
        call rdtmax(itpmax-ntmax)
    endif
!
!     IMPRESSION D'UN MESSAGE D'INFORMATION
!
100  continue
    vali(1)=itpmax
    vali(2)=int(ntmax)
    vali(3)=int(itpmax-ntmax)
    call utmess('I', 'SUPERVIS_64', ni=3, vali=vali)
!
end subroutine
