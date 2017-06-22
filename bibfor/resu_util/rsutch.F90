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

subroutine rsutch(nomsd, nomsy, iordr, nomcha, lverif)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
!
#include "asterfort/assert.h"
#include "asterfort/codent.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/rsutrg.h"
    integer :: iordr
    character(len=*) :: nomsd, nomsy, nomcha
    aster_logical :: lverif
! person_in_charge: jacques.pellet at edf.fr
!
! DETERMINATION DU NOM DU CHAMP19 CORRESPONDANT A NOMSD(IORDR,NOMSY)
! ----------------------------------------------------------------------
! IN  : NOMSD  : NOM DE LA STRUCTURE "RESULTAT"
! IN  : NOMSY  : NOM SYMBOLIQUE DU CHAMP
! IN  : IORDR  : NUMERO D'ORDRE DU CHAMP
! OUT : NOMCHA : NOM DU CHAMP
!      LE NOM EST DE LA FORME : 'NOMSD(1:8).III.JJJJJJ'
!      OU : III    : NUMERO ASSOCIE AU NOM SYMBOLIQUE
!           JJJJJJ : NUMERO DE RANGEMENT - 1
! IN  : LVERIF : .TRUE. : SI .TACH EST REMPLI, ON VERIFIE QUE LA
!                REGLE DE NOMMAGE EST VERIFIEE.
! ----------------------------------------------------------------------
!
!
    character(len=3) :: nuch
    character(len=6) :: chford
    character(len=19) :: resu19, nomch3, nomch2
    integer :: isymb, irang, jtach, nbordr
! ----------------------------------------------------------------------
!
    resu19 = nomsd
!
    call jenonu(jexnom(resu19//'.DESC', nomsy), isymb)
    ASSERT(isymb.gt.0)
    call codent(isymb, 'D0', nuch)
!
    call rsutrg(nomsd, iordr, irang, nbordr)
    ASSERT(irang.ge.0)
    ASSERT(irang.le.nbordr)
!
!
!     -- NOMCH2 : NOM QUE LE CHAMP DOIT AVOIR :
    if (irang .eq. 0) then
        call codent(nbordr, 'D0', chford)
    else
        call codent(irang-1, 'D0', chford)
    endif
    nomch2 = resu19(1:8)//'.'//nuch//'.'//chford
!
!
!     -- ON VERIFIE LA COHERENCE DE NOMCH2 AVEC L'OBJET .TACH :
    if (irang .gt. 0 .and. lverif) then
        call jeveuo(jexnum(resu19//'.TACH', isymb), 'L', jtach)
        nomch3 = zk24(jtach-1+irang)(1:19)
        if (nomch3 .ne. ' ') then
            ASSERT(nomch3.eq.nomch2)
        endif
    endif
!
    nomcha = nomch2
!
end subroutine
