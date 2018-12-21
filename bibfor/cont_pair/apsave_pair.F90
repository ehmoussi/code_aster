! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

subroutine apsave_pair(i_zone         , elem_slav_nume ,&
                       nb_pair        , list_pair      ,&
                       li_nbptsl      , li_ptintsl     ,&
                       li_ptintma     , li_ptgausma    ,&
                       nb_pair_zone   , list_pair_zone ,&
                       li_nbptsl_zone , li_ptintsl_zone,&
                       li_ptintma_zone, li_ptgausma_zone,&
                       nb_elem_slav   , nb_elem_mast    ,&
                       nb_next_alloc)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
!
!
    integer, intent(in) :: i_zone
    integer, intent(in) :: elem_slav_nume
    integer, intent(in) :: nb_pair
    integer, intent(in) :: nb_elem_slav
    integer, intent(in) :: nb_elem_mast
    integer, intent(inout) :: nb_next_alloc
    integer, intent(in) :: list_pair(:)
    integer, intent(in) :: li_nbptsl(:)
    real(kind=8), intent(in) :: li_ptintsl(:)
    real(kind=8), intent(in) :: li_ptintma(:)
    real(kind=8), intent(in) :: li_ptgausma(:)
    integer, intent(inout) :: nb_pair_zone
    integer, pointer :: list_pair_zone(:)
    integer, pointer :: li_nbptsl_zone(:)
    real(kind=8), pointer :: li_ptintsl_zone(:)
    real(kind=8), pointer :: li_ptintma_zone(:)
    real(kind=8), pointer :: li_ptgausma_zone(:)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing segment to segment
