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
!
subroutine mateMFrontAddElasticity(l_mfront_func, l_mfront_anis,&
                                   mate         , i_mate_add   ,&
                                   mfront_nbvale, mfront_prop  ,&
                                   mfront_valr  , mfront_valk)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/codent.h"
#include "asterfort/jeecra.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/mateMFrontToAsterProperties.h"
!
aster_logical, intent(in) :: l_mfront_func, l_mfront_anis
character(len=8), intent(in) :: mate
integer, intent(in) :: i_mate_add
integer, intent(in) :: mfront_nbvale
character(len=16), intent(in) :: mfront_prop(16)
real(kind=8), intent(in) :: mfront_valr(16)
character(len=16), intent(in) :: mfront_valk(16)
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_MATERIAU
!
! Add elasticity parameters from MFront parameters
!
! --------------------------------------------------------------------------------------------------
!
! In  l_mfront_func    : .TRUE. if MFront properties are functions
! In  l_mfront_anis    : .TRUE. if MFront properties are anisotropic
! In  i_mate_add       : index of material to add
! In  mate             : name of output datastructure
! In  mfront_nbvale    : number of properties for NOMRC
! In  mfront_prop      : name of properties for NOMRC
! In  mfront_valr      : values of properties for NOMRC (real)
! In  mfront_valk      : values of properties for NOMRC (function)
!
! --------------------------------------------------------------------------------------------------
!
    character(len=6) :: nom
    character(len=32) :: nomrc_mfront
    character(len=19) :: noobrc_add
    integer :: nb_prop, i_prop, i_mfront, nb_prop_r, nb_prop_c, nb_prop_k
    character(len=16) :: mf_prop_name, cv_prop_name
    character(len=32), pointer :: v_mate(:) => null()
    character(len=16), pointer :: v_mate_valk(:) => null()
    complex(kind=8), pointer :: v_mate_valc(:) => null()
    real(kind=8), pointer :: v_mate_valr(:) => null()
    character(len=16), pointer :: v_prop_func(:) => null()
    character(len=16), pointer :: v_prop_name(:) => null()
    real(kind=8), pointer :: v_prop_valr(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    i_prop  = 0
!
! - Not elasticity: MassDensity and ThermalExpansion
!
    nb_prop = 0
    do i_mfront = 1, mfront_nbvale
! ----- Get property for MFront/Elasticity
        mf_prop_name = mfront_prop(i_mfront)
        call mateMFrontToAsterProperties(mf_prop_name, cv_prop_name)
        if (cv_prop_name .eq. 'ALPHA') then
            nb_prop = nb_prop + 1
            if (l_mfront_anis) then
                call utmess('F', 'MATERIAL2_16')
            endif
        endif
        if (cv_prop_name .eq. 'RHO') then
            nb_prop = nb_prop + 1
        endif
    end do
    ASSERT(nb_prop .le. 2)
!
! - Set elasticity type and count properties
!
    if (l_mfront_func) then
        if (l_mfront_anis) then
            nomrc_mfront = 'ELAS_ORTH_FO'
            nb_prop      = nb_prop + 9
        else
            nomrc_mfront = 'ELAS_FO'
            nb_prop      = nb_prop + 2
        endif
    else
        if (l_mfront_anis) then
            nomrc_mfront = 'ELAS_ORTH'
            nb_prop      = nb_prop + 9
        else
            nomrc_mfront = 'ELAS'
            nb_prop      = nb_prop + 2
        endif
    endif
!
! - Add new material
!
    call jeveuo(mate//'.MATERIAU.NOMRC', 'E', vk32 = v_mate)
    v_mate(i_mate_add) = nomrc_mfront
!
! - Prepare working vectors
!
    AS_ALLOCATE(vk16 = v_prop_name, size = nb_prop)
    AS_ALLOCATE(vk16 = v_prop_func, size = nb_prop)
    AS_ALLOCATE(vr   = v_prop_valr, size = nb_prop)
!
! - Get properties
!
    do i_mfront = 1, mfront_nbvale
! ----- Find name of property for ELAS
        mf_prop_name = mfront_prop(i_mfront)
        call mateMFrontToAsterProperties(mf_prop_name, cv_prop_name)
! ----- Add property
        i_prop = i_prop + 1
        ASSERT(i_prop .le. nb_prop)
        v_prop_name(i_prop) = cv_prop_name
        v_prop_func(i_prop) = mfront_valk(i_mfront)
        v_prop_valr(i_prop) = mfront_valr(i_mfront)
    end do
!
! - Add material
!
    call codent(i_mate_add, 'D0', nom)
    noobrc_add = mate//'.CPT.'//nom
    call wkvect(noobrc_add//'.VALR', 'G V R', nb_prop, vr = v_mate_valr)
    call wkvect(noobrc_add//'.VALC', 'G V C', nb_prop, vc = v_mate_valc)
    call wkvect(noobrc_add//'.VALK', 'G V K16', 2*nb_prop, vk16 = v_mate_valk)
!
! - Create properties
!
    nb_prop_r = 0
    nb_prop_c = 0
    nb_prop_k = 0
    do i_prop = 1, nb_prop
! ----- Set properties
        v_mate_valk(i_prop) = v_prop_name(i_prop)
        if (l_mfront_func) then
            nb_prop_k = nb_prop_k + 1
            v_mate_valk(nb_prop+nb_prop_k) = v_prop_func(i_prop)
        else
            nb_prop_r = nb_prop_r + 1
            v_mate_valr(nb_prop_r) = v_prop_valr(i_prop)
        endif
! ----- Update length for one material factor keyword
        call jeecra(noobrc_add//'.VALR', 'LONUTI', nb_prop_r)
        call jeecra(noobrc_add//'.VALC', 'LONUTI', nb_prop_c)
        call jeecra(noobrc_add//'.VALK', 'LONUTI', nb_prop_r+nb_prop_c+2*nb_prop_k)
    end do
!
! - Clean
!
    AS_DEALLOCATE(vk16 = v_prop_name)
    AS_DEALLOCATE(vk16 = v_prop_func)
    AS_DEALLOCATE(vr   = v_prop_valr)
!
end subroutine
