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

subroutine as_mmheaw(fid, maa, nom, n, typent,&
                     typgeo, cret)
! person_in_charge: nicolas.sellenet at edf.fr
!
!
    implicit none
#include "asterf_types.h"
#include "asterf.h"
#include "asterfort/utmess.h"
#include "med/mmheaw.h"
    character(len=*) :: maa
    character(len=*) :: nom
    aster_int :: fid, typent, typgeo, cret, mdnont, mdnoit
    aster_int :: n
#ifdef _DISABLE_MED
    call utmess('F', 'FERMETUR_2')
#else
!
#if med_int_kind != aster_int_kind
    med_int :: fid4, typen4, typge4, cret4
    med_int :: n4, mdnon4, mdnoi4
    mdnont = -1
    mdnoit = -1
    fid4 = fid
    typen4 = typent
    typge4 = typgeo
    n4 = n
    mdnon4 = mdnont
    mdnoi4 = mdnoit
    call mmheaw(fid4, maa, mdnon4, mdnoi4, typen4,&
                typge4, n4, nom, cret4)
    cret = cret4
#else
    mdnont = -1
    mdnoit = -1
    call mmheaw(fid, maa, mdnont, mdnoit, typent,&
                typgeo, n, nom, cret)
#endif
!
#endif
end subroutine
