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

subroutine nmextc(ds_inout, keyw_fact, i_keyw_fact, field_type, l_extr)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/getvtx.h"
#include "asterfort/nmetob.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_InOut), intent(in) :: ds_inout
    character(len=16), intent(in) :: keyw_fact
    integer, intent(in) :: i_keyw_fact
    character(len=24), intent(out) :: field_type
    aster_logical, intent(out) :: l_extr
!
! --------------------------------------------------------------------------------------------------
!
! *_NON_LINE - Field extraction datastructure
!
! Read field type
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_inout         : datastructure for input/output management
! In  keyw_fact        : factor keyword to read extraction parameters
! In  i_keyw_fact      : index of keyword to read extraction parameters
! Out field_type       : type of field (name in results datastructure)
! Out l_extr           : .true. if field can been extracted
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nchp, n1, i_field
!
! --------------------------------------------------------------------------------------------------
!
    l_extr = .true.
!
! - Read
!
    call getvtx(keyw_fact, 'NOM_CHAM', iocc=i_keyw_fact, nbval=0, nbret=n1)
    nchp = -n1
    ASSERT(nchp.eq.1)
!
! - Get name of field (type)
!
    call getvtx(keyw_fact, 'NOM_CHAM', iocc=i_keyw_fact, scal=field_type)
!
! - Get index of field in input/output datastructure
!
    call nmetob(ds_inout, field_type, i_field)
!
! - Can been monitored ?
!
    l_extr = i_field.gt.0
!
end subroutine
