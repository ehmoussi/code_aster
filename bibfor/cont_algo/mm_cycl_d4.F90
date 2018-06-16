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

subroutine mm_cycl_d4(ds_contact, i_cont_poin, indi_cont_eval,indi_cont_prev,&
                    pres_cont_curr,pres_cont_prev)
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
#include "asterfort/cfdisi.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Contact), intent(inout) :: ds_contact
    integer, intent(in) :: i_cont_poin
    integer, intent(in) :: indi_cont_eval
    integer, intent(in) :: indi_cont_prev
    real(kind=8), intent(in) :: pres_cont_curr
    real(kind=8), intent(in) :: pres_cont_prev
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve - Cycling
!
! Detection: old flip/flop
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_contact       : datastructure for contact management
! In  i_cont_poin      : contact point index
! In  indi_cont_eval   : evaluation of new contact status
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
    integer :: cycl_ecod, cycl_long, cycl_stat
    aster_logical :: detect
    real(kind=8)  :: pres_near_zero
    real(kind=8)  :: coef_refe,F_refe,resi_press_curr
    integer  :: nb_cont_poin
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    cycl_type = 4
    cycl_long_acti = 3
    cycl_stat = 0 
    detect = .false.
    !on definit une pression rasante proche du zero
    pres_near_zero = 1.d-6 * ds_contact%arete_min
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
! - Cycle state
!
    cycl_ecod = p_sdcont_cyclis(4*(i_cont_poin-1)+cycl_type)
    cycl_long = p_sdcont_cycnbr(4*(i_cont_poin-1)+cycl_type)
    cycl_stat = p_sdcont_cyceta(4*(i_cont_poin-1)+1)
    
!
! - Cycling detection
!

    nb_cont_poin = cfdisi(ds_contact%sdcont_defi,'NTPC')
!     if ((abs(ds_contact%cont_pressure) .lt. 1.d0) .or. (ds_contact%iteration_newton .eq. 1)) then 
        coef_refe  =  1.d12*nb_cont_poin* (ds_contact%arete_max/ds_contact%arete_min)
        F_refe = max(coef_refe*ds_contact%arete_min,1.d0,ds_contact%cont_pressure)
!     else 
!         F_refe = abs(ds_contact%cont_pressure)
!     endif
    !On verifie que le point est stabilise en pression, suivant le cas
    if ((indi_cont_eval .eq. 1) .and. (indi_cont_prev .eq. 1)) resi_press_curr = abs(pres_cont_curr-pres_cont_prev)/F_refe
    if ((indi_cont_eval .eq. 1) .and. (indi_cont_prev .eq. 0)) resi_press_curr = abs(pres_cont_curr)/F_refe
    if ((indi_cont_eval .eq. 0) .and. (indi_cont_prev .eq. 1)) resi_press_curr = 1.d-100
    if ((indi_cont_eval .eq. 0) .and. (indi_cont_prev .eq. 0)) resi_press_curr = 1.d-100
    if (resi_press_curr .gt. ds_contact%resi_pressure)    ds_contact%resi_pressure = resi_press_curr
    
!     if (indi_cont_eval .eq. 1) then
!         write (6,*) "ROUTINE FLI-FLOP : etat cylage",cycl_stat
!
!   - Un point a fait du flip-flop
!
!         if ((ds_contact%iteration_newton .ge. 1 ) ) then
            if (abs(pres_cont_curr) .gt.pres_near_zero) then 
                cycl_stat    =    0
                ! "PRESSIONS DE CONTACT TROP ELEVEES POUR ACTIVER LE FLIP-FLOP: "
!                 "ON DESACTIVE LE FLIP-FLOP "
!                 write (6,*) "Point de contact non declenche FLIP_FLOP : i_cont_poin",i_cont_poin
            else
                cycl_stat = -10
!                 write (6,*) "FLIP-FLOP ACTIF"
!                 write (6,*) "Point de contact en FLIP_FLOP : i_cont_poin",i_cont_poin
!                 write (6,*) "Pression de contact en FLIP_FLOP courante   : ",pres_cont_curr
!                 write (6,*) "Pression de contact en FLIP_FLOP précédente : ",pres_cont_prev
!                 write (6,*) "SOMME TOTALE DES FORCES DE CONTACT : ",ds_contact%cont_pressure
            endif
!         endif                    
    
!     endif

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
