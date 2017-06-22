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
    subroutine dfort3(nsommx, icnc, noeu1, noeu2, tbelzo,&
                      nbelt, tbnozo, nbnoe, xy, volume,&
                      energi, pe)
        integer :: nbnoe
        integer :: nbelt
        integer :: nsommx
        integer :: icnc(nsommx+2, *)
        integer :: noeu1
        integer :: noeu2
        integer :: tbelzo(nbelt)
        integer :: tbnozo(nbnoe)
        real(kind=8) :: xy(3, *)
        real(kind=8) :: volume(*)
        real(kind=8) :: energi(*)
        real(kind=8) :: pe
    end subroutine dfort3
end interface
