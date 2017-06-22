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

subroutine thermo_3d(kaft, temp, kafm)
! person_in_charge: etienne.grimal at edf.fr
!=====================================================================
!      provient de rsi_3d : 
!     calcul des données thermodynamiques
!=====================================================================
    implicit none
    real(kind=8) :: kaft
    real(kind=8) :: temp
    real(kind=8) :: kafm
    kaft=1d-67*dexp(0.1693d0*temp)
    kafm=8d-37*dexp(0.0526d0*temp)
end subroutine
