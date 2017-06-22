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

subroutine getvid(motfac, motcle, iocc, nbval, vect,&
                  scal, nbret, isdefault)
! person_in_charge: mathieu.courtois at edf.fr
    implicit none
    character(len=*), intent(in) :: motfac
    character(len=*), intent(in) :: motcle
    integer, intent(in), optional :: iocc
    integer, intent(in), optional :: nbval
    character(len=*), intent(out), optional :: vect(*)
    character(len=*), intent(out), optional :: scal
    integer, intent(out), optional :: nbret
    integer, intent(out), optional :: isdefault
#include "asterc/getvid_wrap.h"
#include "asterfort/assert.h"
#include "asterc/getres.h"
!
!   really used variables
    integer :: uioc, uisdef, unbret, umax
!   len=8 should be sufficient, but the same as in getvtx
    integer, parameter :: maxlen=255
    character(len=maxlen) :: uvect(1)
    character(len=1) :: vdummy(1)
!
!   motfac + iocc
    if (present(iocc)) then
        uioc = iocc
    else
        uioc = 0
    endif
    ASSERT(motfac == ' ' .or. uioc > 0)
!   vect + nbval
    ASSERT(AU_MOINS_UN3(nbret,scal,vect))
    ASSERT(EXCLUS2(vect,scal))
    if (present(nbval)) then
        umax = nbval
    else
        umax = 1
    endif
!
    if (present(vect)) then
        call getvid_wrap(motfac, motcle, uioc, uisdef, umax,&
                         vect, unbret)
    else if (present(scal)) then
        ASSERT(len(scal) .le. maxlen)
        call getvid_wrap(motfac, motcle, uioc, uisdef, umax,&
                         uvect, unbret)
        if (unbret .ne. 0) then
            scal = uvect(1)(1:len(scal))
        endif
    else
        call getvid_wrap(motfac, motcle, uioc, uisdef, umax,&
                         vdummy, unbret)
    endif
!   if the ".capy" can not ensure that at least 'umax' are provided, you must check
!   the number of values really read using the 'nbret' argument
    ASSERT(present(nbret) .or. umax .eq. unbret)
!
    if (present(isdefault)) then
        isdefault = uisdef
    endif
    if (present(nbret)) then
        nbret = unbret
    endif
!
end subroutine getvid
