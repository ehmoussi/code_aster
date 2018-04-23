! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
#include "asterf_types.h"
interface 
       subroutine gauss3d(n,a,x,b,ngf,&
              err1,ipzero)
        integer :: n
        real(kind=8) :: a(ngf,ngf+1)
        real(kind=8) :: x(ngf)
        real(kind=8) :: b(ngf)
        integer :: ngf
        integer :: err1
        integer :: ipzero(ngf)
    end subroutine gauss3d
end interface
