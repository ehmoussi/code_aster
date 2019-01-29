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

!
!
#include "asterf_types.h"
!
interface
    subroutine apsave_patch(mesh          , sdappa        , i_zone,&
                            patch_weight_t, nb_proc, list_pair_zmpi,&
                            list_nbptit_zmpi,list_ptitsl_zmpi,list_ptitma_zmpi,&
                            li_ptgausma_zmpi,&
                            nb_pair_zmpi, list_pair_zone,list_nbptit_zone, list_ptitsl_zone,&
                            list_ptitma_zone,li_ptgausma_zone,nb_pair_zone, i_proc)
        character(len=8), intent(in) :: mesh
        character(len=19), intent(in) :: sdappa
        integer, intent(in) :: i_zone
        real(kind=8), intent(in) :: patch_weight_t(*)
        integer, intent(inout) :: nb_pair_zone
        integer, pointer :: list_pair_zone(:)
        integer, pointer :: list_nbptit_zone(:)
        real(kind=8), pointer :: list_ptitsl_zone(:)
        real(kind=8), pointer :: list_ptitma_zone(:)
        real(kind=8), pointer :: li_ptgausma_zone(:)
        integer, pointer :: nb_pair_zmpi(:)
        integer, pointer :: list_pair_zmpi(:)
        integer, pointer :: list_nbptit_zmpi(:)
        real(kind=8), pointer :: list_ptitsl_zmpi(:)
        real(kind=8), pointer :: list_ptitma_zmpi(:)
        real(kind=8), pointer :: li_ptgausma_zmpi(:)
        integer, intent(in) :: nb_proc
        integer, intent(in) :: i_proc
    end subroutine apsave_patch
end interface