!
! Save current contact pairs
!
! --------------------------------------------------------------------------------------------------
!
! In  i_zone           : index of contact zone
! In  elem_slav_nume   : current index of slave element
! In  nb_pair          : number of contact pairs to add
! In  list_pair        : list of contact pairs to add
! IO  nb_pair_zone     : number of contact elements
! IO  list_pair_zone   : list of contact elements
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_pair, nb_seuil
    integer, pointer :: tmp1(:) => null()
    integer, pointer :: tmp2(:) => null()
    real(kind=8), pointer :: tmp3(:) => null()
    real(kind=8), pointer :: tmp4(:) => null()
    real(kind=8), pointer :: tmp5(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
! -----
!
    nb_seuil = 10000
    if (nb_pair_zone.eq. 0) then
        if (nb_elem_mast*nb_elem_slav .lt. nb_seuil) then
!
! - Allocate pairing saving vectors step by step
!
            AS_ALLOCATE(vi=list_pair_zone, size= 3*nb_elem_slav*nb_elem_mast)
            AS_ALLOCATE(vi=li_nbptsl_zone, size= nb_elem_slav*nb_elem_mast)
            AS_ALLOCATE(vr=li_ptintsl_zone, size= 16*nb_elem_slav*nb_elem_mast)
            AS_ALLOCATE(vr=li_ptintma_zone, size= 16*nb_elem_slav*nb_elem_mast)
            AS_ALLOCATE(vr=li_ptgausma_zone, size= 72*nb_elem_slav*nb_elem_mast)
            nb_next_alloc = 0
        else
            nb_next_alloc = int(4*nb_elem_slav*nb_elem_mast/100)
            AS_ALLOCATE(vi=list_pair_zone, size= 3*nb_next_alloc)
            AS_ALLOCATE(vi=li_nbptsl_zone, size= nb_next_alloc)
            AS_ALLOCATE(vr=li_ptintsl_zone, size= 16*nb_next_alloc)
            AS_ALLOCATE(vr=li_ptintma_zone, size= 16*nb_next_alloc)
            AS_ALLOCATE(vr=li_ptgausma_zone, size= 72*nb_next_alloc)
        endif
        do i_pair = 1, nb_pair
            list_pair_zone(3*nb_pair_zone+3*(i_pair-1)+1) = elem_slav_nume
            list_pair_zone(3*nb_pair_zone+3*(i_pair-1)+2) = list_pair(i_pair)
            list_pair_zone(3*nb_pair_zone+3*(i_pair-1)+3) = i_zone
            li_nbptsl_zone(nb_pair_zone+i_pair) = li_nbptsl(i_pair)
            li_ptintsl_zone(nb_pair_zone*16+1+(i_pair-1)*16:nb_pair_zone*16+i_pair*16) = &
            li_ptintsl(1+(i_pair-1)*16:i_pair*16)
            li_ptintma_zone(nb_pair_zone*16+1+(i_pair-1)*16:nb_pair_zone*16+i_pair*16) = &
            li_ptintma(1+(i_pair-1)*16:i_pair*16)
            li_ptgausma_zone(nb_pair_zone*72+1+(i_pair-1)*72:nb_pair_zone*72+i_pair*72) = &
            li_ptgausma(1+(i_pair-1)*72:i_pair*72)
        end do
    else
!
! ----- Add new pairs
!

        if (nb_elem_mast*nb_elem_slav .ge. nb_seuil .and.&
            (nb_pair_zone+nb_pair) .ge. nb_next_alloc) then
!
! - ReAllocate pairing saving vectors step by step
!
            AS_ALLOCATE(vi=tmp1, size=3*nb_pair_zone)
            tmp1(:) = list_pair_zone(1:3*nb_pair_zone)
            AS_ALLOCATE(vi=tmp2, size=nb_pair_zone)
            tmp2(:) = li_nbptsl_zone(1:nb_pair_zone)
            AS_ALLOCATE(vr=tmp3, size=16*nb_pair_zone)
            tmp3(:) = li_ptintsl_zone(1:nb_pair_zone*16)
            AS_ALLOCATE(vr=tmp4, size=16*nb_pair_zone)
            tmp4(:) = li_ptintma_zone(1:nb_pair_zone*16)
            AS_ALLOCATE(vr=tmp5, size=72*nb_pair_zone)
            tmp5(:) = li_ptgausma_zone(1:nb_pair_zone*72)
            AS_DEALLOCATE(vi=list_pair_zone)
            AS_DEALLOCATE(vi=li_nbptsl_zone)
            AS_DEALLOCATE(vr=li_ptintsl_zone)
            AS_DEALLOCATE(vr=li_ptintma_zone)
            AS_DEALLOCATE(vr=li_ptgausma_zone)
            nb_next_alloc = nb_next_alloc + int(4*nb_elem_slav*nb_elem_mast/100)
            AS_ALLOCATE(vi=list_pair_zone, size= 3*nb_next_alloc)
            AS_ALLOCATE(vi=li_nbptsl_zone, size= nb_next_alloc)
            AS_ALLOCATE(vr=li_ptintsl_zone, size= 16*nb_next_alloc)
            AS_ALLOCATE(vr=li_ptintma_zone, size= 16*nb_next_alloc)
            AS_ALLOCATE(vr=li_ptgausma_zone, size= 72*nb_next_alloc)
            list_pair_zone(1:3*nb_pair_zone)    = tmp1(:)
            li_nbptsl_zone(1:nb_pair_zone)      = tmp2(:)
            li_ptintsl_zone(1:nb_pair_zone*16)  = tmp3(:)
            li_ptintma_zone(1:nb_pair_zone*16)  = tmp4(:)
            li_ptgausma_zone(1:nb_pair_zone*72) = tmp5(:)
            AS_DEALLOCATE(vi=tmp1)
            AS_DEALLOCATE(vi=tmp2)
            AS_DEALLOCATE(vr=tmp3)
            AS_DEALLOCATE(vr=tmp4)
            AS_DEALLOCATE(vr=tmp5)
        endif
        do i_pair = 1, nb_pair
            list_pair_zone(3*nb_pair_zone+3*(i_pair-1)+1) = elem_slav_nume
            list_pair_zone(3*nb_pair_zone+3*(i_pair-1)+2) = list_pair(i_pair)
            list_pair_zone(3*nb_pair_zone+3*(i_pair-1)+3) = i_zone
            li_nbptsl_zone(nb_pair_zone+i_pair) = li_nbptsl(i_pair)
            li_ptintsl_zone(nb_pair_zone*16+1+(i_pair-1)*16:nb_pair_zone*16+i_pair*16) = &
            li_ptintsl(1+(i_pair-1)*16:i_pair*16)
            li_ptintma_zone(nb_pair_zone*16+1+(i_pair-1)*16:nb_pair_zone*16+i_pair*16) = &
            li_ptintma(1+(i_pair-1)*16:i_pair*16)
            li_ptgausma_zone(nb_pair_zone*72+1+(i_pair-1)*72:nb_pair_zone*72+i_pair*72) = &
            li_ptgausma(1+(i_pair-1)*72:i_pair*72)
        end do
    endif
!
! - New number of contact pairs
!
    nb_pair_zone = nb_pair_zone+nb_pair
!
end subroutine
