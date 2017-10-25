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

subroutine mm_cycl_init_lac(mesh,ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/cfdisi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jelira.h"
#include "asterfort/jexnum.h"
#include "asterfort/mminfi.h"
#include "asterfort/mminfl.h"
#include "asterfort/mminfm.h"
#include "asterfort/mminfr.h"
!
! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
!
    type(NL_DS_Contact), intent(inout) :: ds_contact
    character(len=8), intent(in) :: mesh
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve - Cycling
!
! Initialization of data structures
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_contact       : datastructure for contact management
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: sdcont_cyclac_etat
    integer, pointer :: v_sdcont_cyclac_etat(:) => null()
    character(len=24) :: sdcont_cyclac_hist
    real(kind=8), pointer :: v_sdcont_cyclac_hist(:) => null()
    character(len=24) :: sdcont_stat_prev
    integer, pointer :: v_sdcont_stat_prev(:) => null()
    integer, pointer :: v_mesh_comapa(:) => null()
    integer, pointer :: v_mesh_lpatch(:) => null()
    integer :: nt_patch, nb_cont_zone, nb_elem
    integer :: i_cont_zone, i_patch,j_patch,nb_patch
    integer :: hist_index
    
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    nb_cont_zone = cfdisi(ds_contact%sdcont_defi,'NZOCO' )
    nt_patch     = ds_contact%nt_patch
!
! - Access to mesh
!
    call jeveuo(mesh//'.COMAPA', 'L' , vi = v_mesh_comapa)
    call jelira(mesh//'.COMAPA', 'LONMAX', nb_elem)
!
! - Access to mesh (patches)
!
    call jeveuo(jexnum(mesh//'.PATCH',1), 'L', vi = v_mesh_lpatch)
!
! - Access to cycling objects
!
    sdcont_stat_prev = ds_contact%sdcont_solv(1:14)//'.CYCL'
    sdcont_cyclac_etat = ds_contact%sdcont_solv(1:14)//'.CYCE'
    sdcont_cyclac_hist = ds_contact%sdcont_solv(1:14)//'.CYCH'

    call jeveuo(sdcont_stat_prev, 'E', vi = v_sdcont_stat_prev)
    call jeveuo(sdcont_cyclac_etat, 'E', vi = v_sdcont_cyclac_etat)
    call jeveuo(sdcont_cyclac_hist, 'E', vr = v_sdcont_cyclac_hist)
!
! - Init history

!
! - Loop on contact zones
!
    do i_cont_zone = 1, nb_cont_zone
!
! ----- Get access to patch
!
        nb_patch = v_mesh_lpatch((i_cont_zone-1)*2+2)
        j_patch  = v_mesh_lpatch((i_cont_zone-1)*2+1)

!
! ----- Loop on patches
!
        do i_patch = 1, nb_patch
           v_sdcont_cyclac_etat(j_patch-2+i_patch) = -2
           v_sdcont_stat_prev(j_patch-2+i_patch) = -1
           do hist_index = 1,22
              v_sdcont_cyclac_hist(22*(j_patch-2+i_patch-1)+hist_index) = 0.d0  
           enddo
        
        enddo
    enddo
!

!
    call jedema()
end subroutine
