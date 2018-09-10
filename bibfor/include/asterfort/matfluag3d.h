! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
interface 
      subroutine matfluag3d(epse06,epsk06,sig06,&
                psik,tauk,taum,&
                deps6,dt,theta,&
                kveve66,kvem66,kmve66,kmm66,bve6,&
                bm6,deltam,avean,cc03,vcc33,&
                vcc33t,vref33,vref33t)
        real(kind=8) :: epse06(6)
        real(kind=8) :: epsk06(6)
        real(kind=8) :: sig06(6)
        real(kind=8) :: psik
        real(kind=8) :: tauk
        real(kind=8) :: taum
        real(kind=8) :: deps6(6)
        real(kind=8) :: dt
        real(kind=8) :: theta
        real(kind=8) :: kveve66(6,6)
        real(kind=8) :: kvem66(6,6)
        real(kind=8) :: kmve66(6,6)
        real(kind=8) :: kmm66(6,6)
        real(kind=8) :: bve6(6)
        real(kind=8) :: bm6(6)
        real(kind=8) :: deltam
        real(kind=8) :: avean
        real(kind=8) :: cc03(3)
        real(kind=8) :: vcc33(3,3)
        real(kind=8) :: vcc33t(3,3)
        real(kind=8) :: vref33(3,3)
        real(kind=8) :: vref33t(3,3)
    end subroutine matfluag3d
end interface 
