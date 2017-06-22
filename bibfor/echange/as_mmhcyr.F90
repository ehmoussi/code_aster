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

subroutine as_mmhcyr(fid, maa, conn, csize, switch,&
                     typent, typgeo, typcon, cret)
! person_in_charge: nicolas.sellenet at edf.fr
!     L'ARGUMENT CSIZE N'EST PAS DANS L'API MED
!
!
    implicit none
#include "asterf_types.h"
#include "asterf.h"
#include "asterfort/conv_int.h"
#include "asterfort/utmess.h"
#include "med/mmhcyr.h"
    character(len=*) :: maa
    aster_int :: fid, typent, typgeo, cret
    aster_int :: typcon, switch, csize, mdnont, mdnoit
    aster_int :: conn(*)
#ifdef _DISABLE_MED
    call utmess('F', 'FERMETUR_2')
#else
!
#if med_int_kind != aster_int_kind
    med_int :: fid4, typen4, typge4, cret4
    med_int :: typco4, switc4, mdnon4, mdnoi4
    med_int, allocatable :: conn4(:)
    mdnont = -1
    mdnoit = -1
    fid4 = fid
    typen4 = typent
    typge4 = typgeo
    typco4 = typcon
    switc4 = switch
    mdnon4 = mdnont
    mdnoi4 = mdnoit
    allocate ( conn4(csize) )
    call mmhcyr(fid4, maa, mdnon4, mdnoi4, typen4,&
                typge4, typco4, switc4, conn4, cret4)
    call conv_int('med->ast', csize, vi_ast=conn, vi_med=conn4)
    cret = cret4
    deallocate (conn4)
#else
    mdnont = -1
    mdnoit = -1
    call mmhcyr(fid, maa, mdnont, mdnoit, typent,&
                typgeo, typcon, switch, conn, cret)
#endif
!
#endif
end subroutine
