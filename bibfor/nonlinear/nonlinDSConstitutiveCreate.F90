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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nonlinDSConstitutiveCreate(ds_constitutive)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
!
type(NL_DS_Constitutive), intent(out) :: ds_constitutive
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Constitutive laws
!
! Create constitutive laws management datastructure
!
! --------------------------------------------------------------------------------------------------
!
! Out ds_constitutive  : datastructure for constitutive laws management
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> . Create constitutive laws management datastructure'
    endif
!
! - Initializations
!
    ds_constitutive%compor      = '&&OP00XX.COMPOR'
    ds_constitutive%carcri      = '&&OP00XX.CARCRI'
    ds_constitutive%mult_comp   = '&&OP00XX.MULT_COMP'
    ds_constitutive%comp_error  = '&&OP00XX.COMP_ERROR'
    ds_constitutive%l_deborst   = ASTER_FALSE
    ds_constitutive%l_dis_choc  = ASTER_FALSE
    ds_constitutive%l_post_incr = ASTER_FALSE
    ds_constitutive%l_matr_geom = ASTER_FALSE
!
end subroutine
