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
subroutine behaviourIsGEOMExternal(l_varext_geom)
!
use calcul_module, only : ca_jvcnom_, ca_nbcvrc_
!
implicit none
!
#include "jeveux.h"
#include "asterf_types.h"
#include "asterc/indik8.h"
!
aster_logical, intent(inout) :: l_varext_geom
!
! --------------------------------------------------------------------------------------------------
!
! Behaviour
!
! Detect 'GEOM' in external state variables
!
! --------------------------------------------------------------------------------------------------
!
! Out l_varext_geom    : flag for GEOM in external state variables (AFFE_VARC)
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8), parameter :: varc_geom = 'X'
    integer :: varc_indx
!
! --------------------------------------------------------------------------------------------------
!
    l_varext_geom = ASTER_FALSE
!
! - Detect 'GEOM' external state variables
!
    if (ca_nbcvrc_ .eq. 0) then
        l_varext_geom = ASTER_FALSE
    else
        varc_indx = indik8(zk8(ca_jvcnom_), varc_geom, 1, ca_nbcvrc_)
        l_varext_geom = varc_indx .ne. 0
    endif
!
end subroutine
