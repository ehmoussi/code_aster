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
subroutine dbr_calcpod_save(base, nbMode, nbSnapRedu, baseSing, baseValeR)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/romBaseSave.h"
#include "asterfort/dbr_calcpod_savel.h"
!
type(ROM_DS_Empi), intent(in) :: base
integer, intent(in) :: nbMode, nbSnapRedu
real(kind=8), pointer :: baseValeR(:), baseSing(:)
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Compute
!
! Save base
!
! --------------------------------------------------------------------------------------------------
!
! In  base             : base
! In  nbMode           : number of modes in base
! In  nbSnapRedu       : number of snapshots used to construct base
! Ptr baseValeR        : pointer to the values of all modes in base
! Ptr baseSing         : pointer to the singular values of all modes in base
!
! --------------------------------------------------------------------------------------------------
!
    if (base%baseType .eq. 'LINEIQUE') then
        call dbr_calcpod_savel(base    , nbMode  , nbSnapRedu,&
                               baseSing, baseValeR)
    else
        call romBaseSave(base     , nbMode   , nbSnapRedu,&
                         baseValeR, baseSing)
    endif
!
end subroutine
