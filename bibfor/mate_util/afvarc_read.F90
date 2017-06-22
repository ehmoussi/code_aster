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

subroutine afvarc_read(varc_cata, varc_affe)
!
use Material_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/afvarc_read_cata.h"
#include "asterfort/afvarc_read_keyw.h"
!
!
    type(Mat_DS_VarcListCata), intent(out) :: varc_cata
    type(Mat_DS_VarcListAffe), intent(out) :: varc_affe
!
! --------------------------------------------------------------------------------------------------
!
! Material - External state variables (VARC)
!
! Read data
!
! --------------------------------------------------------------------------------------------------
!
! Out varc_cata        : datastructure for catalog of external state variables
! Out varc_affe        : datastructure for external state variables affected
!
! --------------------------------------------------------------------------------------------------
!
!
! - Read list of variables from AFFE_MATERIAU catalog
!
    call afvarc_read_cata(varc_cata)
!
! - Get external state variables affected from command file
!
    call afvarc_read_keyw(varc_cata, varc_affe)
!
end subroutine
