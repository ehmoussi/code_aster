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

subroutine mm_cycl_d3(ds_contact    , i_cont_poin   ,&
                      indi_frot_prev, dist_frot_prev,&
                      indi_cont_eval, indi_frot_eval,&
                      dist_frot_curr)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterc/r8prem.h"
#include "asterc/r8rddg.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/normev.h"
#include "asterfort/mm_cycl_erase.h"
#include "asterfort/mm_cycl_init.h"
#include "blas/ddot.h"
!
! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
!
    type(NL_DS_Contact), intent(in) :: ds_contact
    integer, intent(in) :: i_cont_poin
    integer, intent(in) :: indi_frot_prev
    real(kind=8), intent(in) :: dist_frot_prev(3)
    integer, intent(in) :: indi_cont_eval
    integer, intent(in) :: indi_frot_eval
    real(kind=8), intent(in) :: dist_frot_curr(3)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve - Cycling
!
! Detection: sliding forward/backward
!
! -----------------------------------------------------------------
!
! In  ds_contact       : datastructure for contact management
! In  i_cont_poin      : contact point index
! In  indi_frot_prev   : previous friction indicator
! In  dist_frot_prev   : previous friction distance
! In  indi_cont_eval   : evaluation of new contact status
! In  indi_frot_eval   : evaluation of new friction status
! In  dist_frot_curr   : current friction distance
!
! --------------------------------------------------------------------------
!
    character(len=24) :: sdcont_cyclis
    integer, pointer :: p_sdcont_cyclis(:) => null()
    character(len=24) :: sdcont_cycnbr
    integer, pointer :: p_sdcont_cycnbr(:) => null()
    character(len=24) :: sdcont_cyceta
    integer, pointer :: p_sdcont_cyceta(:) => null()
    real(kind=8) :: module_prev, module_curr
    real(kind=8) :: angle, prosca, val, tole_angl
    integer :: cycl_type, cycl_ecod, cycl_long, cycl_stat,cycl_long_acti
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    cycl_type = 3
    cycl_stat = 0
    cycl_ecod = 0
    cycl_long = 0
    tole_angl = 5.d0
    cycl_long_acti = ds_contact%cycl_long_acti
!
! - Access to cycling objects
!
    sdcont_cyclis = ds_contact%sdcont_solv(1:14)//'.CYCLIS'
    sdcont_cycnbr = ds_contact%sdcont_solv(1:14)//'.CYCNBR'
    sdcont_cyceta = ds_contact%sdcont_solv(1:14)//'.CYCETA'
    call jeveuo(sdcont_cyclis, 'E', vi = p_sdcont_cyclis)
    call jeveuo(sdcont_cycnbr, 'E', vi = p_sdcont_cycnbr)
    call jeveuo(sdcont_cyceta, 'E', vi = p_sdcont_cyceta)
!
! - Cycling break if: no contact, sticking or previous state was sticking
!
    if ((indi_cont_eval .eq. 0).or.&
        (indi_frot_eval .eq. 1).or.&
        (indi_frot_prev .eq. 1)) then
        goto 99
    endif
!
! - Cycle state
!
    cycl_long    = p_sdcont_cycnbr(4*(i_cont_poin-1)+cycl_type)
    cycl_ecod    = p_sdcont_cyclis(4*(i_cont_poin-1)+cycl_type)
    cycl_ecod    = cycl_ecod + (2**cycl_long)*indi_cont_eval
    if (cycl_long .eq. cycl_long_acti)  then 
        cycl_long = 0
        cycl_ecod = 0
    endif
!
! - Cycling detection
!
    prosca = ddot(3,dist_frot_prev,1,dist_frot_curr,1)
    module_curr = sqrt(dist_frot_curr(1)*dist_frot_curr(1)+&
                       dist_frot_curr(2)*dist_frot_curr(2)+&
                       dist_frot_curr(3)*dist_frot_curr(3))
    module_prev = sqrt(dist_frot_prev(1)*dist_frot_prev(1)+&
                       dist_frot_prev(2)*dist_frot_prev(2)+&
                       dist_frot_prev(3)*dist_frot_prev(3))
    angle  = 0.d0
    if ((module_prev*module_curr) .gt. r8prem()) then
        val = prosca/(module_prev*module_curr)
        if (val .gt. 1.d0) then
            val = 1.d0
        endif
        if (val .lt. -1.d0) then
            val = -1.d0
        endif
        angle = acos(val)
        angle = angle*r8rddg()
    endif
!
! - Detection
!
    cycl_stat = 0
    if ((abs(angle) .ge. 180.-tole_angl) .and. (abs(angle) .le. 180.d0+tole_angl))  then
        cycl_stat = 10
        if (module_curr  .lt. 1.d-6  .and. module_prev .lt. 1.d-6) cycl_stat = 11
        
        if ( (module_curr .lt. 1.d-6 .and. module_prev .gt. 1.d-6)        .or.  &
             (module_curr .gt. 1.d-6 .and. module_prev .lt. 1.d-6) ) cycl_stat = 12
             
        if (module_curr  .gt. 1.d-6  .and. module_prev .gt. 1.d-6) cycl_stat = 13
             
    endif

!
! - Cycling save : incrementation of cycle objects
!
    99  continue
    cycl_long = cycl_long + 1
!        write (6,*) "cyclage avant-arrière de type ", cycl_stat
    p_sdcont_cyceta(4*(i_cont_poin-1)+cycl_type) = cycl_stat
    p_sdcont_cyclis(4*(i_cont_poin-1)+cycl_type) = cycl_ecod
    if (cycl_long .eq. cycl_long_acti)  then 
        cycl_long = 0
        cycl_ecod = 0
    endif
    p_sdcont_cycnbr(4*(i_cont_poin-1)+cycl_type) = cycl_long
    p_sdcont_cyclis(4*(i_cont_poin-1)+cycl_type) = cycl_ecod
    ASSERT(cycl_long .le. cycl_long_acti)
!
!
    call jedema()
end subroutine
