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
subroutine dbrInitAlgoGreedy(paraGreedy)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/infniv.h"
#include "asterfort/romFSINumberingInit.h"
#include "asterfort/romGreedyAlgoInit.h"
#include "asterfort/romMultiParaInit.h"
#include "asterfort/romMultiParaSystEvalType.h"
#include "asterfort/romSolveDOMSystCreate.h"
#include "asterfort/romSolveROMSystCreate.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_ParaDBR_Greedy), intent(inout) :: paraGreedy
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE
!
! Initializations for algorith - For greedy method
!
! --------------------------------------------------------------------------------------------------
!
! IO  paraGreedy       : datastructure for parameters (Greedy)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nbVariCoef, nbModeMaxi
    character(len=1) :: systMatrType, syst2mbrType, systType
    aster_logical :: lStabFSI
    character(len=19) :: vectRefe
    character(len=8)  :: matrRefe
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM18_31')
    endif
!
! - Get parameters
!
    nbModeMaxi = paraGreedy%nbModeMaxi
    lStabFSI   = paraGreedy%lStabFSI
    vectRefe   = paraGreedy%algoGreedy%solveDOM%vect_zero
    matrRefe   = paraGreedy%multiPara%matr_name(1)
    nbVariCoef = paraGreedy%multiPara%nb_vari_coef
!
! - For FSI: three basis
!
    if (lStabFSI) then
        nbModeMaxi = 3*nbModeMaxi
    end if 
!
! - Evaluate type of system
!
    call romMultiParaSystEvalType(paraGreedy%multiPara,&
                                  systMatrType, syst2mbrType, systType)
    paraGreedy%algoGreedy%resi_type = systType
!
! - Create objects to solve system (DOM)
!
    call romSolveDOMSystCreate(systMatrType, syst2mbrType, systType, matrRefe,&
                               paraGreedy%algoGreedy%solveDOM)
!
! - Create objects to solve system (ROM)
!
    call romSolveROMSystCreate(systMatrType, syst2mbrType, systType, nbModeMaxi,&
                               paraGreedy%algoGreedy%solveROM)
!
! - Initializations for multiparametric problems
!
    call romMultiParaInit(paraGreedy%multiPara, nbModeMaxi)
!
! - Create numbering of nodes for FSI
!
    if (lStabFSI) then 
        call romFSINumberingInit(paraGreedy%multiPara%field, paraGreedy%algoGreedy)
    endif
!
! - Init algorithm
!
    call romGreedyAlgoInit(nbModeMaxi, nbVariCoef, vectRefe, paraGreedy%algoGreedy)
!
end subroutine
