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

subroutine char_read_val(keywordfact, iocc, keyword_z, val_type, val_nb,&
                         val_r, val_f, val_c, val_t)
!
    implicit none
!
#include "asterc/getexm.h"
#include "asterfort/assert.h"
#include "asterfort/getvc8.h"
#include "asterfort/getvid.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
!
!
    character(len=16), intent(in) :: keywordfact
    integer, intent(in) :: iocc
    character(len=*), intent(in) :: keyword_z
    character(len=4), intent(in) :: val_type
    integer, intent(out) :: val_nb
    real(kind=8), intent(out) :: val_r
    character(len=8), intent(out) :: val_f
    complex(kind=8), intent(out) :: val_c
    character(len=16), intent(out) :: val_t
!
! --------------------------------------------------------------------------------------------------
!
! AFFE_CHAR_MECA
!
! Read keywords values
!
! --------------------------------------------------------------------------------------------------
!
! In  keywordfact   : factor keyword to read
! In  iocc          : factor keyword index in AFFE_CHAR_MECA
! In  val_type      : type of values (REEL, COMP, FONC or TEXT) in keyword
! In  keyword       : keyword to read
! Out val_nb        : number of values in keyword
! Out val_r         : values (if real) in keyword
! Out val_f         : names of function (if function) in keyword
! Out val_c         : values (if complex) in keyword
! Out val_t         : values (if text) in keyword
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: keyword
!
! --------------------------------------------------------------------------------------------------
!
    keyword = keyword_z
    val_r = 0.d0
    val_c = (0.d0,0.d0)
    val_f = ' '
    val_t = ' '
    val_nb = 0
!
    if (getexm(keywordfact,keyword) .eq. 0) goto 99
!
    if (val_type .eq. 'REEL') then
        call getvr8(keywordfact, keyword, iocc=iocc, scal=val_r, nbret=val_nb)
    else if (val_type .eq. 'FONC') then
        call getvid(keywordfact, keyword, iocc=iocc, scal=val_f, nbret=val_nb)
    else if (val_type .eq. 'COMP') then
        call getvc8(keywordfact, keyword, iocc=iocc, scal=val_c, nbret=val_nb)
    else if (val_type .eq. 'TEXT') then
        call getvtx(keywordfact, keyword, iocc=iocc, scal=val_t, nbret=val_nb)
    else
        ASSERT(.false.)
    endif
!
99  continue
!
end subroutine
