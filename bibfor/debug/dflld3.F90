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
subroutine dflld3(sdlist, i_adap)
!
implicit none
!
#include "asterf_types.h"
#include "event_def.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
!
character(len=8), intent(in) :: sdlist
integer, intent(in) :: i_adap
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_LIST_INST
!
! Print for next time step evaluation
!
! --------------------------------------------------------------------------------------------------
!
! In  sdlist           : name of DEFI_LIST_INST datastructure
! In  i_adap           : current scheme of adaptation
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: sdlist_aevenr
    real(kind=8), pointer :: v_sdlist_aevenr(:) => null()
    character(len=24) :: sdlist_atplur
    real(kind=8), pointer :: v_sdlist_atplur(:) => null()
    character(len=24) :: sdlist_atpluk
    character(len=16), pointer :: v_sdlist_atpluk(:) => null()
    integer :: action_type, nb_iter_newton_ref
    real(kind=8) :: pcent_augm, vale_ref
    character(len=16):: nom_cham, nom_cmp, crit_cmp
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Access to datastructures
!
    sdlist_aevenr = sdlist(1:8)//'.ADAP.EVENR'
    sdlist_atplur = sdlist(1:8)//'.ADAP.TPLUR'
    sdlist_atpluk = sdlist(1:8)//'.ADAP.TPLUK'
    call jeveuo(sdlist_aevenr, 'L', vr   = v_sdlist_aevenr)
    call jeveuo(sdlist_atplur, 'L', vr   = v_sdlist_atplur)
    call jeveuo(sdlist_atpluk, 'L', vk16 = v_sdlist_atpluk)
!
! - Print
!
    action_type = nint(v_sdlist_atplur(SIZE_LATPR*(i_adap-1)+1))
    pcent_augm  = v_sdlist_atplur(SIZE_LATPR*(i_adap-1)+2)
    vale_ref    = v_sdlist_atplur(SIZE_LATPR*(i_adap-1)+3)
    nom_cham    = v_sdlist_atpluk(SIZE_LATPK*(i_adap-1)+2)
    nom_cmp     = v_sdlist_atpluk(SIZE_LATPK*(i_adap-1)+3)
    crit_cmp    = 'GE'
    nb_iter_newton_ref = nint(v_sdlist_atplur(SIZE_LATPR*(i_adap-1)+5))
    if (action_type .eq. ADAP_ACT_FIXE) then
        call utmess('I', 'DISCRETISATION3_80')
        call utmess('I', 'DISCRETISATION3_84', sr = pcent_augm)
    elseif (action_type .eq. ADAP_ACT_INCR_QUANT) then
        call utmess('I', 'DISCRETISATION3_81')
        call utmess('I', 'DISCRETISATION3_21', &
                    nk = 3, valk = [nom_cham, nom_cmp, crit_cmp],&
                    sr = vale_ref)
    elseif (action_type .eq. ADAP_ACT_ITER) then
        call utmess('I', 'DISCRETISATION3_82')
        call utmess('I', 'DISCRETISATION3_85', si = nb_iter_newton_ref)
    elseif (action_type .eq. ADAP_ACT_IMPLEX) then
        call utmess('I', 'DISCRETISATION3_83')
    endif
!
    call jedema()
end subroutine
