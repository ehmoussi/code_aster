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
#include "asterf_types.h"
!
interface
    subroutine xprali(p1, p2, vnele, nelcou, poifis,&
                      trifis, libre, vin)
        integer :: p1
        integer :: p2
        real(kind=8) :: vnele(3)
        integer :: nelcou
        character(len=19) :: poifis
        character(len=19) :: trifis
        aster_logical :: libre
        real(kind=8) :: vin(3)
    end subroutine xprali
end interface
