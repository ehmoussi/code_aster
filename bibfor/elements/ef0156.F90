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

subroutine ef0156(nomte)
    implicit none
#include "jeveux.h"
#include "asterfort/jevech.h"
#include "asterfort/tecach.h"
#include "asterfort/assert.h"
#include "asterfort/ppgan2.h"
#include "asterfort/teattr.h"
#include "asterfort/elrefe_info.h"

    character(len=16) :: nomte
!-----------------------------------------------------------------------
! REALISE  EFGE_ELNO pour barres et membranes
! ----------------------------------------------------------------------
!
    integer :: itabin(2), itabou(2),iret,k,ibid,jgano, npg, nno
    character(len=8) :: alias8
    aster_logical :: lbarre
!------------------------------------------------------------------------
!
    call teattr('S', 'ALIAS8', alias8, ibid)
    lbarre=alias8(6:8).eq.'SE2'

    call tecach('OOO', 'PCONTRR', 'L', iret=iret, nval=2, itab=itabin)
    ASSERT(iret.eq.0)
    call tecach('OOO', 'PEFFORR', 'E', iret=iret, nval=2, itab=itabou)
    ASSERT(iret.eq.0)

    if (lbarre) then
        ASSERT(itabin(2).eq.1)
        ASSERT(itabou(2).eq.2)
        zr(itabou(1)-1+1)=zr(itabin(1)-1+1)
        zr(itabou(1)-1+2)=zr(itabin(1)-1+1)

    else
        call elrefe_info(fami='RIGI', nno=nno, npg=npg,jgano=jgano)
        ASSERT(3*nno.eq.itabou(2))
        ASSERT(3*npg.eq.itabin(2))

        do k=1,itabin(2)
            zr(itabou(1)-1+k)=zr(itabin(1)-1+k)
        enddo
        call ppgan2(jgano, 1, 3, zr(itabin(1)), zr(itabou(1)))
    endif
!
end subroutine
