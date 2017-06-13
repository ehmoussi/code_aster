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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine romAlgoNLCorrEFResiduModify(vect_2mbr, ds_algorom)

!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jelira.h"
!
character(len=24)    , intent(in) :: vect_2mbr
type(ROM_DS_AlgoPara), intent(in) :: ds_algorom
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Solving non-linear problem
!
! Evaluate equilibrium residual for EF correction
!
! --------------------------------------------------------------------------------------------------
!
! In  vect_2mbr        : second member
! In  ds_algorom       : datastructure for ROM parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_equa_2mbr, i_equa
    real(kind=8), pointer :: v_vect_2mbr(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jeveuo(vect_2mbr(1:19)//'.VALE', 'E'     , vr = v_vect_2mbr)
    call jelira(vect_2mbr(1:19)//'.VALE', 'LONMAX', nb_equa_2mbr)
    do i_equa = 1, nb_equa_2mbr
        if (ds_algorom%v_equa_sub(i_equa) .eq. 1) then
            v_vect_2mbr(i_equa) = 0.d0
        endif
    enddo
!
end subroutine
