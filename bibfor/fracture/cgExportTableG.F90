! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
!
! person_in_charge: nicolas.pignet at edf.fr
!
subroutine cgExportTableG(cgField, cgTheta)
!
use calcG_type
!
    implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/cgtabl.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/titre.h"
!
    type(CalcG_field), intent(in) :: cgField
    type(CalcG_theta), intent(in) :: cgTheta
!
! --------------------------------------------------------------------------------------------------
!
!     CALC_G --- Utilities
!
!     Export table container
!
! --------------------------------------------------------------------------------------------------
!
!
    integer :: nb_objet, icham
    character(len=16), pointer :: obje_name(:) => null()
    character(len=24), pointer :: obje_sdname(:) => null()
    character(len=24), pointer :: v_chtheta(:) => null()
!
    call jemarq()
!
! --- Create table_container to store (calc_g and cham_theta)
!
    AS_ALLOCATE(vk16=obje_name, size=cgTheta%nb_theta_field+2)
    AS_ALLOCATE(vk24=obje_sdname, size=cgTheta%nb_theta_field+2)
!
    obje_name(1)   = "TABLE_G"
    obje_sdname(1) = cgField%table_g
    nb_objet       = 1
!
    if (cgField%ndim == 2) then
        nb_objet              = nb_objet + 1
        obje_name(nb_objet)   = "NB_CHAM_THETA"
        obje_sdname(nb_objet) = " "
        nb_objet              = nb_objet + 1
        obje_name(nb_objet)   = "CHAM_THETA"
        obje_sdname(nb_objet) = cgTheta%theta_field
    else if (cgField%ndim == 3) then
        ASSERT(cgTheta%nb_theta_field == 0)
        !call jeveuo(cgTheta%theta_field, 'L', vk24=v_chtheta)
        nb_objet              = nb_objet + 1
        obje_name(nb_objet)   = "NB_CHAM_THETA"
        obje_sdname(nb_objet) = " "
        do icham = 1, cgTheta%nb_theta_field
            nb_objet              = nb_objet + 1
            obje_name(nb_objet)   = "CHAM_THETA"
            obje_sdname(nb_objet) = v_chtheta(icham)
        end do
    else
        ASSERT(ASTER_FALSE)
    end if
!
    call cgtabl(cgField%table_out, nb_objet, obje_name, obje_sdname, cgTheta%nb_theta_field)
    AS_DEALLOCATE(vk16=obje_name)
    AS_DEALLOCATE(vk24=obje_sdname)
!
    call titre()
!
    call jedema()
!
end subroutine
