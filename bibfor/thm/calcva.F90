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
! aslint: disable=W1504
! person_in_charge: sylvie.granet at edf.fr
!
subroutine calcva(kpi   , ndim  , &
                  yachai, yamec , yate   , yap1  , yap2,&
                  defgem, defgep,&
                  addeme, addep1, addep2, addete,&
                  depsv , epsv  , deps  ,&
                  t     , dt    , grat  ,&
                  p1    , dp1   , grap1 ,&
                  p2    , dp2   , grap2 ,&
                  retcom)
!
use calcul_module, only : ca_ctempr_, ca_ctempm_, ca_ctempp_
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/rcvarc.h"
#include "asterfort/tecael.h"
#include "asterfort/utmess.h"
!
    integer, intent(in) :: kpi
    integer, intent(in) :: ndim
    aster_logical, intent(out) :: yachai
    integer, intent(in) :: yamec
    integer, intent(in) :: yate
    integer, intent(in) :: yap1
    integer, intent(in) :: yap2
    real(kind=8), intent(in) :: defgem(*)
    real(kind=8), intent(in) :: defgep(*)
    integer, intent(in) :: addeme
    integer, intent(in) :: addep1
    integer, intent(in) :: addep2
    integer, intent(in) :: addete
    real(kind=8), intent(out) :: depsv
    real(kind=8), intent(out) :: epsv
    real(kind=8), intent(out) :: deps(6)
    real(kind=8), intent(out) :: t
    real(kind=8), intent(out) :: dt
    real(kind=8), intent(out) :: grat(ndim)
    real(kind=8), intent(out) :: p1
    real(kind=8), intent(out) :: dp1
    real(kind=8), intent(out) :: grap1(ndim)
    real(kind=8), intent(out) :: p2
    real(kind=8), intent(out) :: dp2
    real(kind=8), intent(out) :: grap2(ndim)
    integer, intent(out) :: retcom
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Update unknowns
!
! --------------------------------------------------------------------------------------------------
!
! In  kpi          : current Gauss point
! In  ndim         : dimension of space (2 or 3)
! Out yachai       : .true. if weak coupled (mechanic/hydraulic)
! In  yamec        : 1 if mechanic dof
! In  yate         : 1 if thermic dof
! In  yap1         : 1 if first pressure dof
! In  yap2         : 1 if second pressure dof
! In  defgem       : generalized strains - At begin of current step
! In  defgep       : generalized strains - At end of current step
! In  addeme       : index of mechanic quantities in generalized tensors
! In  addep1       : index of first hydraulic quantities in generalized tensors
! In  addep2       : index of second hydraulic quantities in generalized tensors
! In  addete       : index of thermic quantities in generalized tensors
! Out depsv        : increment of mechanic strains (deviatoric part)
! Out epsv         : increment of mechanic strains (deviatoric part) at end of current step
! Out deps         : increment of mechanic strains (deviatoric part)
! Out t            : temperature at end of current step
! Out dt           : increment of temperature
! Out grat         : gradient of temperature
! Out p1           : first pressure at end of current step
! Out dp1          : increment of first pressure
! Out grap1        : gradient of first pressure
! Out p2           : second pressure at end of current step
! Out dp2          : increment of second pressure
! Out grap2        : gradient of second pressure
! Out retcom       : 1 if error, 0 otherwise
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i, iadzi, iazk24, iret1, iret2
    character(len=8) :: nomail
    real(kind=8) :: epsvp, epsvm
!
! --------------------------------------------------------------------------------------------------
!
    retcom = 0
    yachai = .false.
!
! - Mechanic - Full coupled
!
    depsv = 0.d0
    epsv  = 0.d0
    if (yamec .eq. 1) then
        do i = 1, 6
            deps(i)=defgep(addeme+ndim-1+i)-defgem(addeme+ndim-1+i)
        end do
        do i = 1, 3
            depsv=depsv+defgep(addeme+ndim-1+i)-defgem(addeme+ndim-1+i)
        end do
        do i = 1, 3
            epsv=epsv+defgep(addeme+ndim-1+i)
        end do
    endif
!
! - Mechanic - Weak coupled
!
    yachai = ds_thm%ds_elem%l_weak_coupling
    if (yachai) then
        call rcvarc(' ', 'DIVU', '-', 'RIGI', kpi, 1, epsvm, iret1)
        call rcvarc(' ', 'DIVU', '+', 'RIGI', kpi, 1, epsvp, iret2)
        depsv = epsvp - epsvm
        epsv  = epsvp
    endif
!
! - Hydraulic
!
    p1  = ds_thm%ds_parainit%pre1_init
    dp1 = 0.d0
    p2  = ds_thm%ds_parainit%pre2_init
    dp2 = 0.d0
    if (yap1 .eq. 1) then
        p1  = defgep(addep1)+ds_thm%ds_parainit%pre1_init
        dp1 = defgep(addep1)-defgem(addep1)
        do i = 1, ndim
            grap1(i)=defgep(addep1+i)
        end do
        if (yap2 .eq. 1) then
            p2  = defgep(addep2)+ds_thm%ds_parainit%pre2_init
            dp2 = defgep(addep2)-defgem(addep2)
            do i = 1, ndim
                grap2(i)=defgep(addep2+i)
            end do
        endif
    endif
!
! - Thermic
!
    t  = ds_thm%ds_parainit%temp_init
    dt = 0.d0
    if (yate .eq. 1) then
        dt=defgep(addete)-defgem(addete)
        t =defgep(addete)+ds_thm%ds_parainit%temp_init
        do i = 1, ndim
            grat(i)=defgep(addete+i)
        end do
        if (t .le. 0.d0) then
            call tecael(iadzi, iazk24)
            nomail = zk24(iazk24-1+3) (1:8)
            call utmess('A', 'THM2_6', sk=nomail)
            retcom = 1
        endif
        ca_ctempr_ = ds_thm%ds_parainit%temp_init
        ca_ctempm_ = t-dt 
        ca_ctempp_ = t
    else
        ca_ctempr_ = 0.d0
        ca_ctempm_ = 0.d0
        ca_ctempp_ = 0.d0
    endif
!
end subroutine
