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

subroutine as_mmhcyw(fid, maa, conn, csize, switch,&
                     n, typent, typgeo, typcon, cret)
! person_in_charge: nicolas.sellenet at edf.fr
!     L'ARGUMENT CSIZE N'EST PAS DANS L'API MED
!
!
    implicit none
#include "asterf_types.h"
#include "asterf.h"
#include "asterfort/conv_int.h"
#include "asterfort/utmess.h"
#include "med/mmhcyw.h"
    character(len=*) :: maa
    aster_int :: fid, conn(*), csize, typent, typgeo, typcon, cret
    aster_int :: n, switch, mdnont, mdnoit
    real(kind=8) :: mdnodt
#ifdef _DISABLE_MED
    call utmess('F', 'FERMETUR_2')
#else
!
#if med_int_kind != aster_int_kind
    med_int, allocatable :: conn4(:)
    med_int :: fid4, typen4, typge4, typco4, cret4
    med_int :: n4, switc4, mdnon4, mdnoi4
    aster_int :: ic
    mdnont = -1
    mdnoit = -1
    mdnodt = -1.d0
    fid4 = fid
    allocate ( conn4(csize) )
    call conv_int('ast->med', csize, vi_ast=conn, vi_med=conn4)
    typen4 = typent
    typge4 = typgeo
    typco4 = typcon
    n4 = n
    switc4 = switch
    mdnon4 = mdnont
    mdnoi4 = mdnoit
    call mmhcyw(fid4, maa, mdnon4, mdnoi4, mdnodt,&
                typen4, typge4, typco4, switc4, n4,&
                conn4, cret4)
    cret = cret4
    deallocate (conn4)
#else
    mdnont = -1
    mdnoit = -1
    mdnodt = -1.d0
    call mmhcyw(fid, maa, mdnont, mdnoit, mdnodt,&
                typent, typgeo, typcon, switch, n,&
                conn, cret)
#endif
!
#endif
end subroutine
