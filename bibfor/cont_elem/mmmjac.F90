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
subroutine mmmjac(l_axis   , nb_node     , elem_dime,&
                  elem_code, elem_coor   ,&
                  ff       , dff         ,&
                  jacobi   , l_axis_warn_)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/subaco.h"
#include "asterfort/sumetr.h"
#include "asterfort/utmess.h"
!
aster_logical, intent(in) :: l_axis
character(len=8), intent(in) :: elem_code
integer, intent(in) :: elem_dime, nb_node
real(kind=8), intent(in) :: elem_coor(3, 9)
real(kind=8), intent(in) :: ff(9), dff(2, 9)
real(kind=8), intent(out) :: jacobi
aster_logical, intent(out), optional :: l_axis_warn_
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Compute jacobian
!
! --------------------------------------------------------------------------------------------------
!
! In  l_axis           : .true. for axisymmetric element
! In  elem_dime        : dimension of elements
! In  nb_node          : number of nodes 
! In  elem_code        : code of element
! In  elem_coor        : updated coordinates of element
! In  ff               : shape functions at integration point
! In  dff              : derivatives of shape functions at integration point
! Out jacobian         : jacobian at integration point
! Out l_axis_warn      : flag for warning if axisymmetric
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_node
    real(kind=8) :: dxdk, dydk, dzdk
    real(kind=8) :: r
    real(kind=8) :: cova(3, 3), metr(2, 2)
!
! --------------------------------------------------------------------------------------------------
!
    jacobi = 0.d0
    dxdk   = 0.d0
    dydk   = 0.d0
    dzdk   = 0.d0
    if (present(l_axis_warn_)) then
        l_axis_warn_ = ASTER_FALSE
    endif
!
    if (elem_code(1:2) .eq. 'SE') then
        do i_node = 1, nb_node
            dxdk = dxdk + elem_coor(1,i_node)*dff(1,i_node)
            dydk = dydk + elem_coor(2,i_node)*dff(1,i_node)
            if (elem_dime .eq. 3) then
                dzdk = dzdk + elem_coor(3,i_node)*dff(1,i_node)
            endif
        end do
        jacobi = sqrt(dxdk**2+dydk**2+dzdk**2)
        if (l_axis) then
            r = 0.d0
            do i_node = 1, nb_node
                r = r + elem_coor(1,i_node)*ff(i_node)
            end do
            if (r .eq. 0.d0) then
                r=1.d-7
                if (present(l_axis_warn_)) then
                    l_axis_warn_ = ASTER_TRUE
                endif
            endif
            jacobi = jacobi*abs(r)
        endif
    else
        ASSERT(elem_dime .eq. 3)
        call subaco(nb_node, dff, elem_coor, cova)
        call sumetr(cova, metr, jacobi)
    endif
!
end subroutine
