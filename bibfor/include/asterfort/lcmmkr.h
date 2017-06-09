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
    subroutine lcmmkr(taus, coeft, cisa2, ifa, nmat,&
                      nbcomm, is, nbsys, nfs, nsg,&
                      hsr, vind, dy, dt, dalpha,&
                      dgamma, dp, crit, sgns, iret)
        integer :: nsg
        integer :: nmat
        real(kind=8) :: taus
        real(kind=8) :: coeft(nmat)
        real(kind=8) :: cisa2
        integer :: ifa
        integer :: nbcomm(nmat, 3)
        integer :: is
        integer :: nbsys
        integer :: nfs
        real(kind=8) :: hsr(nsg, nsg)
        real(kind=8) :: vind(*)
        real(kind=8) :: dy(*)
        real(kind=8) :: dt
        real(kind=8) :: dalpha
        real(kind=8) :: dgamma
        real(kind=8) :: dp
        real(kind=8) :: crit
        real(kind=8) :: sgns
        integer :: iret
    end subroutine lcmmkr
end interface
