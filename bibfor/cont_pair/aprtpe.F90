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
subroutine aprtpe(elem_dime   , elem_code, indx_tria_elem,&
                  nb_poin_inte, poin_inte)
!
implicit none
!
#include "asterfort/reerel.h"
#include "asterfort/assert.h"
!
integer, intent(in) :: elem_dime
character(len=8), intent(in) :: elem_code
integer, intent(in) :: indx_tria_elem
integer, intent(in) :: nb_poin_inte
real(kind=8), intent(inout) :: poin_inte(elem_dime-1,16)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing segment to segment
!
! Projection from parametric space of triangle in real space
!
! --------------------------------------------------------------------------------------------------
!
! In  elem_dime        : dimension of element
! In  elem_code        : code of element
! In  indx_tria_elem   : index of triangle in element
! In  poin_inte        : coordinates in parametric space of triangle
! Out poin_inte        : coordinates in real space
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: poin_inte_real(elem_dime-1,16)
    integer :: i_poin_inte
    real(kind=8) :: node_real(3), ksi(2)
    real(kind=8) :: tau1(3), tau2(3), norm(3), noor
    real(kind=8) :: node_para(3,3)
    character(len=8) :: elem_proj_code
!
! --------------------------------------------------------------------------------------------------
!
    do i_poin_inte = 1, nb_poin_inte
        poin_inte_real(1, i_poin_inte) = 0.d0
        poin_inte_real(2, i_poin_inte) = 0.d0
    end do
    tau1(1:3) = 0.d0
    tau2(1:3) = 0.d0
    norm(1:3) = 0.d0
    noor      = 0.d0
!
! - Sub-element is always TR3
!
    elem_proj_code = 'TR3'
!
! - Loop on intersection points
!
    do i_poin_inte = 1, nb_poin_inte
        tau1(1:3) = 0.d0
        tau2(1:3) = 0.d0
        norm(1:3) = 0.d0
        noor      = 0.d0
        ksi(1) = poin_inte (1, i_poin_inte)
        if (elem_dime .eq. 3) then
            ksi(2) = poin_inte (2, i_poin_inte)
        end if
        if (elem_code.eq.'QU4' .or. elem_code.eq.'QU8' .or. elem_code.eq.'QU9') then
            if (indx_tria_elem .eq. 1) then
                node_para(1,1) = -1.d0
                node_para(2,1) = -1.d0
                node_para(3,1) =  0.d0
                node_para(1,2) =  1.d0
                node_para(2,2) = -1.d0
                node_para(3,2) =  0.d0
                node_para(1,3) =  1.d0
                node_para(2,3) =  1.d0
                node_para(3,3) =  0.d0
                call reerel(elem_proj_code, 3, 3, node_para, ksi, node_real)
                poin_inte_real(1,i_poin_inte) = node_real(1)
                poin_inte_real(2,i_poin_inte) = node_real(2)
            elseif (indx_tria_elem .eq. 2) then
                node_para(1,1) =  1.d0
                node_para(2,1) =  1.d0
                node_para(3,1) =  0.d0
                node_para(1,2) = -1.d0
                node_para(2,2) =  1.d0
                node_para(3,2) =  0.d0
                node_para(1,3) = -1.d0
                node_para(2,3) = -1.d0
                node_para(3,3) =  0.d0
                call reerel(elem_proj_code,3, 3, node_para, ksi, node_real)
                poin_inte_real(1,i_poin_inte) = node_real(1)
                poin_inte_real(2,i_poin_inte) = node_real(2)
            else
                ASSERT(ASTER_FALSE)
            endif
        else
            poin_inte_real(1,i_poin_inte) = ksi(1)
            if (elem_dime .eq. 3) then
                poin_inte_real(2,i_poin_inte) = ksi(2)
            end if
        end if
    end do
!
! - Copy
!
    do i_poin_inte = 1, nb_poin_inte
        poin_inte(1, i_poin_inte) = poin_inte_real(1, i_poin_inte)
        poin_inte(2, i_poin_inte) = poin_inte_real(2, i_poin_inte)
    end do
!
end subroutine
