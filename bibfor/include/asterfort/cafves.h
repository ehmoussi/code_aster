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
#include "asterf_types.h"
!
interface
    subroutine cafves(l_matr, maxfa , nface,&
                      fks   , dfks1 , dfks2,&
                      mobfa , dmob1 , dmob2,&
                      dmob1f, dmob2f,&
                      flux  , dflx1 , dflx2)
        aster_logical, intent(in) :: l_matr
        integer, intent(in) :: maxfa, nface
        real(kind=8), intent(in) :: fks(maxfa), dfks1(maxfa+1, maxfa), dfks2(maxfa+1, maxfa)
        real(kind=8), intent(in) :: mobfa(maxfa), dmob1(maxfa), dmob2(maxfa)
        real(kind=8), intent(in) :: dmob1f(maxfa), dmob2f(maxfa)
        real(kind=8), intent(inout) :: flux, dflx1(maxfa+1), dflx2(maxfa+1)
    end subroutine cafves
end interface
