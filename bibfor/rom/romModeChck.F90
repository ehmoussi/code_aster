! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
subroutine romModeChck(mode)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/dismoi.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_Field), intent(in) :: mode
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Check mode
!
! --------------------------------------------------------------------------------------------------
!
! In  mode             : mode
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: modeMesh, modeModel
    character(len=16) :: modeli
    integer :: nbDimGeom
!
! --------------------------------------------------------------------------------------------------
!
    modeMesh  = mode%mesh
    modeModel = mode%model
!
! - Check mesh
!
    call dismoi('DIM_GEOM', modeMesh, 'MAILLAGE', repi = nbDimGeom)
    if (nbDimGeom .ne. 3) then
        call utmess('F','ROM10_10')
    endif
!
! - Check model
!
    if (modeModel .eq. '#PLUSIEURS') then
        call utmess('F','ROM10_11')
    endif
!
! - Check modelization
!
    call dismoi('MODELISATION', modeModel, 'MODELE', repk = modeli)
    if (modeli .ne. '3D' .and. modeli .ne. '3D_DIAG' .and. modeli .ne. '3D_SI') then
        call utmess('F','ROM10_12')
    endif
!
! - Check support
!
    if (mode%fieldSupp .ne. 'NOEU') then
        call utmess('F','ROM10_13')
    endif
!
end subroutine
