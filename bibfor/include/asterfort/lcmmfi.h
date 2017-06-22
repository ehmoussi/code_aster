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
    subroutine lcmmfi(coeft, ifa, nmat, nbcomm, necris,&
                      is, nbsys, vind, nsfv, dy,&
                      nfs, nsg, hsr, iexp, expbp,&
                      rp)
        integer :: nsg
        integer :: nmat
        real(kind=8) :: coeft(nmat)
        integer :: ifa
        integer :: nbcomm(nmat, 3)
        character(len=16) :: necris
        integer :: is
        integer :: nbsys
        real(kind=8) :: vind(*)
        integer :: nsfv
        real(kind=8) :: dy(*)
        integer :: nfs
        real(kind=8) :: hsr(nsg, nsg)
        integer :: iexp
        real(kind=8) :: expbp(*)
        real(kind=8) :: rp
    end subroutine lcmmfi
end interface
