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

subroutine CreateInOutDS(phenom, ds_inout)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8vide.h"
#include "asterfort/assert.h"
#include "asterfort/gnomsd.h"
#include "asterfort/CreateInOutDS_M.h"
#include "asterfort/CreateInOutDS_T.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=4), intent(in) :: phenom
    type(NL_DS_InOut), intent(out) :: ds_inout
!
! --------------------------------------------------------------------------------------------------
!
! *_NON_LINE - Input/output management
!
! Create input/output datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  phenom           : phenomenon (MECA/THER/THNL)
! Out ds_inout         : datastructure for input/output management
!
! --------------------------------------------------------------------------------------------------
!
    character(len=19) :: list_load_resu
    character(len=24) :: noobj
!
! --------------------------------------------------------------------------------------------------
!
    ds_inout%result            = ' '
    ds_inout%l_temp_nonl       = .false.
    ds_inout%stin_evol         = ' '
    ds_inout%l_stin_evol       = .false._1
    ds_inout%l_state_init      = .false._1
    ds_inout%l_reuse           = .false._1
    ds_inout%didi_nume         = -1
    ds_inout%criterion         = ' '
    ds_inout%precision         = r8vide()
    ds_inout%user_time         = r8vide()
    ds_inout%user_nume         = 0
    ds_inout%stin_time         = r8vide()
    ds_inout%l_stin_time       = .false._1
    ds_inout%l_user_time       = .false._1
    ds_inout%l_user_nume       = .false._1
    ds_inout%init_time         = r8vide()
    ds_inout%init_nume         = -1
    ds_inout%l_init_stat       = .false._1
    ds_inout%l_init_vale       = .false._1
    ds_inout%temp_init         = r8vide()
!
! - Generate name of list of loads saved in results datastructure
!
    noobj = '12345678'//'.1234'//'.EXCIT'
    call gnomsd(' ', noobj, 10, 13)
    list_load_resu = noobj(1:19)
    ds_inout%list_load_resu = list_load_resu
!
! - Specific parameters
!
    if (phenom.eq.'MECA') then
        call CreateInOutDS_M(ds_inout)
    elseif (phenom.eq.'THER') then
        call CreateInOutDS_T(ds_inout, .false._1)
    elseif (phenom.eq.'THNL') then
        call CreateInOutDS_T(ds_inout, .true._1)
    else
        ASSERT(.false.)
    endif
!
end subroutine
