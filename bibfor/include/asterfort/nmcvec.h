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
    subroutine nmcvec(oper, typvez, optioz, lcalc, lasse,&
                      nbvect, ltypve, loptve, lcalve, lassve)
        character(len=4) :: oper
        character(len=*) :: typvez
        character(len=*) :: optioz
        aster_logical :: lcalc
        aster_logical :: lasse
        integer :: nbvect
        character(len=6) :: ltypve(20)
        character(len=16) :: loptve(20)
        aster_logical :: lcalve(20)
        aster_logical :: lassve(20)
    end subroutine nmcvec
end interface
