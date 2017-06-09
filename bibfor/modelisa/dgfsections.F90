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

subroutine dgfsections(nboccsec, iinbgf, tousgroupesnom, tousgroupesnbf, maxmailgrp, &
                       ulnbnoeuds, ulnbmailles, nbfibres1)
!
!
! --------------------------------------------------------------------------------------------------
!
!                O P E R A T E U R    DEFI_GEOM_FIBRE
!
!   Pré-traitement du mot clef SECTION
!
! --------------------------------------------------------------------------------------------------
!
! person_in_charge: jean-luc.flejou at edf.fr
!
    implicit none
!
    integer :: nboccsec, iinbgf, maxmailgrp, ulnbnoeuds, ulnbmailles, nbfibres1
    integer           :: tousgroupesnbf(*)
    character(len=24) :: tousgroupesnom(*)
!
#include "jeveux.h"
#include "asterf_types.h"
#include "asterfort/codent.h"
#include "asterfort/getvid.h"
#include "asterfort/getvtx.h"
#include "asterfort/jenonu.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/reliem.h"
#include "asterfort/utmess.h"
!
! --------------------------------------------------------------------------------------------------
!
    integer           :: ioc, nbv, jdtm, jmaill, nbmagr, jdo, nbmaills, nbnoeuds, nummai, nutyma
    integer           :: nttri3, ntqua4, ntseg2, ntpoi1
    character(len=7)  :: k7bid
    character(len=8)  :: nomas,ktyma
    character(len=24) :: mlgtms
!
    character(len=24) :: valk(3)
!
    character(len=16) :: limcls(3), ltymcl(3)
    data limcls/'MAILLE_SECT','GROUP_MA_SECT','TOUT_SECT'/
    data ltymcl/'MAILLE','GROUP_MA','TOUT'/
!
! --------------------------------------------------------------------------------------------------
!
!   Récupération des types mailles TRI3, QUAD4, SEG2, POI1
    call jenonu(jexnom('&CATA.TM.NOMTM', 'TRIA3'), nttri3)
    call jenonu(jexnom('&CATA.TM.NOMTM', 'QUAD4'), ntqua4)
    call jenonu(jexnom('&CATA.TM.NOMTM', 'SEG2'),  ntseg2)
    call jenonu(jexnom('&CATA.TM.NOMTM', 'POI1'),  ntpoi1)
!
    do ioc = 1, nboccsec
        iinbgf = iinbgf + 1
        call getvtx('SECTION', 'GROUP_FIBRE', iocc=ioc, scal=tousgroupesnom(iinbgf))
!
        call getvid('SECTION', 'MAILLAGE_SECT', iocc=ioc, scal=nomas, nbret=nbv)
!       Type de maille dans le maillage associé
        mlgtms = nomas//'.TYPMAIL'
        call jeveuo(mlgtms, 'L', jdtm)
!       nombre de fibres = nombre de mailles concernées
        call reliem(' ', nomas, 'NU_MAILLE', 'SECTION', ioc,&
                    3, limcls, ltymcl, '&&OP0119.GRPMAILL', nbmaills)
        call reliem(' ', nomas, 'NU_NOEUD',  'SECTION', ioc,&
                    3, limcls, ltymcl, '&&OP0119.GRPNOEUD', nbnoeuds)
        ulnbnoeuds = ulnbnoeuds + nbnoeuds
        call jeveuo('&&OP0119.GRPMAILL', 'L', jmaill)
!       Les mailles : TRIA3 ou QUA4
!           - les SEG2 sont exclus, ils peuvent servir à la construction
!           - arrêt dans les autres cas
        nbmagr = 0
        do jdo = 1, nbmaills
            nummai = zi(jmaill+jdo-1)
            nutyma = zi(jdtm+nummai-1)
            if (nutyma.eq.ntseg2) cycle
            if ((nutyma.eq.nttri3).or.(nutyma.eq.ntqua4)) then
                nbmagr = nbmagr + 1
                ulnbmailles = ulnbmailles +1
                nbfibres1   = nbfibres1 + 1
                tousgroupesnbf(iinbgf) = tousgroupesnbf(iinbgf) + 1
            else
                call codent(nummai, 'G', k7bid)
                call jenuno(jexnum('&CATA.TM.NOMTM', nutyma), ktyma)
                valk(1)=nomas
                valk(2)=k7bid
                valk(3)=ktyma
                call utmess('F', 'MODELISA6_27', nk=3, valk=valk)
            endif
        enddo
        if ( nbmagr.eq.0 ) then
            valk(1)=nomas
            valk(2)='TRIA3, QUAD4'
            call utmess('F', 'MODELISA6_14', nk=2, valk=valk)
        endif
        maxmailgrp = max(maxmailgrp,nbmagr)
    enddo

end
