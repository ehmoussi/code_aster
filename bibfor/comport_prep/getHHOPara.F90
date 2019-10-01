! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
subroutine getHHOPara(ds_compor_para)
!
use Behaviour_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/Behaviour_type.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterc/getexm.h"
!
type(Behaviour_PrepCrit), intent(inout) :: ds_compor_para
!
! --------------------------------------------------------------------------------------------------
!
! HHO
!
! Get parameters from STAT_NON_LINE command
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_compor_para   : datastructure to prepare parameters for constitutive laws
!
! --------------------------------------------------------------------------------------------------
!
    integer :: hho_calc, iret, hho_stab
    character(len=16) :: txt
    real(kind=8) :: hho_coef_stab
!
! --------------------------------------------------------------------------------------------------
!
! - Default values
!
    hho_coef_stab = 0.d0
    hho_calc = HHO_CALC_NO
    hho_stab = HHO_STAB_AUTO
!
    if (getexm('HHO','OPTIMISATION') == 1) then
!
        call getvtx('HHO', 'OPTIMISATION', iocc = 1, nbval=0, nbret = iret)
!
        if(iret == -1) then
            call getvtx('HHO', 'OPTIMISATION', iocc = 1, scal=txt, nbret = iret)
            ASSERT(iret == 1)
            if(txt == "MEMOIRE") then
                hho_calc = HHO_CALC_NO
            elseif(txt == "TEMPS") then
                hho_calc = HHO_CALC_YES
            else
                ASSERT(ASTER_FALSE)
            end if
        end if
!
    end if
!
    if (getexm('HHO','STABILISATION') == 1) then
!
        call getvtx('HHO', 'STABILISATION', iocc = 1, nbval=0, nbret = iret)
!
        if(iret == -1) then
            call getvtx('HHO', 'STABILISATION', iocc = 1, scal=txt, nbret = iret)
            ASSERT(iret == 1)
            if(txt == "AUTO") then
                hho_stab = HHO_STAB_AUTO
            elseif(txt == "MANUEL") then
                hho_stab = HHO_STAB_MANU
                if (getexm('HHO','COEF_STAB') == 1) then
                    call getvr8('HHO', 'COEF_STAB', iocc = 1, scal=hho_coef_stab, nbret = iret)
                    ASSERT(iret == 1)
                else
                    ASSERT(ASTER_FALSE)
                end if
            else
                ASSERT(ASTER_FALSE)
            end if
        end if
!
    end if
!
    ds_compor_para%hho_coef_stab = hho_coef_stab
    ds_compor_para%hho_type_stab = real(hho_stab, kind=8)
    ds_compor_para%hho_type_calc = real(hho_calc, kind=8)
!
end subroutine
