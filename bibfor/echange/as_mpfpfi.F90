! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

subroutine as_mpfpfi(fid, indice, pro, n, cret)
! person_in_charge: nicolas.sellenet at edf.fr
!
!
    implicit none
#include "asterf_types.h"
#include "asterf.h"
#include "asterfort/utmess.h"
#include "med/mpfpfi.h"
    med_idt :: fid
    aster_int :: n, cret, indice
    character(len=*) :: pro
#ifdef _DISABLE_MED
    call utmess('F', 'FERMETUR_2')
#else
!
#if med_int_kind != aster_int_kind || med_idt_kind != aster_int_kind
    med_idt :: fidm
    med_int :: n4, cret4, indic4
    fidm = to_med_idt(fid)
    indic4 = indice
    call mpfpfi(fidm, indic4, pro, n4, cret4)
    n = n4
    cret = cret4
#else
    call mpfpfi(fid, indice, pro, n, cret)
#endif
!
#endif
end subroutine
