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
subroutine fnoesu(nface ,&
                  dimcon, dimuel,&
                  press1, press2,&
                  congem, vectu )
!
implicit none
!
integer, parameter :: maxfa = 6
integer, intent(in) :: nface
integer, intent(in) :: dimcon, dimuel
integer, intent(in) :: press1(7), press2(7)
real(kind=8), intent(in) :: congem(dimcon, maxfa+1)
real(kind=8), intent(inout) :: vectu(dimuel)
!
! --------------------------------------------------------------------------------------------------
!
! THM - Compute (finite volume)
!
! Compute FORC_NODA
!
! --------------------------------------------------------------------------------------------------
!
! In  dimcon           : dimension of generalized stresses vector
! In  dimuel           : number of dof for element
! In  press1           : parameters for hydraulic (capillary pressure)
! In  press2           : parameters for hydraulic (gaz pressure)
! In  congem           : generalized stresses - At begin of current step
! IO  vectu            : non-linear forces
!
! --------------------------------------------------------------------------------------------------
!
    integer :: adcp11, adcp12, adcp21, adcp22
    real(kind=8) :: sfluw, sfluvp, sfluas, sfluad
    integer :: ifa
    integer :: adcm1, adcm2
!
#define adcf1(fa) 2*(fa-1)+1
#define adcf2(fa) 2*(fa-1)+2
!
! --------------------------------------------------------------------------------------------------
!
    adcm1 = 2*nface+1
    adcm2 = 2*nface+2
!
! - Get address in generalized stress vector
!
    adcp11 = press1(4)
    adcp12 = press1(5)
    adcp21 = press2(4)
    adcp22 = press2(5)
!
! - Compute flux
!
    do ifa = 1, nface
        vectu(adcf1(ifa)) = congem(adcp11+1,ifa+1)
        vectu(adcf2(ifa)) = congem(adcp12+1,ifa+1)
    end do
    sfluw        = congem(adcp11+1,1)
    sfluvp       = congem(adcp12+1,1)
    sfluas       = congem(adcp21+1,1)
    sfluad       = congem(adcp22+1,1)
    vectu(adcm1) = sfluw+sfluvp
    vectu(adcm2) = sfluas+sfluad
!
end subroutine
