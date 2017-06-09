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

subroutine lireco(keywf         , mesh          , model         , i_zone      , list_elem_slav,&
                  list_elem_mast, list_node_slav, list_node_mast, nb_elem_slav, nb_node_slav  ,&
                  nb_elem_mast  , nb_node_mast)
!
implicit none
!
#include "asterfort/reliem.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: mesh
    character(len=8), intent(in) :: model
    character(len=16), intent(in) :: keywf
    integer, intent(in) :: i_zone
    character(len=24), intent(in) :: list_elem_slav
    character(len=24), intent(in) :: list_elem_mast
    character(len=24), intent(in) :: list_node_slav
    character(len=24), intent(in) :: list_node_mast
    integer, intent(out) :: nb_elem_slav
    integer, intent(out) :: nb_node_slav
    integer, intent(out) :: nb_elem_mast
    integer, intent(out) :: nb_node_mast
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_CONTACT
!
! Read slave and master surfaces
!
! --------------------------------------------------------------------------------------------------
!
! In  keywf            : factor keyword to read
! In  mesh             : name of mesh
! In  model            : name of model
! In  list_elem_slav   : name of JEVEUX object for list of slave elements
! In  list_elem_mast   : name of JEVEUX object for list of master elements
! In  list_node_slav   : name of JEVEUX object for list of slave nodes
! In  list_node_mast   : name of JEVEUX object for list of master nodes
! Out nb_elem_slav     : number of slave elements
! Out nb_elem_mast     : number of master elements
! Out nb_node_slav     : number of slave nodes
! Out nb_node_mast     : number of master nodes
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_keyw
    character(len=8) :: k8bla
    character(len=16) :: keyw_name(2), keyw_type(2)
!
! --------------------------------------------------------------------------------------------------
!
    nb_elem_slav = 0
    nb_elem_mast = 0
    nb_node_slav = 0
    nb_node_mast = 0
    k8bla        = ' '
    nb_keyw      = 2
    keyw_type(1) = 'GROUP_MA'
    keyw_type(2) = 'MAILLE'
!
! - Elements
!
    keyw_name(1) = 'GROUP_MA_ESCL'
    keyw_name(2) = 'MAILLE_ESCL'
    call reliem(k8bla  , mesh     , 'NU_MAILLE', keywf         , i_zone      ,&
                nb_keyw, keyw_name, keyw_type  , list_elem_slav, nb_elem_slav)
    keyw_name(1) = 'GROUP_MA_MAIT'
    keyw_name(2) = 'MAILLE_MAIT'
    call reliem(k8bla  , mesh     , 'NU_MAILLE', keywf         , i_zone      ,&
                nb_keyw, keyw_name, keyw_type  , list_elem_mast, nb_elem_mast)
!
! - Nodes
!
    keyw_name(1) = 'GROUP_MA_ESCL'
    keyw_name(2) = 'MAILLE_ESCL'
    call reliem(model  , mesh     , 'NU_NOEUD', keywf         , i_zone      ,&
                nb_keyw, keyw_name, keyw_type , list_node_slav, nb_node_slav)
    keyw_name(1) = 'GROUP_MA_MAIT'
    keyw_name(2) = 'MAILLE_MAIT'
    call reliem(model  , mesh     , 'NU_NOEUD', keywf         , i_zone      ,&
                nb_keyw, keyw_name, keyw_type , list_node_mast, nb_node_mast)

end subroutine
