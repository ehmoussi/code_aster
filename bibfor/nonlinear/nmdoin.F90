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

subroutine nmdoin(ds_inout)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8vide.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/rs_gettime.h"
#include "asterfort/rs_getlast.h"
#include "asterfort/rs_getnume.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_InOut), intent(inout) :: ds_inout
!
! --------------------------------------------------------------------------------------------------
!
! Non-linear algorithm - Input/output management
!
! Initial storing index and time
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_inout         : datastructure for input/output management
!
! --------------------------------------------------------------------------------------------------
!
    integer :: last_nume, user_nume, init_nume
    real(kind=8) :: last_time, user_time, init_time, stin_time
    character(len=8) :: criterion
    real(kind=8) :: precision
    integer :: iret
    aster_logical :: l_user_time, l_stin_time, l_user_nume
!
! --------------------------------------------------------------------------------------------------
!
    init_time = r8vide()
    init_nume = -1
!
! - Get parameters
!
    criterion   = ds_inout%criterion
    precision   = ds_inout%precision
    user_time   = ds_inout%user_time 
    l_user_time = ds_inout%l_user_time
    user_nume   = ds_inout%user_nume
    l_user_nume = ds_inout%l_user_nume
    stin_time   = ds_inout%stin_time
    l_stin_time = ds_inout%l_stin_time
!
! - Initial time search
!
    if (ds_inout%l_stin_evol) then
!
! ----- No storing index/time by user => last one in results datastructure
!
        if ((.not.l_user_time) .and. (.not.l_user_nume)) then
            call rs_getlast(ds_inout%stin_evol, last_nume, last_time)
            init_nume = last_nume
            init_time = last_time
        endif
!
! ----- Time by user => get storing index
!
        if (l_user_time) then
            init_time = user_time
            call rs_getnume(ds_inout%stin_evol, init_time, criterion, precision, init_nume, iret)
            if (iret .eq. 0) then
                call utmess('F', 'ETATINIT_3', sk=ds_inout%stin_evol)
            endif
            if (iret .eq. 2) then
                call utmess('F', 'ETATINIT_4', sk=ds_inout%stin_evol)
            endif
            ASSERT(iret.eq.1)
        endif
!
! ----- Storing index by user => get time
!
        if (l_user_nume) then
            init_nume = user_nume
            call rs_gettime(ds_inout%stin_evol, init_nume, init_time)
        endif
    endif
!
! - Initial time defined by user
!
    if (l_stin_time) then
        init_time = stin_time
    endif
!
! - Set parameters
!
    ds_inout%init_time = init_time
    ds_inout%init_nume = init_nume
!
end subroutine
