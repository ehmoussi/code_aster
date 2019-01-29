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
subroutine lcsegp(elem_dime    , nb_lagr, indi_lagc,&
                  nb_node_slav , nmcp   , gapi     ,&
                  vtmp)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/mmnewd.h"
#include "asterfort/mmdonf.h"
#include "asterfort/mmtang.h"
#include "asterfort/mmnorm.h"
#include "asterfort/lcnorm.h"
#include "asterfort/reerel.h"
#include "asterfort/apdist.h"
!
integer, intent(in) :: elem_dime
integer, intent(in) :: nb_lagr
integer, intent(in) :: indi_lagc(10)
integer, intent(in) :: nb_node_slav
integer, intent(in) :: nmcp
real(kind=8), intent(in) :: gapi
real(kind=8), intent(inout) :: vtmp(55)
!
! --------------------------------------------------------------------------------------------------
!
! Contact (LAC) - Elementary computations
!
! Compute contact vector (slave side)
!
! --------------------------------------------------------------------------------------------------
!
! In  elem_dime        : dimension of elements
! In  nb_lagr          : total number of Lagrangian dof on contact element
! In  indi_lagc        : PREVIOUS node where Lagrangian dof is present (1) or not (0)
! In  nb_node_slav     : number of nodes of for slave side from contact element
! In  gapi             : gap integral on patch
! In  nmcp             : number of contact elements associated to the concerned patch
! In  elin_slav_code   : code of all sub-elements in slave element
! IO  vtmp             : vector
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_node, jj, shift
    real(kind=8) :: r_lagr_c, r_nmcp
!
! --------------------------------------------------------------------------------------------------
!
    jj=0
    shift = 0
    r_lagr_c=real(nb_lagr,kind=8)
    r_nmcp = real(nmcp, kind=8)
!
! - Compute vector
!
    r_lagr_c=real(nb_lagr,kind=8)
    do i_node = 1, nb_node_slav
            shift=shift+indi_lagc(i_node)
            if (indi_lagc(i_node+1).eq. 1) then
                jj=elem_dime*(i_node-1)+shift+elem_dime+1
                vtmp(jj)=gapi/(r_nmcp*r_lagr_c)
            end if
    end do
!
end subroutine
