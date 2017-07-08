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

subroutine dflldb(sdlist)
!
implicit none
!
#include "asterf_types.h"
#include "event_def.h"
#include "asterfort/assert.h"
#include "asterfort/dflld2.h"
#include "asterfort/dflld3.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
!
character(len=8), intent(in) :: sdlist
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_LIST_INST
!
! Debug
!
! --------------------------------------------------------------------------------------------------
!
! In  sdlist           : name of DEFI_LIST_INST datastructure
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_fail, nb_fail, nb_inst, i_adap, nb_adap
    integer :: nb_pas_maxi
    real(kind=8) :: dtmin, step_mini, step_maxi
    character(len=24) :: sdlist_eevenr
    real(kind=8), pointer :: v_sdlist_eevenr(:) => null()
    character(len=24) :: sdlist_eevenk
    character(len=16), pointer :: v_sdlist_eevenk(:) => null()
    character(len=24) :: sdlist_esubdr
    real(kind=8), pointer :: v_sdlist_esubdr(:) => null()
    character(len=24) :: sdlist_linfor
    real(kind=8), pointer :: v_sdlist_linfor(:) => null()
    character(len=24) :: sdlist_aevenr
    real(kind=8), pointer :: v_sdlist_aevenr(:) => null()
    real(kind=8) :: vale_ref, pene_maxi, resi_glob_maxi, pcent_iter_plus, coef_maxi
    character(len=16):: nom_cham, nom_cmp, crit_cmp
    integer :: nb_incr_seuil, nb_iter_newt, crit_compi
    integer :: event_type, action_type
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Access to datastructures
!
    sdlist_linfor = sdlist(1:8)//'.LIST.INFOR'
    call jeveuo(sdlist_linfor, 'L', vr = v_sdlist_linfor)
    sdlist_eevenr = sdlist(1:8)//'.ECHE.EVENR'
    sdlist_eevenk = sdlist(1:8)//'.ECHE.EVENK'
    sdlist_esubdr = sdlist(1:8)//'.ECHE.SUBDR'
    call jeveuo(sdlist_eevenr, 'L', vr   = v_sdlist_eevenr)
    call jeveuo(sdlist_eevenk, 'L', vk16 = v_sdlist_eevenk)
    call jeveuo(sdlist_esubdr, 'L', vr   = v_sdlist_esubdr)
!
! - Get main parameters
!
    step_mini   = v_sdlist_linfor(2)
    step_maxi   = v_sdlist_linfor(3)
    nb_pas_maxi = nint(v_sdlist_linfor(4))
    dtmin       = v_sdlist_linfor(5)
    nb_fail     = nint(v_sdlist_linfor(9))
    nb_inst     = nint(v_sdlist_linfor(8))
    nb_adap     = nint(v_sdlist_linfor(10))
!
! - Time list management
!
    if (nint(v_sdlist_linfor(1)) .eq. 1) then
        call utmess('I', 'DISCRETISATION3_1')
    else if (nint(v_sdlist_linfor(1)) .eq. 2) then
        call utmess('I', 'DISCRETISATION3_2')
        call utmess('I', 'DISCRETISATION3_3',&
            nr = 2, valr = [step_mini,step_maxi],&
            si = nb_pas_maxi)
    else
        ASSERT(.false.)
    endif
    call utmess('I', 'DISCRETISATION3_4', si = nb_inst, sr = dtmin)
!
! - Failures
!
    if (nb_fail .gt. 0) then
        call utmess('I', 'DISCRETISATION3_5', si = nb_fail)
        do i_fail = 1, nb_fail
            vale_ref       = v_sdlist_eevenr(SIZE_LEEVR*(i_fail-1)+5)
            pene_maxi      = v_sdlist_eevenr(SIZE_LEEVR*(i_fail-1)+6)
            resi_glob_maxi = v_sdlist_eevenr(SIZE_LEEVR*(i_fail-1)+7)
            nom_cham       = v_sdlist_eevenk(SIZE_LEEVK*(i_fail-1)+1)
            nom_cmp        = v_sdlist_eevenk(SIZE_LEEVK*(i_fail-1)+2)
            crit_cmp       = v_sdlist_eevenk(SIZE_LEEVK*(i_fail-1)+3)
            event_type     = nint(v_sdlist_eevenr(SIZE_LEEVR*(i_fail-1)+1))
            if (event_type .eq. FAIL_EVT_ERROR) then
                call utmess('I', 'DISCRETISATION3_10', si = i_fail)
            else if (event_type .eq. FAIL_EVT_INCR_QUANT) then
                call utmess('I', 'DISCRETISATION3_11', si = i_fail)
                call utmess('I', 'DISCRETISATION3_21', &
                            nk = 3, valk = [nom_cham, nom_cmp, crit_cmp],&
                            sr = vale_ref)
            else if (event_type .eq. FAIL_EVT_COLLISION) then
                call utmess('I', 'DISCRETISATION3_12', si = i_fail)
            else if (event_type .eq. FAIL_EVT_INTERPENE) then
                call utmess('I', 'DISCRETISATION3_13', si = i_fail)
                call utmess('I', 'DISCRETISATION3_22', sr = pene_maxi)
            else if (event_type .eq. FAIL_EVT_DIVE_RESI) then
                call utmess('I', 'DISCRETISATION3_14', si = i_fail)
            else if (event_type .eq. FAIL_EVT_INSTABILITY) then
                call utmess('I', 'DISCRETISATION3_15', si = i_fail)
            else if (event_type .eq. FAIL_EVT_RESI_MAXI) then
                call utmess('I', 'DISCRETISATION3_16', si = i_fail)
                call utmess('I', 'DISCRETISATION3_23', sr = resi_glob_maxi)
            else
                ASSERT(.false.)
            endif
