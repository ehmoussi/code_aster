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
subroutine nonlinDSMaterialInit(model      , mate, cara_elem,&
                                ds_material)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/utmess.h"
#include "asterfort/nmvcre.h"
!
character(len=24), intent(in) :: model, mate, cara_elem
type(NL_DS_Material), intent(inout) :: ds_material
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Material parameters management
!
! Initializations for material parameters management
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  mate             : name of material characteristics (field)
! In  cara_elem        : name of elementary characteristics (field)
! IO  ds_material      : datastructure for material parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv

!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> ... Initializations for material parameters management'
    endif
!
! - Save material field
!
    ds_material%field_mate = mate
!
! - Create field for reference of external state variables
!
    call nmvcre(model, mate, cara_elem, ds_material%varc_refe)
!
end subroutine
