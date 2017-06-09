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
    subroutine lcmmjd(taur, materf, ifa, nmat, nbcomm,&
                      dt, ir, is, nbsys, nfs,&
                      nsg, hsr, vind, dy, dpdtau,&
                      dprdas, dhrdas, hr, dpr, sgnr,&
                      iret)
        integer :: nsg
        integer :: nmat
        real(kind=8) :: taur
        real(kind=8) :: materf(nmat*2)
        integer :: ifa
        integer :: nbcomm(nmat, 3)
        real(kind=8) :: dt
        integer :: ir
        integer :: is
        integer :: nbsys
        integer :: nfs
        real(kind=8) :: hsr(nsg, nsg)
        real(kind=8) :: vind(36)
        real(kind=8) :: dy(12)
        real(kind=8) :: dpdtau
        real(kind=8) :: dprdas
        real(kind=8) :: dhrdas
        real(kind=8) :: hr
        real(kind=8) :: dpr
        real(kind=8) :: sgnr
        integer :: iret
    end subroutine lcmmjd
end interface
