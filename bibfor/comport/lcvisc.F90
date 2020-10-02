! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

subroutine lcvisc(fami, kpg, ksp, ndim, imate,&
                      instam, instap, deps, vim, option, &
                      sigp, vip, dsidep)
                      
    implicit none
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/rcvalb.h"
    
    character(len=*),intent(in) :: fami
    integer,intent(in)          :: kpg
    integer,intent(in)          :: ksp
    integer,intent(in)          :: ndim
    integer,intent(in)          :: imate
    real(kind=8),intent(in)     :: instam
    real(kind=8),intent(in)     :: instap
    real(kind=8),intent(in)     :: deps(:)
    real(kind=8),intent(in)     :: vim(:)
    character(len=16),intent(in):: option
    real(kind=8),intent(inout)  :: sigp(:)
    real(kind=8),intent(out)    :: vip(:)
    real(kind=8),intent(inout)  :: dsidep(:,:)
! ----------------------------------------------------------------------
    real(kind=8),parameter             :: rac2 = sqrt(2.d0)
    real(kind=8),dimension(6),parameter:: r2=[1.d0,1.d0,1.d0,rac2,rac2,rac2]
! ----------------------------------------------------------------------
    aster_logical:: resi,rigi
    integer      :: nd,i, iok(2)
    real(kind=8) :: k,tau,dt,a,b
    real(kind=8) :: sivm(2*ndim),siv(2*ndim),sivi(2*ndim),enerElas, incrEnerDiss
    real(kind=8) :: valev(2)
    character(len=16):: nomev(2)
! ----------------------------------------------------------------------
    data nomev /'K','TAU'/
! ----------------------------------------------------------------------

!   Controles
    ASSERT(size(vim).eq.8)
    ASSERT(size(vip).eq.8)
    ASSERT(size(deps).eq.2*ndim)
    ASSERT(size(sigp).eq.2*ndim)
    ASSERT(size(dsidep,1).eq. 2*ndim)
    ASSERT(size(dsidep,2).eq. 2*ndim)
    
!   Initialisation
    nd   = 2*ndim
    dt   = instap - instam
    sivm = vim(1:nd)*r2(1:nd)
    resi = option(1:4).eq.'FULL' .or. option(1:4).eq.'RAPH'
    rigi = option(1:4).eq.'RIGI' .or. option(1:4).eq.'FULL'


!   Viscous parameters
    call rcvalb(fami,kpg,ksp,'+',imate,' ','VISC_ELAS',0,' ',[0.d0],2,nomev,valev,iok,2)
    k   = valev(1)
    tau = valev(2)
    
    
!   Integration scheme parameters
    a = exp(-dt/tau)
    b = k*tau/dt*(1-a)
    
    
!   Viscous stress update
    siv = a*sivm + b*deps
    
!   Post-treatment
    sivi         = 0.5d0*(sivm+siv)
    enerElas     = dot_product(siv,siv)/(2*k)
    incrEnerDiss = dot_product(sivi,sivi)/(k*tau)*dt
    
!   Storage
    if (resi) then
        sigp      = sigp + siv
        vip(1:6)  = 0
        vip(1:nd) = siv/r2(1:nd)
        vip(7)    = enerElas
        vip(8)    = vim(8) + incrEnerDiss
    end if
    
    if (rigi) then
        do i =1,nd
            dsidep(i,i) = dsidep(i,i) + b
        end do
    end if

end subroutine
