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
subroutine apinte_norm(elem_dime       , &
                       elem_mast_nbnode, elem_mast_coor, elem_mast_code,&
                       elem_slav_coor  , elem_slav_code,&
                       mast_norm       , slav_norm)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/apelem_getcenter.h"
#include "asterfort/apnorm.h"
!
integer, intent(in) :: elem_dime
integer, intent(in) :: elem_mast_nbnode
real(kind=8), intent(in) :: elem_mast_coor(3,9)
character(len=8), intent(in) :: elem_mast_code
real(kind=8), intent(in) :: elem_slav_coor(3,9)
character(len=8), intent(in) :: elem_slav_code
real(kind=8), intent(out) :: mast_norm(3), slav_norm(3)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing segment to segment
!
! Compute norms
!
! --------------------------------------------------------------------------------------------------
!
! In  elem_dime        : dimension of elements
! In  elem_mast_nbnode : number of nodes of master element
! In  elem_mast_coor   : coordinates of master element
! In  elem_slav_code   : code of master element
! In  elem_slav_coor   : coordinates of slave element
! In  elem_slav_code   : code of slave element
! Out mast_norm        : normal for master side
! Out slav_norm        : normal for slave side
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: debug
    real(kind=8) :: ksi1_cent, ksi2_cent
    integer :: elem_line_nbnode
    character(len=8) :: elem_line_code
!
! --------------------------------------------------------------------------------------------------
!
    debug        = ASTER_FALSE
    mast_norm(:) = 0.d0
    slav_norm(:) = 0.d0
!
! - Compute master element normal (at center)
!
    ASSERT(elem_mast_code .eq. 'SE2' .or. elem_mast_code .eq. 'TR3')
    call apelem_getcenter(elem_mast_code, ksi1_cent, ksi2_cent)
    call apnorm(elem_mast_nbnode, elem_mast_code, elem_dime, elem_mast_coor,&
                ksi1_cent       , ksi2_cent     , mast_norm)
    if (debug) then
        write(*,*) ".. Master/Norm: ", mast_norm
    endif
!
! - Linearization of reference element for slave element
!
    if (elem_slav_code .eq. 'TR3' .or.&
        elem_slav_code .eq. 'TR6') then
        elem_line_code   = 'TR3'
        elem_line_nbnode = 3 
    elseif (elem_slav_code .eq. 'QU4' .or.&
            elem_slav_code .eq. 'QU8' .or. &
            elem_slav_code .eq. 'QU9') then
        elem_line_code   = 'QU4'
        elem_line_nbnode = 4  
    elseif (elem_slav_code .eq. 'SE2' .or.&
            elem_slav_code .eq. 'SE3') then
        elem_line_code   = 'SE2'
        elem_line_nbnode = 2
    else
        ASSERT(ASTER_FALSE) 
    end if
!
! - Compute slave element normal (at center)
!
    call apelem_getcenter(elem_line_code, ksi1_cent, ksi2_cent)
    call apnorm(elem_line_nbnode, elem_line_code, elem_dime, elem_slav_coor,&
                ksi1_cent       , ksi2_cent     , slav_norm)
    if (debug) then
        write(*,*) ".. Slave/Norm: ", slav_norm
    endif
!
end subroutine

