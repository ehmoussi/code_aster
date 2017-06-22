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

subroutine optdep(option, lisopt, nopout)
    implicit none
!     --- ARGUMENTS IN ---
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/ccliop.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeveuo.h"
    character(len=16) :: option
!     --- ARGUMENTS OUT ---
    integer :: nopout
    character(len=24) :: lisopt(*)
!
    character(len=24) :: noliop
    character(len=8) :: temp
    integer :: i, jlisop
!
    temp = '&&OPTDEP'
    call ccliop('CHAMP', option, temp, noliop, nopout)
    if (nopout .eq. 0) goto 9999
    ASSERT(nopout.le.100)
!
    call jeveuo(noliop, 'L', jlisop)
    do 10 i = 1, nopout
        lisopt(i) = zk24(jlisop-1+i)
10  end do
!
9999  continue
    call jedetr(temp//'.LISOPT')
    call jedetr(temp//'.LISORI')
    call jedetr(temp//'.LISDEP')
    call jedetr(temp//'.LNOINS')
    call jedetr(temp//'.ISODEP')
end subroutine
