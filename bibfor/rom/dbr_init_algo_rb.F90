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

subroutine dbr_init_algo_rb(nb_mode, ds_para_rb)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/romGreedyAlgoInit.h"
#include "asterfort/romSolveDOMSystCreate.h"
#include "asterfort/romSolveROMSystCreate.h"
#include "asterfort/romMultiParaSystEvalType.h"
#include "asterfort/romMultiParaInit.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    integer, intent(in) :: nb_mode
    type(ROM_DS_ParaDBR_RB), intent(inout) :: ds_para_rb
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Init algorithm - For RB methods
!
! --------------------------------------------------------------------------------------------------
!
! In  nb_mode          : number of empiric modes
! IO  ds_para_rb       : datastructure for parameters (RB)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nb_vari_coef
    character(len=1) :: syst_matr_type, syst_2mbr_type, syst_type
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM2_41')
    endif
!
! - Evaluate type of system
!
    call romMultiParaSystEvalType(ds_para_rb%multipara,&
                                  syst_matr_type, syst_2mbr_type, syst_type)
!
! - Create objects to solve system (DOM)
!
    call romSolveDOMSystCreate(syst_matr_type, syst_2mbr_type, syst_type,&
                               ds_para_rb%multipara%matr_name(1),&
                               ds_para_rb%solveDOM)
!
! - Create objects to solve system (ROM)
!
    call romSolveROMSystCreate(syst_matr_type, syst_2mbr_type, syst_type,&
                               nb_mode,&
                               ds_para_rb%solveROM)
!
! - Initializations for multiparametric problems
!
    call romMultiParaInit(ds_para_rb%multipara)
!
! - Init algorithm
!
    nb_vari_coef = ds_para_rb%multipara%nb_vari_coef
    call romGreedyAlgoInit(syst_type , nb_mode, nb_vari_coef,&
                           ds_para_rb%solveDOM%vect_zero, ds_para_rb)
!
end subroutine
