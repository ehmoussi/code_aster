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

subroutine op0054()
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/infmaj.h"
#include "asterfort/titre.h"
#include "asterfort/rrc_ini0.h"
#include "asterfort/rrc_read.h"
#include "asterfort/rrc_init.h"
#include "asterfort/rrc_chck.h"
#include "asterfort/rrc_comp.h"
!
!
!
!
! --------------------------------------------------------------------------------------------------
!
!   REST_REDUIT_COMPLET
!
! --------------------------------------------------------------------------------------------------
!
    type(ROM_DS_ParaRRC) :: ds_para
!
! --------------------------------------------------------------------------------------------------
!
    call titre()
    call infmaj()
!
! - Initialization of datastructures
!
    call rrc_ini0(ds_para)
!
! - Read parameters
!
    call rrc_read(ds_para)
!
! - Initializations
!
    call rrc_init(ds_para)
!
! - Check parameters
!
    call rrc_chck(ds_para)
!
! - Compute 
!
    call rrc_comp(ds_para)
!
end subroutine
