! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine comp_meta_pvar(model, compor_cart, compor_info)
!
use Metallurgy_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/lcdiscard.h"
#include "asterc/lccree.h"
#include "asterc/lcvari.h"
#include "asterfort/assert.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/dismoi.h"
#include "asterfort/etenca.h"
#include "asterfort/jecrec.h"
#include "asterfort/jecroc.h"
#include "asterfort/jedema.h"
#include "asterfort/jeecra.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/jexatr.h"
#include "asterfort/wkvect.h"
!
character(len=8), intent(in) :: model
character(len=19), intent(in) :: compor_cart
character(len=19), intent(in) :: compor_info
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (metallurgy)
!
! Prepare informations about internal variables
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  compor_info      : name of object for information about internal variables and comportement
! In  compor_cart      : name of <CARTE> COMPOR
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_zone_read
    character(len=8) :: mesh
    character(len=19) :: ligrmo
    integer, pointer :: v_info(:) => null()
    integer, pointer :: v_zone(:) => null()
    integer, pointer :: v_zone_read(:) => null()
    integer, pointer :: v_model_elem(:) => null()
    character(len=16), pointer :: v_vari(:) => null()
    character(len=16), pointer :: v_rela(:) => null()
    character(len=16), pointer :: v_compor_vale(:) => null()
    integer, pointer :: v_compor_desc(:) => null()
    integer, pointer :: v_compor_lima(:) => null()
    integer, pointer :: v_compor_lima_lc(:) => null()
    integer, pointer :: v_compor_ptma(:) => null()
    integer :: nb_vale, nb_cmp_max, nb_zone, nb_vari, nt_vari, nb_vari_maxi, nb_zone_acti
    integer :: i_zone, i_elem, nb_elem_mesh, iret, nume_comp
    character(len=16) :: phase_type, model_meta
    integer :: nb_comp_elem, nb_vari_max
    character(len=16) :: comp_elem(2), comp_code_py
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    nb_zone_acti = 0
!
! - Access to mesh
!
    call dismoi('NOM_MAILLA'  , compor_cart, 'CARTE'   , repk=mesh)
    call dismoi('NB_MA_MAILLA', mesh       , 'MAILLAGE', repi=nb_elem_mesh)
!
! - Access to model
!
    ligrmo = model(1:8)//'.MODELE'
    call jeveuo(model//'.MAILLE', 'L', vi = v_model_elem)
!
! - Access to COMPOR
!
    call jeveuo(compor_cart//'.DESC', 'L', vi   = v_compor_desc)
    call jeveuo(compor_cart//'.VALE', 'L', vk16 = v_compor_vale)
    call jelira(compor_cart//'.VALE', 'LONMAX', nb_vale)
    call jeveuo(jexnum(compor_cart//'.LIMA', 1), 'L', vi = v_compor_lima)
    call jeveuo(jexatr(compor_cart//'.LIMA', 'LONCUM'), 'L', vi = v_compor_lima_lc)
    nb_zone    = v_compor_desc(3)
    nb_cmp_max = nb_vale/v_compor_desc(2)
!
! - Extend field on model
!
    call etenca(compor_cart, ligrmo, iret)
    call jeveuo(compor_cart//'.PTMA', 'L', vi = v_compor_ptma)
!
! - Create list of zones: for each zone (in CARTE), how many elements 
!
    call wkvect(compor_info(1:19)//'.ZONE', 'V V I', nb_zone, vi = v_zone)
!
! - Count number of elements by zone (in CARTE)
!
    do i_elem = 1, nb_elem_mesh
        i_zone = v_compor_ptma(i_elem)
        if (i_zone .ne. 0 .and. v_model_elem(i_elem) .ne. 0) then
            v_zone(i_zone) = v_zone(i_zone)+1
        endif
    end do
!
! - Count total of internal variables
!
    nt_vari     = 0
    nb_vari_max = 0
    do i_zone = 1, nb_zone
        read (v_compor_vale(nb_cmp_max*(i_zone-1)+2),'(I16)') nb_vari
        nt_vari      = nt_vari+nb_vari
        nb_vari_maxi = max(nb_vari_maxi,nb_vari)
    end do
    AS_ALLOCATE(vi = v_zone_read, size = nb_zone)
!
! - No internal variables names
!
    if (nt_vari .eq. 0) then
        goto 99
    endif
!
! - Create list of comportment information
!
    call wkvect(compor_info(1:19)//'.RELA', 'V V K16', 2*nb_zone, vk16 = v_rela)
!
! - Create list of internal variables names
!
    call jecrec(compor_info(1:19)//'.VARI', 'V V K16', 'NU', 'DISPERSE', 'VARIABLE', nb_zone)
    do i_zone = 1, nb_zone
        call jecroc(jexnum(compor_info(1:19)//'.VARI', i_zone))
    end do
! 
    do i_elem = 1, nb_elem_mesh
! ----- Get current zone
        i_zone = v_compor_ptma(i_elem)
        if (i_zone .eq. 0) then
            l_zone_read = .true.
        else
            ASSERT(i_zone .ne. 0)
            l_zone_read = v_zone_read(i_zone) .eq. 1
        endif
        if (.not. l_zone_read) then
! --------- Get parameters
            phase_type = v_compor_vale(nb_cmp_max*(i_zone-1)+1)
            model_meta = v_compor_vale(nb_cmp_max*(i_zone-1)+3)
            read (v_compor_vale(nb_cmp_max*(i_zone-1)+2),'(I16)') nb_vari
            read (v_compor_vale(nb_cmp_max*(i_zone-1)+4),'(I16)') nume_comp
! --------- Create composite comportment
            nb_comp_elem = 2
            comp_elem(1) = phase_type
            comp_elem(2) = model_meta
            call lccree(nb_comp_elem, comp_elem, comp_code_py)
! --------- Save names of relation
            v_rela(2*(i_zone-1) + 1) = phase_type
            v_rela(2*(i_zone-1) + 2) = model_meta
! --------- Save name of internal variables
            call jeecra(jexnum(compor_info(1:19)//'.VARI', i_zone), 'LONMAX', nb_vari)
            call jeveuo(jexnum(compor_info(1:19)//'.VARI', i_zone), 'E', vk16 = v_vari)
            call lcvari(comp_code_py, nb_vari, v_vari)
            call lcdiscard(comp_code_py)
! --------- Save current zone
            v_zone_read(i_zone) = 1
            nb_zone_acti        = nb_zone_acti + 1
        endif
    end do
!
 99 continue
!
! - Save general information
!
    call wkvect(compor_info(1:19)//'.INFO', 'V V I', 5, vi = v_info)
    v_info(1) = nb_elem_mesh
    v_info(2) = nb_zone
    v_info(3) = nb_vari_maxi
    v_info(4) = nt_vari
    v_info(5) = nb_zone_acti
!
    AS_DEALLOCATE(vi = v_zone_read)
!
    call jedema()
!
end subroutine
