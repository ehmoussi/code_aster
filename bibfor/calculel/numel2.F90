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

subroutine numel2(cham, ima, igrel, iel)
    implicit none
#include "jeveux.h"
!
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
    character(len=*) :: cham
!
! IN  : CHAM   : NOM D'UN CHAMP GD
! IN  : IMA    : NUMERO D'UNE MAILLE
! OUT : IGREL  : NUMERO DU GREL OU ON TROUVE LA MAILLE IMA
! OUT : IEL    : NUMERO DE L'ELEMENT DANS LE GREL.
!
!     SI ON NE TROUVE PAS LA MAILLE, ON REND IGREL=IEL=0
! ----------------------------------------------------------------------
!
    character(len=19) :: cham19, noligr
!
!-----------------------------------------------------------------------
    integer :: i, iacelk, ialiel, iel, igr, igrel, ima
    integer :: nbgrel, nel
!-----------------------------------------------------------------------
    call jemarq()
    igrel=0
    iel=0
    cham19 = cham
    call jeveuo(cham19//'.CELK', 'L', iacelk)
    noligr = zk24(iacelk)(1:19)
!
    call jelira(noligr//'.LIEL', 'NUTIOC', nbgrel)
    do 10 igr = 1, nbgrel
        call jelira(jexnum(noligr//'.LIEL', igr), 'LONMAX', nel)
        call jeveuo(jexnum(noligr//'.LIEL', igr), 'L', ialiel)
        do 20 i = 1, nel-1
            if (zi(ialiel-1+i) .eq. ima) then
                igrel = igr
                iel = i
                goto 9999
            endif
20      continue
10  end do
!
9999  continue
    call jedema()
end subroutine
