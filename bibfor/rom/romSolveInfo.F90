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

subroutine romSolveInfo(ds_solve)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(ROM_DS_Solve), intent(in) :: ds_solve
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Informations about objects to solve system
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_solve         : datastructure to solve systems
!
! --------------------------------------------------------------------------------------------------
!
    character(len=1) :: syst_matr_type, syst_2mbr_type, syst_type
!
! --------------------------------------------------------------------------------------------------
!
    syst_matr_type = ds_solve%syst_matr_type
    syst_2mbr_type = ds_solve%syst_2mbr_type
    syst_type      = ds_solve%syst_type
    if (syst_matr_type .eq. 'C') then
        call utmess('I', 'ROM2_14')
    elseif (syst_matr_type .eq. 'R') then
        call utmess('I', 'ROM2_15')
    endif
    if (syst_2mbr_type .eq. 'C') then
        call utmess('I', 'ROM2_16')
    elseif (syst_2mbr_type .eq. 'R') then
        call utmess('I', 'ROM2_17')
    endif 
    if (syst_type .eq. 'C') then
        call utmess('I', 'ROM2_36')
    elseif (syst_type .eq. 'R') then
        call utmess('I', 'ROM2_37')
    endif 
    call utmess('I', 'ROM2_35', si = ds_solve%syst_size)
!
end subroutine
