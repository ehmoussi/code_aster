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

subroutine as_mmhcow(fid, maa, coo, modcoo, n,&
                     cret)
! person_in_charge: nicolas.sellenet at edf.fr
!
!
    implicit none
#include "asterf_types.h"
#include "asterf.h"
#include "asterfort/utmess.h"
#include "med/mmhcow.h"
    character(len=*) :: maa
    real(kind=8) :: coo(*)
    aster_int :: fid
    aster_int :: n, cret, modcoo, mdnont, mdnoit
    real(kind=8) :: mdnodt
#ifdef _DISABLE_MED
    call utmess('F', 'FERMETUR_2')
#else
!
#if med_int_kind != aster_int_kind
    med_int :: fid4
    med_int :: n4, cret4, modco4, mdnoi4, mdnon4
    mdnont = -1
    mdnoit = -1
    mdnodt = -1.d0
    fid4 = fid
    n4 = n
    modco4 = modcoo
    mdnon4 = mdnont
    mdnoi4 = mdnoit
    call mmhcow(fid4, maa, mdnon4, mdnoi4, mdnodt,&
                modco4, n4, coo, cret4)
    cret = cret4
#else
    mdnont = -1
    mdnoit = -1
    mdnodt = -1.d0
    call mmhcow(fid, maa, mdnont, mdnoit, mdnodt,&
                modcoo, n, coo, cret)
#endif
!
#endif
end subroutine
