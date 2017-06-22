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

subroutine apnorm(elem_nbnode, elem_code, elem_dime, elem_coor,&
                  ksi1       , ksi2     , elem_norm)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/mmtang.h"
#include "asterfort/mmnorm.h"
#include "asterfort/mmdonf.h"
!
!
    integer, intent(in) :: elem_nbnode
    character(len=8), intent(in) :: elem_code
    integer, intent(in) :: elem_dime
    real(kind=8), intent(in) :: elem_coor(3,9)
    real(kind=8), intent(in) :: ksi1
    real(kind=8), intent(in) :: ksi2
    real(kind=8), intent(out) :: elem_norm(3)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing segment to segment
!
! Compute _exterior_ normal at fiven parametric cooordinates
!
! --------------------------------------------------------------------------------------------------
!
! In  elem_nbnode      : number of node for current element
! In  elem_code        : code of current element
! In  elem_dime        : dimension of current element
! In  elem_coor        : coordinates of nodes for current element
! In  ksi1             : first parametric coordinate of the point
! In  ksi2             : second parametric coordinate of the point
! Out elem_norm        : normal direction of element
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: tau1(3), tau2(3)
    real(kind=8) :: dff(2,9), noor
!
! --------------------------------------------------------------------------------------------------
!
    elem_norm(1:3) = 0.d0
    tau1(1:3)      = 0.d0
    tau2(1:3)      = 0.d0
!
    call mmdonf(elem_dime, elem_nbnode, elem_code, ksi1, ksi2,&
                dff)
    call mmtang(elem_dime, elem_nbnode, elem_coor, dff , tau1,&
                tau2)
    call mmnorm(elem_dime, tau1, tau2, elem_norm, noor)
!
    elem_norm(1:3) = -elem_norm(1:3)
!
end subroutine
