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
#include "asterfort/romGreedyModeSave.h"
#include "asterfort/romGreedyResiCalc.h"
#include "asterfort/romGreedyResiMaxi.h"
#include "asterfort/romGreedyResi.h"
#include "asterfort/romSaveBaseStableIFS.h"
#include "asterfort/romCalcIndiceUPPHI.h"
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
    integer :: i_mode, i_coef_maxi, i_coef, nb_mode_maxi
    real(kind=8) :: tole
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
    i_mode       = 1
    i_coef       = 1
    nb_mode_maxi = ds_para_rb%nb_mode_maxi
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
    call romMultiParaDOM2mbrCreate(ds_para_rb%multipara, &
                                   i_coef,&
                                   ds_para_rb%solveDOM%syst_2mbr_type,&
                                   ds_para_rb%vect_2mbr)
!
! - Create initial matrix
!
    call romMultiParaDOMMatrCreate(ds_para_rb%multipara,&
                                   i_coef,&
                                   ds_para_rb%solveDOM%syst_matr)
!
! - Solve initial system (DOM)
!
    ds_para_rb%solveDOM%syst_2mbr = ds_para_rb%vect_2mbr(1:19)
    call romSolveDOMSystSolve(ds_para_rb%solver, ds_para_rb%solveDOM)
!
! - Normalization of basis and save it 
!
    if (ds_para_rb%l_base_ifs) then 
         call romCalcIndiceUPPHI(ds_para_rb%multipara)
         call romSaveBaseStableIFS(ds_para_rb, ds_empi, i_mode)
    else 
         call romNormalize(ds_para_rb%solveDOM%syst_type, ds_para_rb%solveDOM%syst_solu,&
                           ds_empi%ds_mode%nb_equa)
         call romGreedyModeSave(ds_para_rb%multipara, ds_empi,&
                                i_mode              , ds_para_rb%solveDOM%syst_solu)
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
        if (ds_para_rb%l_base_ifs) then
            call romMultiParaCoefCompute(ds_empi                  ,&
                                         ds_para_rb%multipara     ,&
                                         ds_para_rb%solveROM      ,&
                                         3*(i_mode-1), i_mode-1   ,&
                                         ds_para_rb%coef_redu)
            call romGreedyResiCalc(ds_empi, ds_para_rb, 3*(i_mode-1), i_mode-1)
        else
            call romMultiParaCoefCompute(ds_empi              ,& 
                                         ds_para_rb%multipara ,&
                                         ds_para_rb%solveROM  ,&
                                         i_mode-1, i_mode-1   ,&
                                         ds_para_rb%coef_redu)
            call romGreedyResiCalc(ds_empi, ds_para_rb, i_mode-1, i_mode-1)
        endif
! ----- Find maximum
        call romGreedyResiMaxi(ds_para_rb, i_coef_maxi)
! ----- Stop if the residual maximal is less than the value of tolerance given by user
        tole = ds_para_rb%resi_norm(i_coef_maxi)
        if (tole .le. ds_para_rb%tole_glouton) then
           exit
        end if
! ----- Create second member (correspond to i_coef_maxi)
        call romMultiParaDOM2mbrCreate(ds_para_rb%multipara, &
                                       i_coef_maxi,&
                                       ds_para_rb%solveDOM%syst_2mbr_type,&
                                       ds_para_rb%vect_2mbr)
! ----- Create matrix (correspond to i_coef_maxi)
        call romMultiParaDOMMatrCreate(ds_para_rb%multipara,&
                                       i_coef_maxi,&
                                       ds_para_rb%solveDOM%syst_matr)
! ----- Solve system (DOM)
        ds_para_rb%solveDOM%syst_2mbr = ds_para_rb%vect_2mbr(1:19)
        call romSolveDOMSystSolve(ds_para_rb%solver, ds_para_rb%solveDOM)
! ----- Normalization of basis and save it
        if (ds_para_rb%l_base_ifs) then 
            call romSaveBaseStableIFS(ds_para_rb, ds_empi, i_mode)
        else
            call romNormalize(ds_para_rb%solveDOM%syst_type,&
                              ds_para_rb%solveDOM%syst_solu, ds_empi%ds_mode%nb_equa)
            call romGreedyModeSave(ds_para_rb%multipara, ds_empi,&
                                   i_mode              , ds_para_rb%solveDOM%syst_solu)
        endif
!
        i_mode = i_mode + 1
    end do
!
end subroutine
