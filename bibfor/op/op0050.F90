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

subroutine op0050()
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/infmaj.h"
#include "asterfort/titre.h"
#include "asterfort/ddr_DSInit.h"
#include "asterfort/ddr_chck.h"
#include "asterfort/ddr_read.h"
#include "asterfort/ddr_main.h"
!
!
!
!
! ----------------------------------------------------------------------
!
!   DEFI_DOMAINE_REDUIT
!
! ----------------------------------------------------------------------
!
    type(ROM_DS_ParaDDR) :: ds_para
!
! ----------------------------------------------------------------------
!
    call titre()
    call infmaj()
!
! - Initialization of datastructures
!
    call ddr_DSInit(ds_para)
!
! - Read parameters
!
    call ddr_read(ds_para)
!
! - Some checks
!
    call ddr_chck(ds_para)
!
! - Compute EIM
!   
    call ddr_main(ds_para)
!
end subroutine
