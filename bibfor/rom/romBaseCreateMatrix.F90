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
subroutine romBaseCreateMatrix(ds_empi, v_matr_phi)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/as_allocate.h"
#include "asterfort/rsexch.h"
#include "asterfort/jeveuo.h"
!
type(ROM_DS_Empi), intent(in) :: ds_empi
real(kind=8), pointer, intent(out) :: v_matr_phi(:)
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Create [PHI] matrix from empiric base
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_empi          : datastructure for empiric modes
! Out v_matr_phi       : pointer to [PHI] matrix
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: i_mode, iret, i_equa
    integer :: nb_equa, nb_mode
    character(len=24) :: mode
    real(kind=8), pointer :: v_mode(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
!
! - Get parameters
!
    nb_equa = ds_empi%nb_equa
    nb_mode = ds_empi%nb_mode
    if (niv .ge. 2) then
        call utmess('I', 'ROM6_30', ni = 2, vali = [nb_equa,nb_mode])
    endif
!
! - Create [PHI] matrix
!
    AS_ALLOCATE(vr = v_matr_phi, size = nb_equa*nb_mode)
    do i_mode = 1, nb_mode
        call rsexch(' ', ds_empi%base, ds_empi%field_name, i_mode, mode, iret)
        ASSERT(iret .eq. 0)
        call jeveuo(mode(1:19)//'.VALE', 'L', vr = v_mode)
        do i_equa = 1, nb_equa
            v_matr_phi(i_equa+nb_equa*(i_mode-1)) = v_mode(i_equa)    
        end do
    end do
!
end subroutine
