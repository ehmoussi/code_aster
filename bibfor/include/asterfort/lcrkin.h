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
    subroutine lcrkin(ndim, opt, rela_comp, materf, nbcomm,&
                      cpmono, nmat, mod, nvi, sigd,&
                      sigf, vind, vinf, nbphas, iret)
        integer :: nmat
        integer :: ndim
        character(len=16) :: opt
        character(len=16) :: rela_comp
        real(kind=8) :: materf(nmat, 2)
        integer :: nbcomm(nmat, 3)
        character(len=24) :: cpmono(5*nmat+1)
        character(len=8) :: mod
        integer :: nvi
        real(kind=8) :: sigd(*)
        real(kind=8) :: sigf(*)
        real(kind=8) :: vind(*)
        real(kind=8) :: vinf(*)
        integer :: nbphas
        integer :: iret
    end subroutine lcrkin
end interface
