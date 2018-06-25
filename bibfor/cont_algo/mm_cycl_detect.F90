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

subroutine mm_cycl_detect(ds_contact    , &
                          l_frot_zone   , i_cont_poin   ,&
                           coef_cont, coef_frot,&                          
                          pres_cont_prev, dist_cont_prev,&
                          pres_frot_curr,pres_frot_prev ,&
                          indi_frot_prev, dist_frot_prev,&
                          indi_cont_eval, indi_frot_eval,&
                          indi_cont_prev, &
                          dist_cont_curr, pres_cont_curr, dist_frot_curr,&
                          alpha_cont_matr,alpha_cont_vect,&
                          alpha_frot_matr,alpha_frot_vect)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/mm_cycl_d1.h"
#include "asterfort/mm_cycl_d2.h"
#include "asterfort/mm_cycl_d3.h"
#include "asterfort/mm_cycl_d4.h"
!
! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
!
    type(NL_DS_Contact), intent(inout) :: ds_contact
    aster_logical, intent(in) :: l_frot_zone
    integer, intent(in) :: i_cont_poin
    real(kind=8), intent(in) :: coef_cont
    real(kind=8), intent(in) :: coef_frot
    real(kind=8), intent(in) :: pres_cont_prev
    real(kind=8), intent(in) :: pres_frot_prev(3), pres_frot_curr(3)
    real(kind=8), intent(in) :: dist_cont_prev
    integer, intent(in) :: indi_frot_prev
    integer, intent(in) :: indi_cont_prev
    real(kind=8), intent(in) :: dist_frot_prev(3)
    integer, intent(in) :: indi_cont_eval
    integer, intent(in) :: indi_frot_eval
    real(kind=8), intent(in) :: dist_cont_curr
    real(kind=8), intent(in) :: pres_cont_curr
    real(kind=8), intent(in) :: dist_frot_curr(3)
    real(kind=8), intent(out) :: alpha_cont_matr
    real(kind=8), intent(out) :: alpha_cont_vect
    real(kind=8), intent(out) :: alpha_frot_matr
    real(kind=8), intent(out) :: alpha_frot_vect
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve - Cycling
!
! Detection
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_contact       : datastructure for contact management
! In  l_frot_zone      : .true. if friction on zone
! In  i_cont_poin      : contact point index
! In  coef_cont        : augmented ratio for contact
! In  pres_cont_prev   : previous pressure contact in cycle
! In  dist_cont_prev   : previous pressure distance in cycle
! In  indi_frot_prev   : previous friction indicator in cycle
! In  dist_frot_prev   : previous friction distance in cycle
! In  indi_cont_eval   : evaluation of new contact status
! In  dist_cont_curr   : current contact gap
! In  pres_cont_curr   : current contact pressure
! In  indi_frot_eval   : evaluation of new friction status
! In  dist_frot_curr   : current friction distance
!
! --------------------------------------------------------------------------------------------------
!
! - Detection of cycling: contact/no contact
!
    call mm_cycl_d1(ds_contact, i_cont_poin, pres_cont_prev, dist_cont_prev, coef_cont,&
                    indi_cont_eval,indi_cont_prev, dist_cont_curr, pres_cont_curr,alpha_cont_matr,&
                    alpha_cont_vect)
!
! - Detection of cycling: sliding/sticking
!
    if (l_frot_zone) then
        call mm_cycl_d2(ds_contact, i_cont_poin, indi_cont_eval, indi_frot_eval,&
                      coef_frot , pres_frot_curr,pres_frot_prev ,&
                      dist_frot_curr,dist_frot_prev , alpha_frot_matr,alpha_frot_vect)
    endif
!
! - Detection of cycling: sliding forward/backward
!
    if (l_frot_zone) then
        call mm_cycl_d3(ds_contact, i_cont_poin, indi_frot_prev, dist_frot_prev,&
                        indi_cont_eval, indi_frot_eval, dist_frot_curr)
    endif
!
! - Detection of cycling: old flip/flop
!
        call mm_cycl_d4(ds_contact, i_cont_poin, indi_cont_eval,indi_cont_prev,&
                        pres_cont_curr,pres_cont_prev)
!
end subroutine
