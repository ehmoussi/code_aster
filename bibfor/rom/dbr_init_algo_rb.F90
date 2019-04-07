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
subroutine dbr_init_algo_rb(ds_para_rb)
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
#include "asterfort/romFSINumberingInit.h"
!
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
! IO  ds_para_rb       : datastructure for parameters (RB)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nb_vari_coef, nb_mode_maxi
    character(len=1) :: syst_matr_type, syst_2mbr_type, syst_type
    aster_logical :: l_stab_fsi
    character(len=19) :: vect_refe
    character(len=8)  :: matr_refe
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM2_41')
    endif
!
! - Get parameters
!
    nb_mode_maxi = ds_para_rb%nb_mode_maxi
    l_stab_fsi   = ds_para_rb%l_stab_fsi
    vect_refe    = ds_para_rb%algoGreedy%solveDOM%vect_zero
    matr_refe    = ds_para_rb%multipara%matr_name(1)
    nb_vari_coef = ds_para_rb%multipara%nb_vari_coef
!
! - For FSI: three basis
!
    if (l_stab_fsi) then
        nb_mode_maxi = 3*nb_mode_maxi
    end if 
!
! - Evaluate type of system
!
    call romMultiParaSystEvalType(ds_para_rb%multipara,&
                                  syst_matr_type, syst_2mbr_type, syst_type)
    ds_para_rb%algoGreedy%resi_type  = syst_type
!
! - Create objects to solve system (DOM)
!
    call romSolveDOMSystCreate(syst_matr_type, syst_2mbr_type, syst_type, matr_refe,&
                               ds_para_rb%algoGreedy%solveDOM)
!
! - Create objects to solve system (ROM)
!
    call romSolveROMSystCreate(syst_matr_type, syst_2mbr_type, syst_type, nb_mode_maxi,&
                               ds_para_rb%algoGreedy%solveROM)
!
! - Initializations for multiparametric problems
!
    call romMultiParaInit(ds_para_rb%multipara, nb_mode_maxi)
!
! - Create numbering of nodes for FSI
!
    if (l_stab_fsi) then 
        call romFSINumberingInit(ds_para_rb%multipara%field, ds_para_rb%algoGreedy)
    endif
!
! - Init algorithm
!
    call romGreedyAlgoInit(nb_mode_maxi, nb_vari_coef, vect_refe, ds_para_rb%algoGreedy)
!
end subroutine
