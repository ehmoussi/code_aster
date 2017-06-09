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

subroutine listco(sdcont      , keywf       , mesh, model, nb_cont_zone,&
                  nb_cont_elem, nb_cont_node)
!
implicit none
!
#include "asterfort/liexco.h"
#include "asterfort/nbsuco.h"
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
! Count and save nodes and elements
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

!
! - Count elements/nodes of contact
!
    call nbsuco(sdcont      , keywf       , mesh, model, nb_cont_zone,&
                nb_cont_elem, nb_cont_node)
!
! - Save elements/nodes of contact
!
    call liexco(sdcont      , keywf       , mesh, model, nb_cont_zone,&
                nb_cont_elem, nb_cont_node)

end subroutine
