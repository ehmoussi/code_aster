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
! aslint: disable=W1504
!
#include "asterf_types.h"
!
interface
    subroutine calcva(kpi   , ndim  ,&
                      defgem, defgep,&
                      addeme, addep1, addep2   , addete,&
                      depsv , epsv  , deps     ,&
                      temp  , dtemp , grad_temp,&
                      p1    , dp1   , grad_p1  ,&
                      p2    , dp2   , grad_p2  ,&
                      retcom)
        integer, intent(in) :: kpi, ndim
        real(kind=8), intent(in) :: defgem(*), defgep(*)
        integer, intent(in) :: addeme, addep1, addep2, addete
        real(kind=8), intent(out) :: depsv, epsv, deps(6)
        real(kind=8), intent(out) :: temp, dtemp, grad_temp(ndim)
        real(kind=8), intent(out) :: p1, dp1, grad_p1(ndim)
        real(kind=8), intent(out) :: p2, dp2, grad_p2(ndim)
        integer, intent(out) :: retcom
    end subroutine calcva
end interface
