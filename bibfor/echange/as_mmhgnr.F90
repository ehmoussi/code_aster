! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

subroutine as_mmhgnr(fid, nomail, typent, typgeo, tblogl,&
                     n, cret)
! person_in_charge: nicolas.sellenet at edf.fr
!
!
    implicit none
#include "asterf_config.h"
#include "asterf_types.h"
#include "asterfort/conv_int.h"
#include "asterfort/utmess.h"
#include "med/mmhgnr.h"
    med_idt :: fid
    aster_int :: typent, typgeo, n, cret, numdt, numo
    aster_int :: tblogl(n)
    character(len=*) :: nomail
#ifdef _DISABLE_MED
    call utmess('F', 'FERMETUR_2')
#else

#if med_int_kind != aster_int_kind || med_idt_kind != aster_int_kind
    med_idt :: fid4
    med_int :: typen4, typge4, cret4, numdt4, numo4
    med_int, allocatable :: tblog4(:)

    fid4 = to_med_idt(fid)
    numdt4 = -1
    numo4 = -1
    typen4 = to_med_int(typent)
    typge4 = to_med_int(typgeo)
    allocate ( tblog4(n) )

    call mmhgnr(fid4, nomail, numdt4, numo4, typen4,&
                typge4, tblog4, cret4)

    call conv_int('med->ast', n, vi_ast=tblogl, vi_med=tblog4)
    cret = to_aster_int(cret4)
    deallocate (tblog4)
#else
    call mmhgnr(fid, nomail, -1, -1, typent,&
                typgeo, tblogl, cret)
#endif

#endif
end subroutine
