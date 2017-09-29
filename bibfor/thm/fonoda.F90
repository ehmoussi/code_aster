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
subroutine fonoda(jv_mater, ndim  , l_steady, fnoevo,&
                  mecani  , press1, press2  , tempe ,&
                  dimdef  , dimcon, dt      , congem,&
                  r)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/thmEvalGravity.h"
!
integer, intent(in) :: jv_mater
integer, intent(in) :: ndim
aster_logical, intent(in) :: fnoevo
aster_logical, intent(in) :: l_steady
integer, intent(in) :: mecani(5), press1(7), press2(7), tempe(5)
integer, intent(in) :: dimdef, dimcon
real(kind=8), intent(in) :: dt
real(kind=8), intent(inout) :: congem(dimcon)
real(kind=8), intent(out) :: r(dimdef+1)
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute stress vector {R} 
!
! --------------------------------------------------------------------------------------------------
!
! In  jv_mater     : coded material address
! In  ndim         : dimension of element (2 ou 3)
! In  fnoevo       : .true. if compute in non-linear operator (transient terms)
! In  l_steady     : .true. for steady state
! In  mecani       : parameters for mechanic
! In  press1       : parameters for hydraulic (first pressure)
! In  press1       : parameters for hydraulic (second pressure)
! In  tempe        : parameters for thermic
! In  dimdef       : number of generalized strains
! In  dimcon       : number of generalized stresses
! In  dt           : time increment
! IO  congem       : generalized stresses at the beginning of time step
!                    => output sqrt(2) on SIG_XY, SIG_XZ, SIG_YZ
! Out r            : stress vector
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nbpha1, nbpha2
    integer :: addeme, addete, addep1, addep2
    integer :: adcome, adcote, adcp11, adcp12, adcp21, adcp22
    integer :: i_dim
    real(kind=8), parameter :: rac2 = sqrt(2.d0)
    real(kind=8) :: gravity(3)
!
! --------------------------------------------------------------------------------------------------
!
    r(1:dimdef+1) = 0.d0
!
! - Compute gravity
!
    call thmEvalGravity(jv_mater, 0.d0, gravity)
!
! - Get active physics
!
    nbpha1 = press1(2)
    nbpha2 = press2(2)
!
! - Get adresses in generalized vectors
!
    addeme = mecani(2)
    addep1 = press1(3)
    adcome = mecani(3)
    addete = tempe(2)
    adcote = tempe(3)
    addep2 = press2(3)
    if (l_steady) then
        adcp11 = press1(4) - 1
        adcp12 = press1(5) - 1
        adcp21 = press2(4) - 1
        adcp22 = press2(5) - 1
    else
        adcp11 = press1(4)
        adcp12 = press1(5)
        addep2 = press2(3)
        adcp21 = press2(4)
        adcp22 = press2(5)
    endif
!
! - Transforms stress with sqrt(2)
!
    if (ds_thm%ds_elem%l_dof_meca) then
        do i_dim = 4, 6
            congem(adcome+6+i_dim-1) = congem(adcome+6+i_dim-1)*rac2
            congem(adcome+i_dim-1)   = congem(adcome+i_dim-1)*rac2
        end do
    endif
!
! - Compute residual {R}
!
    if (ds_thm%ds_elem%l_dof_meca) then
! ----- {R} from mechanic
        do i_dim = 1, 6
            r(addeme+ndim+i_dim-1) = r(addeme+ndim+i_dim-1)+congem(adcome-1+i_dim)
        end do
        do i_dim = 1, 6
            r(addeme+ndim-1+i_dim) = r(addeme+ndim-1+i_dim)+congem(adcome+6+i_dim-1)
        end do
