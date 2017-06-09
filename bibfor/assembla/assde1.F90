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

subroutine assde1(tych, champ)
! person_in_charge: jacques.pellet at edf.fr
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/chlici.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
#include "asterfort/assert.h"
    character(len=*), intent(in) :: champ
    character(len=*), intent(in) :: tych
! ----------------------------------------------------------------------
!     IN:
!       NOMU   : NOM D'UN CONCEPT DE TYPE
!                CHAMP / CHAM_NO, CHAM_ELEM, CARTE ou RESUELEM (K19)
!
!     RESULTAT:
!     ON DETRUIT TOUS LES OBJETS JEVEUX CORRESPONDANT A CE CONCEPT.
! ----------------------------------------------------------------------
!
!
    character(len=19) :: champ2
    aster_logical :: dbg
! -DEB------------------------------------------------------------------
    champ2 = champ
!
    dbg=.true.
    dbg=.false.
    if (dbg) call chlici(champ2, 19)
!
!
!
!   -- POUR LES CARTE, CHAM_NO, CHAM_ELEM, ET RESU_ELEM :
    if (tych .eq. 'CHAM_ELEM') then
        call jedetr(champ2//'.CELD')
        call jedetr(champ2//'.CELV')
        call jedetr(champ2//'.CELK')
!
    else if (tych.eq.'CHAM_NO') then
        call jedetr(champ2//'.VALE')
        call jedetr(champ2//'.REFE')
        call jedetr(champ2//'.DESC')
!
    else if (tych.eq.'CARTE') then
        call jedetr(champ2//'.DESC')
        call jedetr(champ2//'.NOMA')
        call jedetr(champ2//'.VALE')
        call jedetr(champ2//'.NOLI')
        call jedetr(champ2//'.LIMA')
        call jedetr(champ2//'.VALV')
        call jedetr(champ2//'.NCMP')
        call jedetr(champ2//'.PTMA')
        call jedetr(champ2//'.PTMS')
!
    else if (tych.eq.'RESUELEM') then
        call jedetr(champ2//'.NOLI')
        call jedetr(champ2//'.DESC')
        call jedetr(champ2//'.RESL')
!
    else if (tych.eq.'CHAMP') then
        call jedetr(champ2//'.CELD')
        call jedetr(champ2//'.CELK')
        call jedetr(champ2//'.CELV')
        call jedetr(champ2//'.DESC')
        call jedetr(champ2//'.LIMA')
        call jedetr(champ2//'.NCMP')
        call jedetr(champ2//'.NOLI')
        call jedetr(champ2//'.NOMA')
        call jedetr(champ2//'.PTMA')
        call jedetr(champ2//'.PTMS')
        call jedetr(champ2//'.REFE')
        call jedetr(champ2//'.RESL')
        call jedetr(champ2//'.VALE')
        call jedetr(champ2//'.VALV')
    else
        ASSERT(.false.)
    endif
!
!
!
end subroutine
