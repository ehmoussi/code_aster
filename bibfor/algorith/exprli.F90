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

subroutine exprli(basmdz, lintfz, nmintz, numint, famprz,&
                  ii, ordo)
!    P. RICHARD     DATE 23/05/91
!-----------------------------------------------------------------------
!  BUT:  < DETERMINATION PROFNO  INTERFACE >
    implicit none
!
!  CONSISTE A DETERMINER UN MINI PROFNO POUR UNE INTERFACE
!
!  PROFLI(1,I)=NUMERO DU PREMIER DDL DU IEME NOEUD DE
!              L'INTERFACE DANS LA MATRICE DE LIAISON
!               (1 DDL = 1 LIGNE)
!  PROFLI(2,I)= ENTIER CODE DES TYPE DDL ACTIF AU NOEUD DANS
!              L'INTERFACE
!
! C'EST A DIRE POUR CHAQUE NOEUDS DE L'INTERFACE LE RANG DE SON PREMIER
!  DDL ACTIF DANS LA MATRICE DE LIAISON ET L'ENTIER CODE DES DDL ACTIFS
! A LA LIAISON
!
!-----------------------------------------------------------------------
!
! BASMDZ   /I/: NOM UT DE LA BASE_MODALE
! LINTFZ   /I/: NOM UT DE LA LIST_INTERFACE
! NMINTZ   /I/: NOM DE L'INTERFACE
! NUMINT   /I/: NUMERO DE L'INTERFACE
! FAMPRZ   /I/: FAMILLE DES MINI-PROFNO
! II       /I/: NUMERO DU PROFNO A CREER DANS LA FAMILLE
!
!
!
#include "jeveux.h"
#include "asterfort/bmnoin.h"
#include "asterfort/bmrdda.h"
#include "asterfort/codent.h"
#include "asterfort/dismoi.h"
#include "asterfort/isdeco.h"
#include "asterfort/jedema.h"
#include "asterfort/jeecra.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"
!
!
!
    integer :: idec(30), llint4, nbcmpm, nbec, nbcmp, nbddl, ordo
    integer :: ii, llact, iec, ldmap, numint, nbdef, nbnoe, icomp, i, j
    parameter   (nbcmpm=10)
    character(len=*) :: basmdz, nmintz, lintfz, famprz
    character(len=4) :: nliai
    character(len=8) :: basmod, nomint, lintf, kbid, blanc, nomg, temp
    character(len=24) :: ordod
    character(len=32) :: famprl
!
!-----------------------------------------------------------------------
    data blanc /'        '/
!-----------------------------------------------------------------------
!
!-------------RECUPERATION LIST_INTERFACE AMONT SI BASE MODALE----------
!
    call jemarq()
!
    basmod = basmdz
    nomint = nmintz
    lintf = lintfz
    famprl = famprz
!
    if (basmod .ne. blanc) then
        call dismoi('REF_INTD_PREM', basmod, 'RESU_DYNA', repk=lintf)
    endif
!
!-----RECUPERATION DU NOMBRE DU NOMBRE D'ENTIERS CODES ASSOCIE A DEPL_R
!
    nomg = 'DEPL_R'
    call dismoi('NB_EC', nomg, 'GRANDEUR', repi=nbec)
    if (nbec .gt. 10) then
        call utmess('F', 'MODELISA_94')
    endif
    call jelira(jexnom('&CATA.GD.NOMCMP', nomg), 'LONMAX', nbcmp)
!
!----------------RECUPERATION EVENTUELLE DU NUMERO INTERFACE------------
!
    if (nomint .ne. '             ') then
        call jenonu(jexnom(lintf//'.IDC_NOMS', nomint), numint)
    endif
!
!----------------RECUPERATION DU NOMBRE DE DDL GENERALISES--------------
!
    call dismoi('NB_MODES_TOT', basmod, 'RESULTAT', repi=nbdef)
!
!----RECUPERATION DU NOMBRE DE DDL  ET NOEUDS ASSOCIES A L'INTERFACE----
!
    kbid=' '
    call bmrdda(basmod, kbid, nomint, numint, 0,&
                [0], nbddl, ordo, ii)
    kbid=' '
    call bmnoin(basmod, kbid, nomint, numint, 0,&
                [0], nbnoe)
!
!-------ALLOCATION DU MINI PROFNO LIAISON INTERFACE COURANTE------------
!
    call jeecra(jexnum(famprl, ii), 'LONMAX', nbnoe*(1+nbec))
    call jeveuo(jexnum(famprl, ii), 'E', ldmap)
!
!--------------------------DETERMINATION DU PRNO------------------------
!
    call jeveuo(jexnum(lintf//'.IDC_DDAC', numint), 'L', llact)
!
    icomp=0
    do i = 1, nbnoe
        do iec = 1, nbec
            if (ordo .eq. 0) then
                zi(ldmap+(1+nbec)*(i-1)+iec)=zi(llact+(i-1)*nbec+iec-&
                1)
            else
                temp='&&OP0126'
                call codent(ii, 'D', nliai)
                ordod=temp//'      .LDAC.'//nliai
                call jeveuo(ordod, 'L', llint4)
                zi(ldmap+(1+nbec)*(i-1)+iec)=zi(llint4+(i-1)*nbec+iec-&
                1)
            endif
        end do
        zi(ldmap+(1+nbec)*(i-1))=icomp+1
        if (ordo .eq. 0) then
            call isdeco(zi(llact+(i-1)*nbec+1-1), idec, nbcmpm)
        else
            temp='&&OP0126'
            call codent(ii, 'D', nliai)
            ordod=temp//'      .LDAC.'//nliai
            call jeveuo(ordod, 'L', llint4)
            call isdeco(zi(llint4+(i-1)*nbec+1-1), idec, nbcmpm)
        endif
        do j = 1, 6
            icomp=icomp+idec(j)
        end do
    end do
!
    call jedema()
end subroutine
