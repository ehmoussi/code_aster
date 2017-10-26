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
subroutine nmcrld(sddisc)
!
implicit none
!
#include "asterf_types.h"
#include "event_def.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/utdidt.h"
#include "asterfort/wkvect.h"
!
character(len=19) :: sddisc
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE *_NON_LINE (STRUCTURES DE DONNES - DISCRETISATION)
!
! CREATION EVENEMENTS ERREURS: ARRET
!
! --------------------------------------------------------------------------------------------------
!
! In  sddisc           : datastructure for time discretization
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_fail, i_fail_save
    character(len=24) :: sddisc_eevenr
    real(kind=8), pointer :: v_sddisc_eevenr(:) => null()
    character(len=24) :: sddisc_eevenk
    character(len=16), pointer :: v_sddisc_eevenk(:) => null()
    character(len=24) :: sddisc_esubdr
    real(kind=8), pointer :: v_sddisc_esubdr(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    nb_fail     = 1
    i_fail_save = 1
    call utdidt('E', sddisc, 'LIST', 'NECHEC', vali_ = nb_fail)
!
! - Create datastructure
!
    sddisc_eevenr = sddisc(1:19)//'.EEVR'
    sddisc_eevenk = sddisc(1:19)//'.EEVK'
    sddisc_esubdr = sddisc(1:19)//'.ESUR'
    call wkvect(sddisc_eevenr, 'V V R'  , nb_fail*SIZE_LEEVR, vr   = v_sddisc_eevenr)
    call wkvect(sddisc_eevenk, 'V V K16', nb_fail*SIZE_LEEVK, vk16 = v_sddisc_eevenk)
    call wkvect(sddisc_esubdr, 'V V R'  , nb_fail*SIZE_LESUR, vr   = v_sddisc_esubdr)
!
! - Create default action: if ERROR => STOP
!
    v_sddisc_eevenr(SIZE_LEEVR*(i_fail_save-1)+1) = FAIL_EVT_ERROR
    v_sddisc_eevenr(SIZE_LEEVR*(i_fail_save-1)+2) = FAIL_ACT_STOP
!
    call jedema()
!
end subroutine
