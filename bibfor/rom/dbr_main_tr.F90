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
subroutine dbr_main_tr(ds_para_tr, ds_empi)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/infniv.h"
#include "asterfort/rsexch.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsnoch.h"
#include "asterfort/copisd.h"
#include "asterfort/dismoi.h"
#include "asterfort/romModeParaSave.h"
#include "asterfort/romModeParaRead.h"
!
type(ROM_DS_ParaDBR_TR), intent(inout) :: ds_para_tr
type(ROM_DS_Empi), intent(inout) :: ds_empi
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Compute
!
! Main subroutine to compute empiric modes - Truncation
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_para_tr       : datastructure for truncation parameters
! IO  ds_empi          : datastructure for empiric modes
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: i_mode, nb_mode, i_equa, iret, nb_equa_dom, nb_equa_rom, idx_rom
    character(len=24) :: mode_dom, mode_rom, field_name
    character(len=8) :: model_rom
    real(kind=8) :: mode_freq
    integer :: nb_snap, nume_slice
    real(kind=8), pointer :: v_mode_dom(:) => null()
    real(kind=8), pointer :: v_mode_rom(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_68')
    endif
!
! - Get parameters
!
    nb_mode     = ds_para_tr%ds_empi_init%nb_mode
    nb_equa_dom = ds_para_tr%ds_empi_init%nb_equa
    nb_equa_rom = ds_para_tr%nb_equa_rom
    model_rom   = ds_para_tr%model_rom
    mode_rom    = ds_para_tr%mode_rom 
!
! - Compute
!
    do i_mode = 1, nb_mode
! ----- Read parameters
        call romModeParaRead(ds_para_tr%ds_empi_init%base, i_mode,&
                             field_name_ = field_name,&
                             mode_freq_  = mode_freq,&
                             nume_slice_ = nume_slice,&
                             nb_snap_    = nb_snap)
! ----- Get mode (complete)
        call rsexch(' ', ds_empi%base, field_name, i_mode,&
                    mode_dom, iret)
        ASSERT(iret .eq. 0)
        call jeveuo(mode_dom(1:19)//'.VALE', 'L', vr = v_mode_dom)
! ----- Access to new mode (reduced)
        call jeveuo(mode_rom(1:19)//'.VALE', 'E', vr = v_mode_rom)
! ----- Truncation
        idx_rom = 0
        do i_equa = 1, nb_equa_dom
            if (ds_para_tr%v_equa_rom(i_equa) .ne. 0) then
                idx_rom = idx_rom + 1
                ASSERT(idx_rom .le. nb_equa_rom)
                v_mode_rom(idx_rom) = v_mode_dom(i_equa)
            endif
        enddo
! ----- Save mode
        call copisd('CHAMP_GD', 'G', mode_rom, mode_dom)
        call rsnoch(ds_empi%base, field_name, i_mode)
! ----- Save parameters
        call romModeParaSave(ds_empi%base, i_mode,&
                             model_rom   ,&
                             field_name  ,&
                             mode_freq   ,&
                             nume_slice  ,&
                             nb_snap)     
    enddo
!
end subroutine
