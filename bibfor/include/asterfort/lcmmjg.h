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
    subroutine lcmmjg(nmat, nbcomm, cpmono, hsr,&
                      dt, nvi, vind, yd, dy,&
                      itmax, toler, materf, sigf, fkooh,&
                      nfs, nsg, toutms, pgl, msnst,&
                      gamsns, dfpdga, iret)
        integer :: nsg
        integer :: nfs
        integer :: nmat
        integer :: nbcomm(nmat, 3)
        character(len=24) :: cpmono(5*nmat+1)
        real(kind=8) :: hsr(nsg, nsg)
        real(kind=8) :: dt
        integer :: nvi
        real(kind=8) :: vind(*)
        real(kind=8) :: yd(*)
        real(kind=8) :: dy(*)
        integer :: itmax
        real(kind=8) :: toler
        real(kind=8) :: materf(nmat*2)
        real(kind=8) :: sigf(6)
        real(kind=8) :: fkooh(6, 6)
        real(kind=8) :: toutms(nfs, nsg, 6)
        real(kind=8) :: pgl(3, 3)
        real(kind=8) :: msnst(3, 3, nsg)
        real(kind=8) :: gamsns(3, 3)
        real(kind=8) :: dfpdga(3, 3, nsg)
        integer :: iret
    end subroutine lcmmjg
end interface
