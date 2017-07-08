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
subroutine dfllec(sdlist, dtmin)
!
implicit none
!
#include "asterf_types.h"
#include "event_def.h"
#include "asterfort/dfdevn.h"
#include "asterfort/dfllac.h"
#include "asterfort/dfllne.h"
#include "asterfort/dfllpe.h"
#include "asterfort/dfllsv.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/wkvect.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
!
character(len=8), intent(in) :: sdlist
real(kind=8), intent(in) :: dtmin
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_LIST_INST - Read parameters
!
! Keyword ECHEC
!
! --------------------------------------------------------------------------------------------------
!
! In  sdlist           : name of DEFI_LIST_INST datastructure
! In  dtmin            : minimum time increment in list of times
!
! --------------------------------------------------------------------------------------------------
!
    integer :: event_list(FAIL_EVT_NB)
    character(len=16) :: keywf
    character(len=16) :: nom_cham, nom_cmp, crit_cmp
    real(kind=8) :: vale_ref, subd_pas_mini
    integer :: nb_fail_read, nb_fail
    integer :: i_fail, i_event, i_fail_save
    character(len=16) :: event_typek, action_type, event_curr
    character(len=16) :: subd_method, subd_auto
    integer :: subd_pas, subd_niveau
    real(kind=8) :: subd_niveau_r, subd_niveau_maxi
    real(kind=8) :: pcent_iter_plus, pene_maxi, resi_glob_maxi
    real(kind=8) :: coef_maxi, subd_inst, subd_duree
    aster_logical :: l_save, l_fail_error
    integer :: i_last, iplus
    integer, pointer :: v_work(:) => null()
    character(len=24) :: sdlist_eevenr
    real(kind=8), pointer :: v_sdlist_eevenr(:) => null()
    character(len=24) :: sdlist_eevenk
    character(len=16), pointer :: v_sdlist_eevenk(:) => null()
    character(len=24) :: sdlist_esubdr
    real(kind=8), pointer :: v_sdlist_esubdr(:) => null()
    character(len=24) :: sdlist_linfor
    real(kind=8), pointer :: v_sdlist_linfor(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    keywf         = 'ECHEC'
    nb_fail_read  = 0
    nb_fail       = 0
    event_list(:) = 0
!
! - Get number of failure keywords
!
    call dfllne(keywf, nb_fail_read, l_fail_error)
    nb_fail = nb_fail_read
!
! - ERROR failure is required
!
    if (.not. l_fail_error) then
        nb_fail = nb_fail + 1
    endif
!
! - Access to datastructures
!
    sdlist_linfor = sdlist(1:8)//'.LIST.INFOR'
    call jeveuo(sdlist_linfor, 'E', vr = v_sdlist_linfor)
!
! - Create datastructure
!
    sdlist_eevenr = sdlist(1:8)//'.ECHE.EVENR'
    sdlist_eevenk = sdlist(1:8)//'.ECHE.EVENK'
    sdlist_esubdr = sdlist(1:8)//'.ECHE.SUBDR'
    call wkvect(sdlist_eevenr, 'G V R'  , nb_fail*SIZE_LEEVR, vr   = v_sdlist_eevenr)
    call wkvect(sdlist_eevenk, 'G V K16', nb_fail*SIZE_LEEVK, vk16 = v_sdlist_eevenk)
    call wkvect(sdlist_esubdr, 'G V R'  , nb_fail*SIZE_LESUR, vr   = v_sdlist_esubdr)
    v_sdlist_linfor(9) = nb_fail
!
! - Ordering list of events
!
    AS_ALLOCATE(vi=v_work, size=nb_fail)
    i_last = 1
    do i_event = 1, FAIL_EVT_NB
        event_curr = failEventKeyword(i_event)
        do i_fail = 1, nb_fail_read
            call getvtx(keywf, 'EVENEMENT', iocc=i_fail, scal=event_typek)
            if (event_typek .eq. event_curr) then
                event_list(i_event) = i_fail
                if (event_typek .eq. failEventKeyword(FAIL_EVT_INCR_QUANT)) then
                    v_work(i_last) = i_fail
                    i_last = i_last + 1
                endif
            endif
        end do
    end do
!
! - List
!
    i_fail_save = 0
    iplus       = 0
    i_last      = 1
    do i_event = 1, FAIL_EVT_NB
!
! ----- Current event
!
        i_fail     = event_list(i_event)
        event_curr = failEventKeyword(i_event)
!
! ----- Event to create
!
157     continue
        if (i_fail .eq. 0) then
! --------- This event doesn't exist but it's required
            if (event_curr .eq. failEventKeyword(FAIL_EVT_ERROR)) then
                event_typek = event_curr
                iplus       = 0
                i_fail_save = i_fail_save + 1
            endif
        else
            event_typek = event_curr
            if (event_typek .eq. failEventKeyword(FAIL_EVT_INCR_QUANT)) then
! ------------- This event must be at end of list
                iplus  = v_work(i_last)
                i_fail = iplus
                if (iplus .eq. 0) then
                    i_fail = 0
                else
                    i_fail_save = i_fail_save + 1
                    i_last      = i_last + 1
                endif
            else
                i_fail_save = i_fail_save + 1
            endif
        endif
!
! ----- Get parameters
!
        l_save = .false.
        if (i_fail .eq. 0) then
            if (event_curr .eq. failEventKeyword(FAIL_EVT_ERROR)) then
! ------------- Default value for this event
                call dfdevn(action_type, subd_method, subd_pas_mini, subd_pas, subd_niveau)
                l_save = .true.
            endif
        else
! --------- Get parameters of EVENEMENT for current failure keyword
            call dfllpe(keywf    , i_fail        , event_typek,&
                        vale_ref , nom_cham      , nom_cmp   , crit_cmp,&
                        pene_maxi, resi_glob_maxi)
! --------- Get parameters of ACTION for current failure keyword
            call dfllac(keywf          , i_fail       , dtmin     , event_typek,&
                        action_type    ,&
                        subd_method    , subd_pas_mini,&
                        subd_niveau    , subd_pas     ,&
                        subd_auto      , subd_inst    , subd_duree,&
                        pcent_iter_plus, coef_maxi    )
            l_save = .true.
        endif
!
! ----- Save parameters in datastructure
!
        if (l_save) then
            call dfllsv(v_sdlist_linfor, v_sdlist_eevenr, v_sdlist_eevenk, v_sdlist_esubdr,&
                        i_fail_save    ,&
                        event_typek    , vale_ref       , nom_cham       , nom_cmp        ,&
                        crit_cmp       , pene_maxi      , resi_glob_maxi ,&
                        action_type    , subd_method    , subd_auto      , subd_pas_mini  ,&
                        subd_pas       , subd_niveau    , pcent_iter_plus, coef_maxi      ,&
                        subd_inst      , subd_duree)
        endif
        if (iplus .ne. 0) then
            goto 157
        endif
    end do
!
! - Compute maximum level of time step cutting
!
    subd_niveau_maxi = 0.d0
    do i_fail = 1, nb_fail
        subd_niveau_r    = v_sdlist_esubdr(SIZE_LESUR*(i_fail-1)+4)
        subd_niveau_maxi = max(subd_niveau_r, subd_niveau_maxi)
    end do
    do i_fail = 1, nb_fail
        v_sdlist_esubdr(SIZE_LESUR*(i_fail-1)+4) = subd_niveau_maxi
    end do
!
    AS_DEALLOCATE(vi=v_work)
    call jedema()
end subroutine
