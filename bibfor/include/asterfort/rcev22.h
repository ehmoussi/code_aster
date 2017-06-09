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
    subroutine rcev22(nbinti, kinti, iocc, csigm, cinst,&
                      ccont, lfatig, flexio, lrocht, cnoc,&
                      cresu, cpres)
        integer :: nbinti
        character(len=16) :: kinti
        integer :: iocc
        character(len=24) :: csigm
        character(len=24) :: cinst
        character(len=24) :: ccont
        aster_logical :: lfatig
        aster_logical :: flexio
        aster_logical :: lrocht
        character(len=24) :: cnoc
        character(len=24) :: cresu
        character(len=24) :: cpres
    end subroutine rcev22
end interface
