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

subroutine nmarce(ds_inout, result   , sddisc, time, nume_store,&
                  force   , ds_print_)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nmeteo.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_InOut), intent(in) :: ds_inout
    character(len=8), intent(in) :: result
    character(len=19), intent(in) :: sddisc
    real(kind=8), intent(in) :: time
    integer, intent(in) :: nume_store
    aster_logical, intent(in) :: force
    type(NL_DS_Print), optional, intent(in) :: ds_print_
!
! --------------------------------------------------------------------------------------------------
!
! *_NON_LINE - Input/output datastructure
!
! Save fields in results datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  result           : name of datastructure for results
! In  ds_inout         : datastructure for input/output management
! In  ds_print         : datastructure for printing parameters
! In  sddisc           : datastructure for discretization
! In  time             : current time
! In  force            : .true. to store field whatever storing options
! In  nume_store       : index to store in results
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_field, i_field
!
! --------------------------------------------------------------------------------------------------
!
    nb_field = ds_inout%nb_field
!
! - Loop on fields
!
    do i_field = 1, nb_field
        if (present(ds_print_)) then
            call nmeteo(result, sddisc , ds_inout , force, nume_store, &
                        time  , i_field, ds_print_)
        else
            call nmeteo(result, sddisc , ds_inout , force, nume_store, &
                        time  , i_field)
        endif
    end do
!
end subroutine
