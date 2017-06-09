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
    function dmwdp1(rho11, signe, sat, dsatp1, phi,&
                    cs, cliq, dp11p1, emmag, em)
        real(kind=8) :: rho11
        real(kind=8) :: signe
        real(kind=8) :: sat
        real(kind=8) :: dsatp1
        real(kind=8) :: phi
        real(kind=8) :: cs
        real(kind=8) :: cliq
        real(kind=8) :: dp11p1
        aster_logical :: emmag
        real(kind=8) :: em
        real(kind=8) :: dmwdp1_0
    end function dmwdp1
end interface 
