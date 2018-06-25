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

subroutine apsave_pair(i_zone      , elem_slav_nume,&
                       nb_pair     , list_pair     ,&
                       nb_pair_zone, list_pair_zone)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
!
!
    integer, intent(in) :: i_zone
    integer, intent(in) :: elem_slav_nume
    integer, intent(in) :: nb_pair
    integer, intent(in) :: list_pair(:)
    integer, intent(inout) :: nb_pair_zone
    integer, pointer :: list_pair_zone(:)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing segment to segment
!
! Save current contact pairs
!
! --------------------------------------------------------------------------------------------------
!
! In  i_zone           : index of contact zone
! In  elem_slav_nume   : current index of slave element
! In  nb_pair          : number of contact pairs to add
! In  list_pair        : list of contact pairs to add
! IO  nb_pair_zone     : number of contact elements
! IO  list_pair_zone   : list of contact elements
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_pair
!
! --------------------------------------------------------------------------------------------------
!
! ----- Add new pairs
! 
    do i_pair = 1, nb_pair
        list_pair_zone(3*nb_pair_zone+3*(i_pair-1)+1) = elem_slav_nume    
        list_pair_zone(3*nb_pair_zone+3*(i_pair-1)+2) = list_pair(i_pair)
        list_pair_zone(3*nb_pair_zone+3*(i_pair-1)+3) = i_zone
    end do
!
! - New number of contact pairs
!
    nb_pair_zone = nb_pair_zone+nb_pair      
!
end subroutine
