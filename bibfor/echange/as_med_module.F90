! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
! person_in_charge: mathieu.courtois@edf.fr
module as_med_module
    implicit none
    private

! default version to be used for output
    integer, parameter :: DEF_BKWD_VERS(3) = (/4, 0, 0/)

    ! currently used version
    integer :: bkwd_vers(3) = (/0, 0, 0/)

#include "asterfort/as_mfiope.h"
#include "asterfort/as_mfivop.h"

    public :: as_med_open

contains

    subroutine init()
        bkwd_vers = DEF_BKWD_VERS
    end subroutine init

!>  Open med file
    subroutine as_med_open(fid, nom, acces, cret)
!
        aster_int, intent(out) :: fid
        character(len=*), intent(in) :: nom
        aster_int, intent(in) :: acces
        aster_int, intent(out) :: cret
!
        integer, parameter :: med_acc_creat = 3
        call init()
!
        if (acces .eq. med_acc_creat) then
            call as_mfivop(fid, nom, acces, &
                           bkwd_vers(1), bkwd_vers(2), bkwd_vers(3), &
                           cret)
        else
            call as_mfiope(fid, nom, acces, cret)
        endif
!
    end subroutine as_med_open

end module as_med_module
