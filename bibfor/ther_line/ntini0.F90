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

subroutine ntini0(ds_algopara, ds_inout)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/infniv.h"
#include "asterfort/CreateAlgoParaDS.h"
#include "asterfort/CreateInOutDS.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_AlgoPara), intent(out) :: ds_algopara
    type(NL_DS_InOut), intent(out) :: ds_inout
!
! --------------------------------------------------------------------------------------------------
!
! THER_LINEAIRE - Initializations
!
! Creation of datastructures
!
! --------------------------------------------------------------------------------------------------
!
! Out ds_algopara      : datastructure for algorithm parameters
! Out ds_inout         : datastructure for input/output management
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<THER_LINEAIRE> Create datastructures'
    endif
!
! - Create input/output management datastructure
!
    call CreateInOutDS('THER', ds_inout)
!
! - Create algorithm parameters datastructure
!
    call CreateAlgoParaDS(ds_algopara)
!
end subroutine
