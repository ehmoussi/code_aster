! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
subroutine romAlgoNLTableSave(nume_store, time_curr, ds_algorom)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/jeveuo.h"
#include "asterfort/romTableSave.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
!
integer, intent(in) :: nume_store
real(kind=8), intent(in) :: time_curr
type(ROM_DS_AlgoPara), intent(in) :: ds_algorom
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Solving non-linear problem
!
! Save table for the reduced coordinates
!
! --------------------------------------------------------------------------------------------------
!
! In  nume_store       : index to store in results
! In  time_curr        : current time
! In  ds_algorom       : datastructure for ROM parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=24) :: tabl_name = ' ', gamma = ' '
    integer :: nb_mode 
    real(kind=8), pointer :: v_gamma(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    tabl_name  = ds_algorom%tabl_name
    gamma      = ds_algorom%gamma
    nb_mode    = ds_algorom%ds_empi%nb_mode
!
! - Print
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_55', si = nb_mode)
    endif
!
! - Access to reduced coordinates
!
    call jeveuo(gamma, 'L', vr = v_gamma)
!
! - Save in table
!
    call romTableSave(tabl_name , nb_mode  , v_gamma  ,&
                      nume_store, time_curr)
!
end subroutine
