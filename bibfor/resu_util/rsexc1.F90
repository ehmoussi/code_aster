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
!
subroutine rsexc1(nomsd, nomsy, nume_store, chextr)
!
implicit none
!
#include "asterfort/detrsd.h"
#include "asterfort/rsexch.h"
#include "asterfort/utmess.h"
!
character(len=*), intent(in) :: nomsd, nomsy
integer, intent(in) :: nume_store
character(len=*), intent(out) :: chextr
!
! --------------------------------------------------------------------------------------------------
!
!      RECUPERATION DU NOM DU CHAMP-GD  CORRESPONDANT A:
!          NOMSD(IORDR,NOMSY).
!      IL S'AGIT D'UN APPEL A RSEXCH COMPLETE PAR DES VERIFICATIONS
!      NOTAMMENT SI L'OPTION A DEJA ETE CALCULEE
!      DANS CE CAS, LES OBJETS JEVEUX PRECEDENTS SONT DETRUITS
!      AFIN DE POUVOIR REFAIRE LE CALCUL DE L'OPTION
!
! --------------------------------------------------------------------------------------------------
!
! IN  : NOMSD  : NOM DE LA STRUCTURE "RESULTAT"
! IN  : NOMSY  : NOM SYMBOLIQUE DU CHAMP A CHERCHER.
! IN  : IORDR  : NUMERO D'ORDRE DU CHAMP A CHERCHER.
! OUT : CHEXTR : NOM DU CHAMP EXTRAIT.
!
! --------------------------------------------------------------------------------------------------
!
    integer :: icode
    character(len=16) :: option
!
! --------------------------------------------------------------------------------------------------
!
    option = nomsy
    call rsexch(' ', nomsd, nomsy, nume_store, chextr, icode)
!
    if (icode .eq. 0) then
        call utmess('A', 'UTILITAI8_31', sk=option, si=nume_store)
        call detrsd('CHAM_ELEM', chextr(1:19))
    else if (icode .gt. 100) then
        call utmess('F', 'CALCULEL3_27', sk=option)
    endif
end subroutine
