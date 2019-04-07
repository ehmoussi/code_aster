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
!
! default version to be used for output for backward compatibility
    integer, parameter :: bkwd_vers(3) = (/3, 3, 1/)
!
#include "asterc/write33header.h"
#include "asterfort/as_mfiope.h"
#include "asterfort/as_mfivop.h"
#include "asterfort/utmess.h"

    public :: as_med_open

contains
!
!>  Open a med file in read, write or read+write mode.
!>  In write mode (creation of a new file) the version of the med format may be
!>  selected. The default version is (3, 3, 1).
!>  Other possible value for 'vers' is (4, 0, 0).
!>  The version value is ignored in other opening modes.
!
!>  @param[out]     fid     file identifier
!>  @param[in]      nom     filename
!>  @param[in]      acces   open mode (see med.h for details)
!>  @param[out]     cret    exit code
!>  @param[in]      vers    med version number to be used, only for creation (optional)
subroutine as_med_open(fid, nom, acces, cret, vers)
!
        med_idt, intent(out) :: fid
        character(len=*), intent(in) :: nom
        aster_int, intent(in) :: acces
        aster_int, intent(out) :: cret
        aster_int, optional :: vers(3)
!
        integer, parameter :: med_acc_rdwr = 1, med_acc_creat = 3
        integer :: mode, uvers(3)
!
        mode = acces
        if (.not. present(vers)) then
            uvers = bkwd_vers
        else
            uvers = vers
        endif
        !
#if (MED_NUM_MAJOR >= 4)
        if (mode .eq. med_acc_creat) then
            if (uvers(1) .eq. 4 .and. uvers(2) .eq. 0) then
!               pass
            elseif (uvers(1) .eq. 3 .and. uvers(2) .eq. 3) then
                call write33header(nom)
                mode = med_acc_rdwr
            else
                 call utmess('F', 'MED_9', ni=3, vali=uvers)
            endif
            call utmess('I', 'MED_8', ni=3, vali=uvers)
            call as_mfivop(fid, nom, mode, &
                           uvers(1), uvers(2), uvers(3), &
                           cret)
        else
            call as_mfiope(fid, nom, acces, cret)
        endif
#else
        call as_mfiope(fid, nom, acces, cret)
#endif
!
    end subroutine as_med_open
!
end module as_med_module
