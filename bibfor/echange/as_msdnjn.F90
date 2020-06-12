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

subroutine as_msdnjn(fid,maa,n,cret)
! person_in_charge: nicolas.sellenet at edf.fr
!
!
    implicit none
#include "asterf_config.h"
#include "asterf_types.h"
#include "asterfort/utmess.h"
#include "med/msdnjn.h"
    med_idt :: fid
    character(len=*) :: maa
    aster_int :: n, cret

#ifdef _DISABLE_MED
    call utmess('F', 'FERMETUR_2')
#else

#ifdef _DEBUG_MED
    write(6,*) '=== as_msdnjn fid=',fid
    write(6,*) '=== as_msdnjn maa=',maa
#endif

#if med_int_kind != aster_int_kind || med_idt_kind != aster_int_kind
    med_idt :: fid4
    med_int :: n4, cret4
    fid4=to_med_idt(fid)
    call msdnjn(fid4,maa,n4,cret4)
    n=to_aster_int(n4)
    cret=to_aster_int(cret4)
#else
    call msdnjn(fid,maa,n,cret)
#endif

#ifdef _DEBUG_MED
    write(6,*) '=== as_msdnjn n4=',n4
    write(6,*) '=== as_msdnjn cret4=',cret4
#endif

#endif
end subroutine
