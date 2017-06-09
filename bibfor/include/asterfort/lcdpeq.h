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
    subroutine lcdpeq(vind, vinf, rela_comp, nbcomm, cpmono,&
                      nmat, nvi, sig, detot, epsd,&
                      materf, pgl)
        integer :: nvi
        integer :: nmat
        real(kind=8) :: vind(nvi)
        real(kind=8) :: vinf(nvi)
        character(len=16) :: rela_comp
        integer :: nbcomm(nmat, 3)
        character(len=24) :: cpmono(5*nmat+1)
        real(kind=8) :: sig(6)
        real(kind=8) :: detot(*)
        real(kind=8) :: epsd(*)
        real(kind=8) :: materf(nmat, 2)
        real(kind=8) :: pgl(3, 3)
    end subroutine lcdpeq
end interface
