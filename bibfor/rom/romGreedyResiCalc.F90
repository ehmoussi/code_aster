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
subroutine romGreedyResiCalc(ds_empi     , ds_multipara, ds_algoGreedy,&
                             i_mode_until, i_mode_coef)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsexch.h"
#include "asterfort/romGreedyResi.h"
#include "asterfort/romGreedyResiNormCalc.h"
#include "asterfort/romMultiParaDOM2mbrCreate.h"
!
type(ROM_DS_Empi), intent(in) :: ds_empi
type(ROM_DS_MultiPara), intent(inout) :: ds_multipara
type(ROM_DS_AlgoGreedy), intent(inout) :: ds_algoGreedy
integer, intent(in) :: i_mode_until, i_mode_coef
!
! --------------------------------------------------------------------------------------------------
!
! Greedy algorithm
!
! Compute residual
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_empi          : datastructure for empiric modes
! IO  ds_multipara     : datastructure for multiparametric problems
! IO  ds_algoGreedy    : datastructure for Greedy algorithm
! In  i_mode_until     : last mode to compute
! In  i_mode_coef      : index of mode to compute coefficients
!
! --------------------------------------------------------------------------------------------------
!    
    integer :: ifm, niv
    integer :: i_coef
    integer :: nb_mode, nb_coef, nb_matr, nb_equa
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM2_50')
    endif
!
! - Get parameters
!
    nb_matr = ds_multipara%nb_matr
    nb_coef = ds_multipara%nb_vari_coef
    nb_mode = ds_algoGreedy%solveROM%syst_size
    nb_equa = ds_algoGreedy%solveDOM%syst_size
    ASSERT(i_mode_until .le. nb_mode)
    ASSERT(i_mode_coef  .le. nb_mode)
!
! - Compute residual
!
    do i_coef = 1, nb_coef
! ----- Compute second member for one coefficient
        call romMultiParaDOM2mbrCreate(ds_multipara, i_coef, ds_algoGreedy%solveDOM)
! ----- Compute residual for one coefficient
        call romGreedyResi(ds_empi     , ds_multipara, ds_algoGreedy,&
                           i_mode_until, i_mode_coef , i_coef)
! ----- Compute norm of residual/norm second membre
        call romGreedyResiNormCalc(i_coef, nb_equa, ds_algoGreedy)
    end do
!
! - Print norm of residual
!
    if (niv .ge. 2) then
        do i_coef = 1, nb_coef
            call utmess('I', 'ROM2_49', si = i_coef, sr = ds_algoGreedy%resi_norm(i_coef))
        end do
    endif
!
end subroutine
