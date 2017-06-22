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

subroutine as_msmsmi(fid, iterat, nom, dim, desc,&
                     typrep, nocomp, unit, cret)
! person_in_charge: nicolas.sellenet at edf.fr
!
!
    implicit none
#include "asterf_types.h"
#include "asterf.h"
#include "asterfort/utmess.h"
#include "med/msmsmi.h"
    character(len=*) :: nom
    character(len=*) :: desc
    character(len=16) :: nocomp(3), unit(3)
    aster_int :: fid, dim, cret, typrep, iterat
#ifdef _DISABLE_MED
    call utmess('F', 'FERMETUR_2')
#else
!
#if med_int_kind != aster_int_kind
    med_int :: fid4, dim4, cret4, typre4, itera4
    fid4 = fid
    itera4 = iterat
    call msmsmi(fid4, itera4, nom, dim4, dim4,&
                desc, typre4, nocomp, unit, cret4)
    dim = dim4
    typrep = typre4
    cret = cret4
#else
    call msmsmi(fid, iterat, nom, dim, dim,&
                desc, typrep, nocomp, unit, cret)
#endif
!
#endif
end subroutine
