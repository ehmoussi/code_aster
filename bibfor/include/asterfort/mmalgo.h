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
! aslint: disable=W1504
#include "asterf_types.h"
!
interface
    subroutine mmalgo(ds_contact, l_loop_cont   , l_frot_zone   ,  &
                  l_glis_init   , type_adap   , zone_index    , i_cont_poin , &
                   indi_cont_eval, indi_frot_eval, dist_cont_curr, &
                   pres_cont_curr, dist_frot_curr, pres_frot_curr, &
                  v_sdcont_cychis, v_sdcont_cyccoe, v_sdcont_cyceta, indi_cont_curr,&
                  indi_frot_curr, ctcsta        , mmcvca               ,l_pena_frot,l_pena_cont,&
                  vale_pene)

        use NonLin_Datastructure_type
        type(NL_DS_Contact), intent(in) :: ds_contact
        aster_logical, intent(in) :: l_loop_cont
        aster_logical, intent(in) :: l_frot_zone
        aster_logical, intent(in) :: l_glis_init
        integer, intent(in) :: type_adap
        integer, intent(in) :: i_cont_poin
        integer, intent(in) :: zone_index
        real(kind=8), intent(in) :: vale_pene
        aster_logical, intent(in) :: l_pena_frot
        aster_logical, intent(in) :: l_pena_cont
        integer, intent(inout) :: indi_cont_eval
        integer, intent(inout) :: indi_frot_eval
        real(kind=8), intent(inout) :: dist_cont_curr
        real(kind=8), intent(inout) :: pres_cont_curr
        real(kind=8), intent(inout) :: dist_frot_curr(3)
        real(kind=8), intent(in) :: pres_frot_curr(3)
        real(kind=8), pointer, intent(in) :: v_sdcont_cychis(:)
        real(kind=8), pointer, intent(in) :: v_sdcont_cyccoe(:)
        integer, pointer, intent(in) :: v_sdcont_cyceta(:)
        integer, intent(out) :: indi_cont_curr
        integer, intent(out) :: indi_frot_curr
        integer, intent(out) :: ctcsta
        aster_logical, intent(out) :: mmcvca
    end subroutine mmalgo
end interface
