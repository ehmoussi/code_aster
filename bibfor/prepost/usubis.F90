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

subroutine usubis(type, para, crit, epsi, x1,&
                  x2, x, iret)
    implicit none
#include "asterfort/usufon.h"
    real(kind=8) :: para(*)
    character(len=*) :: type, crit
!-----------------------------------------------------------------------
    integer :: i, iret, maxit
    real(kind=8) :: df, df1, df2, epsi, f, f1, f2
    real(kind=8) :: resu, x, x1, x2, xd, xg
!-----------------------------------------------------------------------
    parameter     ( maxit = 100 )
!     ------------------------------------------------------------------
!
    iret = 0
!
    resu = para(5)
    call usufon(type, para, x1, f1, df1)
    call usufon(type, para, x2, f2, df2)
    if (crit(1:4) .eq. 'RELA') then
        if (abs(f1-resu) .le. epsi * abs(resu)) goto 9999
    else
        if (abs(f1 - resu) .le. epsi) goto 9999
    endif
    if (crit(1:4) .eq. 'RELA') then
        if (abs(f2-resu) .le. epsi * abs(resu)) goto 9999
    else
        if (abs(f2 - resu) .le. epsi) goto 9999
    endif
    xg = x1
    xd = x2
    do 10 i = 1, maxit
        x = ( xg + xd ) * 0.5d0
        call usufon(type, para, x, f, df)
        if (crit(1:4) .eq. 'RELA') then
            if (abs(f-resu) .le. epsi * abs(resu)) goto 9999
        else
            if (abs(f-resu) .le. epsi) goto 9999
        endif
        if (f .lt. resu) then
            xg = x
            xd = xd
        else
            xg = xg
            xd = x
        endif
10  end do
    iret = 10
    goto 9999
!
9999  continue
end subroutine
