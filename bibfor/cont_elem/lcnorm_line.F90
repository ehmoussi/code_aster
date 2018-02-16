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
subroutine lcnorm_line(elem_code, elem_coor, norm_line)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/provec.h"
!
character(len=8), intent(in) :: elem_code
real(kind=8), intent(in) :: elem_coor(27)
real(kind=8), intent(out) :: norm_line(3)
!
! --------------------------------------------------------------------------------------------------
!
! Contact (LAC) - Elementary computations
!
! Compute normal vector for linearized elements
!
! --------------------------------------------------------------------------------------------------
!
! In  elem_coor        : updated coordinates of element
! In  elem_code        : code of element
! Out norm_line        : normal vector on linearized element
!
! --------------------------------------------------------------------------------------------------
!  
    real(kind=8) :: x1(3), x2(3), x3(3), x4(3)   
    real(kind=8) :: norme  
    real(kind=8) :: e1(3), e2(3)  
!
! --------------------------------------------------------------------------------------------------
!
    x1(:) = 0.d0
    x2(:) = 0.d0
    x3(:) = 0.d0
    x4(:) = 0.d0
    e1(:) = 0.d0
    e2(:) = 0.d0
    norm_line(:) = 0.d0
!
    if (elem_code .eq. 'SE2' .or. elem_code .eq. 'SE3') then 
        x1(1:2) = elem_coor(1:2)  
        x2(1:2) = elem_coor(3:4) 
        norm_line(1) = x1(2)-x2(2)
        norm_line(2) = x2(1)-x1(1)
        norme        = sqrt(norm_line(1)*norm_line(1)+norm_line(2)*norm_line(2))
        norm_line(1) = norm_line(1)/norme
        norm_line(2) = norm_line(2)/norme                      
    elseif (elem_code .eq. 'TR3' .or. elem_code .eq. 'TR6') then
        x1(1:3) = elem_coor(1:3)  
        x2(1:3) = elem_coor(4:6)  
        x3(1:3) = elem_coor(7:9)
        e1(1:3) = x3(1:3)-x1(1:3) 
        e2(1:3) = x3(1:3)-x2(1:3)
        call provec(e1, e2, norm_line) 
        norme = sqrt(norm_line(1)*norm_line(1)+norm_line(2)*norm_line(2)+norm_line(3)*norm_line(3))
        norm_line(1:3) = norm_line(1:3)/norme
    elseif (elem_code .eq. 'QU4'.or. elem_code .eq. 'QU9') then
        x1(1:3) = elem_coor(1:3)  
        x2(1:3) = elem_coor(4:6)  
        x3(1:3) = elem_coor(7:9)
        x4(1:3) = elem_coor(10:12)
        e1(1:3) = x3(1:3)-x1(1:3) 
        e2(1:3) = x4(1:3)-x2(1:3)
        call provec(e1, e2, norm_line) 
        norme = sqrt(norm_line(1)*norm_line(1)+norm_line(2)*norm_line(2)+norm_line(3)*norm_line(3))
        norm_line(1:3) = norm_line(1:3)/norme
    else
       ASSERT(ASTER_FALSE)
    end if 
!
end subroutine
