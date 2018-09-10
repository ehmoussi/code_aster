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

subroutine get_load8(model, v_list_load8, nb_load)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvid.h"
#include "asterfort/utmess.h"
#include "asterfort/as_allocate.h"
!
!
    character(len=8), intent(in) :: model
    character(len=8), pointer :: v_list_load8(:)
    integer, intent(out) :: nb_load
!
! --------------------------------------------------------------------------------------------------
!
! List of loads - Utility
!
! Create datastructure and read data for special list of loads (K8)
!
! --------------------------------------------------------------------------------------------------
!
! In  model          : name of model
! Out v_list_load8   : pointer to list of loads (K8)
! Out nb_load        : number of loads
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nocc, i_load
    character(len=8) :: model_load, model_chck
    character(len=8) :: load_type
!
! --------------------------------------------------------------------------------------------------
!
    nb_load      = 0
    v_list_load8 => null()
!
! - Number of loads
!
    call getvid(' ', 'CHARGE', nbval=0, nbret=nocc)
    nb_load = -nocc
!
! - Create datastructure
!
    AS_ALLOCATE(vk8 = v_list_load8, size = max(1, nb_load))
!
! - Get name of loads
!
    call getvid(' ', 'CHARGE', nbval=nb_load, vect = v_list_load8)
!
! - Same model on all loads
!
    if (nb_load .gt. 0) then
        call dismoi('NOM_MODELE', v_list_load8(1), 'CHARGE', repk=model_load)
        do i_load = 1, nb_load
            call dismoi('NOM_MODELE', v_list_load8(i_load), 'CHARGE', repk=model_chck)
            if (model_chck .ne. model_load) then
                call utmess('F', 'CHARGES5_6')
            endif
        end do
    endif
!
! - Same model
!
    if (nb_load .gt. 0) then
        if (model .ne. model_load) then
            call utmess('F', 'CHARGES5_5', sk = v_list_load8(1))
        endif
    endif
!
! - Check load type
!
    do i_load = 1, nb_load
        call dismoi('TYPE_CHARGE', v_list_load8(i_load), 'CHARGE', repk=load_type)
        if ((load_type(1:4).ne.'MECA') .and. (load_type(1:4).ne.'CIME') .and.&
            (load_type(1:4).ne.'THER') .and. (load_type(1:4).ne.'ACOU')) then
            call utmess('F', 'CHARGES5_12', sk = v_list_load8(i_load))
        endif
    end do
!
end subroutine
