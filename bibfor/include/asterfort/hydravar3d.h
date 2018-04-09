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
     subroutine  hydravar3d(hyd0,hydr,hyds,phi00,phi0,dth00,dth0,&
            epleq00,epleq0,epspt600,epspt60,&
            epspg600,epspg60,epspc600,epspc60,epsk006,epsk06,&
            epsm006,epsm06,dfl00,dfl0,ett600,ett60,wplt006,wplt06,&
            wpltx006,wpltx06)

        real(kind=8) :: hyd0
        real(kind=8) :: hydr
        real(kind=8) :: hyds
        real(kind=8) :: phi00
        real(kind=8) :: phi0
        real(kind=8) :: dth00
        real(kind=8) :: dth0
        real(kind=8) :: epleq00
        real(kind=8) :: epleq0
        real(kind=8) :: epspt600(6)
        real(kind=8) :: epspt60(6)
        real(kind=8) :: epspg600(6)
        real(kind=8) :: epspg60(6)
        real(kind=8) :: epspc600(6)
        real(kind=8) :: epspc60(6)
        real(kind=8) :: epsk006(6)
        real(kind=8) :: epsk06(6)
        real(kind=8) :: epsm006(6)
        real(kind=8) :: epsm06(6)
        real(kind=8) :: dfl00
        real(kind=8) :: dfl0
        real(kind=8) :: ett600(6)
        real(kind=8) :: ett60(6)
        real(kind=8) :: wplt006(6)
        real(kind=8) :: wplt06(6)
        real(kind=8) :: wpltx006(6)
        real(kind=8) :: wpltx06(6)
    end subroutine hydravar3d
end interface
