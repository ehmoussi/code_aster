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

subroutine mmfonc(fepx, fmin, fmax)
    implicit none
#include "jeveux.h"
!
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=8) :: fepx
    real(kind=8) :: fmin, fmax
!     CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
!
    integer :: rl, jfon, i, nf0
    real(kind=8) :: val
!
    call jemarq()
!
    call jelira(fepx//'           .VALE', 'LONUTI', rl)
    call jeveuo(fepx//'           .VALE', 'L', jfon)
!
    fmax = -1.0d100
    fmin = 1.0d100
    rl = int(rl/2.d0)
    nf0 = jfon-1 + rl
!
    do 20, i = 1, rl
    val = zr(nf0 + i)
    if (val .gt. fmax) fmax = val
    if (val .lt. fmin) fmin = val
    20 end do
!
    call jedema()
!
end subroutine
