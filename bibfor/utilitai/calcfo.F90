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

subroutine calcfo(compl, nomfin, nomfon, nbval, vale,&
                  nopara)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/fointc.h"
#include "asterfort/fointe.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/lxlgut.h"
#include "asterfort/wkvect.h"
    integer :: nbval
    real(kind=8) :: vale(*)
    aster_logical :: compl
    character(len=24) :: nopara
    character(len=19) :: nomfin, nomfon
!
!     CREATION DU SD FONCTION A PARTIR D'UNE FORMULE (FONCTION )
!     ------------------------------------------------------------------
    integer :: ier, nbval2, lvale, lfon, ival, lprol
!     ------------------------------------------------------------------
!
    call jemarq()
!
!     --- CREATION ET REMPLISSAGE DE L'OBJET NOMFON.VALE ---
!
    if (compl) then
        nbval2 = 3*nbval
    else
        nbval2 = 2*nbval
    endif
!
    call wkvect(nomfon//'.VALE', 'G V R', nbval2, lvale)
    lfon = lvale + nbval
    do 10 ival = 0, nbval-1
        zr(lvale+ival) = vale(ival+1)
        if (compl) then
            call fointc('F', nomfin, 1, nopara, zr(lvale+ival),&
                        zr(lfon+2*ival), zr(lfon+2*ival+1), ier)
        else
            call fointe('F', nomfin, 1, nopara, zr(lvale+ival),&
                        zr( lfon+ival), ier)
        endif
 10 end do
!
!     --- CREATION ET REMPLISSAGE DE L'OBJET NOMFON.PROL ---
!
    ASSERT(lxlgut(nomfon).le.24)
    call wkvect(nomfon//'.PROL', 'G V K24', 6, lprol)
    if (compl) then
        zk24(lprol) = 'FONCT_C         '
    else
        zk24(lprol) = 'FONCTION        '
    endif
    zk24(lprol+1) = 'LIN LIN         '
    zk24(lprol+2) = nopara
    zk24(lprol+3) = 'TOUTRESU        '
    zk24(lprol+4) = 'EE              '
    zk24(lprol+5) = nomfon
!
    call jedema()
end subroutine
