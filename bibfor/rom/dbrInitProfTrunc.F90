! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
subroutine dbrInitProfTrunc(resultNameIn, resultNameOut, paraTrunc)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/gnomsd.h"
#include "asterfort/copisd.h"
#include "asterfort/rsexch.h"
#include "asterfort/romModeParaRead.h"
!
character(len=8), intent(in) :: resultNameIn, resultNameOut
type(ROM_DS_ParaDBR_Trunc), intent(inout) :: paraTrunc
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Create PROF_CHNO for truncation
!
! --------------------------------------------------------------------------------------------------
!
! In  resultNameIn     : name of base to truncate
! In  resultNameOut    : name of results datastructure to save base
! IO  paraTrunc        : datastructure for parameters (truncation)
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: numeModeRefe = 1
    integer :: iret, physNume
    character(len=24) :: profChnoNew, modeSymbName, modeRefe
    character(len=19) :: profChnoRefe
!
! --------------------------------------------------------------------------------------------------
!
!
! - Get symbolic name of mode
!
    call romModeParaRead(resultNameIn, numeModeRefe, modeSymbName_ = modeSymbName)
!
! - Get mode (complete)
!
    call rsexch(' '     , resultNameIn, modeSymbName, numeModeRefe,&
                modeRefe, iret)
    ASSERT(iret .eq. 0)
!
! - Get parameters from numbering
!
    call dismoi('NUM_GD'   , modeRefe, 'CHAM_NO', repi = physNume)
    call dismoi('PROF_CHNO', modeRefe, 'CHAM_NO', repk = profChnoRefe)
!
! - Create name of new PROF_CHNO
!
    profChnoNew = resultNameOut(1:8)//'.00000'
    call gnomsd(' ', profChnoNew, 10, 14)
!
! - Duplicate numbering
!
    call copisd('PROF_CHNO', 'G', profChnoRefe, profChnoNew)
!
! - Save parameters
!
    paraTrunc%profChnoRom = profChnoNew
    paraTrunc%physNume    = physNume
!
end subroutine
