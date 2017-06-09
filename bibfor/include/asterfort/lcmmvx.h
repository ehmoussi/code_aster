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
    subroutine lcmmvx(sigf, vin, nmat, materf, nbcomm,&
                      cpmono, pgl, nvi, hsr, nfs,&
                      nsg, toutms, timed, timef, deps,&
                      seuil)
        integer :: nsg
        integer :: nfs
        integer :: nvi
        integer :: nmat
        real(kind=8) :: sigf(6)
        real(kind=8) :: vin(nvi)
        real(kind=8) :: materf(nmat*2)
        integer :: nbcomm(nmat, 3)
        character(len=24) :: cpmono(5*nmat+1)
        real(kind=8) :: pgl(3, 3)
        real(kind=8) :: hsr(nsg, nsg)
        real(kind=8) :: toutms(nfs, nsg, 6)
        real(kind=8) :: timed
        real(kind=8) :: timef
        real(kind=8) :: deps(6)
        real(kind=8) :: seuil
    end subroutine lcmmvx
end interface
