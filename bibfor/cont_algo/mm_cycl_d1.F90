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

subroutine mm_cycl_d1(ds_contact    , i_cont_poin   ,&
                      coef_cont     , pres_cont_prev, dist_cont_prev,&
                      indi_cont_eval,indi_cont_prev,&
                      dist_cont     , pres_cont,alpha_cont_matr,alpha_cont_vect)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/iscode.h"
#include "asterfort/iscycl.h"
#include "asterfort/isdeco.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mm_cycl_erase.h"
#include "asterfort/mm_cycl_d1_ss.h"
!
! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
!
    type(NL_DS_Contact), intent(in) :: ds_contact
    integer, intent(in) :: i_cont_poin
    real(kind=8), intent(in) :: coef_cont
    real(kind=8), intent(in) :: pres_cont_prev
    real(kind=8), intent(in) :: dist_cont_prev
    integer, intent(in) :: indi_cont_eval,indi_cont_prev
    real(kind=8), intent(in) :: dist_cont
    real(kind=8), intent(in) :: pres_cont
    real(kind=8), intent(out) :: alpha_cont_matr, alpha_cont_vect 
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve - Cycling
!
! Detection: contact/no-contact
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_contact       : datastructure for contact management
! In  i_cont_poin      : contact point index
! In  coef_cont        : augmented ratio for contact
! In  pres_cont_prev   : previous pressure contact in cycle
! In  dist_cont_prev   : previous pressure distance in cycle
! In  indi_cont_eval   : evaluation of new contact status
! In  dist_cont        : contact gap
! In  pres_cont        : contact pressure
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: sdcont_cyclis
    integer, pointer :: p_sdcont_cyclis(:) => null()
    character(len=24) :: sdcont_cycnbr
    integer, pointer :: p_sdcont_cycnbr(:) => null()
    character(len=24) :: sdcont_cyceta
    integer, pointer :: p_sdcont_cyceta(:) => null()
    integer :: statut(30)
    integer :: cycl_type, cycl_long_acti
    integer :: cycl_ecod, cycl_long, cycl_sub_type, cycl_stat
    aster_logical :: detect
    real(kind=8) :: laug_cont_prev, laug_cont_curr
    real(kind=8) :: pres_near_zero
    integer :: zone_cont_prev, zone_cont_curr
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    cycl_long_acti = ds_contact%cycl_long_acti
    cycl_type = 1
    cycl_ecod = 0
    detect    = .false.
    !on definit une pression rasante proche du zero
    pres_near_zero = 1.d-2 * ds_contact%arete_min
    alpha_cont_matr = 1.0d0
    alpha_cont_vect = 1.0d0
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
! - Previous augmented lagrangian
!
    laug_cont_prev = pres_cont_prev - coef_cont * dist_cont_prev
!
! - Current augmented lagrangian
!
    laug_cont_curr = pres_cont - coef_cont * dist_cont
!
! - Cycle state
!
    cycl_long    = p_sdcont_cycnbr(4*(i_cont_poin-1)+cycl_type)
    cycl_ecod    = p_sdcont_cyclis(4*(i_cont_poin-1)+cycl_type)
    cycl_ecod    = cycl_ecod + (2**cycl_long)*indi_cont_eval
    
!
! - Cycling detection
!
    cycl_stat = 0
!     write (6,*) "(2**cycl_long)*indi_cont_eval",(2**cycl_long)*indi_cont_eval,cycl_long,indi_cont_eval
!     write (6,*) "p_sdcont_cyclis(4*(i_cont_poin-1)+cycl_type)",p_sdcont_cyclis(4*(i_cont_poin-1)+cycl_type)
!     write (6,*) "cycl_long",cycl_long
    if (cycl_long+1  .eq. cycl_long_acti) then
        detect = iscycl(cycl_ecod, cycl_long_acti)
        if (p_sdcont_cyceta(4*(i_cont_poin-1)+cycl_type) .ge. 10) then
            cycl_stat = 10
            if (indi_cont_eval .eq. indi_cont_prev) cycl_stat = 0
        elseif (detect) then
            cycl_stat = 10
            call mm_cycl_d1_ss(pres_near_zero, laug_cont_prev, laug_cont_curr, zone_cont_prev,&
                               zone_cont_curr, cycl_sub_type,alpha_cont_matr,alpha_cont_vect)

            cycl_stat = cycl_stat + cycl_sub_type
            alpha_cont_matr = 0.99d0
            alpha_cont_vect = 0.99d0
        endif
        if (cycl_stat .ge. 10) &
                write (6,*) "Point de contact en CYCLAGE CONTACT : i_cont_poin",i_cont_poin
    endif


!
! - Cycling save : incrementation of cycle objects
!
    cycl_long = cycl_long + 1
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
    call jedema()
end subroutine
