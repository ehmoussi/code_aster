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

subroutine apcond(newgeo, node_nume, node_coor)
!
implicit none
!
#include "asterfort/jeveuo.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=19), intent(in) :: newgeo
    integer, intent(in) :: node_nume
    real(kind=8), intent(out) :: node_coor(3)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing
!
! Get coordinates of current node
!
! --------------------------------------------------------------------------------------------------
!
! In  newgeo           : name of field for geometry update from initial coordinates of nodes
! In  node_nume        : index of node in mesh datastructure
! Out node_coor        : coordinates of node 
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8), pointer :: v_newgeo_vale(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jeveuo(newgeo(1:19)//'.VALE', 'L', vr=v_newgeo_vale)
    node_coor(1) = v_newgeo_vale(3*(node_nume -1)+1)
    node_coor(2) = v_newgeo_vale(3*(node_nume -1)+2)
    node_coor(3) = v_newgeo_vale(3*(node_nume -1)+3)
!
end subroutine
