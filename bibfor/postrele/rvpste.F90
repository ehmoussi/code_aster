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

subroutine rvpste(lieu, ssch19, nomsd, typaff)
    implicit none
!
#include "jeveux.h"
#include "asterfort/i3crdm.h"
#include "asterfort/i3drdm.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rveche.h"
#include "asterfort/rvechn.h"
#include "asterfort/wkvect.h"
    character(len=24) :: nomsd, lieu
    character(len=19) :: ssch19
    character(len=1) :: typaff
!
!     OPERATION EXTRACTION DU POST-TRAITEMENT DE L' OCCURENCE COURANTE
!     ------------------------------------------------------------------
! IN  LIEU   : K : OJB S V K24 NOMS DE LIEU DE POST-TRAITEMENT
! IN  SSCH19 : K : SS_CHAM_19 DE L' EXTRACTION DES CMP NECESSAIRES
! OUT NOMSD  : K : OJB S V K24  NOM DE SD D' EVALUATION SUR LES LIEUX
!     ------------------------------------------------------------------
!     LIEU DE POST-TRAITEMENT ::= RECORD
!        .ABSC : XD V R
!        .REFE : S E K8
!         CHOIX DOCU(.REFE) PARMI
!         -----             -----
!          'LSTN' : DESC = L_NOMS_NOEUDS       REFE =  NOM_MAILLAGE
!         FIN_CHOIX
!         ---------
!
!     SD_EVAL
!        . UNE SD_EVAL PAR LIEU DE POST
!        . TYPE : SOUS_CHAM_GD
!        . LE LIEU JOUE LE ROLE D' UN MAILLAGE
!             NOEUD  : POINT DE POST
!             MAILLE :  TYPE POI1 
!
!    REPRESENTATION SOUS_CHAM_GD :
!        'CHNO' : STANDARD
!        'CHLM' : SEG2 --> NB_CMP PAR POINT, 2 POINTS
!                 POI1 --> NB_CMP PAR POINT, N POINTS
!                          N EST LE NOMBRE DE MAILLES SIGNIFICATIVES
!                          DU MAILLAGE INITIAL
!     ------------------------------------------------------------------
!
!
    integer :: alieu, ibid, l, nbl, anomsd, i, anbndf, aclocf, adescm
    character(len=24) :: nrefe, descm
    character(len=19) :: sdlieu, sdeval
    character(len=4) :: docu
!
!==================== CORPS DE LA ROUTINE =============================
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    call jemarq()
    descm = '&&RVPSTE.PTR.DESC.TYP.MA'
    call jelira(lieu, 'LONMAX', nbl)
    call jeveuo(lieu, 'L', alieu)
    call wkvect(nomsd, 'V V K24', nbl, anomsd)
    call i3crdm(descm)
    call jeveuo(descm, 'L', adescm)
    call wkvect('&&RVPSTE.NB.ND.FACE.TYPE', 'V V I', 18, anbndf)
    call wkvect('&&RVPSTE.CNC.LOC.FA.TYPE', 'V V I', 72, aclocf)
    do 5, i = 1, 3, 1
    ibid = zi(adescm + i-1)
    do 6, l = 1, 6, 1
    zi(anbndf + 6*(i-1) + l-1) = zi(ibid + l+1)
 6  continue
    do 7, l = 1, 24, 1
    zi(aclocf + 24*(i-1) + l-1) = zi(ibid + l+7)
 7  continue
    5 end do
    do 10, l = 1, nbl, 1
    sdlieu = zk24(alieu + l-1)(1:19)
    sdeval = sdlieu
    sdeval(1:8) = '&&RVPSTE'
    zk24(anomsd + l-1) = sdeval//'     '
    nrefe = sdlieu//'.REFE'
    call jelira(nrefe, 'DOCU', cval=docu)
    if (docu .eq. 'LSTN') then
        if (typaff .eq. 'N') then
            call rvechn(ssch19, sdlieu, sdeval)
        else
            call rveche(ssch19, sdlieu, sdeval)
        endif
    else
!           AUTRE LIEU DE POST-TRAITEMENT
    endif
    10 end do
    call jedetr('&&RVPSTE.NB.ND.FACE.TYPE')
    call jedetr('&&RVPSTE.CNC.LOC.FA.TYPE')
    call i3drdm(descm)
    call jedema()
end subroutine
