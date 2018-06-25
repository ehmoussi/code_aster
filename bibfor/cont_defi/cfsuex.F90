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

subroutine cfsuex(sdcont_defi, v_list_excl, nb_excl, nb_cont_zone)
!
implicit none
!
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
#include "asterfort/wkvect.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=24), intent(in) :: sdcont_defi
    integer, pointer :: v_list_excl(:)
    integer, intent(in) :: nb_excl
    integer, intent(in) :: nb_cont_zone
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_CONTACT
!
! QUAD8 linear relations - Suppress nodes by add in SANS_* datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  sdcont_defi      : name of contact definition datastructure (from DEFI_CONTACT)
! In  v_list_excl      : list of nodes to exclude
! In  nb_excl          : number of nodes to exclude
! In  nb_cont_zone     : number of zones of contact
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_node, i_zone, i_excl, i_node_new
    integer :: nb_node_old, nb_node_new, nb_sans
    character(len=24) :: sdcont_ssnoco
    integer, pointer :: v_sdcont_ssnoco(:) => null()
    character(len=24) :: sdcont_pssnoco
    integer, pointer :: v_sdcont_pssnoco(:) => null()
    integer, pointer :: v_ssnoco(:) => null()
    integer, pointer :: v_pssnoco(:) => null()
!
! --------------------------------------------------------------------------------------------------
!

!
! - Access to datastructure
!
    sdcont_ssnoco  = sdcont_defi(1:16)//'.SSNOCO'
    sdcont_pssnoco = sdcont_defi(1:16)//'.PSSNOCO'
    call jeveuo(sdcont_ssnoco , 'E', vi=v_sdcont_ssnoco)
    call jeveuo(sdcont_pssnoco, 'E', vi=v_sdcont_pssnoco)
    call jelira(sdcont_ssnoco, 'LONMAX', ival=nb_sans)
!
! - Copy vectors
!
    AS_ALLOCATE(vi=v_ssnoco , size=nb_sans)
    AS_ALLOCATE(vi=v_pssnoco, size=nb_cont_zone+1)
    v_ssnoco(1:nb_sans)  = v_sdcont_ssnoco(1:nb_sans)
    do i_node = 1, nb_cont_zone + 1
        v_pssnoco(1:nb_cont_zone + 1) = v_sdcont_pssnoco(1:nb_cont_zone + 1)
    end do
!
! - Destruct objects
!
    call jedetr(sdcont_ssnoco)
    call jedetr(sdcont_pssnoco)
!
! - Create new objects
!
    call wkvect(sdcont_ssnoco , 'G V I', nb_sans+nb_excl*nb_cont_zone, vi=v_sdcont_ssnoco)
    call wkvect(sdcont_pssnoco, 'G V I', nb_cont_zone+1              , vi=v_sdcont_pssnoco)
    i_node_new = 1
    v_sdcont_pssnoco(1) = 0
    do i_zone = 1, nb_cont_zone
        nb_node_old = v_pssnoco(i_zone+1) - v_pssnoco(i_zone)
        do i_excl = 1, nb_node_old
            v_sdcont_ssnoco(i_node_new) = v_ssnoco(v_pssnoco(i_zone)+i_excl)
            i_node_new = i_node_new + 1
        end do
        do i_excl = 1, nb_excl
            v_sdcont_ssnoco(i_node_new) = v_list_excl(i_excl)
            i_node_new = i_node_new + 1
        end do
        nb_node_new = nb_node_old + nb_excl
        v_sdcont_pssnoco(i_zone+1) = v_sdcont_pssnoco(i_zone) + nb_node_new
    end do
!
! - Clean
!
    AS_DEALLOCATE(vi=v_ssnoco)
    AS_DEALLOCATE(vi=v_pssnoco)
!
end subroutine
