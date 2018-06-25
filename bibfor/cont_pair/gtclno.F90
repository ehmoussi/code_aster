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

subroutine gtclno(jv_geom, list_node, nb_node, testnode ,nume_node_cl)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "jeveux.h"
!
!

    integer, intent(in) :: jv_geom
    integer, pointer :: list_node(:)
    integer, intent(in) :: nb_node
    real(kind=8), intent(in) :: testnode(3)
    integer, intent(out) :: nume_node_cl
    
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing segment to segment
!
! Get center of a given contact element 
!
! --------------------------------------------------------------------------------------------------
!
! In jv_geom          : JEVEUX adress to updated geometry
! In list_node        : list of master nodes on current zone
! In nb_node          : number of node in list_node
! In testnode         : node coordonate
! Out nume_node_cl    : closest node
!
! --------------------------------------------------------------------------------------------------
!
  integer      :: i_dime, i_node, node_nume
  real(kind=8) :: vect_pm(3), dist_min, dist
  
!
! --------------------------------------------------------------------------------------------------
!
!
! - Initialisation
!
    dist_min = 0.d0
    
    do i_node=1, nb_node
        node_nume = list_node(i_node)
!
! ----- Vector Point-Projection
!
        do i_dime = 1, 3
            vect_pm(i_dime) = zr(jv_geom+3*(node_nume-1)+i_dime-1) - testnode(i_dime)
        end do
!
! ----- Distance
!
        dist = sqrt(vect_pm(1)**2+vect_pm(2)**2+vect_pm(3)**2)
!
! ----- Check distance
!     
        if (dist.lt. dist_min .or. i_node .eq. 1)then
            dist_min     = dist
            nume_node_cl = node_nume
        end if       
    end do
!
! - Print check
!
    !write(*,*)"CLOSEST NODE: ",nume_node_cl
!
end subroutine       
