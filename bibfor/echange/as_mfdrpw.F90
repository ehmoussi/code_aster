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

subroutine as_mfdrpw(fid, cha, val, intlac, n,&
                     locname, numco, profil, pflmod, typent,&
                     typgeo, numdt, dt, numo, cret)
! person_in_charge: nicolas.sellenet at edf.fr
!
!
    implicit none
#include "asterf_types.h"
#include "asterf.h"
#include "asterfort/utmess.h"
#include "med/mfdrpw.h"
    character(len=*) :: cha, profil, locname
    aster_int :: fid, n, pflmod, typent, typgeo, cret
    aster_int :: intlac, numco, numdt, numo
    real(kind=8) :: dt
    real(kind=8) :: val(*)
#ifdef _DISABLE_MED
    call utmess('F', 'FERMETUR_2')
#else
!
#if med_int_kind != aster_int_kind
    med_int :: fid4, n4, pflmo4, typen4, typge4, cret4
    med_int :: intla4, numco4, numdt4, numo4
    fid4 = fid
    n4 = n
    pflmo4 = pflmod
    typen4 = typent
    typge4 = typgeo
    intla4 = intlac
    numco4 = numco
    numdt4 = numdt
    numo4 = numo
    call mfdrpw(fid4, cha, numdt4, numo4, dt,&
                typen4, typge4, pflmo4, profil, locname,&
                intla4, numco4, n4, val, cret4)
    cret = cret4
#else
    call mfdrpw(fid, cha, numdt, numo, dt,&
                typent, typgeo, pflmod, profil, locname,&
                intlac, numco, n, val, cret)
#endif
!
#endif
end subroutine
