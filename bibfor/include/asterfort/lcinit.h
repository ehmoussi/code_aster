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
#include "asterf_types.h"
!
interface
    subroutine lcinit(fami, kpg, ksp, loi, typess,&
                      essai, mod, nmat, materd, materf,&
                      timed, timef, intg, nr, nvi,&
                      yd, epsd, deps, dy, comp,&
                      nbcomm, cpmono, pgl, nfs, nsg,&
                      toutms, vind, sigd, sigf, epstr,&
                      bnews, mtrac, indi, iret)
        integer :: nsg
        integer :: nfs
        integer :: nmat
        character(len=*) :: fami
        integer :: kpg
        integer :: ksp
        character(len=16) :: loi
        integer :: typess
        real(kind=8) :: essai
        character(len=8) :: mod
        real(kind=8) :: materd(nmat, 2)
        real(kind=8) :: materf(nmat, 2)
        real(kind=8) :: timed
        real(kind=8) :: timef
        integer :: intg
        integer :: nr
        integer :: nvi
        real(kind=8) :: yd(*)
        real(kind=8) :: epsd(6)
        real(kind=8) :: deps(6)
        real(kind=8) :: dy(*)
        character(len=16) :: comp(*)
        integer :: nbcomm(nmat, 3)
        character(len=24) :: cpmono(5*nmat+1)
        real(kind=8) :: pgl(3, 3)
        real(kind=8) :: toutms(nfs, nsg, 6)
        real(kind=8) :: vind(*)
        real(kind=8) :: sigd(6)
        real(kind=8) :: sigf(6)
        real(kind=8) :: epstr(6)
        aster_logical :: bnews(3)
        aster_logical :: mtrac
        integer :: indi(7)
        integer :: iret
    end subroutine lcinit
end interface
