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
!
interface
    subroutine dpladg(yate, rho11, rho12, r, t,&
                      kh, congem, dimcon, adcp11, ndim,&
                      padp, dp11p1, dp11p2, dp21p1, dp21p2,&
                      dp11t, dp21t)
        integer :: dimcon
        integer :: yate
        real(kind=8) :: rho11
        real(kind=8) :: rho12
        real(kind=8) :: r
        real(kind=8) :: t
        real(kind=8) :: kh
        real(kind=8) :: congem(dimcon)
        integer :: adcp11
        integer :: ndim
        real(kind=8) :: padp
        real(kind=8) :: dp11p1
        real(kind=8) :: dp11p2
        real(kind=8) :: dp21p1
        real(kind=8) :: dp21p2
        real(kind=8) :: dp11t
        real(kind=8) :: dp21t
    end subroutine dpladg
end interface
