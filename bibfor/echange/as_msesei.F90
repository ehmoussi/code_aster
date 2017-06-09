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

subroutine as_msesei(idfimd, imasup, nomaes, nvtymd, dimest,&
                     nomasu, medcel, nbnosu, nbmssu, tygems,&
                     nbattc, prespr, nbattv, codret)
! person_in_charge: nicolas.sellenet at edf.fr
!
!
    implicit none
#include "asterf_types.h"
#include "asterf.h"
#include "asterfort/utmess.h"
#include "med/msesei.h"
    character(len=*) :: nomaes, nomasu
    aster_int :: idfimd, imasup, nvtymd, dimest, medcel, nbnosu
    aster_int :: nbmssu, tygems, nbattc, prespr, nbattv, codret
#ifdef _DISABLE_MED
    call utmess('F', 'FERMETUR_2')
#else
!
#if med_int_kind != aster_int_kind
    med_int :: idfim4, imasu4, nvtym4, dimes4, medce4, nbnos4
    med_int :: nbmss4, tygem4, nbatc4, presp4, nbatv4, codre4
    idfim4 = idfimd
    imasu4 = imasup
    call msesei(idfim4, imasu4, nomaes, nvtym4, dimes4,&
                nomasu, medce4, nbnos4, nbmss4, tygem4,&
                nbatc4, presp4, nbatv4, codre4)
    nvtymd = nvtym4
    dimest = dimes4
    medcel = medce4
    nbnosu = nbnos4
    nbmssu = nbmss4
    tygems = tygem4
    nbattc = nbatc4
    prespr = presp4
    nbattv = nbatv4
    codret = codre4
#else
    call msesei(idfimd, imasup, nomaes, nvtymd, dimest,&
                nomasu, medcel, nbnosu, nbmssu, tygems,&
                nbattc, prespr, nbattv, codret)
#endif
!
#endif
end subroutine
