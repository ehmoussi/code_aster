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

subroutine char_read_vect(keywordfact, iocc, keyword_z, vect_r)
!
    implicit none
!
#include "asterc/getexm.h"
#include "asterfort/assert.h"
#include "asterfort/getvr8.h"
!
!
    character(len=16), intent(in) :: keywordfact
    integer, intent(in) :: iocc
    character(len=*), intent(in) :: keyword_z
    real(kind=8), intent(out) :: vect_r(3)
!
! --------------------------------------------------------------------------------------------------
!
! AFFE_CHAR_MECA
!
! Read keywords values for a vector
!
! --------------------------------------------------------------------------------------------------
!
! In  keywordfact   : factor keyword to read
! In  iocc          : factor keyword index in AFFE_CHAR_MECA
! In  keyword       : keyword to read
! Out vect_r        : vector in keyword
!
! --------------------------------------------------------------------------------------------------
!
    integer ::  val_nb, ibid
    character(len=16) :: keyword
!
! --------------------------------------------------------------------------------------------------
!
    keyword = keyword_z
    vect_r(1) = 0.d0
    vect_r(2) = 0.d0
    vect_r(3) = 0.d0
!
    if (getexm(keywordfact,keyword) .eq. 0) goto 99
!
    call getvr8(keywordfact, keyword, iocc=iocc, nbval=0, nbret=val_nb)
    val_nb = -val_nb
    if (val_nb .eq. 0) goto 99
    ASSERT(val_nb.le.3)
    call getvr8(keywordfact, keyword, iocc=iocc, nbval=val_nb, vect=vect_r,&
                nbret=ibid)
!
99  continue
!
end subroutine
