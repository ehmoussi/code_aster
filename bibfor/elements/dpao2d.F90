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
!
subroutine dpao2d(repere, irep, matr_tran)
!
implicit none
!
#include "asterfort/assert.h"
!
real(kind=8), intent(in) :: repere(7)
integer, intent(out) :: irep
real(kind=8), intent(out) :: matr_tran(4, 4)
!
! --------------------------------------------------------------------------------------------------
!
! Elasticity
!
! Construct transition matrix for orthotropic elasticity - 2D case
!
! --------------------------------------------------------------------------------------------------
!
! In  repere           : define reference frame (AFFE_CARA_ELEM/MASSIF)
!                        repere(1) =  1 => nautical angles (ANGL_REP)
!                           repere(2:4) : nautical angles
!                           repere(5:7) : 0.d0
!                        repere(1) =  2 => Euler angles (ANGL_EULER)
!                           repere(2:4) : nautical angles
!                           repere(5:7) : Euler angles
!                        repere(1) = -1 => axisymetric axis (ANGL_AXE)
!                           repere(2:4) : ANGL_AXE
!                           repere(5:7) : ORIG_AXE
! Out irep             : 0 if matrix is trivial (identity), 1 otherwise
! Out matr_tran        : transition matrix
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: angl, cosa, sina
    real(kind=8), parameter :: zero = 0.d0
    real(kind=8), parameter :: un = 1.d0
    real(kind=8), parameter :: deux = 2.d0
!
! --------------------------------------------------------------------------------------------------
!
    irep = 0
    angl = repere(2)
!
    if (angl .eq. zero) then
        irep = 0
    else
        cosa = cos(angl)
        sina = sin(angl)
        irep = 1
!
        matr_tran(1,1) = cosa*cosa
        matr_tran(2,1) = sina*sina
        matr_tran(3,1) = zero
        matr_tran(4,1) =-deux*cosa*sina
!
        matr_tran(1,2) = sina*sina
        matr_tran(2,2) = cosa*cosa
        matr_tran(3,2) = zero
        matr_tran(4,2) = deux*sina*cosa
!
        matr_tran(1,3) = zero
        matr_tran(2,3) = zero
        matr_tran(3,3) = un
        matr_tran(4,3) = zero
!
        matr_tran(1,4) = sina*cosa
        matr_tran(2,4) =-sina*cosa
        matr_tran(3,4) = zero
        matr_tran(4,4) = cosa*cosa - sina*sina
!
    endif
!
end subroutine
