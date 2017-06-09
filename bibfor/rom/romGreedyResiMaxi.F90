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

subroutine romGreedyResiMaxi(ds_para_rb, i_coef_maxi)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8gaem.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(ROM_DS_ParaDBR_RB), intent(in) :: ds_para_rb
    integer, intent(out) :: i_coef_maxi
!
! --------------------------------------------------------------------------------------------------
!
! Greedy algorithm
!
! Get maximum of residual
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_para_rb       : datastructure for parameters (RB)
! Out i_coef_maxi      : index where residual is maximum
!
! --------------------------------------------------------------------------------------------------
!    
    integer :: i_coef, nb_coef
    real(kind=8) :: vale_maxi
!
! --------------------------------------------------------------------------------------------------
!
    vale_maxi   = -r8gaem()
    i_coef_maxi = 0
!
! - Get parameters
!
    nb_coef        = ds_para_rb%multipara%nb_vari_coef
!
! - Get maximum
!
    do i_coef = 1, nb_coef
        if (ds_para_rb%resi_norm(i_coef) .ge. vale_maxi) then
            vale_maxi   = ds_para_rb%resi_norm(i_coef)
            i_coef_maxi = i_coef
        endif
    end do
    !WRITE(6,*) 'Indice du residu max:  ',i_coef_maxi,ds_para_rb%resi_norm(i_coef_maxi)
!
end subroutine
