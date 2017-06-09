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
    subroutine lcmmjp(mod, nmat, mater, timed, timef,&
                      comp, nbcomm, cpmono, pgl, nfs,&
                      nsg, toutms, hsr, nr, nvi, sigd,&
                      itmax, toler, vinf, vind, dsde,&
                      drdy, option, iret)
        common/tdim/ ndt,ndi
        integer :: ndt
        integer :: ndi
        integer :: nr
        integer :: nsg
        integer :: nfs
        integer :: nmat
        character(len=8) :: mod
        real(kind=8) :: mater(*)
        real(kind=8) :: timed
        real(kind=8) :: timef
        character(len=16) :: comp(*)
        integer :: nbcomm(nmat, 3)
        character(len=24) :: cpmono(5*nmat+1)
        real(kind=8) :: pgl(3, 3)
        real(kind=8) :: toutms(nfs, nsg, 6)
        real(kind=8) :: hsr(nsg, nsg)
        integer :: nvi
        integer :: itmax
        real(kind=8) :: toler
        real(kind=8) :: sigd(6)        
        real(kind=8) :: vinf(*)
        real(kind=8) :: vind(*)
        real(kind=8) :: dsde(6, *)
        real(kind=8) :: drdy(nr, nr)
        character(len=16) :: option
        integer :: iret
    end subroutine lcmmjp
end interface
