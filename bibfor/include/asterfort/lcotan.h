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
    subroutine lcotan(opt, angmas, etatd, etatf, fami,&
                      kpg, ksp, loi, mod, imat,&
                      nmat, materd, materf, epsd, deps,&
                      sigd, sigf, nvi, vind, vinf,&
                      drdy, vp, vecp, theta, dt,&
                      devg, devgii, timed, timef, comp,&
                      nbcomm, cpmono, pgl, nfs, nsg,&
                      toutms, hsr, nr, itmax, toler,&
                      typma, dsde, codret)
        integer :: nsg
        integer :: nfs
        integer :: nmat
        character(len=16) :: opt
        real(kind=8) :: angmas(3)
        character(len=7) :: etatd
        character(len=7) :: etatf
        character(len=*) :: fami
        integer :: kpg
        integer :: ksp
        character(len=16) :: loi
        character(len=8) :: mod
        integer :: imat
        real(kind=8) :: materd(nmat, 2)
        real(kind=8) :: materf(nmat, 2)
        real(kind=8) :: epsd(9)
        real(kind=8) :: deps(9)
        real(kind=8) :: sigd(6)
        real(kind=8) :: sigf(6)
        integer :: nvi
        real(kind=8) :: vind(*)
        real(kind=8) :: vinf(*)
        real(kind=8) :: drdy(*)
        real(kind=8) :: vp(3)
        real(kind=8) :: vecp(3, 3)
        real(kind=8) :: theta
        real(kind=8) :: dt
        real(kind=8) :: devg(6)
        real(kind=8) :: devgii
        real(kind=8) :: timed
        real(kind=8) :: timef
        character(len=16) :: comp(*)
        integer :: nbcomm(nmat, 3)
        character(len=24) :: cpmono(5*nmat+1)
        real(kind=8) :: pgl(3, 3)
        real(kind=8) :: toutms(nfs, nsg, 6)
        real(kind=8) :: hsr(nsg, nsg)
        integer :: nr
        integer :: itmax
        real(kind=8) :: toler
        character(len=8) :: typma
        real(kind=8) :: dsde(6, *)
        integer :: codret
    end subroutine lcotan
end interface
