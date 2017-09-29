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
! person_in_charge: sylvie.granet at edf.fr
!
subroutine thmComputeMatrix(parm_theta, gravity,&
                            ndim      ,&
                            dimdef    , dimcon ,&
                            mecani    , press1 , press2, tempe,&
                            congem    , congep ,&
                            time_incr ,&
                            drds      )
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
!
real(kind=8), intent(in)  :: parm_theta, gravity(3)
integer, intent(in) :: ndim
integer, intent(in) :: dimdef, dimcon
integer, intent(in) :: mecani(5), press1(7), press2(7), tempe(5)
real(kind=8), intent(in) :: congem(dimcon), congep(dimcon)
real(kind=8), intent(in) :: time_incr
real(kind=8), intent(out) :: drds(dimdef+1, dimcon)
!
! --------------------------------------------------------------------------------------------------
!
! THM - Compute
!
! Compute non-linear residual - Unsteady version
!
! --------------------------------------------------------------------------------------------------
!
! In  parm_theta       : parameter PARM_THETA
! In  gravity          : gravity
! In  ndim             : dimension of space (2 or 3)
! In  dimdef           : dimension of generalized strains vector
! In  dimcon           : dimension of generalized stresses vector
! In  mecani           : parameters for mechanic
! In  press1           : parameters for hydraulic (capillary pressure)
! In  press2           : parameters for hydraulic (gaz pressure)
! In  tempe            : parameters for thermic
! In  congem           : generalized stresses - At begin of current step
! In  congep           : generalized stresses - At end of current step
! In  time_incr        : time increment
! Out drds             : derivative matrix (residual/stress)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i
    integer :: nbpha1, nbpha2
    integer :: addeme, addete, addep1, addep2
    integer :: adcome, adcote, adcp11, adcp12, adcp21, adcp22
!
! --------------------------------------------------------------------------------------------------
!
    drds(1:dimdef+1,1:dimcon) = 0.d0
!
! - Address in generalized strains vector
!
    addeme = mecani(2)
    addete = tempe(2)
    addep1 = press1(3)
    addep2 = press2(3)
!
! - Address in generalized stresses vector
!
    adcome = mecani(3)
    adcote = tempe(3)
    adcp11 = press1(4)
    adcp12 = press1(5)
    adcp21 = press2(4)
    adcp22 = press2(5)
!
! - Number of phases
!
    nbpha1 = press1(2)
    nbpha2 = press2(2)
!
! - Mechanical DOF
!
    if (ds_thm%ds_elem%l_dof_meca) then
        do i = 1, 6
            drds(addeme+ndim-1+i,adcome+i-1) = drds(addeme+ndim-1+i,adcome+i-1)+1.d0
        end do
        do i = 1, 6
            drds(addeme+ndim-1+i,adcome+6+i-1) = drds(addeme+ndim-1+i,adcome+6+i-1)+1.d0
        end do
    endif
!
! - First pressure DOF
!
    if (ds_thm%ds_elem%l_dof_pre1) then
        if (ds_thm%ds_elem%l_dof_meca) then
            do i = 1, ndim
                drds(addeme+i-1,adcp11) = drds(addeme+i-1,adcp11) - gravity(i)
            end do
        endif
        drds(addep1,adcp11) = drds(addep1,adcp11)-1.d0
        do i = 1, ndim
            drds(addep1+i,adcp11+i) = drds(addep1+i,adcp11+i) + parm_theta*time_incr
        end do
        if (nbpha1 .gt. 1) then
            if (ds_thm%ds_elem%l_dof_meca) then
                do i = 1, ndim
                    drds(addeme+i-1,adcp12) = drds(addeme+i-1,adcp12) - gravity(i)
                end do
            endif
            drds(addep1,adcp12) = drds(addep1,adcp12)-1.d0
            do i = 1, ndim
                drds(addep1+i,adcp12+i) = drds(addep1+i,adcp12+i) + parm_theta*time_incr
            end do
        endif
    endif
!
! - Second pressure DOF
!
    if (ds_thm%ds_elem%l_dof_pre2) then
        if (ds_thm%ds_elem%l_dof_meca) then
            do i = 1, ndim
                drds(addeme+i-1,adcp21) = drds(addeme+i-1,adcp21) - gravity(i)
            end do
        endif
        drds(addep2,adcp21) = drds(addep2,adcp21)-1.d0
        do i = 1, ndim
            drds(addep2+i,adcp21+i) = drds(addep2+i,adcp21+i) + parm_theta*time_incr
        end do
        if (nbpha2 .gt. 1) then
            if (ds_thm%ds_elem%l_dof_meca) then
                do i = 1, ndim
                    drds(addeme+i-1,adcp22) = drds(addeme+i-1,adcp22)-gravity(i)
                end do
            endif
            drds(addep2,adcp22) = drds(addep2,adcp22)-1.d0
            do i = 1, ndim
                drds(addep2+i,adcp22+i) = drds(addep2+i,adcp22+i) + parm_theta*time_incr
            end do
        endif
    endif
