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

subroutine apelem_inside(pair_tole   , elem_dime, elem_code,&
                         nb_poin_coor, poin_coor,&
                         nb_poin_inte, poin_inte)
!
implicit none
!
#include "asterfort/assert.h"
!
!
    real(kind=8), intent(in) :: pair_tole
    integer, intent(in) :: elem_dime
    character(len=8), intent(in) :: elem_code
    integer, intent(in) :: nb_poin_coor
    real(kind=8), intent(in) :: poin_coor(elem_dime-1,4)
    integer, intent(inout) :: nb_poin_inte
    real(kind=8), intent(inout) :: poin_inte(elem_dime-1,16)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing segment to segment
!
! Add points in list of intersection point if inside element
!
! --------------------------------------------------------------------------------------------------
!
! In  pair_tole        : tolerance for pairing
! In  elem_dime        : dimension of elements
! In  elem_code        : code of element
! In  nb_poin_coor     : number of points 
! In  poin_coor        : parametric coordinates of points 
! IO  nb_poin_inte     : number of intersection points
! IO  poin_inte        : list of intersection points
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_node
    real(kind=8) :: xpt, ypt
!
! --------------------------------------------------------------------------------------------------
!
    if (elem_code .eq. 'SE2') then
        do i_node = 1, nb_poin_coor
            xpt = poin_coor(1, i_node)
            if (xpt .ge. (-1.d0-pair_tole) .and.&
                xpt .le. ( 1.d0+pair_tole)) then       
                nb_poin_inte              = nb_poin_inte+1
                ASSERT(nb_poin_inte.le.16)
                poin_inte(1,nb_poin_inte) = xpt
            endif
        end do
    elseif (elem_code .eq. 'TR3') then
        do i_node = 1, nb_poin_coor
            xpt=poin_coor(1,i_node)
            ypt=poin_coor(2,i_node)
            if (xpt .ge. -pair_tole .and.&
                ypt .ge. -pair_tole .and.&
               (ypt+xpt).le.(1.d0+pair_tole)) then       
                nb_poin_inte              = nb_poin_inte+1
                ASSERT(nb_poin_inte.le.16)
                poin_inte(1,nb_poin_inte) = xpt
                poin_inte(2,nb_poin_inte) = ypt
            endif
        end do
    elseif (elem_code .eq. 'QU4') then
        do i_node = 1, nb_poin_coor
            xpt=poin_coor(1,i_node)
            ypt=poin_coor(2,i_node)
            if (xpt .ge. (-1.d0-pair_tole) .and.&
                ypt .ge. (-1.d0-pair_tole) .and.&
                ypt .le. ( 1.d0+pair_tole) .and.&
                xpt .le. ( 1.d0+pair_tole)) then       
                nb_poin_inte              = nb_poin_inte+1
                ASSERT(nb_poin_inte.le.16)
                poin_inte(1,nb_poin_inte) = xpt
                poin_inte(2,nb_poin_inte) = ypt
            endif
        end do
    else
        ASSERT(.false.)
    end if
!
!
end subroutine
