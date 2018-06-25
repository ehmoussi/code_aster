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

subroutine mm_cycl_trait(ds_contact    , i_cont_poin, &
                         coef_cont_prev, &
                         coef_frot_prev, pres_frot_prev, dist_frot_prev, &
                         pres_frot_curr, dist_frot_curr, &
                         indi_cont_eval, indi_frot_eval, &
                         indi_cont_curr, coef_cont_curr, &
                         indi_frot_curr, coef_frot_curr)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/cfdisi.h"
#include "asterfort/cfmmvd.h"
#include "asterfort/infdbg.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mminfi.h"
#include "asterfort/mminfl.h"
#include "asterfort/mm_cycl_t2.h"
#include "asterfort/mm_cycl_t3.h"
!
! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
!
    type(NL_DS_Contact), intent(in) :: ds_contact
    integer, intent(in) :: i_cont_poin
    real(kind=8), intent(in) :: coef_cont_prev
    real(kind=8), intent(in) :: coef_frot_prev
    real(kind=8), intent(in) :: pres_frot_prev(3)
    real(kind=8), intent(in) :: dist_frot_prev(3)
    real(kind=8), intent(in) :: pres_frot_curr(3)
    real(kind=8), intent(in) :: dist_frot_curr(3)
    integer, intent(in) :: indi_cont_eval
    integer, intent(in) :: indi_frot_eval
    integer, intent(out) :: indi_cont_curr
    integer, intent(out) :: indi_frot_curr
    real(kind=8), intent(out) :: coef_cont_curr
    real(kind=8), intent(out) :: coef_frot_curr
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve - Cycling
!
! Treatment
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_contact       : datastructure for contact management
! In  i_cont_poin      : contact point index
! In  coef_cont_prev   : previous augmented ratio for contact
! In  coef_frot_prev   : previous augmented ratio for friction
! In  pres_frot_prev   : previous friction pressure in cycle
! In  dist_frot_prev   : previous friction distance in cycle
! In  dist_frot_curr   : friction distance
! In  pres_frot_curr   : friction pressure
! In  indi_cont_eval   : evaluation of new contact status
! In  indi_frot_eval   : evaluation of new friction status
! Out indi_cont_curr   : current contact status
! Out indi_frot_curr   : current friction status
! Out coef_cont_curr   : current augmented ratio for contact
! Out coef_frot_curr   : current augmented ratio for friction
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: sdcont_cyceta
    integer, pointer :: p_sdcont_cyceta(:) => null()
    integer :: cycl_type, cycl_stat_prev, cycl_stat_curr
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Access to cycling objects
!
    sdcont_cyceta = ds_contact%sdcont_solv(1:14)//'.CYCETA'
    call jeveuo(sdcont_cyceta, 'E' , vi = p_sdcont_cyceta)
!
! - No specific treatment
!
    coef_cont_curr = coef_cont_prev
    coef_frot_curr = coef_frot_prev
    indi_cont_curr = indi_cont_eval
    indi_frot_curr = indi_frot_eval


!
! - Cycling 2
!
    cycl_type = 2
    cycl_stat_prev = p_sdcont_cyceta(4*(i_cont_poin-1)+cycl_type)
    if (cycl_stat_prev.gt.0) then
        call mm_cycl_t2(pres_frot_prev, dist_frot_prev, coef_frot_prev, &
                        cycl_stat_prev, pres_frot_curr, dist_frot_curr, &
                        coef_frot_curr, cycl_stat_curr)
!         p_sdcont_cyceta(4*(i_cont_poin-1)+cycl_type) = cycl_stat_curr
        goto 99
    endif
!
! - Cycling 3
!
    cycl_type = 3
    cycl_stat_prev = p_sdcont_cyceta(4*(i_cont_poin-1)+cycl_type)
    if (cycl_stat_prev.gt.0) then
        call mm_cycl_t3(pres_frot_prev, dist_frot_prev, coef_frot_prev, &
                        cycl_stat_curr)
!         p_sdcont_cyceta(4*(i_cont_poin-1)+cycl_type) = cycl_stat_curr
        goto 99
    endif
!
99  continue
!
    call jedema()
end subroutine
