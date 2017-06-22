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

subroutine as_mfaofi(fid, maa, ind, fam, num,&
                     attid, attval, attdes, natt, gro,&
                     cret)
! person_in_charge: nicolas.sellenet at edf.fr
!     l'argument natt est en "plus"
!     il sert a dimensionner attid4(*) et attva4(*)
!
!
    implicit none
#include "asterf_types.h"
#include "asterf.h"
#include "asterfort/conv_int.h"
#include "asterfort/utmess.h"
#include "med/mfaofi.h"
!
    aster_int :: fid, num, attid(*), attval(*), natt, cret, ind
    character(len=*) :: maa, fam, attdes(*), gro(*)
!
#ifdef _DISABLE_MED
    call utmess('F', 'FERMETUR_2')
#else
!
#if med_int_kind != aster_int_kind
    med_int, allocatable :: attid4(:), attva4(:)
    med_int :: cret4, num4
!
    allocate ( attid4(natt) )
    allocate ( attva4(natt) )
!
    call mfaofi(to_med_int(fid), maa, to_med_int(ind), fam, attid4,&
                attva4, attdes, num4, gro, cret4)
    num = to_aster_int(num4)
    cret = to_aster_int(cret4)
    call conv_int('med->ast', natt, vi_ast=attid, vi_med=attid4)
    call conv_int('med->ast', natt, vi_ast=attval, vi_med=attva4)
!
    deallocate (attid4)
    deallocate (attva4)
#else
    call mfaofi(fid, maa, ind, fam, attid,&
                attval, attdes, num, gro, cret)
#endif
!
#endif
end subroutine
