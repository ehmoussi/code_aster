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

subroutine assert(cond, str_cond, fname, line)
    implicit none
#include "asterf_types.h"
#include "asterfort/utmess.h"
    aster_logical :: cond
    character(len=*) :: str_cond
    character(len=*) :: fname
    integer :: line
!
! person_in_charge: mathieu.courtois@edf.fr
!
    character(len=256) :: valk(2)
    integer :: vali(1)
    real(kind=8) :: rbid(1)
    if (.not.cond) then
        valk(1) = str_cond
        valk(2) = fname
        vali(1) = line
        call utmess('F', 'DVP_1', nk=2, valk=valk, si=vali(1),&
                    sr=rbid(1))
    endif
end subroutine
