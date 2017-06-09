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
    subroutine cafves(cont, tange, maxfa, nface, fks,&
                      dfks1, dfks2, mobfa, dmob1, dmob2,&
                      mob1f, mob2f, flux, dflx1, dflx2)
        integer :: maxfa
        aster_logical :: cont
        aster_logical :: tange
        integer :: nface
        real(kind=8) :: fks(maxfa)
        real(kind=8) :: dfks1(maxfa+1, maxfa)
        real(kind=8) :: dfks2(maxfa+1, maxfa)
        real(kind=8) :: mobfa(maxfa)
        real(kind=8) :: dmob1(maxfa)
        real(kind=8) :: dmob2(maxfa)
        real(kind=8) :: mob1f(maxfa)
        real(kind=8) :: mob2f(maxfa)
        real(kind=8) :: flux
        real(kind=8) :: dflx1(maxfa+1)
        real(kind=8) :: dflx2(maxfa+1)
    end subroutine cafves
end interface
