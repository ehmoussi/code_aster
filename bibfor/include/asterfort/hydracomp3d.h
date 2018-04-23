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
      subroutine hydracomp3d(we0,we0s,epse06,souplesse66,sig06,&
                 deps6r,deps6r2,sigke06,&
                 epsk06,psik,fl3d)

        real(kind=8) :: we0
        real(kind=8) :: we0s
        real(kind=8) :: epse06(6)
        real(kind=8) :: souplesse66(6,6)
        real(kind=8) :: sig06(6)
        real(kind=8) :: deps6r(6)
        real(kind=8) :: deps6r2(6)
        real(kind=8) :: sigke06(6)
        real(kind=8) :: epsk06(6)
        real(kind=8) :: psik
        aster_logical :: fl3d
    end subroutine hydracomp3d
end interface
