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
    subroutine calcva(kpi, yachai, yamec, yate, yap1,&
                      yap2, defgem, defgep, addeme, addep1,&
                      addep2, addete, ndim, t0, p10,&
                      p20, depsv, epsv, deps, t,&
                      p1, p2, grat, grap1, grap2,&
                      dp1, dp2, dt, retcom)
        integer :: ndim
        integer :: kpi
        aster_logical :: yachai
        integer :: yamec
        integer :: yate
        integer :: yap1
        integer :: yap2
        real(kind=8) :: defgem(*)
        real(kind=8) :: defgep(*)
        integer :: addeme
        integer :: addep1
        integer :: addep2
        integer :: addete
        real(kind=8) :: t0
        real(kind=8) :: p10
        real(kind=8) :: p20
        real(kind=8) :: depsv
        real(kind=8) :: epsv
        real(kind=8) :: deps(6)
        real(kind=8) :: t
        real(kind=8) :: p1
        real(kind=8) :: p2
        real(kind=8) :: grat(ndim)
        real(kind=8) :: grap1(ndim)
        real(kind=8) :: grap2(ndim)
        real(kind=8) :: dp1
        real(kind=8) :: dp2
        real(kind=8) :: dt
        integer :: retcom
    end subroutine calcva
end interface
