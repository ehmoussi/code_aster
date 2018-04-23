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
      subroutine matcc3d(cc3,vcc33,vcc33t,v33,v33t,&
             cc6)
        real(kind=8) :: cc3(3)
        real(kind=8) :: vcc33(3,3)
        real(kind=8) :: vcc33t(3,3)
        real(kind=8) :: v33(3,3)
        real(kind=8) :: v33t(3,3)
        real(kind=8) :: cc6(6)
    end subroutine matcc3d
end interface 
