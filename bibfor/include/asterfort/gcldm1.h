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
            subroutine gcldm1(m,in,ip,prec,x,y,perm,xtrav,ytrav)
              integer, intent(in) :: m
              integer, intent(in) :: in(*)
              integer(kind=4), intent(in) :: ip(*)
              real(kind=8), intent(in) :: prec(*)
              real(kind=8), intent(in) :: x(*)
              real(kind=8), intent(out) :: y(*)
              integer, intent(in) :: perm(*)
              real(kind=8), intent(inout) :: xtrav(*)
              real(kind=8), intent(inout) :: ytrav(*)
            end subroutine gcldm1
          end interface 
