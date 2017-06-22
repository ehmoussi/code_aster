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

subroutine as_mlclor(fid, tr1, tr2, tr3, nbt,&
                     k64, cret)
! person_in_charge: nicolas.sellenet at edf.fr
!
!
    implicit none
#include "asterf_types.h"
#include "asterf.h"
#include "asterfort/utmess.h"
#include "med/mlclor.h"
    real(kind=8) :: tr1(*), tr2(*), tr3(*)
    aster_int :: fid, nbt, cret
    character(len=64) :: k64
#ifdef _DISABLE_MED
    call utmess('F', 'FERMETUR_2')
#else
!
#if med_int_kind != aster_int_kind
    med_int :: fid4, nbt4, cret4
    fid4 = fid
    nbt4 = nbt
    call mlclor(fid4, k64, nbt4, tr1, tr2,&
                tr3, cret4)
    cret = cret4
#else
    call mlclor(fid, k64, nbt, tr1, tr2,&
                tr3, cret)
#endif
!
#endif
end subroutine
