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
!
subroutine nzcomp_prep(jv_mater, phase_type,&
                       nb_vari , metaPara)
!
use Metallurgy_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/Metallurgy_type.h"
#include "asterfort/metaSteelGetParameters.h"
#include "asterfort/metaSteelTRCGetParameters.h"
!
integer, intent(in) :: jv_mater
character(len=16), intent(in) :: phase_type
integer, intent(out) :: nb_vari
type(META_MaterialParameters), intent(out) :: metaPara
!
! --------------------------------------------------------------------------------------------------
!
! METALLURGY - Compute phases
!
! General (preparation)
!
! --------------------------------------------------------------------------------------------------
!
! In  jv_mater            : coded material address
! In  phase_type          : type of phase
! Out nb_vari             : number of internal state variable
! Out metaPara            : material parameters for metallurgy
!
! --------------------------------------------------------------------------------------------------
!
    type(META_SteelParameters) :: metaSteelPara
!
! --------------------------------------------------------------------------------------------------
!
    if (phase_type .eq. 'ACIER') then
! ----- Get material parameters for steel
        call metaSteelGetParameters(jv_mater, metaSteelPara)
! ----- Get material parameters for TRC curve   
        call metaSteelTRCGetParameters(jv_mater, metaSteelPara)
        nb_vari = STEEL_NBVARI
    elseif (phase_type .eq. 'ZIRC') then
        nb_vari = ZIRC_NBVARI
    else
        ASSERT(ASTER_FALSE)
    endif
!
    metaPara%steel = metaSteelPara
!
end subroutine
