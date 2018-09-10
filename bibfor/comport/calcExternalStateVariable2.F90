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
!
subroutine calcExternalStateVariable2(nno    , npg   , ndim  ,&
                                      jv_func, &
                                      geom   , typmod)
!
use calcul_module, only : ca_vext_coorga_
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
!
integer, intent(in) :: nno, npg, ndim
integer, intent(in) :: jv_func
character(len=8), intent(in) :: typmod(2)
real(kind=8), intent(in) :: geom(ndim, nno)
!
! --------------------------------------------------------------------------------------------------
!
! Behaviour - Compute intrinsic external state variables
!
! Case: coordinates of Gauss points (COORGA)
!
! --------------------------------------------------------------------------------------------------
!
! In  nno              : number of nodes 
! In  npg              : number of Gauss points 
! In  ndim             : dimension of problem (2 or 3)
! In  jv_poids         : JEVEUX adress for weight of Gauss points
! In  jv_func          : JEVEUX adress for shape functions
! In  jv_dfunc         : JEVEUX adress for derivative of shape functions
! In  typmod           : type of modelization (TYPMOD2)
! In  geom             : initial coordinates of nodes
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: laxi
    integer :: i, k, kpg
!
! --------------------------------------------------------------------------------------------------
!
    laxi = typmod(1) .eq. 'AXIS'
    ca_vext_coorga_(:,:) = 0.d0
    ASSERT(npg .le. 27)
!
    if (.not. laxi) then
        do kpg = 1, npg
            do i = 1, ndim
                do k = 1, nno
                    ca_vext_coorga_(kpg, i) = ca_vext_coorga_(kpg, i) +&
                                              geom(i,k)*zr(jv_func-1+nno*(kpg-1)+k)
                end do
            end do
        end do
    endif
!
end subroutine
