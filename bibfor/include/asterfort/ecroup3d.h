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
      subroutine ecroup3d(rp1,drp1_depl,rpic0,s11,epic0,epl0,epp1,&
       r0,eps0,rmin,hpla,ekdc,beta,rpiceff,epeqpc)

        real(kind=8) :: rp1
        real(kind=8) :: drp1_depl
        real(kind=8) :: rpic0
        real(kind=8) :: s11
        real(kind=8) :: epic0
        real(kind=8) :: epl0
        real(kind=8) :: epp1
        real(kind=8) :: r0
        real(kind=8) :: eps0
        real(kind=8) :: rmin
        real(kind=8) :: hpla
        real(kind=8) :: ekdc
        real(kind=8) :: beta
        real(kind=8) :: rpiceff
        real(kind=8) :: epeqpc
    end subroutine ecroup3d
end interface
