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
subroutine visatu(nbvari, vintp, advico, vicsat, satur)
!
use THM_type
use THM_module
!
implicit none
!
integer, intent(in) :: nbvari
real(kind=8), intent(inout) :: vintp(nbvari)
integer, intent(in) :: advico
integer, intent(in) :: vicsat
real(kind=8), intent(in) :: satur
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Save saturation in internal state variables
!
! --------------------------------------------------------------------------------------------------
!
! In  nbvari           : total number of internal state variables
! IO  vintp            : internal state variables at end of time step
! In  advico           : index of first internal state variable for coupling law 
! In  vicsat           : index of internal state variable for saturation
! In  satur            : value of saturation
!
! --------------------------------------------------------------------------------------------------
!
    vintp(advico+vicsat) = satur
!
end subroutine
