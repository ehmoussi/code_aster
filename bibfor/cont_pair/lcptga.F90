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

subroutine lcptga(elem_dime, tria_coor , gauss_family,&
                  nb_gauss , gauss_coor, gauss_weight)
!
implicit none
! 
#include "asterfort/assert.h"
#include "asterfort/elraga.h"
#include "asterfort/reerel.h"
!
!
    integer, intent(in) :: elem_dime
    real(kind=8), intent(in) :: tria_coor(2,3)
    character(len=8) :: gauss_family
    integer, intent(out) :: nb_gauss
    real(kind=8), intent(out) :: gauss_coor(2,12)
    real(kind=8), intent(out) :: gauss_weight(12) 
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing segment to segment
!
! Get integration scheme
!
! --------------------------------------------------------------------------------------------------
!
! In  elem_dime        : dimension of elements
! In  tria_coor        : coordinate of current triangle
! In  gauss_family     : name of integration scheme
! Out nb_gauss         : number of integration points
! Out gauss_coor       : coordinates of integration points
! Out gauss_weight     : weight of integration points
!
! --------------------------------------------------------------------------------------------------
!
    integer ::i_gauss, i_dime, nb_node, model_ndim
    real(kind=8) :: gauxx_coor(24), gauxx_weight(12), segm_coor(2,2)
    real(kind=8) :: area
    real(kind=8) :: xpgpa(2), xpgpr(2)
    character(len=8) :: eleref
!
! --------------------------------------------------------------------------------------------------
!
    model_ndim = elem_dime - 1
    nb_gauss   = 0
    do i_dime = 1, model_ndim
        gauss_coor(i_dime,1:12) = 0.d0
    end do
    gauss_weight(1:12) = 0.d0
!
! - Select reference geometry for auxiliary parametric space
!
    if (model_ndim.eq. 2) then
        eleref  = 'TR3'
        nb_node = 3
    elseif (model_ndim .eq. 1) then
        eleref  = 'SE2'
        nb_node = 2
        segm_coor(1,1) = tria_coor(1,1)
        segm_coor(2,1) = tria_coor(2,1)
        segm_coor(1,2) = tria_coor(1,2)
        segm_coor(2,2) = tria_coor(2,2)
    else
        ASSERT(.false.)
    endif
!
! - Get integration scheme in auxiliary parametric space
!
    call elraga(eleref      , gauss_family, model_ndim, nb_gauss, gauxx_coor,&
                gauxx_weight)
!
! - Surface of real element
!           
    if (model_ndim.eq. 2) then
        area = (tria_coor(1,1)*tria_coor(2,2)-tria_coor(1,2)*tria_coor(2,1)+&
                tria_coor(1,2)*tria_coor(2,3)-tria_coor(1,3)*tria_coor(2,2)+&
                tria_coor(1,3)*tria_coor(2,1)-tria_coor(1,1)*tria_coor(2,3))*1.d0/2.d0
        area = sqrt(area*area)
    else
        area = tria_coor(1,2)-tria_coor(1,1)
        area = sqrt(area*area)
    end if
!
! - Back in element parametric space
!
    do i_gauss = 1, nb_gauss
        do i_dime = 1,model_ndim
            xpgpa(i_dime)=gauxx_coor(model_ndim*(i_gauss-1)+i_dime)
        end do
        if (model_ndim .eq. 2) then       
            call reerel(eleref, nb_node, 2, tria_coor, xpgpa,&
                        xpgpr)
        else
            call reerel(eleref, nb_node, 2, segm_coor, xpgpa,&
                        xpgpr)
        endif
        do i_dime=1,model_ndim
            gauss_coor(i_dime,i_gauss)=xpgpr(i_dime)
        end do
        if (eleref  .eq. 'TR3') then   
            gauss_weight(i_gauss)=2*area*gauxx_weight(i_gauss)
        elseif (eleref .eq. 'SE2') then
            gauss_weight(i_gauss)=1/2.d0*area*gauxx_weight(i_gauss)
        else
            ASSERT(.false.)
        end if
    end do
!
end subroutine
