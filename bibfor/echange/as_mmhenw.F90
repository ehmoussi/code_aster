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

subroutine as_mmhenw(fid, maa, num, n, typent,&
                     typgeo, cret)
! person_in_charge: nicolas.sellenet at edf.fr
!
!
    implicit none
#include "asterf_types.h"
#include "asterf.h"
#include "asterfort/conv_int.h"
#include "asterfort/utmess.h"
#include "med/mmhenw.h"
    character(len=*) :: maa
    aster_int :: num(*)
    aster_int :: fid, typent, typgeo, cret
    aster_int :: n, mdnont, mdnoit
#ifdef _DISABLE_MED
    call utmess('F', 'FERMETUR_2')
#else
!
#if med_int_kind != aster_int_kind
    med_int, allocatable :: num4(:)
    med_int :: fid4, typen4, typge4, cret4
    med_int :: n4, mdnon4, mdnoi4
    mdnont = -1
    mdnoit = -1
    allocate ( num4(n) )
    call conv_int('ast->med', n, vi_ast=num, vi_med=num4)
    fid4 = fid
    typen4 = typent
    typge4 = typgeo
    n4 = n
    mdnon4 = mdnont
    mdnoi4 = mdnoit
    call mmhenw(fid4, maa, mdnon4, mdnoi4, typen4,&
                typge4, n4, num4, cret4)
    cret = cret4
    deallocate (num4)
#else
    mdnont = -1
    mdnoit = -1
    call mmhenw(fid, maa, mdnont, mdnoit, typent,&
                typgeo, n, num, cret)
#endif
!
#endif
end subroutine
