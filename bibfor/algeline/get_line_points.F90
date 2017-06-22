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

subroutine get_line_points(line, pt1, pt2)
!
      implicit none
!
      real(kind=8), intent(in) :: line(3)
      real(kind=8), intent(out) :: pt1(3)
      real(kind=8), intent(out) :: pt2(3)
!
!
!     
!
! IN  LINE : LIGNE 2D en coordonees projectives
! OUT PT1 : un point sur la ligne en coordonnees projectives
! OUT P22 : autre point en coordonnees projectives
!
      if(line(1).eq.0.d0.and.line(2).eq.0.d0) then
         pt1 = (/ 1.d0, 0.d0, 0.d0 /)
         pt2 = (/ 0.d0, 1.d0, 0.d0 /)
      else
         pt2 = (/ -line(2), line(1), 0.d0 /)
         if(abs(line(1)).lt.abs(line(2))) then
            pt1 = (/ 0.d0, -line(3), line(2)/)
         else
            pt1 = (/ -line(3), 0.d0, line(1)/)
         endif
      endif
!
!
end subroutine
