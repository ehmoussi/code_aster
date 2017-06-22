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

subroutine as_mpfprw(fid, pflval, nbval, pro, cret)
! person_in_charge: nicolas.sellenet at edf.fr
!
!
    implicit none
#include "asterf_types.h"
#include "asterf.h"
#include "asterfort/conv_int.h"
#include "asterfort/utmess.h"
#include "med/mpfprw.h"
    aster_int :: fid, nbval, cret
    aster_int :: pflval(*)
    character(len=*) :: pro
#ifdef _DISABLE_MED
    call utmess('F', 'FERMETUR_2')
#else
!
#if med_int_kind != aster_int_kind
    med_int :: fid4, nbval4, cret4
    med_int, allocatable :: pflva4(:)
    fid4 = fid
    nbval4 = nbval
    allocate ( pflva4(nbval) )
    call conv_int('ast->med', nbval, vi_ast=pflval, vi_med=pflva4)
    call mpfprw(fid4, pro, nbval4, pflva4, cret4)
    cret = cret4
    deallocate (pflva4)
#else
    call mpfprw(fid, pro, nbval, pflval, cret)
#endif
!
#endif
end subroutine
