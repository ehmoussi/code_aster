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
    subroutine calcfh_lgat(option, perman , hydr  , ndim  , j_mater,&
                           dimdef, dimcon ,&
                           addep1, adcp11 ,&
                           addeme, addete ,&
                           t     , p2     ,&
                           grap1 ,& 
                           rho11 ,&
                           satur , dsatur, gravity, tperm,&
                           congep, dsde)
        character(len=16), intent(in) :: option, hydr
        aster_logical, intent(in) :: perman
        integer, intent(in) :: j_mater
        integer, intent(in) :: ndim, dimdef, dimcon
        integer, intent(in) :: addeme, addep1, addete, adcp11
        real(kind=8), intent(in) :: rho11, satur, dsatur
        real(kind=8), intent(in) :: grap1(3)
        real(kind=8), intent(in) :: p2, t
        real(kind=8), intent(in) :: gravity(3), tperm(ndim, ndim)
        real(kind=8), intent(inout) :: congep(1:dimcon)
        real(kind=8), intent(inout) :: dsde(1:dimcon, 1:dimdef)
    end subroutine calcfh_lgat
end interface 