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
    subroutine fonoei(ndim, dt, fnoevo, dimdef, dimcon,&
                      yamec, yap1, yap2, yate, addeme,&
                      addep1, addep2, addete, addlh1, adcome,&
                      adcp11, adcp12, adcp21, adcp22, adcote,&
                      adcop1, adcop2, nbpha1, nbpha2, congem,&
                      r)
        integer :: dimcon
        integer :: dimdef
        integer :: ndim
        real(kind=8) :: dt
        aster_logical :: fnoevo
        integer :: yamec
        integer :: yap1
        integer :: yap2
        integer :: yate
        integer :: addeme
        integer :: addep1
        integer :: addep2
        integer :: addete
        integer :: addlh1
        integer :: adcome
        integer :: adcp11
        integer :: adcp12
        integer :: adcp21
        integer :: adcp22
        integer :: adcote
        integer :: adcop1
        integer :: adcop2
        integer :: nbpha1
        integer :: nbpha2
        real(kind=8) :: congem(dimcon)
        real(kind=8) :: r(dimdef)
    end subroutine fonoei
end interface
