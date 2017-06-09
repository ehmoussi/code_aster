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

subroutine dfc_save_dime(sdcont      , mesh        , model_ndim, nb_cont_zone, nb_cont_surf,&
                         nb_cont_elem, nb_cont_node)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/dimeco.h"
#include "asterfort/dimecz.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: mesh
    character(len=8), intent(in) :: sdcont
    integer, intent(in) :: model_ndim
    integer, intent(in) :: nb_cont_zone
    integer, intent(in) :: nb_cont_surf
    integer, intent(in) :: nb_cont_elem
    integer, intent(in) :: nb_cont_node
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_CONTACT
!
! Save contact counters
!
! --------------------------------------------------------------------------------------------------
!
! In  sdcont           : name of contact concept (DEFI_CONTACT)
! In  mesh             : name of mesh
! In  model_ndim       : dimension of model
! In  nb_cont_zone     : number of zones of contact
! In  nb_cont_surf     : number of surfaces of contact
! In  nb_cont_elem     : number of elements of contact
! In  nb_cont_node     : number of nodes of contact
!
! --------------------------------------------------------------------------------------------------
!

!
! - Save contact counters - Counters by zone
!
    call dimecz(sdcont, mesh, nb_cont_zone)
!
! - Save contact counters - Total counters
!
    call dimeco(sdcont      , model_ndim, nb_cont_zone, nb_cont_surf, nb_cont_elem,&
                nb_cont_node)
!
end subroutine
