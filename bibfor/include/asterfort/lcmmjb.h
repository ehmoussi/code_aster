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
    subroutine lcmmjb(taur, materf, cpmono, ifa, nmat,&
                      nbcomm, dt, nuecou, nsfv, nsfa,&
                      ir, is, nbsys, nfs, nsg,&
                      hsr, vind, dy, iexp, expbp,&
                      itmax, toler, dgsdts, dksdts, dgrdbs,&
                      dkrdbs, iret)
        integer :: nsg
        integer :: nmat
        real(kind=8) :: taur
        real(kind=8) :: materf(nmat*2)
        character(len=24) :: cpmono(5*nmat+1)
        integer :: ifa
        integer :: nbcomm(nmat, 3)
        real(kind=8) :: dt
        integer :: nuecou
        integer :: nsfv
        integer :: nsfa
        integer :: ir
        integer :: is
        integer :: nbsys
        integer :: nfs
        real(kind=8) :: hsr(nsg, nsg)
        real(kind=8) :: vind(*)
        real(kind=8) :: dy(*)
        integer :: iexp
        real(kind=8) :: expbp(nsg)
        integer :: itmax
        real(kind=8) :: toler
        real(kind=8) :: dgsdts
        real(kind=8) :: dksdts
        real(kind=8) :: dgrdbs
        real(kind=8) :: dkrdbs
        integer :: iret
    end subroutine lcmmjb
end interface
