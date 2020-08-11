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
subroutine dbr_main_tr(paraTrunc, resultNameOut)
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
#include "asterfort/vtcreb.h"
#include "asterfort/gnomsd.h"
#include "asterfort/romModeParaSave.h"
#include "asterfort/romModeParaRead.h"
!
type(ROM_DS_ParaDBR_TR), intent(in) :: paraTrunc
character(len=8), intent(in) :: resultNameOut
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Compute
!
! Main subroutine to compute empiric modes - Truncation
!
! --------------------------------------------------------------------------------------------------
!
! In  paraTrunc       : datastructure for truncation parameters
! In  resultNameOut   : name of output results
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nbMode, nbEquaDom, nbEquaRom
    integer :: iMode, iEqua, iret, numeEquaRom, numeMode
    character(len=24) :: modeDom, modeRom, modeSymbName, profChno
    character(len=8) :: modelRom, resultNameIn, mesh
    real(kind=8) :: modeSing
    integer :: nbSnap, numeSlice, physNume
    real(kind=8), pointer :: valeDom(:) => null(), valeRom(:) => null()
    type(ROM_DS_Empi) :: baseIn
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_68')
    endif
!
! - Get parameters of operation
!
    nbEquaRom    = paraTrunc%nb_equa_rom
    modelRom     = paraTrunc%model_rom
    profChno     = paraTrunc%prof_chno_rom
    physNume     = paraTrunc%idx_gd
    baseIn       = paraTrunc%ds_empi_init
!
! - Get parameters of input base
!
    nbMode       = baseIn%nb_mode
    nbEquaDom    = baseIn%ds_mode%nbEqua
    resultNameIn = baseIn%base
    mesh         = baseIn%ds_mode%mesh
!
! - Compute
!
    do iMode = 1, nbMode
        numeMode = iMode
! ----- Read parameters
        call romModeParaRead(resultNameIn, numeMode,&
                             modeSymbName_ = modeSymbName,&
                             modeSing_     = modeSing,&
                             numeSlice_    = numeSlice,&
                             nbSnap_       = nbSnap)
! ----- Access to complete mode
        call rsexch(' '    , resultNameIn, modeSymbName, numeMode,&
                    modeDom, iret)
        ASSERT(iret .eq. 0)
        call jeveuo(modeDom(1:19)//'.VALE', 'L', vr = valeDom)
! ----- Create new mode (reduced)
        call rsexch(' '    , resultNameOut, modeSymbName, numeMode,&
                    modeRom, iret)
        ASSERT(iret .eq. 100)
        call vtcreb(modeRom, 'G', 'R',&
                    meshz       = mesh,&
                    prof_chnoz  = profChno,&
                    idx_gdz     = physNume,&
                    nb_equa_inz = nbEquaRom)
        call jeveuo(modeRom(1:19)//'.VALE', 'E', vr = valeRom)
! ----- Truncation
        numeEquaRom = 0
        do iEqua = 1, nbEquaDom
            if (paraTrunc%v_equa_rom(iEqua) .ne. 0) then
                numeEquaRom = numeEquaRom + 1
                ASSERT(numeEquaRom .le. nbEquaRom)
                valeRom(numeEquaRom) = valeDom(iEqua)
            endif
        enddo
! ----- Save mode
        call rsnoch(resultNameOut, modeSymbName, numeMode)
! ----- Save parameters
        call romModeParaSave(resultNameOut, numeMode    ,&
                             modelRom     , modeSymbName,&
                             modeSing     , numeSlice   ,&
                             nbSnap)
    enddo
!
end subroutine
