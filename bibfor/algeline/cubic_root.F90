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

function cubic_root(x) 
!
      implicit none
!
      real(kind=8), intent(in) :: x
      real(kind=8) :: cubic_root
!
!
!    RACINE CUBIQUE 
!
! IN  X : NOMBRE
!
      if(x.lt.0.d0) then
          cubic_root = -((-x)**(1.d0/3.d0))
      else
          cubic_root = x**(1.d0/3.d0)
      endif
!
!
end function
