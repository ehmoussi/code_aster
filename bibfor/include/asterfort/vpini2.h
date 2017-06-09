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
interface
    subroutine vpini2(&
            eigsol, lcomod, nbvecg, nfreqg, nbpark, nbpari, nbparr, vecrer, vecrei, vecrek, vecvp,&
            mxresf)
#include "asterf_types.h"
        character(len=19) , intent(in)    :: eigsol
        aster_logical , intent(in)    :: lcomod
        integer           , intent(in)    :: nbvecg
        integer           , intent(in)    :: nfreqg
        integer           , intent(in)    :: nbpark
        integer           , intent(in)    :: nbpari
        integer           , intent(in)    :: nbparr
        character(len=24) , intent(in)    :: vecrer
        character(len=24) , intent(in)    :: vecrei
        character(len=24) , intent(in)    :: vecrek
        character(len=24) , intent(in)    :: vecvp
        integer           , intent(out)   :: mxresf
    end subroutine vpini2
end interface
