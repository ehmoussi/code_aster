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
subroutine thmSelectMatrix(ndim  , dimdef, inte_type,&
                           addeme, addete, addep1   , addep2,&
                           a     , as    ,&
                           c     , cs    )
!
use THM_type
use THM_module
!
implicit none
!
#include "asterfort/assert.h"
!
integer, intent(in) :: ndim, dimdef
character(len=3), intent(in) :: inte_type
integer, intent(in) :: addeme, addete, addep1, addep2
real(kind=8), intent(out) :: a(2), as(2)
real(kind=8), intent(out) :: c(21), cs(21)
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Create matrix for selection of dof
!
! --------------------------------------------------------------------------------------------------
!
! In  ndim             : dimension of space (2 or 3)
! In  dimdef           : dimension of generalized strains vector
! In  inte_type        : type of integration - classical, lumped (D), reduced (R)
! In  addeme           : adress of mechanic components in generalized strains vector
! In  addete           : adress of thermic components in generalized strains vector
! In  addep1           : adress of capillary pressure in generalized strains vector
! In  addep2           : adress of gaz pressure in generalized strains vector
! Out a                :
! Out as               :
! Out c                :
! Out cs               :
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i
!
! --------------------------------------------------------------------------------------------------
!
    c(:)         = 0.d0
    cs(:)        = 0.d0
    a(:)         = 0.d0
    as(:)        = 0.d0
    c(1:dimdef)  = 1.d0
    cs(1:dimdef) = 1.d0
    a(1:2)       = 1.d0
    as(1:2)      = 1.d0
!
! - For reduced integration
!
    if (inte_type .eq. 'RED') then
        if (ds_thm%ds_elem%l_dof_meca) then
            do i = 1, ndim
                cs(addeme-1+i) = 0.d0
            end do
            do i = 1, 6
                cs(addeme-1+ndim+i) = 0.d0
            end do
        endif
        if (ds_thm%ds_elem%l_dof_pre1) then
            c(addep1) = 0.d0
            do i = 1, ndim
                cs(addep1-1+1+i) = 0.d0
            end do
        endif
        if (ds_thm%ds_elem%l_dof_pre2) then
            c(addep2) = 0.d0
            do i = 1, ndim
                cs(addep2-1+1+i) = 0.d0
            end do
        endif
        if (ds_thm%ds_elem%l_dof_ther) then
            a(2) = 0.d0
            as(1) = 0.d0
            do i = 1, ndim
                cs(addete-1+1+i) = 0.d0
            end do
        endif
    endif
!
end subroutine
