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

!
!
#include "dtmdef.h"
interface
    subroutine dtmsav(sd_dtm_, ip, lonvec, iocc, kscal,&
                      iscal, rscal, cscal, kvect, ivect,&
                      rvect, cvect, buffer)
        character(len=*)          , intent(in) :: sd_dtm_
        integer                   , intent(in) :: ip
        integer                   , intent(in) :: lonvec
        integer,          optional, intent(in) :: iocc
        character(len=*), optional, intent(in) :: kscal
        integer,          optional, intent(in) :: iscal
        real(kind=8),     optional, intent(in) :: rscal
        complex(kind=8),  optional, intent(in) :: cscal   
        character(len=*), optional, intent(in) :: kvect(lonvec)
        integer,          optional, intent(in) :: ivect(lonvec)
        real(kind=8),     optional, intent(in) :: rvect(lonvec)
        complex(kind=8),  optional, intent(in) :: cvect(lonvec)
        integer, pointer, optional, intent(in) :: buffer(:)
    end subroutine dtmsav
end interface
