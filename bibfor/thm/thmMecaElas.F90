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
subroutine thmMecaElas(yate  , option, angl_naut, dtemp,&
                       adcome, dimcon,&
                       deps  , congep, dsdeme, ther_meca)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/thmTherElas.h"
!
integer, intent(in) :: yate
character(len=16), intent(in) :: option
real(kind=8), intent(in) :: dtemp
integer, intent(in) :: dimcon, adcome
real(kind=8), intent(in) :: angl_naut(3)
real(kind=8), intent(in) :: deps(6)
real(kind=8), intent(inout) :: congep(dimcon)
real(kind=8), intent(inout) :: dsdeme(6,6)
real(kind=8), intent(out) :: ther_meca(6)
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute elasticity
!
! --------------------------------------------------------------------------------------------------
!
! In  yate             : 1 if thermic dof
! In  option           : option to compute
! In  typmod           : type of modelization (TYPMOD2)
! In  angl_naut        : nautical angles
!                        (1) Alpha - clockwise around Z0
!                        (2) Beta  - counterclockwise around Y1
!                        (3) Gamma - clockwise around X
! In  dtemp            : increment of temperature
! In  adcome           : adress of mechanic stress in generalized stresses vector
! In  dimcon           : dimension of generalized stresses vector
! In  deps             : increment of mechanic strains
! IO  congep           : generalized stresses - At end of current step
! Out dsdeme           : derivative of sigma/stress for mechanics
! Out ther_elas        : product [Elas] {alpha}
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i, j
    real(kind=8) :: depstr(6), ther_dila
    aster_logical :: l_matrix, l_stress
    real(kind=8), parameter :: rac2 = sqrt(2.d0)
!
! --------------------------------------------------------------------------------------------------
!
    dsdeme(:,:)    = 0.d0
    ther_dila      = 0.d0
    depstr(:)      = 0.d0
    ther_meca(:)   = 0.d0
    l_matrix       = (option(1:9).eq.'RIGI_MECA') .or. (option(1:9) .eq.'FULL_MECA')
    l_stress       = (option(1:9).eq.'RAPH_MECA') .or. (option(1:9) .eq.'FULL_MECA')
!
! - Prepare strains and stresses

    depstr = deps
    do i = 4, 6
        depstr(i)          = deps(i)*rac2
        congep(adcome+i-1) = congep(adcome+i-1)/rac2
    end do
!
! - Compute thermic quantities
!
    call thmTherElas(angl_naut, ther_meca, ther_dila)
!
! - Compute matrix
!
    if (l_matrix) then
        do i = 1, 3
            do j = 1, 3
                dsdeme(i,j) = ds_thm%ds_material%elas%d(i,j)
            end do
            do j = 4, 6
                dsdeme(i,j) = ds_thm%ds_material%elas%d(i,j)/(0.5*rac2)
            end do
        end do
        do i = 4, 6
            do j = 1, 3
                dsdeme(i,j) = ds_thm%ds_material%elas%d(i,j)*rac2
            end do
            do j = 4, 6
                dsdeme(i,j) = ds_thm%ds_material%elas%d(i,j)*2.d0
            end do
        end do
    endif
!
! - Compute stress
!
    if (l_stress) then
        do i = 1, 6
            do j = 1, 6
                congep(adcome+i-1) = congep(adcome+i-1) + &
                                     ds_thm%ds_material%elas%d(i,j)*depstr(j)
            end do
        end do
    endif
!
    do i = 4, 6
        congep(adcome+i-1) = congep(adcome+i-1)*rac2
    end do
!
! - For thermic (dilatation)
!
    if (yate .eq. 1) then
        if (l_stress) then
            do i = 1, 6
                congep(adcome+i-1) = congep(adcome+i-1)-ther_meca(i)*dtemp
            end do
        endif
    endif
!
end subroutine