!
! --------- Action
!
            pcent_iter_plus = v_sdlist_esubdr(SIZE_LESUR*(i_fail-1)+7)
            coef_maxi       = v_sdlist_esubdr(SIZE_LESUR*(i_fail-1)+8)
            action_type     = nint(v_sdlist_eevenr(SIZE_LEEVR*(i_fail-1)+2))
            if (action_type .eq. FAIL_ACT_STOP) then
                call utmess('I', 'DISCRETISATION3_30')
            else if (action_type .eq. FAIL_ACT_CUT) then
                call utmess('I', 'DISCRETISATION3_31')
                call dflld2(sdlist, i_fail)
            else if (action_type .eq. FAIL_ACT_ITER) then
                call utmess('I', 'DISCRETISATION3_32')
                if (nint(v_sdlist_esubdr(SIZE_LESUR*(i_fail-1)+1)) .eq. 0) then
                    call utmess('I', 'DISCRETISATION3_41', sr = pcent_iter_plus)
                else 
                    call utmess('I', 'DISCRETISATION3_42', sr = pcent_iter_plus)
                    call dflld2(sdlist, i_fail)
                endif
            else if (action_type .eq. FAIL_ACT_PILOTAGE) then
                if (nint(v_sdlist_esubdr(SIZE_LESUR*(i_fail-1)+1)) .eq. 0) then
                    call utmess('I', 'DISCRETISATION3_33')
                else if (nint(v_sdlist_esubdr(SIZE_LESUR*(i_fail-1)+1)) .eq. 1) then
                    call utmess('I', 'DISCRETISATION3_34')
                    call dflld2(sdlist, i_fail)
                endif
            else if (action_type .eq. FAIL_ACT_ADAPT_COEF) then
                call utmess('I', 'DISCRETISATION3_35')
                call utmess('I', 'DISCRETISATION3_45', sr = coef_maxi)
            else if (action_type .eq. FAIL_ACT_CONTINUE) then
                call utmess('I', 'DISCRETISATION3_36')
            else
                ASSERT(.false.)
            endif
        end do
    endif
!
! - Adaptation
!
    if (nb_adap .gt. 0) then
        sdlist_aevenr = sdlist(1:8)//'.ADAP.EVENR'
        call jeveuo(sdlist_aevenr, 'L', vr = v_sdlist_aevenr)
        call utmess('I', 'DISCRETISATION3_6', si = nb_adap)
        do i_adap = 1, nb_adap
            nb_incr_seuil = nint(v_sdlist_aevenr(SIZE_LAEVR*(i_adap-1)+2))
            nb_iter_newt  = nint(v_sdlist_aevenr(SIZE_LAEVR*(i_adap-1)+5))
            crit_compi    = nint(v_sdlist_aevenr(SIZE_LAEVR*(i_adap-1)+4))
            event_type    = nint(v_sdlist_aevenr(SIZE_LAEVR*(i_adap-1)+1))
            if (event_type .eq. ADAP_EVT_NONE) then
                call utmess('I', 'DISCRETISATION3_50', si = i_adap)
            else if (event_type .eq. ADAP_EVT_ALLSTEPS) then
                call utmess('I', 'DISCRETISATION3_51', si = i_adap)  
                call dflld3(sdlist, i_adap)
            else if (event_type .eq. ADAP_EVT_TRIGGER) then
                call utmess('I', 'DISCRETISATION3_52', si = i_adap)
                if (crit_compi .eq. 1) then
                    call utmess('I', 'DISCRETISATION3_64', ni = 2,&
                                vali = [nb_incr_seuil, nb_iter_newt])
                elseif (crit_compi .eq. 2) then
                    call utmess('I', 'DISCRETISATION3_66', ni = 2,&
                                vali = [nb_incr_seuil, nb_iter_newt])
                elseif (crit_compi .eq. 3) then
                    call utmess('I', 'DISCRETISATION3_63', ni = 2,&
                                vali = [nb_incr_seuil, nb_iter_newt])
                elseif (crit_compi .eq. 4) then
                    call utmess('I', 'DISCRETISATION3_65', ni = 2,&
                                vali = [nb_incr_seuil, nb_iter_newt])
                endif
                call dflld3(sdlist, i_adap)
            endif
        end do
    endif
!
    call jedema()
end subroutine
