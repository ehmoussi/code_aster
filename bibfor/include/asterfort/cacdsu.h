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
    subroutine cacdsu(maxfa, maxdim, alpha, ndim, nno,&
                      nface, geom, vol, mface, dface,&
                      xface, normfa, kdiag, yss, c,&
                      d)
        integer :: nno
        integer :: ndim
        integer :: maxdim
        integer :: maxfa
        real(kind=8) :: alpha
        integer :: nface
        real(kind=8) :: geom(ndim, nno)
        real(kind=8) :: vol
        real(kind=8) :: mface(maxfa)
        real(kind=8) :: dface(maxfa)
        real(kind=8) :: xface(maxdim, maxfa)
        real(kind=8) :: normfa(maxdim, maxfa)
        real(kind=8) :: kdiag(6)
        real(kind=8) :: yss(maxdim, maxfa, maxfa)
        real(kind=8) :: c(maxfa, maxfa)
        real(kind=8) :: d(maxfa, maxfa)
    end subroutine cacdsu
end interface
