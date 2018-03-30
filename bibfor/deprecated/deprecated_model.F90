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

subroutine deprecated_model(model)
!
implicit none
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
!
! person_in_charge: josselin.delmas at edf.fr
!
    character(len=*), intent(in) :: model
!
! --------------------------------------------------------------------------------------------------
!
! DEPRECATED FEATURES
!
! Warning for deprecated modelling
!
! --------------------------------------------------------------------------------------------------
!
! In  model : name of deprecated modelling
!
! --------------------------------------------------------------------------------------------------
!
    integer :: vali
    character(len=32) :: valk
!
! --------------------------------------------------------------------------------------------------
!
    if (model .eq. 'POU_C_T') then
        vali = 13
        valk    = "MODELISATION='POU_C_T'"
!
    else if (model .eq. '3D_INCO_UPGB') then
        vali = 14
        valk    = "MODELISATION='3D_INCO_UPGB'"
!
    else if (model .eq. 'AXIS_INCO_UPGB') then
        vali = 14
        valk    = "MODELISATION='AXIS_INCO_UPGB'"
!
    else if (model .eq. 'D_PLAN_INCO_UPGB') then
        vali = 14
        valk    = "MODELISATION='D_PLAN_INCO_UPGB'"
!
    else
        goto 999
!
    endif
!
    call utmess('A', 'SUPERVIS_9', sk = valk, si = vali)
!
999 continue
!
end subroutine
