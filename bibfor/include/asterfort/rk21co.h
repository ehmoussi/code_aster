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
    subroutine rk21co(fami, kpg, ksp, rela_comp, mod,&
                      imat, matcst, nbcomm, cpmono, nfs,&
                      nsg, toutms, nvi, nmat, y,&
                      kp, ee, a, h, pgl,&
                      nbphas, cothe, coeff, dcothe, dcoeff,&
                      coel, x, pas, neps, epsd,&
                      detot, nhsr, numhsr, hsr, itmax,&
                      toler, iret)
        integer :: nhsr
        integer :: nmat
        integer :: nvi
        integer :: nsg
        character(len=*) :: fami
        integer :: kpg
        integer :: ksp
        character(len=16) :: rela_comp
        character(len=8) :: mod
        integer :: imat
        character(len=3) :: matcst
        integer :: nbcomm(nmat, 3)
        character(len=24) :: cpmono(5*nmat+1)
        integer :: nfs
        real(kind=8) :: toutms(*)
        real(kind=8) :: y(nvi)
        integer :: kp
        real(kind=8) :: ee(nvi)
        real(kind=8) :: a(nvi)
        real(kind=8) :: h
        real(kind=8) :: pgl(3, 3)
        integer :: nbphas
        real(kind=8) :: cothe(nmat)
        real(kind=8) :: coeff(nmat)
        real(kind=8) :: dcothe(nmat)
        real(kind=8) :: dcoeff(nmat)
        real(kind=8) :: coel(nmat)
        real(kind=8) :: x
        real(kind=8) :: pas
        integer :: neps
        real(kind=8) :: epsd(6)
        real(kind=8) :: detot(6)
        integer :: numhsr(*)
        real(kind=8) :: hsr(nsg, nsg, nhsr)
        integer :: itmax
        real(kind=8) :: toler
        integer :: iret
    end subroutine rk21co
end interface
