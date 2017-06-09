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

subroutine nmexti(node_name, field    , nb_cmp, list_cmp, type_extr_cmp,&
                  nb_vale  , vale_resu)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nmextv.h"
#include "asterfort/posddl.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: node_name
    character(len=19), intent(in) :: field
    integer, intent(in) :: nb_cmp
    character(len=24), intent(in) :: list_cmp
    character(len=8), intent(in) :: type_extr_cmp
    integer, intent(out) :: nb_vale
    real(kind=8), intent(out) :: vale_resu(*)
!
! --------------------------------------------------------------------------------------------------
!
! *_NON_LINE - Field extraction datastructure
!
! Extract value(s) at node
!
! --------------------------------------------------------------------------------------------------
!
! In  node_name        : name of node
! In  field            : name of field
! In  nb_cmp           : number of components
! In  list_cmp         : name of object contains list of components
! In  type_extr_cmp    : type of extraction for components
! Out vale_resu        : list of result values
! Out nb_vale          : number of result values (one if function)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_para_maxi
    parameter    (nb_para_maxi=20)
    character(len=8) :: v_cmp_name(nb_para_maxi)
    real(kind=8) :: v_cmp_vale(nb_para_maxi)
!
    integer :: nb_cmp_vale
    integer :: i_cmp_vale, i_cmp
    character(len=8) :: cmp_name
    integer :: node_nume, dof_nume
    real(kind=8), pointer :: vale(:) => null()
    character(len=8), pointer :: v_list_cmp(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    i_cmp_vale = 1
    ASSERT(nb_cmp.le.nb_para_maxi)
!
! - Access to field
!
    call jeveuo(field //'.VALE', 'L', vr=vale)
!
! - Get name of components
!
    call jeveuo(list_cmp, 'L', vk8 = v_list_cmp)
    do i_cmp = 1, nb_cmp
        v_cmp_name(i_cmp) = v_list_cmp(i_cmp)
    end do
!
! - Get value of components
!
    do i_cmp = 1, nb_cmp
        cmp_name = v_cmp_name(i_cmp)
        call posddl('CHAM_NO', field, node_name, cmp_name, node_nume,&
                    dof_nume)
        if ((node_nume.ne.0) .and. (dof_nume.ne.0)) then
            v_cmp_vale(i_cmp_vale) = vale(dof_nume)
            i_cmp_vale = i_cmp_vale + 1
        endif
    end do
    nb_cmp_vale = i_cmp_vale - 1
!
! - Evaluation
!
    call nmextv(nb_cmp_vale, type_extr_cmp, v_cmp_name, v_cmp_vale, nb_vale,&
                vale_resu)
    ASSERT(nb_vale.le.nb_cmp)
!
end subroutine
