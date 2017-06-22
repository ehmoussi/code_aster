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
    subroutine irsspt(cesz, unite, nbmat, nummai, nbcmp,&
                      nomcmp, lsup, linf, lmax, lmin,&
                      borinf, borsup)
        character(len=*) :: cesz
        integer :: unite
        integer :: nbmat
        integer :: nummai(*)
        integer :: nbcmp
        character(len=*) :: nomcmp(*)
        aster_logical :: lsup
        aster_logical :: linf
        aster_logical :: lmax
        aster_logical :: lmin
        real(kind=8) :: borinf
        real(kind=8) :: borsup
    end subroutine irsspt
end interface
