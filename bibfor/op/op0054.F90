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

subroutine op0054()
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/infmaj.h"
#include "asterfort/titre.h"
#include "asterfort/rrcRead.h"
#include "asterfort/rrcInit.h"
#include "asterfort/rrcChck.h"
#include "asterfort/rrcComp.h"
#include "asterfort/rrcClean.h"
!
! --------------------------------------------------------------------------------------------------
!
!   REST_REDUIT_COMPLET
!
! --------------------------------------------------------------------------------------------------
!
    type(ROM_DS_ParaRRC) :: cmdPara
!
! --------------------------------------------------------------------------------------------------
!
    call titre()
    call infmaj()
!
! - Read parameters
!
    call rrcRead(cmdPara)
!
! - Check parameters
!
    call rrcChck(cmdPara)
!
! - Initializations
!
    call rrcInit(cmdPara)
!
! - Compute 
!
    call rrcComp(cmdPara)
!
! - Clean
!
    call rrcClean(cmdPara)
!
end subroutine
