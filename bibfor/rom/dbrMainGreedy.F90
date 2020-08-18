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
subroutine dbrMainGreedy(paraGreedy, baseOut)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterc/r8gaem.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/romEvalCoef.h"
#include "asterfort/romGreedyModeSave.h"
#include "asterfort/romGreedyResiCalc.h"
#include "asterfort/romGreedyResi.h"
#include "asterfort/romGreedyResiMaxi.h"
#include "asterfort/romMultiParaCoefCompute.h"
#include "asterfort/romMultiParaDOM2mbrCreate.h"
#include "asterfort/romMultiParaDOMMatrCreate.h"
#include "asterfort/romNormalize.h"
#include "asterfort/romOrthoBasis.h"
#include "asterfort/romSaveBaseStableIFS.h"
#include "asterfort/romSolveDOMSystSolve.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_ParaDBR_Greedy), intent(inout) :: paraGreedy
type(ROM_DS_Empi), intent(inout) :: baseOut
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE
!
! Main subroutine to compute base - For greedy method
!
! --------------------------------------------------------------------------------------------------
!
! IO  paraGreedy       : datastructure for parameters (Greedy)
! IO  baseOut          : baseOut
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer, parameter :: iCoef = 1
    integer :: iMode, iCoefMaxi, nbModeMaxi, nbEqua
    real(kind=8) :: tole, toleGreedy
    character(len=1) :: systType
    character(len=19) :: systSolu
    aster_logical :: lStabFSI, lOrthoBase
    type(ROM_DS_MultiPara) :: multiPara
    type(ROM_DS_AlgoGreedy) :: algoGreedy
    type(ROM_DS_Solve) :: solveDOM
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM18_60')
    endif
!
! - Initializations
!
    iMode      = 1
    algoGreedy = paraGreedy%algoGreedy
    multiPara  = paraGreedy%multiPara
    solveDOM   = algoGreedy%solveDOM
    nbEqua     = multiPara%field%nbEqua
    toleGreedy = paraGreedy%toleGreedy
    lStabFSI   = paraGreedy%lStabFSI
    lOrthoBase = paraGreedy%lOrthoBase
    nbModeMaxi = paraGreedy%nbModeMaxi
    systType   = solveDOM%syst_type
    systSolu   = solveDOM%syst_solu
!
! - First mode
!
    if (niv .ge. 2) then
        call utmess('I', 'ROM18_61')
    endif
!
! - Evaluation of initial coefficients
!
    call romEvalCoef(paraGreedy%multiPara, l_init = ASTER_TRUE)
!
! - Create initial second member
!
    call romMultiParaDOM2mbrCreate(multiPara, iCoef, solveDOM)
!
! - Create initial matrix
!
    call romMultiParaDOMMatrCreate(multiPara, iCoef, solveDOM)
!
! - Solve initial system (DOM)
!
    call romSolveDOMSystSolve(paraGreedy%solver, solveDOM)
!
! - Normalization of basis and save it 
!
    if (lStabFSI) then
        call romSaveBaseStableIFS(lOrthoBase, multiPara, algoGreedy, baseOut, iMode)
    else
        call romNormalize(systType, systSolu, nbEqua)
        call romGreedyModeSave(multiPara, baseOut, iMode, systSolu)
    end if 
!
! - Loop on modes
!
    iMode = 2
    tole  = r8gaem()
    do while (iMode .le. nbModeMaxi)
! ----- Print
        if (niv .ge. 2) then
            call utmess('I', 'ROM18_62', si = iMode)
        endif

! ----- Compute reduced coefficients and residual
        if (paraGreedy%lStabFSI) then
            call romMultiParaCoefCompute(baseOut    , paraGreedy%multiPara, algoGreedy,&
                                         3*(iMode-1), iMode-1)
            call romGreedyResiCalc(paraGreedy%multiPara, paraGreedy%algoGreedy,&
                                   3*(iMode-1), iMode-1)
        else
            call romMultiParaCoefCompute(baseOut , paraGreedy%multiPara, algoGreedy,&
                                         iMode-1, iMode-1)
            call romGreedyResiCalc(paraGreedy%multiPara, paraGreedy%algoGreedy,&
                                   iMode-1, iMode-1)
        endif

! ----- Find maximum
        call romGreedyResiMaxi(multiPara, algoGreedy, iCoefMaxi)

! ----- Stop if the residual maximal is less than the value of tolerance given by user
        tole = algoGreedy%resi_norm(iCoefMaxi)
        if (tole .le. paraGreedy%toleGreedy) then
            exit
        end if

! ----- Create second member (correspond to iCoefMaxi)
        call romMultiParaDOM2mbrCreate(multiPara, iCoefMaxi, solveDOM)

! ----- Create matrix (correspond to iCoefMaxi)
        call romMultiParaDOMMatrCreate(multiPara, iCoefMaxi, solveDOM)

! ----- Solve system (DOM)
        call romSolveDOMSystSolve(paraGreedy%solver, solveDOM)

! ----- Normalization of basis and save it
        if (lStabFSI) then 
            call romSaveBaseStableIFS(lOrthoBase, multiPara, algoGreedy, baseOut, iMode)
        else
            call romNormalize(systType, systSolu, nbEqua)
            if (lOrthoBase) then 
                call romOrthoBasis(multiPara, baseOut, systSolu)
            endif 
            call romGreedyModeSave(multiPara, baseOut, iMode, systSolu)
        endif
!
        iMode = iMode + 1
    end do
!
end subroutine
