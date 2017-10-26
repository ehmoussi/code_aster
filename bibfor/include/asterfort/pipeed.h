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
    subroutine pipeed(nno, npg, ipoids, ivf, idfde,&
                      geom, typmod, mate, lgpg, deplm,&
                      vim, ddepl, ddepl0, ddepl1,&
                      dtau, copilo)
        integer :: lgpg
        integer :: npg
        integer :: nno
        integer :: ipoids
        integer :: ivf
        integer :: idfde
        real(kind=8) :: geom(2, 4)
        character(len=8) :: typmod(*)
        integer :: mate
        real(kind=8) :: deplm(2, 4)
        real(kind=8) :: vim(lgpg, npg)
        real(kind=8) :: ddepl(2, 4)
        real(kind=8) :: ddepl0(2, 4)
        real(kind=8) :: ddepl1(2, 4)
        real(kind=8) :: dtau
        real(kind=8) :: copilo(5, npg)
    end subroutine pipeed
end interface
