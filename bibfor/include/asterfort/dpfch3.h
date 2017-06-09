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
    subroutine dpfch3(nno, nnf, poids, dfrdef, dfrdnf,&
                      dfrdkf, coor, dfrdeg, dfrdng, dfrdkg,&
                      dfdx, dfdy, dfdz, jac)
        integer :: nno
        integer :: nnf
        real(kind=8) :: poids
        real(kind=8) :: dfrdef(1)
        real(kind=8) :: dfrdnf(1)
        real(kind=8) :: dfrdkf(1)
        real(kind=8) :: coor(1)
        real(kind=8) :: dfrdeg(1)
        real(kind=8) :: dfrdng(1)
        real(kind=8) :: dfrdkg(1)
        real(kind=8) :: dfdx(1)
        real(kind=8) :: dfdy(1)
        real(kind=8) :: dfdz(1)
        real(kind=8) :: jac
    end subroutine dpfch3
end interface
