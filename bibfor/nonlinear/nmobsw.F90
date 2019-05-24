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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nmobsw(sd_obsv  ,   ds_inout  )
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/diinst.h"
#include "asterfort/nmobse.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmextd.h"
#include "asterfort/jeveuo.h"
!

character(len=19), intent(in) :: sd_obsv
type(NL_DS_InOut), optional, intent(in) :: ds_inout
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Observation
!
! Make observation
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  sddisc           : datastructure for discretization
! In  sd_obsv          : datastructure for observation parameters
! In  nume_time        : index of time
! In  model            : name of model
! In  cara_elem        : name of datastructure for elementary parameters (CARTE)
! In  ds_material      : datastructure for material parameters
! In  ds_constitutive  : datastructure for constitutive laws management
! In  valinc           : hat variable for algorithm fields
! In  ds_inout         : datastructure for input/output management
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: field_type
    character(len=19) :: field
    integer :: i_keyw_fact, nb_keyw_fact, i_field 
    character(len=14) :: sdextr_obsv
    character(len=24) :: extr_info, extr_field
    integer, pointer :: v_extr_info(:) => null()
    character(len=24), pointer :: v_extr_field(:) => null()
!
! --------------------------------------------------------------------------------------------------
!

    !if (nume_time.eq.0) then
    sdextr_obsv = sd_obsv(1:14)
    extr_info   = sdextr_obsv(1:14)//'     .INFO'
    call jeveuo(extr_info, 'L', vi = v_extr_info)
    nb_keyw_fact = v_extr_info(1)
    if (nb_keyw_fact.ne.0) then
        extr_field = sdextr_obsv(1:14)//'     .CHAM'
        call jeveuo(extr_field, 'E', vk24 = v_extr_field)
    endif
    do i_keyw_fact = 1, nb_keyw_fact
        i_field      = v_extr_info(7+7*(i_keyw_fact-1)+7)
        i_field      = abs(i_field)
        field_type   = v_extr_field(4*(i_field-1)+1)
        call nmextd(field_type, ds_inout, field)
        v_extr_field(4*(i_field-1)+4) = field
    end do
    !endif
!
end subroutine
