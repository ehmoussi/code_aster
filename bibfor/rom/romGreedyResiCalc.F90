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

subroutine romGreedyResiCalc(ds_empi, ds_para_rb, i_mode_until)
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
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(ROM_DS_Empi), intent(in) :: ds_empi
    type(ROM_DS_ParaDBR_RB), intent(inout) :: ds_para_rb
    integer, intent(in) :: i_mode_until
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
! IO  ds_para_rb       : datastructure for parameters (RB)
! In  i_mode_until     : last mode to compute
!
! --------------------------------------------------------------------------------------------------
!    
    integer :: ifm, niv
    integer :: i_coef
    integer :: nb_mode, nb_coef, nb_matr, nb_equa
    type(ROM_DS_MultiPara) :: ds_multipara
    complex(kind=8), pointer :: v_coef_redu(:) => null()
    complex(kind=8), pointer :: v_resi_vect(:) => null()
    complex(kind=8), pointer :: v_2mbr_init(:) => null()
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
    ds_multipara   = ds_para_rb%multipara
    nb_matr        = ds_multipara%nb_matr
    nb_coef        = ds_multipara%nb_vari_coef
    nb_mode        = ds_para_rb%solveROM%syst_size
    nb_equa        = ds_para_rb%solveDOM%syst_size
!
! - Access to objects
!
    if (ds_para_rb%solveROM%syst_2mbr_type .eq. 'C') then
        call jeveuo(ds_para_rb%coef_redu, 'L', vc = v_coef_redu)
        call jeveuo(ds_para_rb%vect_2mbr_init(1:19)//'.VALE', 'L', vc = v_2mbr_init)
        call jeveuo(ds_para_rb%resi_vect(1:19)//'.VALE', 'E', vc = v_resi_vect)
    else
        ASSERT(.false.)
    endif
    ASSERT(i_mode_until .le. nb_mode)
!
! - Compute residual
!
    do i_coef = 1, nb_coef
! ----- Initial residual
        v_resi_vect(:) = v_2mbr_init(:)
! ----- Compute residual for one coefficient
        call romGreedyResi(ds_empi, ds_para_rb, i_mode_until, i_mode_until, i_coef)
! ----- Compute norm of residual
        call romGreedyResiNormCalc(i_coef, nb_equa, ds_para_rb)
    end do
!
! - Print norm of residual
!
    if (niv .ge. 2) then
        do i_coef = 1, nb_coef
            call utmess('I', 'ROM2_49', si = i_coef, sr = ds_para_rb%resi_norm(i_coef))
        end do
    endif
!
end subroutine
