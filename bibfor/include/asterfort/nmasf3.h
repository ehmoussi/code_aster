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
    subroutine nmasf3(nno, nbpg1, ipoids, ivf, idfde,&
                      imate, geom, deplm, sigm, vectu,&
                      compor)
        integer :: nbpg1
        integer :: nno
        integer :: ipoids
        integer :: ivf
        integer :: idfde
        integer :: imate
        real(kind=8) :: geom(3, nno)
        real(kind=8) :: deplm(3, nno)
        real(kind=8) :: sigm(78, nbpg1)
        real(kind=8) :: vectu(3, nno)
        character(len=16) :: compor(*)
    end subroutine nmasf3
end interface
