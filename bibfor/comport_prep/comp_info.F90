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
subroutine comp_info(model, compor)
!
use Behaviour_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/comp_meca_pvar.h"
#include "asterfort/imvari.h"
!
character(len=8), intent(in) :: model
character(len=19), intent(in) :: compor
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Print inforamtions about COMPORTEMENT keyword
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  compor           : name of <CARTE> COMPOR
!
! --------------------------------------------------------------------------------------------------
!
    character(len=19) :: compor_info
!
! --------------------------------------------------------------------------------------------------
!
    compor_info = '&&NMDOCC.INFO'
!
! - Prepare informations about internal variables
!
    call comp_meca_pvar(model_ = model, compor_cart_ = compor, compor_info = compor_info)
!
! - Print informations about internal variables
!
    call imvari(compor_info)
!
end subroutine
