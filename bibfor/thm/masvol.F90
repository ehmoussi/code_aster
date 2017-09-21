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
function masvol(mamol, pres, rgaz, temp)
!
implicit none
!
real(kind=8), intent(in) :: mamol, pres, rgaz, temp
real(kind=8) :: masvol
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute volumic mass of gaz
!
! --------------------------------------------------------------------------------------------------
!
! In  mamol            : molar mass of gaz
! In  pres             : pressure of gaz
! In  rgaz             : perfect gaz constant
! In  temp             : temperature
! Out masvol           : volumic mass of gaz
!
! --------------------------------------------------------------------------------------------------
!
    masvol = mamol * pres / rgaz / temp
!
end function
