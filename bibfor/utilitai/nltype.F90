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

function nltype(inttyp)
    implicit none
!
!
#include "nldef.h"
#include "asterfort/assert.h"
!
    integer :: inttyp
    character(len=16) :: nltype
    character(len=16) :: nltypes(_NL_NB_TYPES)

    data  nltypes /'DIS_CHOC        ', 'FLAMBAGE        ', 'ANTI_SISM       ',&
                   'DIS_VISC        ', 'DIS_ECRO_TRAC   ', 'ROTOR_FISS      ',&
                   'PALIER_EDYOS    ', 'RELA_EFFO_DEPL  ', 'RELA_EFFO_VITE  ',&
                   'YACS            '/
!
!
    ASSERT((inttyp.gt.0).and.(inttyp.le._NL_NB_TYPES))
    nltype = nltypes(inttyp)
end function
