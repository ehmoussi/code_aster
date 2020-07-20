! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

subroutine matr_asse_transpose(matas)
! person_in_charge: nicolas.tardieu at edf.fr
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/detrsd.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jelira.h"
#include "asterfort/jexnum.h"
#include "asterfort/wkvect.h"
#include "blas/dcopy.h"
#include "blas/zcopy.h"

    character(len=*) :: matas
!-----------------------------------------------------------------------
! But : transposer une matrice assemblee
!
! in/jxvar  k* matas : nom de la sd_matr_asse a transposer
!
!-----------------------------------------------------------------------
    character(len=19) :: matas1
    character(len=3) :: tysca
    integer :: n1,neq,jvalm1,jvalm2,jvaltmp
    character(len=24), pointer :: refa(:) => null()
!-------------------------------------------------------------------
    call jemarq()
    matas1=matas
    call jelira(matas1//'.VALM', 'NUTIOC', n1)
    ASSERT(n1.eq.1 .or. n1.eq.2)

!   -- si la matrice est deja symetrique, il n'y a rien a faire :
    if (n1.eq.1) goto 999

    call jeveuo(matas1//'.REFA', 'E', vk24=refa)
    ASSERT(refa(9).eq.'MR')
    call jelira(matas1//'.VALM', 'TYPE', cval=tysca)

    call jelira(jexnum(matas1//'.VALM',1),'LONMAX',neq)
    call wkvect('&&matr_transpose.VALM', 'V V '//tysca, neq, jvaltmp)
    
    call jeveuo(jexnum(matas1//'.VALM', 1),'E',jvalm1)
    call jeveuo(jexnum(matas1//'.VALM', 2),'E',jvalm2)
    if (tysca.eq.'R') then
        call dcopy(neq,zr(jvalm1),1,zr(jvaltmp),1)
        call dcopy(neq,zr(jvalm2),1,zr(jvalm1),1)
        call dcopy(neq,zr(jvaltmp),1,zr(jvalm2),1)
    elseif (tysca.eq.'C') then
        call zcopy(neq,zc(jvalm1),1,zc(jvaltmp),1)
        call zcopy(neq,zc(jvalm2),1,zc(jvalm1),1)
        call zcopy(neq,zc(jvaltmp),1,zc(jvalm2),1)
    else
        ASSERT(.false.)
    endif
    call jedetr('&&matr_transpose.VALM')


999 continue
    call jedema()
end subroutine
