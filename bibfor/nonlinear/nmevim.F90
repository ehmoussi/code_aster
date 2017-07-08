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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nmevim(ds_print, sddisc, sderro, loop_name)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "event_def.h"
#include "asterfort/assert.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nmacto.h"
#include "asterfort/nmerge.h"
#include "asterfort/nmimpx.h"
#include "asterfort/nmlecv.h"
#include "asterfort/nmltev.h"
#include "asterfort/utdidt.h"
#include "asterfort/utmess.h"
#include "asterfort/getFailEvent.h"
!
type(NL_DS_Print), intent(in) :: ds_print
character(len=24), intent(in) :: sderro
character(len=19), intent(in) :: sddisc
character(len=4), intent(in) :: loop_name
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Event management
!
! Print event messages
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_print         : datastructure for printing parameters
! In  sddisc           : datastructure for time discretization TEMPORELLE
! In  sderro           : name of datastructure for error management (events)
! In  loop_name        : name of loop
!                         'NEWT' - Newton loop
!                         'FIXE' - Fixed points loop
!                         'INST' - Step time loop
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: lacti, cvbouc, lerrei, l_sep_line, lldcbo
    integer :: i_fail_acti
    integer :: ieven, zeven
    character(len=24) :: sderro_info
    character(len=24) :: sderro_eact
    character(len=24) :: sderro_eniv
    character(len=24) :: sderro_emsg
    integer, pointer :: v_sderro_info(:) => null()
    integer, pointer :: v_sderro_eact(:) => null()
    character(len=16), pointer :: v_sderro_eniv(:) => null()
    character(len=24), pointer :: v_sderro_emsg(:) => null()
    integer :: icode, event_type
    character(len=9) :: teven
    character(len=24) :: meven
!
! --------------------------------------------------------------------------------------------------
!
    call nmlecv(sderro, loop_name, cvbouc)
    call nmltev(sderro, 'ERRI', loop_name, lerrei)
    call nmerge(sderro, 'INTE_BORN', lldcbo)
!
! - Separator line to print ?
!
    l_sep_line = (.not.cvbouc.and..not.lerrei.and..not.lldcbo)
!
! - Access to error management datastructure
!
    sderro_info = sderro(1:19)//'.INFO'
    sderro_eact = sderro(1:19)//'.EACT'
    sderro_eniv = sderro(1:19)//'.ENIV'
    sderro_emsg = sderro(1:19)//'.EMSG'
    call jeveuo(sderro_info, 'L', vi = v_sderro_info)
    call jeveuo(sderro_eact, 'L', vi = v_sderro_eact)
    call jeveuo(sderro_eniv, 'L', vk16 = v_sderro_eniv)
    call jeveuo(sderro_emsg, 'L', vk24 = v_sderro_emsg)
    zeven = v_sderro_info(1)
!
! - Print event messages - Algorithm
!
    do ieven = 1, zeven
        icode = v_sderro_eact(ieven)
        teven = v_sderro_eniv(ieven)(1:9)
        meven = v_sderro_emsg(ieven)
        if ((teven(1:4).eq.'EVEN') .and. (icode.eq.1)) then
            if (meven .ne. ' ') then
                if (l_sep_line) then
                    call nmimpx(ds_print)
                endif
                if (meven .eq. 'MECANONLINE10_1') then
                    call utmess('I', 'MECANONLINE10_1')
                else if (meven.eq.'MECANONLINE10_2') then
                    call utmess('I', 'MECANONLINE10_2')
                else if (meven.eq.'MECANONLINE10_3') then
                    call utmess('I', 'MECANONLINE10_3')
                else if (meven.eq.'MECANONLINE10_4') then
                    call utmess('I', 'MECANONLINE10_4')
                else if (meven.eq.'MECANONLINE10_5') then
                    call utmess('I', 'MECANONLINE10_5')
                else if (meven.eq.'MECANONLINE10_6') then
                    call utmess('I', 'MECANONLINE10_6')
                else if (meven.eq.'MECANONLINE10_7') then
                    call utmess('I', 'MECANONLINE10_7')
                else if (meven.eq.'MECANONLINE10_8') then
                    call utmess('I', 'MECANONLINE10_8')
                else if (meven.eq.'MECANONLINE10_9') then
                    call utmess('I', 'MECANONLINE10_9')
                else if (meven.eq.'MECANONLINE10_10') then
                    call utmess('I', 'MECANONLINE10_10')
                else if (meven.eq.'MECANONLINE10_11') then
                    call utmess('I', 'MECANONLINE10_11')
                else if (meven.eq.'MECANONLINE10_12') then
                    call utmess('I', 'MECANONLINE10_12')
                else if (meven.eq.'MECANONLINE10_20') then
                    call utmess('I', 'MECANONLINE10_20')
                else if (meven.eq.'MECANONLINE10_24') then
                    call utmess('I', 'MECANONLINE10_24')
                 else if (meven.eq.'MECANONLINE10_26') then
                    call utmess('I', 'MECANONLINE10_26')
                else if (meven.eq.'MECANONLINE10_25') then
                    if (cvbouc .and. loop_name .eq. 'NEWT') then
                        call utmess('A', 'MECANONLINE10_25')
                    endif
                else
                    ASSERT(.false.)
                endif
            endif
        endif
    end do
!
! - Print event messages - User
!
    call nmacto(sddisc, i_fail_acti)
    lacti = i_fail_acti.gt.0
    if (lacti) then
! ----- Get event type
        call getFailEvent(sddisc, i_fail_acti, event_type)
        if (event_type .eq. FAIL_EVT_COLLISION) then
            if (l_sep_line) then
                call nmimpx(ds_print)
            endif
            call utmess('I', 'MECANONLINE10_21')
        else if (event_type .eq. FAIL_EVT_INTERPENE) then
            if (l_sep_line) then
                call nmimpx(ds_print)
            endif
            call utmess('I', 'MECANONLINE10_22')
        else if (event_type .eq. FAIL_EVT_DIVE_RESI) then
            if (l_sep_line) then
                call nmimpx(ds_print)
            endif
            call utmess('I', 'MECANONLINE10_23')
        else if (event_type .eq. FAIL_EVT_RESI_MAXI) then
            if (l_sep_line) then
                call nmimpx(ds_print)
            endif
            call utmess('I', 'MECANONLINE10_26')
        else if (event_type .eq. FAIL_EVT_INCR_QUANT) then
            if (l_sep_line) then
                call nmimpx(ds_print)
            endif
            call utmess('I', 'MECANONLINE10_24')
        endif
    endif
!
end subroutine
