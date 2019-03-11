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
subroutine dbr_main_rb(ds_para_rb, ds_empi)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/infniv.h"
#include "asterfort/romEvalCoef.h"
#include "asterfort/romMultiParaDOMMatrCreate.h"
#include "asterfort/romMultiParaDOM2mbrCreate.h"
#include "asterfort/romSolveDOMSystSolve.h"
#include "asterfort/romNormalize.h"
#include "asterfort/romMultiParaCoefCompute.h"
#include "asterfort/romOrthoBasis.h"
#include "asterfort/romGreedyModeSave.h"
#include "asterfort/romGreedyResiCalc.h"
#include "asterfort/romGreedyResiMaxi.h"
#include "asterfort/romGreedyResi.h"
#include "asterfort/romSaveBaseStableIFS.h"
#include "asterc/r8gaem.h"
!
type(ROM_DS_ParaDBR_RB), intent(inout) :: ds_para_rb
type(ROM_DS_Empi), intent(inout) :: ds_empi
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Compute
!
! Main subroutine to compute empiric modes - For RB methods
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_para_rb       : datastructure for parameters (RB)
! IO  ds_empi          : datastructure for empiric modes
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: i_mode, i_coef_maxi, i_coef, nb_mode_maxi, nb_equa
    real(kind=8) :: tole, tole_greedy
    character(len=1) :: syst_type
    character(len=19) :: syst_solu
    aster_logical :: l_stab_fsi, l_ortho_base
    type(ROM_DS_MultiPara) :: ds_multipara
    type(ROM_DS_AlgoGreedy) :: ds_algoGreedy
    type(ROM_DS_Solve) :: ds_solveDOM
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_60')
    endif
!
! - Initializations
!
    i_mode         = 1
    i_coef         = 1
    ds_algoGreedy  = ds_para_rb%algoGreedy
    ds_multipara   = ds_para_rb%multipara
    ds_solveDOM    = ds_algoGreedy%solveDOM
    nb_equa        = ds_multipara%field%nb_equa
    tole_greedy    = ds_para_rb%tole_greedy
    l_stab_fsi     = ds_para_rb%l_stab_fsi
    l_ortho_base   = ds_para_rb%l_ortho_base
    nb_mode_maxi   = ds_para_rb%nb_mode_maxi
    syst_type      = ds_solveDOM%syst_type
    syst_solu      = ds_solveDOM%syst_solu
!
! - First mode
!
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_92')
    endif
!
! - Evaluation of initial coefficients
!
    call romEvalCoef(ds_para_rb%multipara, l_init = ASTER_TRUE)
!
! - Create initial second member
!
    call romMultiParaDOM2mbrCreate(ds_multipara, i_coef, ds_solveDOM)
!
! - Create initial matrix
!
    call romMultiParaDOMMatrCreate(ds_multipara, i_coef, ds_solveDOM)
!
! - Solve initial system (DOM)
!
    call romSolveDOMSystSolve(ds_para_rb%solver, ds_solveDOM)
!
! - Normalization of basis and save it 
!
    if (l_stab_fsi) then
         call romSaveBaseStableIFS(l_ortho_base, ds_multipara, ds_algoGreedy, ds_empi, i_mode)
    else 
         call romNormalize(syst_type, syst_solu, nb_equa)
         call romGreedyModeSave(ds_multipara, ds_empi, i_mode, syst_solu)
    end if 
!
! - Loop on modes
!
    i_mode = 2
    tole   = r8gaem()
    do while (i_mode .le. nb_mode_maxi)
! ----- Print
        if (niv .ge. 2) then
            call utmess('I', 'ROM5_61', si = i_mode)
        endif
! ----- Compute reduced coefficients and residual
        if (ds_para_rb%l_stab_fsi) then
            call romMultiParaCoefCompute(ds_empi     , ds_para_rb%multipara, ds_algoGreedy,&
                                         3*(i_mode-1), i_mode-1)
            call romGreedyResiCalc(ds_empi     , ds_para_rb%multipara, ds_para_rb%algoGreedy,&
                                   3*(i_mode-1), i_mode-1)
        else
            call romMultiParaCoefCompute(ds_empi , ds_para_rb%multipara, ds_algoGreedy,&
                                         i_mode-1, i_mode-1)
            call romGreedyResiCalc(ds_empi , ds_para_rb%multipara, ds_para_rb%algoGreedy,&
                                   i_mode-1, i_mode-1)
        endif
! ----- Find maximum
        call romGreedyResiMaxi(ds_multipara, ds_algoGreedy, i_coef_maxi)
! ----- Stop if the residual maximal is less than the value of tolerance given by user
        tole = ds_algoGreedy%resi_norm(i_coef_maxi)
        if (tole .le. ds_para_rb%tole_greedy) then
           exit
        end if
! ----- Create second member (correspond to i_coef_maxi)
        call romMultiParaDOM2mbrCreate(ds_multipara, i_coef_maxi, ds_solveDOM)
! ----- Create matrix (correspond to i_coef_maxi)
        call romMultiParaDOMMatrCreate(ds_multipara, i_coef_maxi, ds_solveDOM)
! ----- Solve system (DOM)
        call romSolveDOMSystSolve(ds_para_rb%solver, ds_solveDOM)
! ----- Normalization of basis and save it
        if (l_stab_fsi) then 
            call romSaveBaseStableIFS(l_ortho_base, ds_multipara, ds_algoGreedy, ds_empi, i_mode)
        else
            call romNormalize(syst_type, syst_solu, nb_equa)
            if (l_ortho_base) then 
                call romOrthoBasis(ds_multipara, ds_empi, syst_solu)
            endif 
            call romGreedyModeSave(ds_multipara, ds_empi, i_mode, syst_solu)
        endif
!
        i_mode = i_mode + 1
    end do
!
end subroutine
