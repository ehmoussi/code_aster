! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
subroutine romMultiParaInit(ds_multipara, nb_mode_maxi)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/romMultiParaProdModeInit.h"
#include "asterfort/romMultiParaCoefInit.h"
!
type(ROM_DS_MultiPara), intent(inout) :: ds_multipara
integer, intent(in) :: nb_mode_maxi
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Initializations for multiparametric problems
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_multipara     : datastructure for multiparametric problems
! In  nb_mode_maxi     : maximum number of empirical modes
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM2_19')
    endif
!
! - Prepare product [Matrix] x [Mode], reduced Matrix and Reduced Vector
!
    call romMultiParaProdModeInit(ds_multipara, nb_mode_maxi)
!
! - Initializations of coefficients
!
    call romMultiParaCoefInit(ds_multipara)
!
end subroutine
