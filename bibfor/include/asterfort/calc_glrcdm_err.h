! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

interface
    subroutine calc_glrcdm_err(l_calc, commax, flexmax, gamma_f,&
                           gamma_c, epsi_c, h, valpar,&
                           errcom, errflex)
        aster_logical :: l_calc(2)
        real(kind=8) :: commax
        real(kind=8) :: flexmax
        real(kind=8) :: gamma_f
        real(kind=8) :: gamma_c
        real(kind=8) :: epsi_c
        real(kind=8) :: h
        real(kind=8) :: valpar(*)
        real(kind=8) :: errcom
        real(kind=8) :: errflex
    end subroutine calc_glrcdm_err
end interface
