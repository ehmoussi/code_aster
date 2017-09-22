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
interface
    subroutine dplvga(ndim  , dimcon,&
                      rho11 , rho12 , rgaz  , kh,&
                      congem, adcp11, adcp12,&
                      temp  , pad   ,&
                      dp11p1, dp11p2,&
                      dp12p1, dp12p2,&
                      dp21p1, dp21p2,&
                      dp11t , dp12t , dp21t)
        integer, intent(in) :: ndim, dimcon
        real(kind=8), intent(in) :: rho11, rho12, rgaz, kh
        integer, intent(in) :: adcp11, adcp12
        real(kind=8), intent(in) :: congem(dimcon), temp, pad
        real(kind=8), intent(out) :: dp11p1, dp11p2
        real(kind=8), intent(out) :: dp12p1, dp12p2
        real(kind=8), intent(out) :: dp21p1, dp21p2
        real(kind=8), intent(out) :: dp11t, dp12t, dp21t
    end subroutine dplvga
end interface
