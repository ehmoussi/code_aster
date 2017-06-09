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

subroutine rsexc1(nomsd, nomsy, iordr, chextr)
    implicit none
#include "asterc/getres.h"
#include "asterfort/gettco.h"
#include "asterfort/detrsd.h"
#include "asterfort/rsexch.h"
#include "asterfort/utmess.h"
    integer :: iordr
    character(len=*) :: nomsd, nomsy, chextr
    character(len=16) :: nomcmd, option, tysd
    character(len=8) :: concep
    character(len=16) :: typcon
    character(len=24) :: valk(2)
    integer :: vali
!      RECUPERATION DU NOM DU CHAMP-GD  CORRESPONDANT A:
!          NOMSD(IORDR,NOMSY).
!      IL S'AGIT D'UN APPEL A RSEXCH COMPLETE PAR DES VERIFICATIONS
!      NOTAMMENT SI L'OPTION A DEJA ETE CALCULEE
!      DANS CE CAS, LES OBJETS JEVEUX PRECEDENTS SONT DETRUITS
!      AFIN DE POUVOIR REFAIRE LE CALCUL DE L'OPTION
!      CE MODULE EST DESTINE A ETRE APPELE PAR DES OPERATEURS
!      PAR EXEMPLE OP0058 AFIN DE PREPARER LES NOMS DE CHAMP-GD
!      AVANT L'APPEL A MECALC
! ----------------------------------------------------------------------
! IN  : NOMSD  : NOM DE LA STRUCTURE "RESULTAT"
! IN  : NOMSY  : NOM SYMBOLIQUE DU CHAMP A CHERCHER.
! IN  : IORDR  : NUMERO D'ORDRE DU CHAMP A CHERCHER.
! OUT : CHEXTR : NOM DU CHAMP EXTRAIT.
! ----------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: icode
!-----------------------------------------------------------------------
    option=nomsy
    call rsexch(' ', nomsd, nomsy, iordr, chextr,&
                icode)
! --- SI L'OPTION A DEJA ETE CALCULEE, ON LA RECALCULE EN
!     EMETTANT UN MESSAGE D'ALARME
    if (icode .eq. 0) then
        call getres(concep, typcon, nomcmd)
        valk (1) = option
        vali = iordr
        call utmess('A', 'UTILITAI8_31', sk=valk(1), si=vali)
        call detrsd('CHAM_ELEM', chextr(1:19))
    else if (icode.gt.100) then
        call getres(concep, typcon, nomcmd)
        call gettco(nomsd, tysd)
        valk(1) = tysd
        valk(2) = option
        call utmess('F', 'CALCULEL3_27', nk=2, valk=valk)
    endif
end subroutine
