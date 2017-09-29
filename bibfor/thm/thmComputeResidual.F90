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
subroutine thmComputeResidual(parm_theta, gravity,&
                              ndim      ,&
                              dimdef    , dimcon ,&
                              mecani    , press1 , press2, tempe, &
                              congem    , congep ,&
                              time_incr ,&
                              r         )
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
real(kind=8), intent(out) :: r(dimdef+1)
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
! Out r                : non-linear residual vector
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
    r(1:dimdef+1) = 0.d0
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
            r(addeme+ndim+i-1) = r(addeme+ndim+i-1) + congep(adcome+i-1)
        end do
        do i = 1, 6
            r(addeme+ndim+i-1) = r(addeme+ndim-1+i) + congep(adcome+6+i-1)
        end do
        if (ds_thm%ds_elem%l_dof_pre1) then
            do i = 1, ndim
                r(addeme+i-1) = r(addeme+i-1) - gravity(i)*congep(adcp11)
            end do
            if (nbpha1 .gt. 1) then
                do i = 1, ndim
                    r(addeme+i-1) = r(addeme+i-1) - gravity(i)*congep(adcp12)
                end do
            endif
        endif
        if (ds_thm%ds_elem%l_dof_pre2) then
            do i = 1, ndim
                r(addeme+i-1) = r(addeme+i-1) - gravity(i)*congep(adcp21)
            end do
            if (nbpha2 .gt. 1) then
                do i = 1, ndim
                    r(addeme+i-1) = r(addeme+i-1) - gravity(i)*congep(adcp22)
                end do
            endif
        endif
    endif
!
! - First pressure DOF
!
    if (ds_thm%ds_elem%l_dof_pre1) then
        r(addep1) = r(addep1) - congep(adcp11) + congem(adcp11)
        if (nbpha1 .gt. 1) then
            r(addep1) = r(addep1) - congep(adcp12) + congem(adcp12)
        endif
        do i = 1, ndim
            r(addep1+i) = r(addep1+i)+&
                          time_incr*((parm_theta)*congep(adcp11+i)+&
                                     (1.d0-parm_theta)*congem(adcp11+i))
        end do
        if (nbpha1 .gt. 1) then
            do i = 1, ndim
                r(addep1+i) = r(addep1+i)+&
                              time_incr*((parm_theta)*congep(adcp12+i)+&
                                         (1.d0-parm_theta)*congem(adcp12+i))
            end do
        endif
        if (ds_thm%ds_elem%l_dof_ther) then
            r(dimdef+1) = r(dimdef+1)-&
                          (congep(adcp11)-congem(adcp11))*&
                          ((parm_theta)*congep(adcp11+ndim+1)+&
                           (1.d0-parm_theta)*congem(adcp11+ndim+1))
            if (nbpha1 .gt. 1) then
                r(dimdef+1) = r(dimdef+1)-&
                              (congep(adcp12)-congem(adcp12))*&
                              ((parm_theta)*congep(adcp12+ndim+1)+&
                               (1.d0-parm_theta)*congem(adcp12+ndim+1))
            endif
            do i = 1, ndim
                r(addete) = r(addete)+&
                            time_incr*((parm_theta)*congep(adcp11+i)+&
                                       (1.d0-parm_theta)*congem(adcp11+i))*gravity(i)
            end do
            if (nbpha1 .gt. 1) then
                do i = 1, ndim
                    r(addete) = r(addete)+&
                                time_incr*((parm_theta)*congep(adcp12+i)+&
                                           (1.d0-parm_theta)*congem(adcp12+i))*gravity(i)
                end do
            endif
            do i = 1, ndim
                r(addete+i) = r(addete+i)+&
                              time_incr*((parm_theta)*congep(adcp11+ndim+1)*congep(adcp11+i)+&
                                         (1.d0-parm_theta)*congem(adcp11+ndim+1)*congem(adcp11+i))
            end do
            if (nbpha1 .gt. 1) then
                do i = 1, ndim
                    r(addete+i) = r(addete+i)+&
                        time_incr*(parm_theta*congep(adcp12+ndim+1)*congep(adcp12+i) +&
                                  (1.d0-parm_theta)*congem(adcp12+ndim+1)*congem(adcp12+i))
                end do
            endif
        endif
    endif
!
! - Second pressure DOF
!
    if (ds_thm%ds_elem%l_dof_pre2) then
        r(addep2) = r(addep2) - congep(adcp21) + congem(adcp21)
        if (nbpha2 .gt. 1) then
            r(addep2) = r(addep2) - congep(adcp22) + congem(adcp22)
        endif
        do i = 1, ndim
            r(addep2+i) = r(addep2+i) +&
                          time_incr*((parm_theta)*congep(adcp21+i)+&
                                     (1.d0-parm_theta)*congem(adcp21+i))
        end do
        if (nbpha2 .gt. 1) then
            do i = 1, ndim
                r(addep2+i) = r(addep2+i) +&
                              time_incr*((parm_theta)*congep(adcp22+i)+&
                                         (1.d0-parm_theta)*congem(adcp22+i))
            end do
        endif
        if (ds_thm%ds_elem%l_dof_ther) then
            r(dimdef+1) = r(dimdef+1)-&
                          (congep(adcp21)-congem(adcp21))*&
                          ((parm_theta)*congep(adcp21+ndim+1)+&
                           (1.d0-parm_theta)*congem(adcp21+ndim+1))
            if (nbpha2 .gt. 1) then
                r(dimdef+1) = r(dimdef+1)-&
                              (congep(adcp22)-congem(adcp22))*&
                              ((parm_theta)*congep(adcp22+ndim+1)+&
                               (1.d0-parm_theta)*congem(adcp22+ndim+1))
            endif
            do i = 1, ndim
                r(addete) = r(addete) +&
                            time_incr*((parm_theta)*congep(adcp21+i)+&
                                       (1.d0-parm_theta)*congem(adcp21+i))*gravity(i)
            end do
            if (nbpha2 .gt. 1) then
                do i = 1, ndim
                    r(addete) = r(addete) +&
                                time_incr*((parm_theta)*congep(adcp22+i)+&
                                           (1.d0-parm_theta)*congem(adcp22+i))*gravity(i)
                end do
            endif
            do i = 1, ndim
                r(addete+i) = r(addete+i) +&
                    time_incr*((parm_theta)*congep(adcp21+ndim+1)*congep(adcp21+i) +&
                               (1.d0-parm_theta)*congem(adcp21+ndim+1)*congem(adcp21+i))
            end do
            if (nbpha2 .gt. 1) then
                do i = 1, ndim
                    r(addete+i) = r(addete+i) +&
                        time_incr*((parm_theta)*congep(adcp22+ndim+1)*congep(adcp22+i) +&
                                   (1.d0-parm_theta)*congem(adcp22+ndim+1)*congem(adcp22+i))
                end do
            endif
        endif
    endif
!
! - Thermal DOF
!
    if (ds_thm%ds_elem%l_dof_ther) then
        r(dimdef+1) = r(dimdef+1) - (congep(adcote)-congem(adcote))
        do i = 1, ndim
            r(addete+i) = r(addete+i) +&
                          time_incr*((parm_theta)*congep(adcote+i)+&
                                     (1.d0-parm_theta)*congem(adcote+i))
        end do
    endif
!
end subroutine
