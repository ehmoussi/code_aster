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
subroutine carc_chck(ds_compor_para)
!
use Behaviour_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/comp_meca_l.h"
#include "asterfort/utmess.h"
!
type(Behaviour_PrepCrit), intent(in) :: ds_compor_para
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Some checks
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_compor_para   : datastructure to prepare parameters for constitutive laws
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_comp, nb_comp
    aster_logical :: l_mfront_proto, l_mfront_offi
!
! --------------------------------------------------------------------------------------------------
!
    nb_comp = ds_compor_para%nb_comp
!
! - Loop on occurrences of COMPORTEMENT
!
    do i_comp = 1, nb_comp
!
! ----- Detection of specific cases
!
        call comp_meca_l(ds_compor_para%v_para(i_comp)%rela_comp, 'MFRONT_PROTO', l_mfront_proto)
        call comp_meca_l(ds_compor_para%v_para(i_comp)%rela_comp, 'MFRONT_OFFI' , l_mfront_offi)
!
! ----- Ban if RELATION = MFRONT and ITER_INTE_PAS negative
!
        if (ds_compor_para%v_para(i_comp)%iter_inte_pas .lt. 0.d0) then
            if (l_mfront_offi .or. l_mfront_proto) then
                call utmess('F', 'COMPOR1_95')
            end if
        end if
    enddo
!
end subroutine
