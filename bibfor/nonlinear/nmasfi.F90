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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nmasfi(list_func_acti, hval_veasse, cnffdo, sddyna_)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/nonlinDSVectCombCompute.h"
#include "asterfort/nonlinDSVectCombAddHat.h"
#include "asterfort/nonlinDSVectCombAddDyna.h"
#include "asterfort/nonlinDSVectCombInit.h"
#include "asterfort/infdbg.h"
#include "asterfort/isfonc.h"
#include "asterfort/ndynlo.h"
#include "asterfort/ndynre.h"
!
integer, intent(in) :: list_func_acti(*)
character(len=19), intent(in) :: hval_veasse(*), cnffdo
character(len=19), optional, intent(in) :: sddyna_
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Get dead Neumann loads and multi-step dynamic schemes forces
!
! --------------------------------------------------------------------------------------------------
!
! In  list_func_acti   : list of active functionnalities
! In  sddyna           : datastructure for dynamic
! In  hval_veasse      : hat-variable for vectors (node fields)
! In  cnffdo           : name of resultant nodal field
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    real(kind=8) :: coeext, coeex2
    aster_logical :: l_lapl
    aster_logical :: l_wave, l_sstf, l_mult_step, l_dyna, l_viss
    type(NL_DS_VectComb) :: ds_vectcomb
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECA_NON_LINE', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> ...... CALCUL NEUMANN CONSTANT'
    endif
!
! - Active functionnalities
!  
    l_lapl      = isfonc(list_func_acti,'LAPLACE')
    l_sstf      = isfonc(list_func_acti,'SOUS_STRUC')
    l_dyna      = ASTER_FALSE
    l_mult_step = ASTER_FALSE
    l_viss      = ASTER_FALSE
    l_wave      = ASTER_FALSE
    if (present(sddyna_)) then  
        l_mult_step = ndynlo(sddyna_,'MULTI_PAS')
        l_dyna      = ndynlo(sddyna_,'DYNAMIQUE')
        l_viss      = ndynlo(sddyna_,'VECT_ISS')
        l_wave      = ndynlo(sddyna_,'ONDE_PLANE')
    endif
!
! - Initializations
!
    call nonlinDSVectCombInit(ds_vectcomb)
!
! - Coefficients
!
    if (l_dyna) then
        coeext = ndynre(sddyna_,'COEF_MPAS_FEXT_PREC')
        coeex2 = ndynre(sddyna_,'COEF_MPAS_FEXT_COUR')
    else
        coeext = 1.d0
        coeex2 = 1.d0
    endif
!
! - Dead Neumann forces
!
    call nonlinDSVectCombAddHat(hval_veasse, 'CNFEDO', coeex2, ds_vectcomb)
!
! - Laplace load
!
    if (l_lapl) then
        call nonlinDSVectCombAddHat(hval_veasse, 'CNLAPL', coeex2, ds_vectcomb)
    endif
!
! - Wave load
!
    if (l_wave) then
        call nonlinDSVectCombAddHat(hval_veasse, 'CNONDP', -1.d0*coeex2, ds_vectcomb)
    endif
!
! - Sub-structuring force
!
    if (l_sstf) then
        call nonlinDSVectCombAddHat(hval_veasse, 'CNSSTF', coeex2, ds_vectcomb)
    endif
!
! - FSI ground load
!
    if (l_viss) then
        call nonlinDSVectCombAddHat(hval_veasse, 'CNVISS', coeex2, ds_vectcomb)
    endif
!
! - Multi-step dynamic schemes forces from previous time step
!
    if (l_mult_step) then
        call nonlinDSVectCombAddDyna(sddyna_, 'CNFEDO', coeext, ds_vectcomb)
        if (l_lapl) then
            call nonlinDSVectCombAddDyna(sddyna_, 'CNLAPL', coeext, ds_vectcomb)
        endif
        if (l_wave) then
            call nonlinDSVectCombAddDyna(sddyna_, 'CNONDP', -1.d0*coeext, ds_vectcomb)
        endif
        if (l_viss) then
            call nonlinDSVectCombAddDyna(sddyna_, 'CNVISS', coeext, ds_vectcomb)
        endif
        if (l_sstf) then
            call nonlinDSVectCombAddDyna(sddyna_, 'CNSSTF', coeext, ds_vectcomb)
        endif
    endif
!
! - Combination
!
    call nonlinDSVectCombCompute(ds_vectcomb, cnffdo)
!
end subroutine
