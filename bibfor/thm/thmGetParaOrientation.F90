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

subroutine thmGetParaOrientation(ndim, nno, jv_geom, angl_naut)
!
use Behaviour_type
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/r8dgrd.h"
#include "asterfort/assert.h"
#include "asterfort/rcangm.h"
#include "asterfort/eulnau.h"
!
!
    integer, intent(in) :: ndim, nno
    integer, intent(in) :: jv_geom
    real(kind=8), intent(out) :: angl_naut(3)
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Get frame orientation for anisotropy
!
! --------------------------------------------------------------------------------------------------
!
! In  ndim             : dimension of element (2 ou 3)
! In  nno              : number of nodes (all)
! In  jv_geom          : JEVEUX adress to initial geometry (mesh)
! Out angl_naut        : nautical angles for frame orientation
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: angmas(7), coor(3), angleu(3)
    integer :: i_node, i_dim
!
! --------------------------------------------------------------------------------------------------
!
    angmas(:)    = 0.d0
    coor(:)      = 0.d0
    angleu(:)    = 0.d0
    angl_naut(:) = 0.d0
!
! - Compute barycentric center
!
    do i_node = 1, nno
        do i_dim = 1, ndim
            coor(i_dim) = coor(i_dim)+zr(jv_geom+i_dim+ndim*(i_node-1)-1)/ nno
        end do
    end do
!
! - Get ANGLE_MASSIF
!
    call rcangm(ndim, coor, angmas)
!
! - Convert all in nautical angles
!
    if (abs(angmas(4)-2.d0) .lt. 1.d-3) then
        if (ndim .eq. 3) then
            angleu(1) = angmas(5)
            angleu(2) = angmas(6)
            angleu(3) = angmas(7)
        else
            angleu(1) = angmas(5)
        endif
        call eulnau(angleu/r8dgrd(), angl_naut/r8dgrd())
    else
        if (ndim .eq. 3) then
            angl_naut(1) = angmas(1)
            angl_naut(2) = angmas(2)
            angl_naut(3) = angmas(3)
        else
            angl_naut(1) = angmas(1)
        endif
    endif
!
end subroutine
