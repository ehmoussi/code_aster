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

subroutine op0169()
    implicit none
!     OPERATEUR FONC_FLUI_STRU
!     CREATION D UNE FONCTION CONSTANTE (CONCEPT FONCTION) DONNANT
!     LA VALEUR DU COEFFICIENT DE MASSE AJOUTEE
!     ------------------------------------------------------------------
!     OBJETS SIMPLES CREES:
!        NOMFON//'.PROL'
!        NOMFON//'.VALE
!     ------------------------------------------------------------------
!
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/assert.h"
#include "asterfort/getvid.h"
#include "asterfort/infmaj.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/lxlgut.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
    character(len=8) :: typfon
    character(len=16) :: cmd
    character(len=19) :: nomfon, typflu
    character(len=24) :: fsic, fsvr, prol, vale
!     ------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: ibid, lfsic, lfsvr, lprol, lvale
!-----------------------------------------------------------------------
    call jemarq()
    call infmaj()
!
    call getres(nomfon, typfon, cmd)
    call getvid(' ', 'TYPE_FLUI_STRU', scal=typflu, nbret=ibid)
!
! --- VERIFICATION A L EXECUTION
    fsic = typflu//'.FSIC'
    call jeveuo(fsic, 'L', lfsic)
    if (zi(lfsic) .ne. 1) then
        call utmess('F', 'UTILITAI3_2')
    endif
!
! --- CREATION ET REMPLISSAGE DE L'OBJET NOMFON.PROL
    prol = nomfon//'.PROL'
    ASSERT(lxlgut(nomfon).le.24)
    call wkvect(prol, 'G V K24', 6, lprol)
    zk24(lprol) = 'CONSTANT'
    zk24(lprol+1) = 'LIN LIN '
    zk24(lprol+2) = 'ABSC    '
    zk24(lprol+3) = 'COEF_MAS'
    zk24(lprol+4) = 'CC      '
    zk24(lprol+5) = nomfon
!
! --- CREATION ET REMPLISSAGE DE L'OBJET NOMFON.VALE
    fsvr = typflu//'.FSVR'
    call jeveuo(fsvr, 'L', lfsvr)
!
    vale = nomfon//'.VALE'
    call wkvect(vale, 'G V R', 2, lvale)
    zr(lvale) = 1.0d0
    zr(lvale+1) = zr(lfsvr)
!
    call jedema()
end subroutine
