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

subroutine clpoma(elem_dime, elem_code, elem_coor, elem_nbnode, elem_weight)
!
implicit none
!
#include "asterfort/elraga.h"
#include "asterfort/subaco.h"
#include "asterfort/mmdonf.h"
#include "asterfort/sumetr.h"
#include "asterfort/assert.h" 
!
!
    integer, intent(in) :: elem_dime
    character(len=8), intent(in) :: elem_code
    real(kind=8), intent(in) :: elem_coor(3,9)
    integer, intent(in) :: elem_nbnode
    real(kind=8), intent(out) :: elem_weight
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing segment to segment
!
! Compute weight of element
!
! --------------------------------------------------------------------------------------------------
!
! In  elem_dime        : dimension of current element
! In  elem_code        : code of current element
! In  elem_coor        : coordinates of nodes for current element
! In  elem_nbnode      : number of node for current element
! Out elem_weight      : weight of current element
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_gauss, nb_gauss, ino
    character(len=8) :: gauss_family
    real(kind=8) :: gauss_weight(12), gauss_coor(12*2) 
    real(kind=8) :: dff(2, 9), dxdk, dydk, dzdk
    real(kind=8) :: coptg1, coptg2
    real(kind=8) :: cova(3, 3), metr(2, 2), jacobi
!
! --------------------------------------------------------------------------------------------------
!
    elem_weight = 0.d0
!
! - Select integration scheme
!
    if (elem_code.eq. 'SE2') then
        gauss_family = 'FPG3'
    elseif (elem_code.eq. 'SE3') then
        gauss_family = 'FPG3'
    elseif (elem_code.eq. 'TR3') then
        gauss_family = 'FPG3'
    elseif (elem_code.eq. 'TR6') then
        gauss_family = 'FPG6'
    elseif (elem_code.eq. 'QU4') then 
        gauss_family = 'FPG9'  
    elseif (elem_code.eq. 'QU8') then 
        gauss_family = 'FPG9'  
    elseif (elem_code.eq. 'QU9') then 
        gauss_family = 'FPG9'
    else
        ASSERT(.false.)
    end if
!
! - Get integration scheme
!
    call elraga(elem_code   , gauss_family, elem_dime-1, nb_gauss, gauss_coor,&
                gauss_weight)
!
! - Loop on integration points
!
    do i_gauss = 1, nb_gauss
        jacobi = 0.d0
        coptg1 = gauss_coor((elem_dime-1)*(i_gauss-1)+1)
        coptg2 = gauss_coor((elem_dime-1)*(i_gauss-1)+2)
        call mmdonf(elem_dime, elem_nbnode, elem_code, coptg1, coptg2,&
                    dff)
        if ((elem_dime-1) .eq. 2) then
            call subaco(elem_nbnode, dff, elem_coor, cova)
            call sumetr(cova, metr, jacobi)
        else if ((elem_dime-1) .eq. 1) then
            dxdk=0.d0
            dydk=0.d0
            dzdk=0.d0
            do ino = 1, elem_nbnode
                dxdk = dxdk + elem_coor(1,ino)*dff(1,ino)
                dydk = dydk + elem_coor(2,ino)*dff(1,ino)
                if (elem_dime .eq. 3) then
                    dzdk = dzdk + elem_coor(3,ino)*dff(1,ino)
                end if
            end do
            jacobi = sqrt(dxdk**2+dydk**2+dzdk**2)
        else
            ASSERT(.false.)
        end if
        elem_weight = elem_weight+gauss_weight(i_gauss)*jacobi
    end do
!
end subroutine
