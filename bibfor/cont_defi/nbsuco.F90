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

subroutine nbsuco(sdcont      , keywf       , mesh, model, nb_cont_zone,&
                  nb_cont_elem, nb_cont_node)
!
implicit none
!
#include "asterfort/jedetr.h"
#include "asterfort/jeveuo.h"
#include "asterfort/lireco.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: sdcont
    character(len=8), intent(in) :: mesh
    character(len=8), intent(in) :: model
    character(len=16), intent(in) :: keywf
    integer, intent(in) :: nb_cont_zone
    integer, intent(out) :: nb_cont_elem
    integer, intent(out) :: nb_cont_node
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_CONTACT
!
! Count nodes and elements
!
! --------------------------------------------------------------------------------------------------
!
! In  sdcont           : name of contact concept (DEFI_CONTACT)
! In  keywf            : factor keyword to read
! In  mesh             : name of mesh
! In  model            : name of model
! In  nb_cont_zone     : number of zones of contact
! Out nb_cont_elem     : number of elements of contact
! Out nb_cont_node     : number of nodes of contact
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_zone, i_surf
    integer :: nb_elem_slav, nb_node_slav
    integer :: nb_elem_mast, nb_node_mast
    character(len=24) :: list_elem_slav, list_elem_mast
    character(len=24) :: list_node_slav, list_node_mast
    character(len=24) :: sdcont_defi
    character(len=24) :: sdcont_psumaco
    integer, pointer :: v_sdcont_psumaco(:) => null()
    character(len=24) :: sdcont_psunoco
    integer, pointer :: v_sdcont_psunoco(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    nb_cont_node = 0
    nb_cont_elem = 0
    i_surf       = 1
!
! - Datastructure for contact definition
!
    sdcont_defi    = sdcont(1:8)//'.CONTACT'
    sdcont_psumaco = sdcont_defi(1:16)//'.PSUMACO'
    sdcont_psunoco = sdcont_defi(1:16)//'.PSUNOCO'
    call jeveuo(sdcont_psumaco, 'E', vi = v_sdcont_psumaco)
    call jeveuo(sdcont_psunoco, 'E', vi = v_sdcont_psunoco)
!
! - Temporary datastructures
!
    list_elem_mast = '&&NBSUCO.MAIL.MAIT'
    list_elem_slav = '&&NBSUCO.MAIL.ESCL'
    list_node_mast = '&&NBSUCO.NOEU.MAIT'
    list_node_slav = '&&NBSUCO.NOEU.ESCL'
!
! - Number of nodes/elements
!
    do i_zone = 1, nb_cont_zone
        call lireco(keywf         , mesh          , model         , i_zone      , list_elem_slav,&
                    list_elem_mast, list_node_slav, list_node_mast, nb_elem_slav, nb_node_slav  ,&
                    nb_elem_mast  , nb_node_mast)
        nb_cont_node = nb_cont_node+nb_node_mast+nb_node_slav
        nb_cont_elem = nb_cont_elem+nb_elem_mast+nb_elem_slav
!
! ----- Number of master nodes/elements
!
        v_sdcont_psumaco(i_surf+1) = v_sdcont_psumaco(i_surf) + nb_elem_mast
        v_sdcont_psunoco(i_surf+1) = v_sdcont_psunoco(i_surf) + nb_node_mast
        i_surf = i_surf + 1
!
! ----- Number of slave nodes/elements
!
        v_sdcont_psumaco(i_surf+1) = v_sdcont_psumaco(i_surf) + nb_elem_slav
        v_sdcont_psunoco(i_surf+1) = v_sdcont_psunoco(i_surf) + nb_node_slav
        i_surf = i_surf + 1
    end do
!
    call jedetr(list_elem_slav)
    call jedetr(list_elem_mast)
    call jedetr(list_node_slav)
    call jedetr(list_node_mast)
!
end subroutine
