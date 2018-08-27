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
subroutine romBaseComponents(mesh          , nb_equa    ,&
                             field_name    , field_refe ,&
                             nb_cmp_by_node, cmp_by_node, l_lagr)
!
implicit none
!
#include "asterf_types.h"
#include "asterc/indik8.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/dismoi.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jelira.h"
#include "asterfort/jenuno.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
!
character(len=8), intent(in) :: mesh
integer, intent(in) :: nb_equa
character(len=16), intent(in) :: field_name
character(len=24), intent(in) :: field_refe
integer, intent(out) :: nb_cmp_by_node
character(len=8), intent(out)  :: cmp_by_node(10)
aster_logical, intent(out) :: l_lagr
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Get components in empiric mode
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_empi          : datastructure for empiric modes
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: gran_name, node_name
    character(len=19) :: pfchno
    integer :: nb_cmp_maxi, nb_cmp_chck
    integer :: i_equa, i_cmp
    character(len=8) :: name_cmp_chck(6)
    integer :: indx_cmp_chck(6)
    integer :: nume_cmp, nume_node
    aster_logical :: l_find
    character(len=8), pointer :: v_list_cmp(:) => null()
    integer, pointer :: v_deeq(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    l_lagr         = ASTER_FALSE
    cmp_by_node(:) = ' '
    nb_cmp_by_node = 0
!
! - Get parameters for field (empiric mode)
!
    call dismoi('NOM_GD'    , field_refe, 'CHAM_NO', repk = gran_name)
    call dismoi('PROF_CHNO' , field_refe, 'CHAM_NO', repk = pfchno)
    call jeveuo(pfchno//'.DEEQ', 'L', vi = v_deeq)
    call jeveuo(jexnom('&CATA.GD.NOMCMP', gran_name), 'L', vk8 = v_list_cmp)
    call jelira(jexnom('&CATA.GD.NOMCMP', gran_name), 'LONMAX', nb_cmp_maxi)
!
    if (field_name .eq. 'TEMP') then
        nb_cmp_chck      = 1
        name_cmp_chck(1) = 'TEMP'
        indx_cmp_chck(1) = indik8(v_list_cmp, 'TEMP', 1, nb_cmp_maxi)
    elseif (field_name .eq. 'DEPL') then
        nb_cmp_chck      = 3
        name_cmp_chck(1) = 'DX'
        indx_cmp_chck(1) = indik8(v_list_cmp, name_cmp_chck(1), 1, nb_cmp_maxi)
        name_cmp_chck(2) = 'DY'
        indx_cmp_chck(2) = indik8(v_list_cmp, name_cmp_chck(2), 1, nb_cmp_maxi)
        name_cmp_chck(3) = 'DZ'
        indx_cmp_chck(3) = indik8(v_list_cmp, name_cmp_chck(3), 1, nb_cmp_maxi)
    elseif (field_name .eq. 'FLUX_NOEU') then
        nb_cmp_chck      = 3
        name_cmp_chck(1) = 'FLUX'
        indx_cmp_chck(1) = indik8(v_list_cmp, name_cmp_chck(1), 1, nb_cmp_maxi)
        name_cmp_chck(2) = 'FLUY'
        indx_cmp_chck(2) = indik8(v_list_cmp, name_cmp_chck(2), 1, nb_cmp_maxi)
        name_cmp_chck(3) = 'FLUZ'
        indx_cmp_chck(3) = indik8(v_list_cmp, name_cmp_chck(3), 1, nb_cmp_maxi)
    elseif (field_name .eq. 'SIEF_NOEU') then
        nb_cmp_chck      = 6
        name_cmp_chck(1) = 'SIXX'
        indx_cmp_chck(1) = indik8(v_list_cmp, name_cmp_chck(1), 1, nb_cmp_maxi)
        name_cmp_chck(2) = 'SIYY'
        indx_cmp_chck(2) = indik8(v_list_cmp, name_cmp_chck(2), 1, nb_cmp_maxi)
        name_cmp_chck(3) = 'SIZZ'
        indx_cmp_chck(3) = indik8(v_list_cmp, name_cmp_chck(3), 1, nb_cmp_maxi)
        name_cmp_chck(4) = 'SIXZ'
        indx_cmp_chck(4) = indik8(v_list_cmp, name_cmp_chck(4), 1, nb_cmp_maxi)
        name_cmp_chck(5) = 'SIYZ'
        indx_cmp_chck(5) = indik8(v_list_cmp, name_cmp_chck(5), 1, nb_cmp_maxi)
        name_cmp_chck(6) = 'SIXY'
        indx_cmp_chck(6) = indik8(v_list_cmp, name_cmp_chck(6), 1, nb_cmp_maxi)
    else
        ASSERT(ASTER_FALSE)
    endif
!
    ASSERT(nb_cmp_chck .le. 10)
!
    do i_equa = 1, nb_equa
        nume_node = v_deeq(2*(i_equa-1)+1)
        nume_cmp  = v_deeq(2*(i_equa-1)+2)
        l_find    = ASTER_FALSE
! ----- Look for authorized components
        do i_cmp = 1, nb_cmp_chck
            if (nume_cmp .eq. indx_cmp_chck(i_cmp)) then
                l_find = ASTER_TRUE
                cmp_by_node(i_cmp) = name_cmp_chck(i_cmp)
            elseif (nume_cmp .lt. 0) then
                l_find = ASTER_TRUE
                l_lagr = ASTER_TRUE
            else
! --------- No ELSE required here
            endif
        end do
        if (.not.l_find) then
            call jenuno(jexnum(mesh//'.NOMNOE', nume_node), node_name)
            call utmess('F', 'ROM5_23', sk = node_name)
        endif
    end do
!
    do i_cmp = 1, nb_cmp_chck
        if (cmp_by_node(i_cmp) .ne. ' ') then
            nb_cmp_by_node = nb_cmp_by_node + 1
        endif
    end do
!
end subroutine
