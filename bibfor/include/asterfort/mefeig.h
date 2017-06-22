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
    subroutine mefeig(ndim, nbmod, matm, matr, mata,&
                      fre, ksi, mavr, alfr, alfi,&
                      mat1, mavi, w, z, ind)
        integer :: nbmod
        integer :: ndim(14)
        real(kind=8) :: matm(nbmod, nbmod)
        real(kind=8) :: matr(nbmod, nbmod)
        real(kind=8) :: mata(nbmod, nbmod)
        real(kind=8) :: fre(nbmod)
        real(kind=8) :: ksi(nbmod)
        real(kind=8) :: mavr(2*nbmod, 2*nbmod)
        real(kind=8) :: alfr(2*nbmod)
        real(kind=8) :: alfi(2*nbmod)
        real(kind=8) :: mat1(2*nbmod, 2*nbmod)
        real(kind=8) :: mavi(2*nbmod, 2*nbmod)
        real(kind=8) :: w(4*nbmod)
        real(kind=8) :: z(4*nbmod, 2*nbmod)
        integer :: ind(2*nbmod)
    end subroutine mefeig
end interface