!
! - Thermal DOF
!
    if (ds_thm%ds_elem%l_dof_ther) then
        drds(dimdef+1,adcote) = drds(dimdef+1,adcote)-1.d0
        do i = 1, ndim
            drds(addete+i,adcote+i) = drds(addete+i,adcote+i) + parm_theta*time_incr
        end do
        if (ds_thm%ds_elem%l_dof_pre1) then
            drds(dimdef+1,adcp11) = drds(dimdef+1,adcp11) -&
                                    ((parm_theta)*congep(adcp11+ndim+1)+&
                                     (1.d0-parm_theta)*congem(adcp11+ndim+1))
            drds(dimdef+1,adcp11+ndim+1) = drds(dimdef+1,adcp11+ndim+1) -&
                                           parm_theta*(congep(adcp11)-congem(adcp11))
            do i = 1, ndim
                drds(addete,adcp11+i) = drds(addete,adcp11+i)+&
                                        parm_theta*time_incr*gravity(i)
            end do
            do i = 1, ndim
                drds(addete+i,adcp11+ndim+1) = drds(addete+i,adcp11+ndim+1)+&
                                               parm_theta*time_incr*congep(adcp11+i)
            end do
            do i = 1, ndim
                drds(addete+i,adcp11+i) = drds(addete+i,adcp11+i)+&
                                          parm_theta*time_incr*congep(adcp11+ndim+1)
            end do
            if (nbpha1 .gt. 1) then
                drds(dimdef+1,adcp12)        = drds(dimdef+1,adcp12)-&
                    ((parm_theta)*congep(adcp12+ndim+1)+&
                     (1.d0-parm_theta)*congem(adcp12+ndim+1))
                drds(dimdef+1,adcp12+ndim+1) = drds(dimdef+1,adcp12+ndim+1)-&
                                               parm_theta*(congep(adcp12)-congem(adcp12))
                do i = 1, ndim
                    drds(addete,adcp12+i)    = drds(addete,adcp12+i)+&
                                               parm_theta*time_incr*gravity(i)
                end do
                do i = 1, ndim
                    drds(addete+i,adcp12+ndim+1) = drds(addete+i,adcp12+ndim+1)+&
                                                   parm_theta*time_incr*congep(adcp12+i)
                end do
                do i = 1, ndim
                    drds(addete+i,adcp12+i)  = drds(addete+i,adcp12+i)+&
                                               parm_theta*time_incr*congep(adcp12+ndim+1)
                end do
            endif
        endif
        if (ds_thm%ds_elem%l_dof_pre2) then
            drds(dimdef+1,adcp21) = drds(dimdef+1,adcp21) -&
                ((parm_theta)*congep(adcp21+ndim+1)+&
                 (1.d0-parm_theta)*congem(adcp21+ndim+1))
            drds(dimdef+1,adcp21+ndim+1) = drds(dimdef+1,adcp21+ndim+1)-&
                 parm_theta*(congep(adcp21)-congem(adcp21))
            do i = 1, ndim
                drds(addete,adcp21+i) = drds(addete,adcp21+i) + parm_theta*time_incr*gravity(i)
            end do
            do i = 1, ndim
                drds(addete+i,adcp21+ndim+1) = drds(addete+i,adcp21+ndim+1) +&
                                               parm_theta*time_incr*congep(adcp21+i)
            end do
            do i = 1, ndim
                drds(addete+i,adcp21+i) = drds(addete+i,adcp21+i)+&
                                          parm_theta*time_incr*congep(adcp21+ndim+1)
            end do
            if (nbpha2 .gt. 1) then
                drds(dimdef+1,adcp22) = drds(dimdef+1,adcp22)-&
                                        ((parm_theta)*congep(adcp22+ndim+1)+&
                                         (1.d0-parm_theta)*congem(adcp22+ndim+1))
                drds(dimdef+1,adcp22+ndim+1) = drds(dimdef+1,adcp22+ndim+1)-&
                                               parm_theta*(congep(adcp22)-congem(adcp22))
                do i = 1, ndim
                    drds(addete,adcp22+i) = drds(addete,adcp22+i)+&
                                            parm_theta*time_incr*gravity(i)
                end do
                do i = 1, ndim
                    drds(addete+i,adcp22+ndim+1) = drds(addete+i,adcp22+ndim+1)+&
                                                   parm_theta*time_incr*congep(adcp22+i)
                end do
                do i = 1, ndim
                    drds(addete+i,adcp22+i) = drds(addete+i,adcp22+i)+&
                                              parm_theta*time_incr*congep(adcp22+ndim+1)
                end do
            endif
        endif
    endif
!
end subroutine
