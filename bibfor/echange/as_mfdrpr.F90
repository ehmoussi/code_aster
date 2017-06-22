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

subroutine as_mfdrpr(fid, cha, val, intlac, numco,&
                     profil, pflmod, typent, typgeo, numdt,&
                     numo, cret)
! person_in_charge: nicolas.sellenet at edf.fr
!
!
    implicit none
#include "asterf_types.h"
#include "asterf.h"
#include "asterfort/utmess.h"
#include "med/mfdrpr.h"
    character(len=*) :: cha, profil
    aster_int :: fid, typent, typgeo, cret
    aster_int :: intlac, numco, numdt, numo, pflmod
    real(kind=8) :: val(*)
#ifdef _DISABLE_MED
    call utmess('F', 'FERMETUR_2')
#else
!
#if med_int_kind != aster_int_kind
    med_int :: fid4, typen4, typge4, cret4
    med_int :: intla4, numco4, numdt4, numo4, pflmo4
    fid4 = fid
    typen4 = typent
    typge4 = typgeo
    intla4 = intlac
    numco4 = numco
    numdt4 = numdt
    numo4 = numo
    pflmo4 = pflmod
    call mfdrpr(fid4, cha, numdt4, numo4, typen4,&
                typge4, pflmo4, profil, intla4, numco4,&
                val, cret4)
    cret = cret4
#else
    call mfdrpr(fid, cha, numdt, numo, typent,&
                typgeo, pflmod, profil, intlac, numco,&
                val, cret)
#endif
!
#endif
end subroutine
