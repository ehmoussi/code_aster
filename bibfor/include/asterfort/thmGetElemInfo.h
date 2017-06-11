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
    subroutine thmGetElemInfo(l_vf, type_vf, inte_type, elrefe, elref2,&
                              nno, nnos, nnom, &
                              npi, npi2, npg,&
                              jv_gano, jv_poids, jv_poids2,&
                              jv_func, jv_func2, jv_dfunc, jv_dfunc2)
        aster_logical, intent(in) :: l_vf
        integer, intent(in) :: type_vf
        character(len=3), intent(in) :: inte_type
        character(len=8), intent(in) :: elrefe
        character(len=8), intent(in) :: elref2
        integer, intent(out) :: nno, nnos, nnom
        integer, intent(out) :: npi, npi2, npg
        integer, intent(out) :: jv_gano
        integer, intent(out) :: jv_poids, jv_poids2
        integer, intent(out) :: jv_func, jv_func2, jv_dfunc, jv_dfunc2
    end subroutine thmGetElemInfo
end interface
