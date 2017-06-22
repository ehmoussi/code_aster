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

subroutine as_mlclci(fid, nordr, k64, ityp, nbn,&
                     ndim, nomasu, cret)
! person_in_charge: nicolas.sellenet at edf.fr
!
!
    implicit none
#include "asterf_types.h"
#include "asterf.h"
#include "asterfort/utmess.h"
#include "med/mlclci.h"
    aster_int :: fid, nordr, ityp, nbn, cret, ndim, tymasu, nbmasu
    character(len=64) :: k64, giname
    character(len=*) :: nomasu
#ifdef _DISABLE_MED
    call utmess('F', 'FERMETUR_2')
#else
!
#if med_int_kind != aster_int_kind
    med_int :: fid4, nordr4, ityp4, nbn4, cret4, ndim4, tymas4, nbmas4
    fid4 = fid
    nordr4 = nordr
    call mlclci(fid4, nordr4, k64, ityp4, ndim4,&
                nbn4, giname, nomasu, nbmas4, tymas4,&
                cret4)
    ityp = ityp4
    nbn = nbn4
    cret = cret4
    ndim = ndim4
    nbmasu = nbmas4
#else
    call mlclci(fid, nordr, k64, ityp, ndim,&
                nbn, giname, nomasu, nbmasu, tymasu,&
                cret)
#endif
!
#endif
end subroutine
