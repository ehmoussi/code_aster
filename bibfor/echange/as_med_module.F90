! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
#include "asterc/getexm.h"
#include "asterc/write33header.h"
#include "asterfort/getvtx.h"
#include "asterfort/as_mfiope.h"
#include "asterfort/as_mfivop.h"
#include "asterfort/utmess.h"

    public :: as_med_open

contains
!
!>  Open a med file in read, write or read+write mode.
!>  In write mode (creation of a new file) the version of the med format may be
!>  selected. The default version is "3.3.1".
!>  Other possible value is "4.0.0".
!>  The version value is ignored in other opening modes.
!
!>  @param[out]     fid     file identifier
!>  @param[in]      nom     filename
!>  @param[in]      acces   open mode (see med.h for details)
!>  @param[out]     cret    exit code
subroutine as_med_open(fid, nom, acces, cret)
!
    med_idt, intent(out) :: fid
    character(len=*), intent(in) :: nom
    aster_int, intent(in) :: acces
    aster_int, intent(out) :: cret
!
    integer, parameter :: med_acc_rdwr = 1, med_acc_creat = 3
    character(len=8) :: tvers
    integer :: mode, nbret, vers(3)
!
    mode = acces
    vers = bkwd_vers
!
#if (MED_NUM_MAJOR >= 4)
    if (mode .eq. med_acc_creat) then
        if (getexm(' ', 'VERSION_MED') .eq. 1) then
            call getvtx(' ', 'VERSION_MED', nbval=1, scal=tvers, nbret=nbret)
            if (nbret .eq. 1) then
!               TODO create a dedicated function if more than one digit
                read(tvers(1:1), '(i1)') vers(1)
                read(tvers(3:3), '(i1)') vers(2)
                read(tvers(5:5), '(i1)') vers(3)
            endif
        endif

        if (vers(1) .eq. 4 .and. vers(2) .eq. 0) then
!               pass
        elseif (vers(1) .eq. 3 .and. vers(2) .eq. 3) then
            call write33header(nom)
            mode = med_acc_rdwr
        else
            call utmess('F', 'MED_9', ni=3, vali=vers)
        endif
        call utmess('I', 'MED_8', ni=3, vali=vers)
        call as_mfivop(fid, nom, mode, &
                       vers(1), vers(2), vers(3), &
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
