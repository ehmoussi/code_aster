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

subroutine tfvegr(nommcf, ocgril)
    implicit none
!-----------------------------------------------------------------------
!     APPELANT : TFVERI, OP0143 , OPERATEUR DEFI_FLUI_STRU
!     VERIFICATIONS DE PREMIER NIVEAU : MOT-CLE FACTEUR FAISCEAU_AXIAL,
!     OPERANDES CARACTERISTIQUES DES GRILLES
!-----------------------------------------------------------------------
!  IN   : NOMMCF : NOM DU MOT-CLE FACTEUR UTILISE (FAISCEAU_AXIAL)
!  IN   : OCGRIL : OCCURENCE DU MOT-CLE FACTEUR POUR LAQUELLE ON
!                  VERIFIE LES ARGUMENTS FOURNIS SOUS LES OPERANDES
!-----------------------------------------------------------------------
!
#include "jeveux.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
    character(len=16) :: nommcf
    integer :: ocgril, ntypg
!
!    ------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: ibid, igril, iveci, nbgtot, ntot2, ntypg2, ntypg3
    integer :: ntypg4, ntypg5, ntypg6
!-----------------------------------------------------------------------
    call jemarq()
!
    call getvr8(nommcf, 'LONG_TYPG', iocc=ocgril, nbval=0, nbret=ntypg)
    ntypg = abs(ntypg)
    call getvr8(nommcf, 'COOR_GRILLE', iocc=ocgril, nbval=0, nbret=nbgtot)
    nbgtot = abs(nbgtot)
    if (nbgtot .lt. ntypg) then
        call utmess('E', 'MODELISA7_15')
    endif
    call getvis(nommcf, 'TYPE_GRILLE', iocc=ocgril, nbval=0, nbret=ntot2)
    if (abs(ntot2) .ne. nbgtot) then
        call utmess('E', 'MODELISA7_16')
    endif
    call wkvect('&&TFVEGR.TEMP.VECI', 'V V I', nbgtot, iveci)
    call getvis(nommcf, 'TYPE_GRILLE', iocc=ocgril, nbval=nbgtot, vect=zi(iveci),&
                nbret=ibid)
    do 100 igril = 1, nbgtot
        if ((zi(iveci+igril-1).lt.1) .or. (zi(iveci+igril-1).gt.ntypg)) then
            call utmess('E', 'MODELISA7_17')
        endif
100  continue
    call getvr8(nommcf, 'LARG_TYPG', iocc=ocgril, nbval=0, nbret=ntypg2)
    call getvr8(nommcf, 'EPAI_TYPG', iocc=ocgril, nbval=0, nbret=ntypg3)
    call getvr8(nommcf, 'RUGO_TYPG', iocc=ocgril, nbval=0, nbret=ntypg4)
    call getvr8(nommcf, 'COEF_TRAI_TYPG', iocc=ocgril, nbval=0, nbret=ntypg5)
    call getvr8(nommcf, 'COEF_DPOR_TYPG', iocc=ocgril, nbval=0, nbret=ntypg6)
    if ((abs(ntypg2).ne.ntypg) .or. (abs(ntypg3).ne.ntypg) .or. (abs(ntypg4).ne.ntypg) .or.&
        (abs(ntypg5).ne.ntypg) .or. (abs(ntypg6).ne.ntypg)) then
        call utmess('E', 'MODELISA7_18')
    endif
!
!
    call jedetr('&&TFVEGR.TEMP.VECI')
    call jedema()
end subroutine
