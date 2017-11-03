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

subroutine satfvg(sr   , pr    , n, m, pc,&
                  satur, dsatur)
!
!
implicit none
!
    real(kind=8), intent(in) :: sr, pr, n, m, pc
    real(kind=8), intent(out) :: satur, dsatur
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute saturation for VAN-GENUCHTEN model when capillary pressure is greater than maximum
!
! --------------------------------------------------------------------------------------------------
!
! In  sr           : parameter SR
! In  pr           : parameter P
! In  m            : parameter M (with M=1-1/N)
! In  n            : parameter N
! In  pc           : capillary pressure
! Out satur        : saturation
! Out dsatur       : derivative of saturation (/pc)
!
! --------------------------------------------------------------------------------------------------
!
    satur  = sr+(1-sr)*((pc/pr)**n+1.d0)**(-m)
    dsatur = -n*m*((1.d0-sr)/pr)*(((pc/pr)**n+1.d0)**(-m-1.d0))*&
            ((pc/pr)**(n-1.d0))
end subroutine