! ----- {R} from hydraulic (first)
        if (ds_thm%ds_elem%l_dof_pre1) then
            do i_dim = 1, ndim
                r(addeme+i_dim-1) = r(addeme+i_dim-1) - gravity(i_dim)*congem(adcp11)
            end do
            if (nbpha1 .gt. 1) then
                do i_dim = 1, ndim
                    r(addeme+i_dim-1) = r(addeme+i_dim-1)- gravity(i_dim)*congem(adcp12)
                end do
            endif
        endif
! ----- {R} from hydraulic (second)
        if (ds_thm%ds_elem%l_dof_pre2) then
            do i_dim = 1, ndim
                r(addeme+i_dim-1) = r(addeme+i_dim-1)- gravity(i_dim)*congem(adcp21)
            end do
            if (nbpha2 .gt. 1) then
                do i_dim = 1, ndim
                    r(addeme+i_dim-1) = r(addeme+i_dim-1)- gravity(i_dim)*congem(adcp22)
                end do
            endif
        endif
    endif
! - For transient terms
    if (fnoevo) then
! ----- {R(t)} from hydraulic (first)
        if (ds_thm%ds_elem%l_dof_pre1) then
            do i_dim = 1, ndim
                r(addep1+i_dim) = r(addep1+i_dim)+dt*congem(adcp11+i_dim)
            end do
            if (nbpha1 .gt. 1) then
                do i_dim = 1, ndim
                    r(addep1+i_dim) = r(addep1+i_dim)+dt*congem(adcp12+i_dim)
                end do
            endif
            if (ds_thm%ds_elem%l_dof_ther) then
                do i_dim = 1, ndim
                    r(addete) = r(addete)+dt*congem(adcp11+i_dim)*gravity(i_dim)
                end do
                if (nbpha1 .gt. 1) then
                    do i_dim = 1, ndim
                        r(addete)=r(addete) +dt*congem(adcp12+i_dim)*gravity(i_dim)
                    end do
                endif
                do i_dim = 1, ndim
                    r(addete+i_dim) = r(addete+i_dim) + &
                        dt*congem(adcp11+ndim+1)*congem(adcp11+i_dim)
                end do
                if (nbpha1 .gt. 1) then
                    do i_dim = 1, ndim
                        r(addete+i_dim) = r(addete+i_dim) + &
                            dt*congem(adcp12+ndim+1)*congem(adcp12+i_dim)
                    end do
                endif
!
            endif
        endif
! ----- {R(t)} from hydraulic (second)
        if (ds_thm%ds_elem%l_dof_pre2) then
            do i_dim = 1, ndim
                r(addep2+i_dim) = r(addep2+i_dim)+dt*congem(adcp21+i_dim)
            end do
            if (nbpha2 .gt. 1) then
                do i_dim = 1, ndim
                    r(addep2+i_dim) = r(addep2+i_dim)+dt*congem(adcp22+i_dim)
                end do
            endif
            if (ds_thm%ds_elem%l_dof_ther) then
                do i_dim = 1, ndim
                    r(addete) = r(addete)+dt*congem(adcp21+i_dim)*gravity(i_dim)
                end do
                if (nbpha2 .gt. 1) then
                    do i_dim = 1, ndim
                        r(addete) = r(addete)+dt*congem(adcp22+i_dim)*gravity(i_dim)
                    end do
                endif
                do i_dim = 1, ndim
                    r(addete+i_dim) = r(addete+i_dim) + &
                        dt*congem(adcp21+ndim+1)*congem(adcp21+i_dim)
                end do
                if (nbpha2 .gt. 1) then
                    do i_dim = 1, ndim
                        r(addete+i_dim) = r(addete+i_dim) + &
                            dt*congem(adcp22+ndim+1)*congem(adcp22+i_dim)
                    end do
                endif
            endif
        endif
! ----- {R(t)} from thermic
        if (ds_thm%ds_elem%l_dof_ther) then
            do i_dim = 1, ndim
                r(addete+i_dim) = r(addete+i_dim)+dt*congem(adcote+i_dim)
            end do
        endif
    endif
!
end subroutine
