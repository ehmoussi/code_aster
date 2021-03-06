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

subroutine as_mprcre(fid, nom, type, desc, dtunit,&
                     cret)
! person_in_charge: nicolas.sellenet at edf.fr
!
!
    implicit none
#include "asterf_types.h"
#include "asterf.h"
#include "asterfort/utmess.h"
#include "med/mprcre.h"
    character(len=*) :: nom
    character(len=*) :: desc
    character(len=*) :: dtunit
    med_idt :: fid 
    aster_int :: cret, type
#ifdef _DISABLE_MED
    call utmess('F', 'FERMETUR_2')
#else
!
#if med_int_kind != aster_int_kind || med_idt_kind != aster_int_kind
    med_idt :: fidm
    med_int :: cret4, typ4
    fidm = to_med_idt(fid)
    typ4 = type
    call mprcre(fidm, nom, typ4, desc, dtunit, cret4)
    cret = cret4
#else
    call mprcre(fid, nom, type, desc, dtunit, cret)
#endif
!
#endif
end subroutine
