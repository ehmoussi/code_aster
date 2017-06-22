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

subroutine as_mprrvw(fid, nom, numdt, numit, dt,&
                     val, cret)
! person_in_charge: nicolas.sellenet at edf.fr
!
!
    implicit none
#include "asterf_types.h"
#include "asterf.h"
#include "asterfort/utmess.h"
#include "med/mprrvw.h"
    character(len=*) :: nom
    aster_int :: fid, numdt, numit, cret
    real(kind=8) :: dt, val
#ifdef _DISABLE_MED
    call utmess('F', 'FERMETUR_2')
#else
!
#if med_int_kind != aster_int_kind
    med_int :: fid4, numdt4, numit4, cret4
    fid4 = fid
    numdt4 = numdt
    numit4 = numit
    call mprrvw(fid4, nom, numdt4, numit4, dt, val, cret4)
    cret = cret4
#else
    call mprrvw(fid, nom, numdt, numit, dt, val, cret)
#endif
!
#endif
end subroutine
