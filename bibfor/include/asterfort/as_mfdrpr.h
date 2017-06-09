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
interface
    subroutine as_mfdrpr(fid, cha, val, intlac, numco,&
                      profil, pflmod, typent, typgeo, numdt,&
                      numo, cret)
        aster_int :: fid
        character(len=*) :: cha
        real(kind=8) :: val(*)
        aster_int :: intlac
        aster_int :: numco
        character(len=*) :: profil
        aster_int :: pflmod
        aster_int :: typent
        aster_int :: typgeo
        aster_int :: numdt
        aster_int :: numo
        aster_int :: cret
    end subroutine as_mfdrpr
end interface
