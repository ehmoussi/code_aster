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

subroutine impfot(time, string)
!
implicit none
!
#include "asterfort/assert.h"
!
!
    real(kind=8), intent(in) :: time
    character(len=24), intent(out) :: string
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Print management
!
! Convert time in string
!
! --------------------------------------------------------------------------------------------------
!
! In  time             : time to convert
! Out string           : string created
!
! --------------------------------------------------------------------------------------------------
!
    integer :: minut, heure, second
!
! --------------------------------------------------------------------------------------------------
!
    if (time .lt. 60.0d0) then
        write(string,10) time
    else
        if (time .le. 3600.d0) then
            minut = int(time/60)
            second = int(time - (minut*60))
            write(string,20) minut,second
        else
            heure = int(time/3600)
            minut = int((time - (heure*3600))/60)
            second = int(time - (heure*3600) - (minut*60))
            write(string,30) heure,minut,second
        endif
    endif
!
10  format (16x               ,f6.3,' s')
20  format (13x      ,i2,' min ',i2,' s')
30  format (i10,' h ',i2,' min ',i2,' s')
!
end subroutine
