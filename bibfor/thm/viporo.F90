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

subroutine viporo(nbvari, vintm, vintp, advico, vicphi,&
                  phi0, deps, depsv, alphfi, dt,&
                  dp1, dp2, signe, sat, cs0,&
                  tbiot, cbiot, unsks, alpha0,&
                  phi, phim, retcom)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/THM_type.h"
!
integer, intent(in) :: nbvari
real(kind=8), intent(in) :: vintm(nbvari)
real(kind=8), intent(inout) :: vintp(nbvari)
integer, intent(in) :: advico
integer, intent(in) :: vicphi
real(kind=8), intent(in) :: phi0
real(kind=8), intent(in) :: deps(6)
real(kind=8), intent(in) :: depsv
real(kind=8), intent(in) :: alphfi
real(kind=8), intent(in) :: dt
real(kind=8), intent(in) :: dp1
real(kind=8), intent(in) :: dp2
real(kind=8), intent(in) :: signe
real(kind=8), intent(in) :: sat
real(kind=8), intent(in) :: cs0
real(kind=8), intent(in) :: tbiot(6)
real(kind=8), intent(in) :: cbiot
real(kind=8), intent(in) :: unsks
real(kind=8), intent(in) :: alpha0
real(kind=8), intent(out) :: phi
real(kind=8), intent(out) :: phim
integer, intent(out) :: retcom
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute porosity (EQ. 4.1.1-1 ; 4.1.1-2 - R7.01.11)
!
! --------------------------------------------------------------------------------------------------
!
! In  nbvari           : total number of internal state variables
! In  vintm            : internal state variables at beginning of time step
! IO  vintp            : internal state variables at end of time step
! In  advico           : index of first internal state variable for coupling law 
! In  vicphi           : index of internal state variable for porosity
! In  phi0             : initial porosity (THM_INIT)
! In  deps             : increment of mechanical strains vector
! In  depsv            : increment of mechanical volumic strain
! In  alphfi           : differential thermal expansion ratio
! In  dt               : increment of temperature
! In  dp1              : increment of first pressure
! In  dp2              : increment of second pressure
! In  signe            : sign for saturation
! In  sat              : value of saturation
! In  cs0              : initial Biot modulus of solid matrix
! In  tbiot            : tensor of Biot
! In  cbiot            : Biot coefficient (isotropic case)
! In  unsks            : inverse of bulk modulus (solid matrix)
! In  alpha0           : thermal expansion
! Out phi              : porosity at end of current time step
! Out phim             : porosity at beginning of current time step
! Out retcom           : error code 
!                         0 - everything is OK
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: varbio
    real(kind=8), parameter :: epxmax = 5.d0
    real(kind=8), parameter :: rac2 = sqrt(2.d0)
    integer :: i
!
! --------------------------------------------------------------------------------------------------
!
    varbio = 0.d0
    phi    = 0.d0
    phim   = 0.d0
    retcom = 0
!
    if (ds_thm%ds_material%biot_type .eq.  BIOT_TYPE_ISOT) then
        varbio = - depsv + 3.d0*alpha0*dt - (dp2-sat*signe*dp1)*unsks
        if (varbio .gt. epxmax) then
            retcom = 2
            goto 99
        endif
        vintp(advico+vicphi) = cbiot - phi0 - (cbiot-vintm(advico+vicphi)-phi0)*exp(varbio)
        phi  = vintp(advico+vicphi) + phi0
        phim = vintm(advico+vicphi) + phi0
    else if ((ds_thm%ds_material%biot_type .eq.  BIOT_TYPE_ISTR).or.&
             (ds_thm%ds_material%biot_type .eq.  BIOT_TYPE_ORTH)) then
        do i = 1, 3
            varbio = varbio + tbiot(i)*deps(i)
        end do
        do i = 4, 6
            varbio = varbio + tbiot(i)*deps(i)/rac2
        end do
        varbio = varbio-(&
                 vintm(advico+vicphi)-phi0)*depsv - 3.d0*alphfi*dt + cs0*(dp2-sat*signe*dp1)
        if (varbio .gt. epxmax) then
            retcom = 2
            goto 99
        endif
        vintp(advico+vicphi) = varbio + vintm(advico+vicphi)
        phi  = vintp(advico+vicphi) + phi0
        phim = vintm(advico+vicphi) + phi0
    else
        ASSERT(.false.)
    endif
!
99  continue
!
end subroutine
