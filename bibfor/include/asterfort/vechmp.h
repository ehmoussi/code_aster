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
    subroutine vechmp(nomo, mate, carele, varplu, lxfem,&
                      partps, nbin_maxi, lpain, lchin, lastin)
        integer :: nbin_maxi
        character(len=8) :: nomo
        character(len=24) :: mate
        character(len=24) :: carele
        character(len=19) :: varplu
        aster_logical :: lxfem
        real(kind=8) :: partps(3)
        character(len=8) :: lpain(nbin_maxi)
        character(len=19) :: lchin(nbin_maxi)
        integer :: lastin
    end subroutine vechmp
end interface
