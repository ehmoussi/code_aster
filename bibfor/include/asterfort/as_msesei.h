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
    subroutine as_msesei(idfimd, imasup, nomaes, nvtymd, dimest,&
                      nomasu, medcel, nbnosu, nbmssu, tygems,&
                      nbattc, prespr, nbattv, codret)
        aster_int :: idfimd
        aster_int :: imasup
        character(len=*) :: nomaes
        aster_int :: nvtymd
        aster_int :: dimest
        character(len=*) :: nomasu
        aster_int :: medcel
        aster_int :: nbnosu
        aster_int :: nbmssu
        aster_int :: tygems
        aster_int :: nbattc
        aster_int :: prespr
        aster_int :: nbattv
        aster_int :: codret
    end subroutine as_msesei
end interface
