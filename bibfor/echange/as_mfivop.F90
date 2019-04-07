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
! person_in_charge: mathieu.courtois@edf.fr

subroutine as_mfivop(fid, nom, acces, major, minor, rel, cret)
!
    implicit none
#include "asterf_types.h"
#include "asterf.h"
#include "asterfort/utmess.h"
#include "asterfort/assert.h"
#include "med/mfivop.h"
    med_idt, intent(out) :: fid
    character(len=*), intent(in) :: nom
    aster_int, intent(in) :: acces
    aster_int, intent(in) :: major
    aster_int, intent(in) :: minor
    aster_int, intent(in) :: rel
    aster_int, intent(out) :: cret
#ifdef _DISABLE_MED
    call utmess('F', 'FERMETUR_2')
#else
!
#if med_int_kind != aster_int_kind || med_idt_kind != aster_int_kind
    med_idt :: fidm
    med_int :: acces4, cret4, major4, minor4, rel4
#endif
    cret = 0
    if (cret.eq.0) then
#if med_int_kind != aster_int_kind || med_idt_kind != aster_int_kind
        acces4 = acces
        major4 = major
        minor4 = minor
        rel4 = rel
        call mfivop(fidm, nom, acces4, major4, minor4, rel4, cret4)
        fid = fidm
        cret = cret4
#else
        call mfivop(fid, nom, acces, major, minor, rel, cret)
#endif
    endif
!
#endif
end subroutine
