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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine dbr_init_prof_tr(base, ds_para_tr)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/gnomsd.h"
#include "asterfort/jedup1.h"
#include "asterfort/rsexch.h"
#include "asterfort/romModeParaRead.h"
!
character(len=8), intent(in) :: base
type(ROM_DS_ParaDBR_TR), intent(inout) :: ds_para_tr
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Create PROF_CHNO for truncation
!
! --------------------------------------------------------------------------------------------------
!
! In  base             : name of empiric base
! IO  ds_para_tr       : datastructure for truncation parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_mode, iret, idx_gd
    character(len=24) :: prno_new, field_name, mode_ref
    character(len=19) :: prno_old
!
! --------------------------------------------------------------------------------------------------
!
!
! - Get mode (complete)
!
    i_mode = 1
    call romModeParaRead(ds_para_tr%base_init, i_mode,&
                         field_name_ = field_name)
    call rsexch(' ', ds_para_tr%base_init, field_name, i_mode,&
                mode_ref, iret)
    ASSERT(iret .eq. 0)
!
! - Create PROF_CHNO
!
    call dismoi('NUM_GD'   , mode_ref, 'CHAM_NO', repi=idx_gd)
    call dismoi('PROF_CHNO', mode_ref, 'CHAM_NO', repk=prno_old)
    prno_new = base(1:8)//'.00000'
    call gnomsd(' ', prno_new, 10, 14)
    call jedup1(prno_old(1:19)//'.DEEQ', 'G', prno_new(1:14)//'     .DEEQ')
    call jedup1(prno_old(1:19)//'.NUEQ', 'G', prno_new(1:14)//'     .NUEQ')
    call jedup1(prno_old(1:19)//'.PRNO', 'G', prno_new(1:14)//'     .PRNO')
    call jedup1(prno_old(1:19)//'.LILI', 'G', prno_new(1:14)//'     .LILI')
!
! - Save parameters
!
    ds_para_tr%prof_chno_rom = prno_new
    ds_para_tr%idx_gd        = idx_gd
!
end subroutine
