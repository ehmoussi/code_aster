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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine romFieldChck(ds_field, field_name_)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/indik8.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_Field), intent(in) :: ds_field
character(len=*), optional, intent(in) :: field_name_
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Check components in field
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_field         : datastructure for field
! In  field_name       : name of field where empiric modes have been constructed
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: field_name
    integer :: nb_cmp_chck, nb_cmp
    integer :: i_cmp, i_cmp_chck, indx_cmp
    character(len=8) :: name_cmp_chck(6), name_cmp
!
! --------------------------------------------------------------------------------------------------
!
    field_name = ' '
    nb_cmp     = ds_field%nb_cmp
    if (present(field_name_)) then
        field_name = field_name_
    else
        field_name = ds_field%field_name
    endif
!
! - List of componets authorized in field
!
    if (field_name .eq. 'TEMP') then
        nb_cmp_chck      = 1
        name_cmp_chck(1) = 'TEMP'
    elseif (field_name .eq. 'DEPL') then
        nb_cmp_chck      = 3
        name_cmp_chck(1) = 'DX'
        name_cmp_chck(2) = 'DY'
        name_cmp_chck(3) = 'DZ'
    elseif (field_name .eq. 'FLUX_NOEU') then
        nb_cmp_chck      = 3
        name_cmp_chck(1) = 'FLUX'
        name_cmp_chck(2) = 'FLUY'
        name_cmp_chck(3) = 'FLUZ'
    elseif (field_name .eq. 'SIEF_NOEU') then
        nb_cmp_chck      = 6
        name_cmp_chck(1) = 'SIXX'
        name_cmp_chck(2) = 'SIYY'
        name_cmp_chck(3) = 'SIZZ'
        name_cmp_chck(4) = 'SIXZ'
        name_cmp_chck(5) = 'SIYZ'
        name_cmp_chck(6) = 'SIXY'
    elseif (field_name .eq. 'UPPHI_2D') then
        nb_cmp_chck      = 4
        name_cmp_chck(1) = 'DX'
        name_cmp_chck(2) = 'DY'
        name_cmp_chck(3) = 'PRES'
        name_cmp_chck(4) = 'PHI'
    elseif (field_name .eq. 'UPPHI_3D') then
        nb_cmp_chck      = 5
        name_cmp_chck(1) = 'DX'
        name_cmp_chck(2) = 'DY'
        name_cmp_chck(3) = 'DZ'
        name_cmp_chck(4) = 'PRES'
        name_cmp_chck(5) = 'PHI'
    else
        ASSERT(ASTER_FALSE)
    endif
!
! - Required components
!
    do i_cmp_chck = 1, nb_cmp_chck
        name_cmp = name_cmp_chck(i_cmp_chck)
        indx_cmp = indik8(ds_field%v_list_cmp, name_cmp_chck(i_cmp_chck), 1, nb_cmp)
        if (indx_cmp .eq. 0) then
            call utmess('F', 'ROM5_25', sk = name_cmp)
        endif
    end do
!
! - Forbidden components
!
    do i_cmp = 1, nb_cmp
        name_cmp = ds_field%v_list_cmp(i_cmp)
        indx_cmp = indik8(name_cmp_chck, name_cmp, 1, nb_cmp_chck)
        if (indx_cmp .eq. 0) then
            call utmess('F', 'ROM5_23', sk = name_cmp)
        endif
    end do
!
end subroutine
