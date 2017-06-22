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

subroutine as_mfiope(fid, nom, acces, cret)
! person_in_charge: nicolas.sellenet at edf.fr
!
!
    implicit none
#include "asterf_types.h"
#include "asterf.h"
#include "asterfort/utmess.h"
#include "asterfort/assert.h"
#include "asterc/hdfopf.h"
#include "asterc/hdfclf.h"
#include "med/mfiope.h"
    character(len=*) :: nom
    aster_int :: acces, fid, cret
#ifdef _DISABLE_MED
    call utmess('F', 'FERMETUR_2')
#else
!
#if med_int_kind != aster_int_kind
    med_int :: acces4, fid4, cret4
#endif
    cret = 0
    ! En cas de demande d'acces en lecture, on verifie par un appel à HDF que le fichier
    ! est bien de type hdf afin d'eviter les "Erreur à l'ouverture du fichier" dans MED
    if (acces.eq.0) then
        fid = hdfopf(nom)
        if (fid.gt.0) then
            cret = hdfclf(fid)
            ASSERT(cret.eq.0)
        else
            cret = -1
        endif
    endif
    if (cret.eq.0) then
#if med_int_kind != aster_int_kind
        acces4 = acces
        call mfiope(fid4, nom, acces4, cret4)
        fid = fid4
        cret = cret4
#else
        call mfiope(fid, nom, acces, cret)
#endif
    endif
!
#endif
end subroutine
