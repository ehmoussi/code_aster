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
    subroutine dimax1(jvec1, jvec2, nbp1, nbp2, dismax,&
                      cu1max, cv1max, cu2max, cv2max)
        integer :: jvec1
        integer :: jvec2
        integer :: nbp1
        integer :: nbp2
        real(kind=8) :: dismax
        real(kind=8) :: cu1max
        real(kind=8) :: cv1max
        real(kind=8) :: cu2max
        real(kind=8) :: cv2max
    end subroutine dimax1
end interface
