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
    subroutine lcmmon(fami, kpg, ksp, rela_comp, nbcomm,&
                      cpmono, nmat, nvi, vini, x,&
                      dtime, pgl, mod, coeft, neps,&
                      epsd, detot, coel, dvin, nfs,&
                      nsg, toutms, hsr, itmax, toler,&
                      iret)
        integer :: nsg
        integer :: nfs
        integer :: neps
        integer :: nmat
        character(len=*) :: fami
        integer :: kpg
        integer :: ksp
        character(len=16) :: rela_comp
        integer :: nbcomm(nmat, 3)
        character(len=24) :: cpmono(5*nmat+1)
        integer :: nvi
        real(kind=8) :: vini(*)
        real(kind=8) :: x
        real(kind=8) :: dtime
        real(kind=8) :: pgl(3, 3)
        character(len=8) :: mod
        real(kind=8) :: coeft(nmat)
        real(kind=8) :: epsd(neps)
        real(kind=8) :: detot(neps)
        real(kind=8) :: coel(nmat)
        real(kind=8) :: dvin(*)
        real(kind=8) :: toutms(nfs, nsg, 6)
        real(kind=8) :: hsr(nsg, nsg, 1)
        integer :: itmax
        real(kind=8) :: toler
        integer :: iret
    end subroutine lcmmon
end interface
