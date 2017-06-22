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
    subroutine mefrep(nbz, nbmod, nbcyl, nbgrp, numgrp,&
                      z, freq0, rho, visc, rint,&
                      phix, phiy, dcent, matma)
        integer :: nbz
        integer :: nbmod
        integer :: nbcyl
        integer :: nbgrp
        integer :: numgrp(*)
        real(kind=8) :: z(*)
        real(kind=8) :: freq0(*)
        real(kind=8) :: rho(*)
        real(kind=8) :: visc(*)
        real(kind=8) :: rint(*)
        real(kind=8) :: phix(*)
        real(kind=8) :: phiy(*)
        real(kind=8) :: dcent(*)
        real(kind=8) :: matma(*)
    end subroutine mefrep
end interface
