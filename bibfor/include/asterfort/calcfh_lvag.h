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
    subroutine calcfh_lvag(option, perman, hydr  , ndim  , j_mater,&
                           dimdef, dimcon,&
                           yamec , yate  ,&
                           addep1, addep2, adcp11, adcp12, adcp21 ,&
                           addeme, addete, &
                           t     , p2    , pvp    ,&
                           grat  , grap1 , grap2  ,& 
                           rho11 , h11   , h12    ,&
                           satur , dsatur, gravity, tperm,&
                           congep, dsde)
        character(len=16), intent(in) :: option, hydr
        aster_logical, intent(in) :: perman
        integer, intent(in) :: j_mater
        integer, intent(in) :: ndim, dimdef, dimcon, yamec, yate
        integer, intent(in) :: addeme, addep1, addep2, addete, adcp11, adcp12, adcp21
        real(kind=8), intent(in) :: rho11, satur, dsatur
        real(kind=8), intent(in) :: grat(3), grap1(3), grap2(3)
        real(kind=8), intent(in) :: p2, pvp, t
        real(kind=8), intent(in) :: gravity(3), tperm(ndim, ndim)
        real(kind=8), intent(in) :: h11, h12
        real(kind=8), intent(inout) :: congep(1:dimcon)
        real(kind=8), intent(inout) :: dsde(1:dimcon, 1:dimdef)
    end subroutine calcfh_lvag
end interface 
