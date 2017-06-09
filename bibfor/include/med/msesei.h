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
#include "asterf_types.h"
    subroutine msesei(fid, it, mname, mgtype, mdim,&
                      smname, setype, snnode, sncell, sgtype,&
                      ncatt, ap, nvatt, cret)
        med_int :: fid
        med_int :: it
        character(len=*) :: mname
        med_int :: mgtype
        med_int :: mdim
        character(len=*) :: smname
        med_int :: setype
        med_int :: snnode
        med_int :: sncell
        med_int :: sgtype
        med_int :: ncatt
        med_int :: ap
        med_int :: nvatt
        med_int :: cret
    end subroutine msesei
end interface
