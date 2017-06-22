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

subroutine cfleqa(mesh, sdcont_defi, nb_cont_zone, nt_node_middle)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/cfnbsf.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/mminfl.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: mesh
    character(len=24), intent(in) :: sdcont_defi
    integer, intent(in) :: nb_cont_zone
    integer, intent(out) :: nt_node_middle
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_CONTACT
!
! Suppress quadratic middle nodes of QUAD8 - Total number of middle nodes
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  sdcont_defi      : name of contact definition datastructure (from DEFI_CONTACT)
! In  nb_cont_zone     : number of zones of contact
! Out nt_node middle   : number of middle nodes from QUAD8 elements!
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jdecma, elem_nume, type_nume
    integer :: i_surf_curr, i_zone, i_elem, i_surf
    integer :: nb_surf, nb_elem,nb_node_middle
    character(len=8) :: type_name
    aster_logical :: l_veri
    integer, pointer :: v_mesh_typmail(:) => null()
    character(len=24) :: sdcont_mailco
    integer, pointer :: v_sdcont_mailco(:) => null()
    character(len=24) :: sdcont_pzoneco
    integer, pointer :: v_sdcont_pzoneco(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    nt_node_middle = 0
    nb_node_middle = 0
!
! - Datastructure for contact definition
!
    sdcont_pzoneco = sdcont_defi(1:16)//'.PZONECO'
    sdcont_mailco  = sdcont_defi(1:16)//'.MAILCO'
    call jeveuo(sdcont_pzoneco, 'L', vi = v_sdcont_pzoneco)
    call jeveuo(sdcont_mailco , 'L', vi = v_sdcont_mailco)
!
! - Access to mesh
!
    call jeveuo(mesh(1:8)//'.TYPMAIL', 'L', vi = v_mesh_typmail)
!
! - Number of middle nodes for each contact surface
!
    do i_zone = 1, nb_cont_zone
!
! ----- No computation
!
        l_veri = mminfl(sdcont_defi, 'VERIF', i_zone)
        if (l_veri) then
            goto 21
        endif
!
! ----- Number of contact surfaces
!
        nb_surf = v_sdcont_pzoneco(i_zone+1) - v_sdcont_pzoneco(i_zone)
        ASSERT(nb_surf.eq.2)
!
! ----- Loop on surfaces
!
        do i_surf = 1, nb_surf
!
! --------- Parameters of current surface
!
            i_surf_curr = nb_surf*(i_zone-1)+i_surf
            call cfnbsf(sdcont_defi, i_surf_curr, 'MAIL', nb_elem, jdecma)
!
! --------- Loop on elements
!
            do i_elem = 1, nb_elem
!
! ------------- Current element
!
                elem_nume = v_sdcont_mailco(jdecma+i_elem)
!
! ------------- Type of element
!
                type_nume = v_mesh_typmail(elem_nume)
                call jenuno(jexnum('&CATA.TM.NOMTM', type_nume), type_name)
!
! ------------- Number of middle nodes
!
                if (type_name(1:5) .eq. 'QUAD9') then
                    nb_node_middle = 0
                else if (type_name(1:5).eq.'TRIA7') then
                    nb_node_middle = 0
                else if (type_name(1:5).eq.'QUAD8') then
                    nb_node_middle = 4
                else if (type_name(1:5).eq.'TRIA6') then
                    nb_node_middle = 0
                else
                    nb_node_middle = 0
                endif
!
! ------------- Total number of middle nodes
!
                nt_node_middle = nt_node_middle + nb_node_middle
            end do
        end do
 21     continue
    end do
!
end subroutine
