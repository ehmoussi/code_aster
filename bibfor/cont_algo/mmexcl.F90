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

subroutine mmexcl(type_inte  , pair_type  , i_poin_elem, ndexfr,&
                  l_node_excl, l_excl_frot)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/isdeco.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    integer, intent(in) :: type_inte
    integer, intent(in) :: pair_type
    integer, intent(in) :: i_poin_elem
    integer, intent(in) :: ndexfr
    aster_logical, intent(out) :: l_node_excl
    aster_logical, intent(out) :: l_excl_frot
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve
!
! Continue method - Get informations for excluded contact point
!
! --------------------------------------------------------------------------------------------------
!
! In  type_inte        : type of integration scheme
! In  pair_type        : type of pairing
! In  i_poin_elem      : index of point in the element
! In  ndexfr           : coded integer for friction nodes
! Out l_node_excl      : .true. if contact point is excluded
! Out l_excl_frot      : .true. if contact point is excluded for friction
!
! --------------------------------------------------------------------------------------------------
!
    integer :: lnexfr(9)
    aster_logical :: l_tole_appa, l_tole_exte
!
! --------------------------------------------------------------------------------------------------
!
    l_tole_appa = .true.
    l_tole_exte = .true.
    l_node_excl = .false.
    l_excl_frot = .false.
!
! - From pairing
!
    if (pair_type .eq. -2) then
        l_tole_appa = .false.
    else if (pair_type.eq.-3) then
        l_tole_exte = .false.
    endif
!
! - SANS_GROUP_NO nodes
!
    if (pair_type .eq. -1) then
        ASSERT(type_inte.eq.1)
        l_node_excl = .true.
    endif
!
! - TOLE_APPA projection
!
    if (.not.l_tole_appa) then
        l_node_excl = .true.
    endif
!
! - TOLE_EXTE projection
!
    if (.not. l_tole_exte) then
        l_node_excl = .true.
    endif
!
! - Excluded for friction
!
    if (i_poin_elem .le. 9) then
        call isdeco([ndexfr], lnexfr, 9)
        if (lnexfr(i_poin_elem) .eq. 1) then
            l_excl_frot = .true.
        endif
    endif
!
end subroutine
