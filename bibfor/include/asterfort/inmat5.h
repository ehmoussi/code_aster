! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
interface
    subroutine inmat5(elrefa, nno, nnos, npg, mganos,&
                      mgano2)
        character(len=8), intent(in) :: elrefa
        integer, intent(in) :: nnos, npg, nno
        integer, parameter :: nbpgmx=1000, nbnomx=27
        real(kind=8), intent(in) :: mganos(nbpgmx, nbnomx)
        real(kind=8), intent(out) :: mgano2(nbpgmx, nbnomx)
    end subroutine inmat5
end interface
