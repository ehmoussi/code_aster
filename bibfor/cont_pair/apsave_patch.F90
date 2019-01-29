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

subroutine apsave_patch(mesh             ,  sdappa         ,  i_zone       ,&
                        patch_weight_t   , nb_proc         , list_pair_zmpi,&
                        list_nbptit_zmpi , list_ptitsl_zmpi,                &
                        nb_pair_zmpi     , list_pair_zone  , list_nbptit_zone,&
                        list_ptitsl_zone , nb_pair_zone    , i_proc)
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8nnem.h"
#include "asterfort/assert.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/sdmpic.h"
#include "asterfort/wkvect.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/jedetr.h"
!
!
    character(len=8), intent(in) :: mesh
    character(len=19), intent(in) :: sdappa
    integer, intent(in) :: i_zone
    real(kind=8), intent(in) :: patch_weight_t(*)
    integer, intent(inout) :: nb_pair_zone
    integer, pointer :: list_pair_zone(:)
    integer, pointer :: list_nbptit_zone(:)
    real(kind=8), pointer :: list_ptitsl_zone(:)
    integer, pointer :: nb_pair_zmpi(:)
    integer, pointer :: list_pair_zmpi(:)
    integer, pointer :: list_nbptit_zmpi(:)
    real(kind=8), pointer :: list_ptitsl_zmpi(:)
    integer, intent(in) :: nb_proc
    integer, intent(in) :: i_proc
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing segment to segment
!
! Save values for patch
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  sdappa           : name of pairing datastructure
! In  i_zone           : index of contact zone
! In  pair_tole        : tolerance for pairing
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_patch, patch_indx, patch_jdec, nb_patch, deca, idx_start, idx_end
    integer :: i_proc2, nb_pair_init
    integer, pointer :: v_mesh_lpatch(:) => null()
    character(len=24) :: sdappa_wpat,njv_aux,njv_aux2,njv_aux3
    real(kind=8), pointer :: v_sdappa_wpat(:) => null()
    integer, pointer :: v_sdappa_dcl(:) => null()
    integer, pointer :: list_tmp(:) => null()
    integer, pointer :: list_tmp2(:) => null()
    real(kind=8), pointer :: list_tmp3(:) => null()
    integer, pointer :: list_aux(:) => null()
    integer, pointer :: list_aux2(:) => null()
    real(kind=8), pointer :: list_aux3(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
!
! - Access to patch
!
    call jeveuo(jexnum(mesh//'.PATCH',1), 'L', vi = v_mesh_lpatch)
    call jeveuo(sdappa(1:19)//'.DCL', 'L', vi = v_sdappa_dcl)
    nb_patch   = v_mesh_lpatch(2*(v_sdappa_dcl(i_zone)-1)+2)
    patch_jdec = v_mesh_lpatch(2*(v_sdappa_dcl(i_zone)-1)+1)-1

!
! - MPI control
!
    njv_aux = sdappa(1:19)//'.AUX '
    njv_aux2 = sdappa(1:19)//'.AUX2 '
    njv_aux3 = sdappa(1:19)//'.AUX3 '
    nb_pair_init=0
    call sdmpic('SD_APPA_LAC1', sdappa)
!
! - Not first contact element
!
    if (nb_pair_zone .ne. 0) then
!
! ----- Get old contact elements and copy them in temporary one
!
        nb_pair_init = nb_pair_zone
        AS_ALLOCATE(vi = list_tmp, size = 3*nb_pair_init)
        AS_ALLOCATE(vi = list_tmp2, size = nb_pair_init)
        AS_ALLOCATE(vr = list_tmp3, size = 16*nb_pair_init)
        list_tmp(1:3*nb_pair_init)   = list_pair_zone(1:3*nb_pair_init)
        list_tmp2(1:nb_pair_init)    = list_nbptit_zone(1:nb_pair_init)
        list_tmp3(1:16*nb_pair_init) = list_ptitsl_zone(1:16*nb_pair_init)
    end if
    do i_proc2=1, nb_proc
        nb_pair_zone=nb_pair_zone+nb_pair_zmpi(i_proc2)
    end do
    if (nb_pair_zone .ne. 0) then
!
! - Re-allocate list of contact elements
!
        AS_DEALLOCATE(vi = list_pair_zone)
        AS_ALLOCATE(vi = list_pair_zone, size = 3*nb_pair_zone)
        AS_DEALLOCATE(vi = list_nbptit_zone)
        AS_ALLOCATE(vi = list_nbptit_zone, size = nb_pair_zone)
        AS_DEALLOCATE(vr = list_ptitsl_zone)
        AS_ALLOCATE(vr = list_ptitsl_zone, size = 16*nb_pair_zone)
        call wkvect(njv_aux,"V V I", 3*nb_pair_zone, vi=list_aux)
        call wkvect(njv_aux2,"V V I", nb_pair_zone, vi=list_aux2)
        call wkvect(njv_aux3,"V V R", 16*nb_pair_zone, vr=list_aux3)

!
! ----- Add new pairs
!
        deca = 0
        do i_proc2 = 1, i_proc
            deca = deca + nb_pair_zmpi(i_proc2)
        end do
        if (nb_pair_zmpi(i_proc+1).ne.0) then
            idx_start = 1 + 3*(deca+nb_pair_init)
            idx_end   = 3*(nb_pair_zmpi(i_proc+1) + deca + nb_pair_init)
            ASSERT(idx_end-idx_start+1 .eq. 3*nb_pair_zmpi(i_proc+1))
            list_aux(idx_start:idx_end)=list_pair_zmpi(1:3*nb_pair_zmpi(i_proc+1))
            idx_start = 1 + (deca+nb_pair_init)
            idx_end   = (nb_pair_zmpi(i_proc+1) + deca + nb_pair_init)
            list_aux2(idx_start:idx_end) = list_nbptit_zmpi(1:nb_pair_zmpi(i_proc+1))
            idx_start = 1 + 16*(deca+nb_pair_init)
            idx_end   = 16*(nb_pair_zmpi(i_proc+1) + deca + nb_pair_init)
            list_aux3(idx_start:idx_end) = list_ptitsl_zmpi(1:16*nb_pair_zmpi(i_proc+1))
        endif
        call sdmpic('SD_APPA_LAC2', sdappa)

        list_pair_zone(:)   = list_aux(:)
        list_nbptit_zone(:) = list_aux2(:)
        list_ptitsl_zone(:) = list_aux3(:)
!
! ----- Copy old pairs
!
        list_pair_zone(1:3*nb_pair_init)    = list_tmp(1:3*nb_pair_init)
        list_nbptit_zone(1:nb_pair_init)    = list_tmp2(1:nb_pair_init)
        list_ptitsl_zone(1:16*nb_pair_init) = list_tmp3(1:16*nb_pair_init)
    end if
!
! - Access to pairing datastructures
!
    sdappa_wpat = sdappa(1:19)//'.WPAT'
    call jeveuo(sdappa_wpat, 'E', vr = v_sdappa_wpat)
!
! - Init
!
    do i_patch = 1, nb_patch
        patch_indx = i_patch-1+patch_jdec
        v_sdappa_wpat(patch_indx) = patch_weight_t(patch_indx)
    end do

    if (nb_pair_zone .ne. 0) then
        call jedetr(njv_aux)
        call jedetr(njv_aux2)
        call jedetr(njv_aux3)
        AS_DEALLOCATE(vi = list_tmp)
        AS_DEALLOCATE(vi = list_tmp2)
        AS_DEALLOCATE(vr = list_tmp3)
    end if
!
end subroutine
