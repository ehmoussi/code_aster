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

!
!
#include "asterf_types.h"
!
interface
    subroutine nmvarc_prep(type_comp, model    , cara_elem, mate     , varc_refe,&
                           compor   , exis_temp, mxchin   , nbin     , lpain    ,&
                           lchin    , mxchout  , nbout    , lpaout   , lchout   ,&
                           sigm_prev, vari_prev, varc_prev, varc_curr, nume_harm)
        character(len=1), intent(in) :: type_comp
        character(len=24), intent(in) :: model
        character(len=24), intent(in) :: mate
        character(len=24), intent(in) :: varc_refe
        character(len=24), intent(in) :: cara_elem
        character(len=24), intent(in) :: compor
        aster_logical, intent(in) :: exis_temp
        integer, intent(in) :: mxchin
        character(len=8), intent(inout) :: lpain(mxchin)
        character(len=19), intent(inout) :: lchin(mxchin)
        integer, intent(out) :: nbin
        integer, intent(in) :: mxchout
        character(len=8), intent(inout) :: lpaout(mxchout)
        character(len=19), intent(inout) :: lchout(mxchout)
        integer, intent(out) :: nbout
        character(len=19), intent(in) :: sigm_prev
        character(len=19), intent(in) :: vari_prev
        character(len=19), intent(in) :: varc_prev
        character(len=19), intent(in) :: varc_curr
        integer, intent(in) :: nume_harm
    end subroutine nmvarc_prep
end interface
