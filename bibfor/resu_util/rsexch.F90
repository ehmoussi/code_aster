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

subroutine rsexch(kstop, nomsd, nomsy, iordr, chextr,&
                  icode)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/exisd.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/rsutch.h"
#include "asterfort/rsutrg.h"
#include "asterfort/utmess.h"
!
    integer :: iordr, icode
    character(len=*) :: kstop, nomsd, nomsy, chextr
! person_in_charge: jacques.pellet at edf.fr
!      RECUPERATION DU NOM DU CHAMP-GD  CORRESPONDANT A:
!          NOMSD(IORDR,NOMSY).
! ----------------------------------------------------------------------
! IN  : KSTOP  : ' ' / 'F' : VOIR ICODE  (CI-DESSOUS)
! IN  : NOMSD  : NOM DE LA STRUCTURE "RESULTAT"
! IN  : NOMSY  : NOM SYMBOLIQUE DU CHAMP A CHERCHER.
! IN  : IORDR  : NUMERO D'ORDRE DU CHAMP A CHERCHER.
! OUT : CHEXTR : NOM DU CHAMP EXTRAIT (SI POSSIBLE)
!                SINON : '???' (CODE=110,101,102)
! OUT : ICODE  : CODE RETOUR  (SI KSTOP=' ') :
!    0 : LE CHAMP CHEXTR EST "POSSIBLE" ET IL EXISTE (EXISD)
!  100 : LE CHAMP CHEXTR EST "POSSIBLE" MAIS IL N'EXISTE PAS
!  110 : IL FAUT AGRANDIR NOMSD AVANT DE STOCKER IORDR
!  101 : LE NOM SYMBOLIQUE NOMSY EST INTERDIT DANS LA SD
!  102 : LE NUMERO D'ORDRE N'EXISTE PAS DANS LS SD ET IL
!        NE PEUT PAS ETRE AJOUTE CAR IL N'EST PAS SUPERIEUR
!        AU PLUS GRAND.
!  SI KSTOP='F' :
!    SI ICODE=100 => ERREUR <F> DESTINEE A L'UTILISATEUR
!    SI ICODE>100 => ERREUR <F> DESTINEE AU PROGRAMMEUR
! ----------------------------------------------------------------------
!
    character(len=16) :: noms2
    character(len=19) :: nomd2, chext2, chext3
    character(len=24) :: valk(3)
    integer :: iexi, irang, isymb, jtach, nbordr, nbormx
    integer, pointer :: ordr(:) => null()
! ----------------------------------------------------------------------
    call jemarq()
    icode = -99
    noms2 = nomsy
    nomd2 = nomsd
    chextr = '???'
    ASSERT(kstop.eq.' '.or.kstop.eq.'F')
!
!
!     --- NOM SYMBOLIQUE PERMIS ?
    call jenonu(jexnom(nomd2//'.DESC', noms2), isymb)
    if (isymb .eq. 0) then
        icode=101
        goto 10
    endif
!
!
!     --- RECUPERATION DU NUMERO DE RANGEMENT ---
    call rsutrg(nomd2, iordr, irang, nbordr)
!
!
!     -- LE NUMERO DE RANGEMENT EXISTE :
!     -----------------------------------------
    if (irang .gt. 0) then
        call jeveuo(jexnum(nomd2//'.TACH', isymb), 'L', jtach)
        chext2 = zk24(jtach+irang-1)(1:19)
        if (chext2 .eq. ' ') then
            call rsutch(nomsd, noms2, iordr, chext2, .true._1)
        else
            call rsutch(nomsd, noms2, iordr, chext3, .true._1)
            ASSERT(chext2.eq.chext3)
        endif
!
!
!     --- LE NUMERO DE RANGEMENT N'EXISTE PAS :
!     -----------------------------------------
    else
        call jelira(nomd2//'.ORDR', 'LONMAX', nbormx)
        if (nbordr .ge. nbormx) then
            icode = 110
            goto 10
        endif
!
!       -- ON VERIFIE QUE LE NOUVEAU IORDR EST PLUS GRAND
!          QUE L'ANCIEN PLUS GRAND :
        if (nbordr .ge. 1) then
            call jeveuo(nomd2//'.ORDR', 'L', vi=ordr)
            if (iordr .le. ordr(nbordr)) then
                icode=102
                goto 10
            endif
        endif
!
        call rsutch(nomsd, noms2, iordr, chext2, .true._1)
    endif
!
!
!     --- LA SD CHEXTR EXISTE-T-ELLE ? :
!     -----------------------------------------
    chextr = chext2
    ASSERT(chextr.ne.' ')
    call exisd('CHAMP_GD', chextr, iexi)
    if (iexi .gt. 0) then
        icode = 0
    else
        icode = 100
    endif
!
10  continue
    if (kstop .eq. 'F' .and. icode .ne. 0) then
        valk(1)=nomsd
        valk(2)=nomsy
        if (icode .eq. 100) then
            call utmess('F', 'CALCULEL_29', nk=2, valk=valk, si=iordr)
        else
            call utmess('F', 'CALCULEL_29', nk=2, valk=valk, si=iordr)
        endif
    endif
!
!
    call jedema()
end subroutine
