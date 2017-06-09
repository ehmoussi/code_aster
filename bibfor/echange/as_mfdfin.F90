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

subroutine as_mfdfin(fid, cha, ma, n, cunit,&
                     cname, cret)
! person_in_charge: nicolas.sellenet at edf.fr
!
!
    implicit none
#include "asterf_types.h"
#include "asterf.h"
#include "asterfort/utmess.h"
#include "med/mfioex.h"
#include "med/mfdfin.h"
    aster_int :: fid, n, cret
    character(len=*) :: cha
    character(len=16) :: cunit, cname
    character(len=*) :: ma
    character(len=80) :: dtunit
#ifdef _DISABLE_MED
    call utmess('F', 'FERMETUR_2')
#else
!
#if med_int_kind != aster_int_kind
    med_int :: fid4, n4, cret4, lmesh4, typen4
    med_int :: oexist4, class4
    fid4 = fid
    ! class4 = 1 <=> field type
    class4 = 1_4 
    ! On verifie que le champ existe bien avant d'appeler mfdfin
    ! pour eviter les "Erreur à l'ouverture du groupe" dans MED
    call mfioex(fid4, class4, cha, oexist4, cret4)
    if (oexist4.eq.1) then
        call mfdfin(fid4, cha, ma, lmesh4, typen4,&
                    cunit, cname, dtunit, n4, cret4)
        n = n4
        cret = cret4
    else
        n = 0
        cret = -1
    endif

#else
    aster_int :: lmesh, typen
    aster_int :: oexist, class
    ! class = 1 <=> field type
    class = 1
    ! On verifie que le champ existe bien avant d'appeler mfdfin
    ! pour eviter les "Erreur à l'ouverture du groupe" dans MED
    call mfioex(fid, class, cha, oexist, cret)
    if (oexist.eq.1) then
        call mfdfin(fid, cha, ma, lmesh, typen,&
                    cunit, cname, dtunit, n, cret)
    else
        n = 0
        cret = -1
    endif
#endif
!
#endif
end subroutine
