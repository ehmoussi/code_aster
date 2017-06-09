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
    subroutine cgfono(ndim, nno1, nno2, npg, wref,&
                      vff1, vff2, dffr1, geom, tang,&
                      iu, iuc, im, sigp, vect)
        integer :: npg
        integer :: nno2
        integer :: nno1
        integer :: ndim
        real(kind=8) :: wref(npg)
        real(kind=8) :: vff1(nno1, npg)
        real(kind=8) :: vff2(nno2, npg)
        real(kind=8) :: dffr1(nno1, npg)
        real(kind=8) :: geom(ndim, nno1)
        real(kind=8) :: tang(*)
        integer :: iu(3, 3)
        integer :: iuc(3)
        integer :: im(3)
        real(kind=8) :: sigp(3, npg)
        real(kind=8) :: vect(2*nno1*ndim+nno2*ndim)
    end subroutine cgfono
end interface
