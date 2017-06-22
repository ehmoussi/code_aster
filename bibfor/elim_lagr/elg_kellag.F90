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

subroutine elg_kellag(matass, solveu, kellag)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
!-----------------------------------------------------------------------
! But : determiner si la fonctionnalite ELIM_LAGR est demandee
!-----------------------------------------------------------------------
    character(len=*), intent(in) :: matass
    character(len=*), intent(in) :: solveu
    character(len=3), intent(out) :: kellag
!
!-----------------------------------------------------------------------
! ----------------------------------------------------------------------
!
!
    integer ::   n1
    character(len=19) :: matas1, solve1
    character(len=3) :: kbid
    character(len=24), pointer :: slvk(:) => null()
! ----------------------------------------------------------------------
!
    call jemarq()
!
!
!     1. CALCUL DE KELLAG :
!     -------------------------------------
    matas1=matass
    solve1=solveu
    if (solve1 .eq. ' ') call dismoi('SOLVEUR', matas1, 'MATR_ASSE', repk=solve1)
    call jeveuo(solve1//'.SLVK', 'L', vk24=slvk)
    call jelira(solve1//'.SLVK', 'LONMAX', n1, kbid)
    ASSERT(n1.eq.14)
    kellag=slvk(13)(1:3)
    ASSERT(kellag.eq.' '.or.kellag.eq.'OUI'.or.kellag.eq.'NON')
!
    call jedema()
end
