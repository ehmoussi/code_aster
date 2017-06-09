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

subroutine cfmmci(ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/cfdisi.h"
#include "asterfort/cfdisl.h"
#include "asterfort/cfmmco.h"
#include "asterfort/mminfr.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Contact), intent(in) :: ds_contact
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve
!
! Discrete method - Fill datastructure for coefficients
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_contact       : datastructure for contact management
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_cont_zone, i_zone
    aster_logical :: l_cont_disc
    real(kind=8) :: coef_pena_cont, coef_pena_fric
!
! --------------------------------------------------------------------------------------------------
!
    l_cont_disc = cfdisl(ds_contact%sdcont_defi,'FORMUL_DISCRETE')
!
! - Get parameters
!
    nb_cont_zone = cfdisi(ds_contact%sdcont_defi,'NZOCO')
!
! - Initial filling
!
    do i_zone = 1, nb_cont_zone
        if (l_cont_disc) then
            coef_pena_cont = mminfr(ds_contact%sdcont_defi, 'E_N', i_zone)
            coef_pena_fric = mminfr(ds_contact%sdcont_defi, 'E_T', i_zone)
            call cfmmco(ds_contact, i_zone, 'E_N', 'E', coef_pena_cont)
            call cfmmco(ds_contact, i_zone, 'E_T', 'E', coef_pena_fric)
        else
            ASSERT(.false.)
        endif
    end do
!
end subroutine
