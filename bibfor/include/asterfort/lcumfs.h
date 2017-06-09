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
    subroutine lcumfs(vari, nvari, cmat, nmat, iflu,&
                      isph, tdt, hini, hfin, afps,&
                      bfps, cfps)
        integer :: nmat
        integer :: nvari
        real(kind=8) :: vari(nvari)
        real(kind=8) :: cmat(nmat)
        integer :: iflu
        integer :: isph
        real(kind=8) :: tdt
        real(kind=8) :: hini
        real(kind=8) :: hfin
        real(kind=8) :: afps
        real(kind=8) :: bfps
        real(kind=8) :: cfps
    end subroutine lcumfs
end interface
