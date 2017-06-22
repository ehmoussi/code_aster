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
    subroutine pipdef(ndim, nno, kpg, ipoids, ivf,&
                      idfde, geom, typmod, compor, deplm,&
                      ddepl, depl0, depl1, dfdi, fm,&
                      epsm, epsp, epsd)
        integer :: ndim
        integer :: nno
        integer :: kpg
        integer :: ipoids
        integer :: ivf
        integer :: idfde
        real(kind=8) :: geom(ndim, *)
        character(len=8) :: typmod(*)
        character(len=16) :: compor(*)
        real(kind=8) :: deplm(*)
        real(kind=8) :: ddepl(*)
        real(kind=8) :: depl0(*)
        real(kind=8) :: depl1(*)
        real(kind=8) :: dfdi(*)
        real(kind=8) :: fm(3, 3)
        real(kind=8) :: epsm(6)
        real(kind=8) :: epsp(6)
        real(kind=8) :: epsd(6)
    end subroutine pipdef
end interface
