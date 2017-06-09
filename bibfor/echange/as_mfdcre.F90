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

subroutine as_mfdcre(fid, cha, nomamd, type, comp,&
                     unit, ncomp, cret)
! person_in_charge: nicolas.sellenet at edf.fr
!
!
    implicit none
#include "asterf_types.h"
#include "asterf.h"
#include "asterfort/utmess.h"
#include "med/mfdcre.h"
    character(len=*) :: cha, nomamd, comp, unit
    character(len=80) :: unidt
    aster_int :: fid, ncomp, cret, type
!
#ifdef _DISABLE_MED
    call utmess('F', 'FERMETUR_2')
#else
!
#if med_int_kind != aster_int_kind
    med_int :: fid4, ncomp4, cret4, type4
    unidt = ' '
    fid4 = fid
    ncomp4 = ncomp
    type4 = type
    call mfdcre(fid4, cha, type4, ncomp4, comp,&
                unit, unidt, nomamd, cret4)
    cret = cret4
#else
    unidt = ' '
    call mfdcre(fid, cha, type, ncomp, comp,&
                unit, unidt, nomamd, cret)
#endif
!
#endif
end subroutine
