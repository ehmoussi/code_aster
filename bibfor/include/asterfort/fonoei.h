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
    subroutine fonoei(ndim, dt, fnoevo, dimdef, dimcon,&
                      addeme,&
                      addep1, addep2, addlh1, adcome,&
                      adcp11, &
                      adcop1, adcop2, congem,&
                      r)
        integer :: dimcon
        integer :: dimdef
        integer :: ndim
        real(kind=8) :: dt
        aster_logical :: fnoevo
        integer :: addeme
        integer :: addep1
        integer :: addep2
        integer :: addlh1
        integer :: adcome
        integer :: adcp11
        integer :: adcop1
        integer :: adcop2
        real(kind=8) :: congem(dimcon)
        real(kind=8) :: r(dimdef)
    end subroutine fonoei
end interface
