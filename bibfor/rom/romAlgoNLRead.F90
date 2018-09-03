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
subroutine romAlgoNLRead(ds_algorom)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/getvtx.h"
#include "asterfort/getvid.h"
#include "asterfort/getvr8.h"
#include "asterfort/romBaseGetInfo.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_AlgoPara), intent(inout) :: ds_algorom
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Solving non-linear problem
!
! Read parameters for algorithm management
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_algorom       : datastructure for ROM parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    real(kind=8) :: coef_pena
    character(len=8) :: ds_empi_name
    character(len=16) :: keywf, answer
    character(len=24) :: grnode_int, grnode_sub
    aster_logical :: l_hrom, l_hrom_corref
    type(ROM_DS_Empi) :: ds_empi
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_41')
    endif
!
! - Initializations
!
    keywf         = 'MODELE_REDUIT'
    l_hrom        = ASTER_FALSE
    l_hrom_corref = ASTER_FALSE
    grnode_int    = ' '
    grnode_sub    = ' '
    coef_pena     = 0.d0
!
! - Read parameters
!
    call getvid(keywf, 'BASE_PRIMAL'   , iocc=1, scal = ds_empi_name)
    call getvtx(keywf, 'DOMAINE_REDUIT', iocc=1, scal = answer)
    l_hrom = answer .eq. 'OUI'
    if (l_hrom) then
        call getvtx(keywf,'GROUP_NO_INTERF', iocc=1, scal = grnode_int)
        call getvtx(keywf,'CORR_COMPLET', iocc=1, scal = answer)
        l_hrom_corref = answer .eq. 'OUI'
        if (l_hrom_corref) then
            call getvtx(keywf,'GROUP_NO_ENCASTRE', iocc=1, scal = grnode_sub)
            call getvr8(keywf,'COEF_PENA'        , iocc=1, scal = coef_pena)
        endif
    endif
!
! - Get informations about base
!
    call romBaseGetInfo(ds_empi_name, ds_empi)
!
! - Save parameters in datastructure
!
    ds_algorom%l_rom         = ASTER_TRUE
    ds_algorom%ds_empi       = ds_empi
    ds_algorom%l_hrom        = l_hrom
    ds_algorom%grnode_int    = grnode_int
    ds_algorom%l_hrom_corref = l_hrom_corref
    ds_algorom%grnode_sub    = grnode_sub
    ds_algorom%vale_pena     = coef_pena
!
end subroutine
