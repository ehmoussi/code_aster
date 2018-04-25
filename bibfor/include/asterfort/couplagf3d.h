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
       subroutine couplagf3d(a,b,ngf,&
                 kveve66,kmm66,kmve66,kvem66,bve6,&
                 bm6)
        real(kind=8) :: a(ngf,ngf+1)
        real(kind=8) :: b(ngf)
        integer :: ngf
        real(kind=8) :: kveve66(6,6)
        real(kind=8) :: kmm66(6,6)
        real(kind=8) :: kmve66(6,6)
        real(kind=8) :: kvem66(6,6)
        real(kind=8) :: bve6(6)
        real(kind=8) :: bm6(6)
    end subroutine couplagf3d
end interface 
