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
    subroutine cgepsi(ndim, nno1, nno2, npg, wref,&
                      vff1, dffr1,geom, tang, ddl,&
                      iu,iuc,eps)
        integer :: ndim
        integer :: nno1
        integer :: nno2
        integer :: npg
        integer :: iu(3, 3)
        integer :: iuc(3)
        real(kind=8) :: vff1(nno1, npg)
        real(kind=8) :: dffr1(nno1, npg)
        real(kind=8) :: geom(ndim, nno1)
        real(kind=8) :: wref(npg)
        real(kind=8) :: tang(*)
        real(kind=8) :: eps(npg)
        real(kind=8) :: ddl(nno1*(ndim+1) + nno2)
    end subroutine cgepsi
end interface
