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

subroutine jni092(elrefe, nmaxob, liobj, nbobj)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jeexin.h"
#include "asterfort/pgyty.h"
#include "asterfort/wkvect.h"
    character(len=8) :: elrefe
! person_in_charge: jacques.pellet at edf.fr
!
    integer :: nno, npg
    integer :: iyty, nmaxob, nbobj, lyty, iret
    real(kind=8) :: dff(2)
    character(len=24) :: yty, liobj(nmaxob)
! DEB -----------------------------------------------------------------
    ASSERT(elrefe.eq.'CABPOU')
!
    yty = '&INEL.CABPOU.YTY'
!
    nbobj = 1
    ASSERT(nmaxob.gt.nbobj)
    liobj(1) = yty
!
    call jeexin(yty, iret)
    if (iret .ne. 0) goto 10
!
    nno = 2
    npg = 1
!
    lyty = npg*9*nno**2 + npg
    call wkvect(yty, 'V V R', lyty, iyty)
    dff(1) = -0.5d0
    dff(2) = 0.5d0
    call pgyty(nno, npg, dff, zr(iyty))
!
!
10  continue
!
end subroutine
