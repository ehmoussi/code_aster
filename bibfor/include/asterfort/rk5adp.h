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
    subroutine rk5adp(nbeq, param_real, param_int, t0, dt0, nbmax,&
                      errmax, y0, dy0, rk5fct, resu, iret)
        integer      :: nbeq
        real(kind=8) :: param_real(*)
        integer      :: param_int(*)
        real(kind=8) :: t0
        real(kind=8) :: dt0
        integer      :: nbmax
        real(kind=8) :: errmax
        real(kind=8) :: y0(nbeq)
        real(kind=8) :: dy0(nbeq)
        real(kind=8) :: resu(2*nbeq)
        integer      :: iret
!
        interface
            subroutine rk5fct(ppr, ppi, yy0, dy0, dyy, decoup)
                real(kind=8) :: ppr(*)
                integer      :: ppi(*)
                real(kind=8) :: yy0(*)
                real(kind=8) :: dy0(*)
                real(kind=8) :: dyy(*)
                aster_logical :: decoup
            end subroutine rk5fct
        end interface
!
    end subroutine rk5adp
end interface
