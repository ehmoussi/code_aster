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

subroutine i2tgrm(voisn1, voisn2, nbm, stchm, ptchm,&
                  nbchm)
    implicit none
!
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/i2fccl.h"
#include "asterfort/i2fspl.h"
#include "asterfort/i2gspl.h"
#include "asterfort/jecreo.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeecra.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/assert.h"
    integer :: nbm, voisn1(*), voisn2(*)
    integer :: nbchm, stchm(*), ptchm(*)
!
    aster_logical :: simple, cycle
    integer :: i, apt, ast, mdpt, aplace
!-----------------------------------------------------------------------
    call jemarq()
    apt = 1
    ast = 1
!
    mdpt = 0
!
    aplace = 0
!
    simple = .true.
    cycle = .true.
!
    call jecreo('&INTPLACE', 'V V L')
    call jeecra('&INTPLACE', 'LONMAX', nbm)
    call jeveuo('&INTPLACE', 'E', aplace)
!
    do 10 i = 1, nbm, 1
!
        zl(aplace + i-1) = .false.
!
 10 end do
!
 20 continue
    if (simple) then
!
        call i2fspl(voisn2, zl(aplace), nbm, simple, mdpt)
!
        if (simple) then
!
            call i2gspl(mdpt, voisn1, voisn2, zl(aplace), stchm,&
                        ptchm, ast, apt)
!
        endif
!
        goto 20
!
    endif
!
    mdpt = 0
!
    if (cycle) then
        call i2fccl(zl(aplace), nbm, cycle, mdpt)
        ASSERT(.not.cycle)
    endif
!
    ptchm(apt) = ast
!
    nbchm = apt - 1
!
    call jedetr('&INTPLACE')
!
    call jedema()
end subroutine
