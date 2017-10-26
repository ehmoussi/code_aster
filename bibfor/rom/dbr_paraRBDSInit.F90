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
subroutine dbr_paraRBDSInit(ds_multipara, ds_solveDOM, ds_solveROM, ds_para_rb)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8vide.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_Solve), intent(in)       :: ds_solveDOM
type(ROM_DS_Solve), intent(in)       :: ds_solveROM
type(ROM_DS_MultiPara), intent(in)   :: ds_multipara
type(ROM_DS_ParaDBR_RB), intent(out) :: ds_para_rb
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Initialization of datastructures for parameters - POD methods
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_solveDOM      : datastructure for datastructure to solve systems (DOM)
! In  ds_solveROM      : datastructure for datastructure to solve systems (ROM)
! In  ds_multipara     : datastructure for multiparametric problems
! Out ds_para_rb       : datastructure for RB parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_26')
    endif
!
! - General initialisations of datastructure
!
    ds_para_rb%coef_redu       = '&&OP0053.COEF_REDU'
    ds_para_rb%solver          = '&&OP0053.SOLVER'
    ds_para_rb%resi_type       = ' '
    ds_para_rb%resi_vect       = '&&OP0053.RESI_VECT'
    ds_para_rb%vect_2mbr_init  = '&&OP0053.2MBR_INIT'
    ds_para_rb%resi_norm       => null()
    ds_para_rb%resi_refe       = 0.d0
    ds_para_rb%multipara       = ds_multipara
    ds_para_rb%solveROM        = ds_solveROM
    ds_para_rb%solveDOM        = ds_solveDOM
    ds_para_rb%nb_mode_maxi    = 0
!
end subroutine
