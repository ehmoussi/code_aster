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

subroutine mmvalp(nb_dim, elem_type, elem_nbno, nb_cmp, ksi1,&
                  ksi2  , vale_node, vale_poin)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/mmnonf.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    integer, intent(in) :: nb_dim
    character(len=8), intent(in) :: elem_type
    integer, intent(in) :: elem_nbno
    integer, intent(in) :: nb_cmp
    real(kind=8), intent(in) :: ksi1
    real(kind=8), intent(in) :: ksi2
    real(kind=8), intent(in) :: vale_node(*)
    real(kind=8), intent(out) :: vale_poin(*)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Utility
!
! Continue method - Interpolate component(s) at point in given element
!
! --------------------------------------------------------------------------------------------------
!
! In  nb_dim           : dimension of element
! In  elem_type        : type of element
! In  elem_nbno        : number of nodes
! In  nb_cmp           : number of components to interpolate
! In  ksi1             : first parametric coordinate of the point 
! In  ksi2             : second parametric coordinate of the point 
! In  vale_node        : value of components at nodes
! Out vale_poin        : value of components at point
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: shape_func(9)
    integer :: i_node, i_cmp
!
! --------------------------------------------------------------------------------------------------
!
    do i_cmp = 1, nb_cmp
        vale_poin(i_cmp) = 0.d0
    end do
    ASSERT(elem_nbno.le.9)
!
! - Shape functions
!
    call mmnonf(nb_dim    , elem_nbno, elem_type, ksi1, ksi2,&
                shape_func)
!
! - Compute
!
    do i_cmp = 1, nb_cmp
        do i_node = 1, elem_nbno
            vale_poin(i_cmp) = shape_func(i_node)*vale_node((i_node-1)*nb_cmp+i_cmp) +&
                               vale_poin(i_cmp)
        end do
    end do
!
end subroutine
