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

subroutine dfc_read_lac(sdcont, keywf       , mesh, model, model_ndim,&
                        ligret, nb_cont_zone)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/dfc_read_zone.h"
#include "asterfort/dfc_save_dime.h"
#include "asterfort/dfc_chck.h"
#include "asterfort/caraxi.h"
#include "asterfort/tablco.h"
#include "asterfort/utmess.h"
#include "asterfort/elimco.h"
#include "asterfort/typeco.h"
#include "asterfort/mmprel_lac.h"
!
! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
!
    character(len=8), intent(in) :: sdcont
    character(len=8), intent(in) :: mesh
    character(len=8), intent(in) :: model
    character(len=16), intent(in) :: keywf
    integer, intent(in) :: model_ndim
    character(len=19), intent(in) :: ligret
    integer, intent(in) :: nb_cont_zone
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_CONTACT
!
! LAC method - Read contact data
!
! --------------------------------------------------------------------------------------------------
!
! In  sdcont           : name of contact concept (DEFI_CONTACT)
! In  keywf            : factor keyword to read
! In  mesh             : name of mesh
! In  model            : name of model
! In  ligret           : name of special LIGREL for slave elements (CONTINUE formulation)
! In  model_ndim       : dimension of model
! In  nb_cont_zone     : number of zones of contact
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_cont_surf, nb_cont_elem, nb_cont_node, nb_node_coq3d
    aster_logical :: l_elim_coq3d
!
! --------------------------------------------------------------------------------------------------
!
    l_elim_coq3d = .false.
!
! - Read zone: nodes and elements
!
    call dfc_read_zone(sdcont      , keywf       , mesh        , model, nb_cont_zone,&
                       nb_cont_surf, nb_cont_elem, nb_cont_node)
!
! - Cleaning nodes and elements
!
    call elimco(sdcont      , mesh        , model  , nb_cont_surf,&
                nb_cont_elem, nb_cont_node, l_elim_coq3d, nb_node_coq3d_ = nb_node_coq3d)
    if (nb_node_coq3d.ne.0) then
        call utmess('F','CONTACT_94')
    endif
!
! - Inverse connectivities
!
    call tablco(sdcont, mesh, nb_cont_surf, nb_cont_elem, nb_cont_node)
!
! - Save contact counters
!
    call dfc_save_dime(sdcont      , mesh        , model_ndim, nb_cont_zone, nb_cont_surf,&
                       nb_cont_elem, nb_cont_node)
!
! - Elements and nodes parameters
!
    call typeco(sdcont, mesh) 
!
! - Some checks : ONE NODE IS COMMON TO TWO SLAVE SURFACES
!
    call dfc_chck(sdcont, mesh, model_ndim)
!
! - Check if axi-symmetric
!
    call caraxi(sdcont, model, mesh, model_ndim)
!
! - Create slave elements in model
!
    call mmprel_lac(sdcont, mesh, model, ligret)
!
end subroutine
