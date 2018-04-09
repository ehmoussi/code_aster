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
      subroutine fludes3d(bw0,pw0,bw,pw,sfld,&
              sig0,dsw6,nstrs)
        real(kind=8) :: bw0
        real(kind=8) :: pw0
        real(kind=8) :: bw
        real(kind=8) :: pw
        real(kind=8) :: sfld
        real(kind=8) :: sig0(:)
        real(kind=8) :: dsw6(6)
        integer :: nstrs
    end subroutine fludes3d
end interface
