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

subroutine ccnett(nobase, nopout)
    implicit none
!     --- ARGUMENTS ---
#include "jeveux.h"
#include "asterfort/codent.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
    integer :: nopout
    character(len=8) :: nobase
!  CALC_CHAMP - NETTOYAGE
!  -    -       ----
! ----------------------------------------------------------------------
!
! IN  :
!   NOBASE  K8   BASE DU NOM A PARTIR DE LAQUELLE LE NOM DES OBJETS DE
!                CCLIOP ONT ETE CONSTRUITS
!   NOPOUT  I    TAILLE DE LA LISTE OUT
! ----------------------------------------------------------------------
! person_in_charge: nicolas.sellenet at edf.fr
!
    integer :: iop
!
    character(len=5) :: numopt
    character(len=11) :: nobaop
    character(len=24) :: noliop, nolori, noldep, noliin, lisins, nolisd
!
    call jemarq()
!
    noliop = nobase//'.LISOPT'
    nolori = nobase//'.LISORI'
    noldep = nobase//'.LISDEP'
    noliin = nobase//'.LNOINS'
    nolisd = nobase//'.ISODEP'
!
    nobaop = nobase//'.OP'
!
    do 30 iop = 1, nopout
        call codent(iop, 'D0', numopt)
        lisins = nobaop//numopt
        call jedetr(lisins)
30  end do
!
    call jedetr(noliop)
    call jedetr(nolori)
    call jedetr(noldep)
    call jedetr(noliin)
    call jedetr(nolisd)
!
    call jedema()
!
end subroutine
