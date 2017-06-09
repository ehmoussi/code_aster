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
    subroutine mcmmvc(cumul, lmat, smdi, smhc, neq,&
                      vect, xsol, nbvect, vectmp, prepos)
        integer :: nbvect
        integer :: neq
        character(len=*) :: cumul
        integer :: lmat
        integer :: smdi(*)
        integer(kind=4) :: smhc(*)
        complex(kind=8) :: vect(neq, nbvect)
        complex(kind=8) :: xsol(neq, nbvect)
        complex(kind=8) :: vectmp(neq)
        aster_logical :: prepos
    end subroutine mcmmvc
end interface
