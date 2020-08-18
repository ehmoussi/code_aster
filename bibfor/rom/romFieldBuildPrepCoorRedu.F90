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
subroutine romFieldBuildPrepCoorRedu(resultRom, tablReduCoor, fieldBuild)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/romFieldBuildGappy.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_Result), intent(in) :: resultRom
type(ROM_DS_TablReduCoor), intent(in) :: tablReduCoor
type(ROM_DS_FieldBuild), intent(inout) :: fieldBuild
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Field build
!
! Prepare reduced coordinates (or copy from results !)
!
! --------------------------------------------------------------------------------------------------
!
! In  resultRom        : reduced results
! In  tablReduCoor     : table for reduced coordinates
! IO  fieldBuild       : field to reconstruct
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
!
! - Prepare reduced coordinates (or copy from results !)
!
    if (fieldBuild%lGappy) then
        if (niv .ge. 2) then
            call utmess('I', 'ROM17_4')
        endif
! ----- Compute reduced coordinates with Gappy-POD
        call romFieldBuildGappy(resultRom, fieldBuild)
    else
        if (niv .ge. 2) then
            call utmess('I', 'ROM17_5')
        endif
! ----- Get from table
        fieldBuild%reduMatr => tablReduCoor%coorRedu
    endif
!
end subroutine
