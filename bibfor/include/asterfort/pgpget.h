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
interface
    subroutine pgpget(sd_pgp, param, iobs, lonvec, savejv,&
                      kscal, iscal, rscal, cscal, kvect,&
                      ivect, rvect, cvect)
        character(len=*)          , intent(in) :: sd_pgp
        character(len=*)          , intent(in) :: param
        integer,          optional, intent(in) :: iobs
        character(len=24),optional, intent(out):: savejv
        integer,          optional, intent(out):: lonvec
        character(len=*), optional, intent(out):: kscal
        integer,          optional, intent(out):: iscal
        real(kind=8),     optional, intent(out):: rscal
        complex(kind=8),  optional, intent(out):: cscal   
        character(len=*), optional, intent(out):: kvect(*)
        integer,          optional, intent(out):: ivect(*)
        real(kind=8),     optional, intent(out):: rvect(*)
        complex(kind=8),  optional, intent(out):: cvect(*)
    end subroutine pgpget
end interface
