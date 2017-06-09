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

subroutine usunew(type, para, crit, epsi, x1,&
                  x2, resu, iret)
    implicit none
#include "asterfort/usufon.h"
    real(kind=8) :: para(*)
    character(len=*) :: type, crit
!-----------------------------------------------------------------------
    integer :: i, iret, maxit
    real(kind=8) :: da, dfr, dl, dx, dxold, epsi, fr
    real(kind=8) :: resu, temp, x1, x2, xh, xl, zero
!
!-----------------------------------------------------------------------
    parameter     ( maxit = 100 )
!     ------------------------------------------------------------------
!
    iret = 0
    zero = 0.d0
!
    if (type(1:8) .eq. 'TUBE_BAV') then
        dl = para(2)
        da = para(3)
    endif
    xl = x1
    xh = x2
    resu = ( x1 + x2 ) * 0.5d0
    dxold = abs( x2 - x1 )
    dx = dxold
    call usufon(type, para, resu, fr, dfr)
    do 10 i = 1, maxit
        dxold = dx
        if (((resu-xh)*dfr-fr)*((resu-xl)*dfr-fr) .ge. zero .or. abs( fr*2.d0) .gt.&
            abs(dxold*dfr)) then
            dx = ( xh - xl ) * 0.5d0
            resu = dx * xl
!            IF ( XL .EQ. RESU ) GOTO 9999
            if (crit(1:4) .eq. 'RELA') then
                if (abs(xl-resu) .le. epsi * abs(resu)) goto 9999
            else
                if (abs(xl - resu) .le. epsi) goto 9999
            endif
        else
            dx = fr / dfr
            temp = resu
            resu = resu - dx
!            IF ( TEMP .EQ. RESU ) GOTO 9999
            if (crit(1:4) .eq. 'RELA') then
                if (abs(temp-resu) .le. epsi * abs(resu)) goto 9999
            else
                if (abs(temp - resu) .le. epsi) goto 9999
            endif
        endif
        if (abs(dx) .lt. epsi) goto 9999
        if (type(1:8) .eq. 'TUBE_BAV') then
            if (( resu - dl*da ) .lt. 0.d0) then
!            WRITE(8,*)'--->> USUNEW, NOMBRE NEGATIF ',( RESU - DL*DA )
!            WRITE(8,*)'              ON AJUSTE'
                resu = dl*da
            endif
        endif
        call usufon(type, para, resu, fr, dfr)
        if (fr .lt. zero) then
            xl = resu
        else
            xh = resu
        endif
10  end do
    iret = 10
    goto 9999
!
9999  continue
end subroutine
