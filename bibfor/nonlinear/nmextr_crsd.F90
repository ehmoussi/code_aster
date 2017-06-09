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

subroutine nmextr_crsd(sdextrz, nb_keyw_fact, nb_field, nb_field_comp)
!
implicit none
!
#include "asterfort/wkvect.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=*), intent(in) :: sdextrz
    integer, intent(in) :: nb_keyw_fact
    integer, intent(in) :: nb_field
    integer, intent(in) :: nb_field_comp
!
! --------------------------------------------------------------------------------------------------
!
! *_NON_LINE - Field extraction datastructure
!
! Create datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  sdextr           : name of datastructure for extraction
! In  nb_keyw_fact     : number of factor keyword to read extraction parameters
! In  nb_field         : total number of fields
! In  nb_field_comp    : number of fields to compute (not a default in nonlinear operator)
!
! --------------------------------------------------------------------------------------------------
!
    character(len=14) :: sdextr
    character(len=24) :: extr_info, extr_type, extr_flag, extr_field, extr_comp
    integer, pointer :: v_extr_info(:) => null()
    character(len=8), pointer :: v_extr_type(:) => null()
    aster_logical, pointer :: v_extr_flag(:) => null()
    character(len=24), pointer :: v_extr_field(:) => null()
    character(len=24), pointer :: v_extr_comp(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    sdextr = sdextrz
!
! - Create information vector
!
    extr_info = sdextr(1:14)//'     .INFO'
    call wkvect(extr_info, 'V V I', 7+7*nb_keyw_fact, vi = v_extr_info)
!
    if (nb_keyw_fact .ne. 0) then
!
! ----- Create extraction type vector
!
        extr_type = sdextr(1:14)//'     .EXTR'
        call wkvect(extr_type, 'V V K8', 4*nb_keyw_fact, vk8 = v_extr_type)
!
! ----- Create extraction flag vector
!
        extr_flag = sdextr(1:14)//'     .ACTI'
        call wkvect(extr_flag, 'V V L', nb_keyw_fact, vl = v_extr_flag)
    endif
!
! - Create extraction field vector
!
    if (nb_field .ne. 0) then
        extr_field = sdextr(1:14)//'     .CHAM'
        call wkvect(extr_field, 'V V K24', 4*nb_field, vk24 = v_extr_field)
    endif
!
! - Create extraction fields to compute (not a default in nonlinear operator)
!
    if (nb_field_comp .ne. 0) then
        extr_comp = sdextr(1:14)//'     .COMP'
        call wkvect(extr_comp, 'V V K24', 4*nb_field_comp, vk24 = v_extr_comp)
    endif
!
end subroutine
