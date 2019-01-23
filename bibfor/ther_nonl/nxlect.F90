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
subroutine nxlect(result     , model      ,&
                  ther_crit_i, ther_crit_r,&
                  ds_inout   , ds_algopara,&
                  ds_algorom ,&
                  result_dry , compor     ,&
                  mesh       , l_dry)
!
use NonLin_Datastructure_type
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/ntdcom.h"
#include "asterfort/nxdocc.h"
#include "asterfort/nxdocn.h"
#include "asterfort/nxdomt.h"
#include "asterfort/dismoi.h"
#include "asterfort/nonlinDSInOutRead.h"
!
character(len=8), intent(in) :: result
character(len=24), intent(in) :: model
integer, intent(inout) :: ther_crit_i(*)
real(kind=8), intent(inout) :: ther_crit_r(*)
type(NL_DS_InOut), intent(inout) :: ds_inout
type(NL_DS_AlgoPara), intent(inout) :: ds_algopara
type(ROM_DS_AlgoPara), intent(inout) :: ds_algorom
character(len=8), intent(out) :: result_dry
character(len=24), intent(out) :: compor
character(len=8), intent(out) :: mesh
aster_logical, intent(out) :: l_dry
!
! --------------------------------------------------------------------------------------------------
!
! Thermics - Init
!
! Read parameters
!
! --------------------------------------------------------------------------------------------------
!
! In  result           : name of datastructure for results
! In  model            : name of model
! IO  ther_crit_i      : criteria for algorithm (integer)
! IO  ther_crit_r      : criteria for algorithm (real)
! IO  ds_inout         : datastructure for input/output management
! IO  ds_algopara      : datastructure for algorithm parameters
! IO  ds_algorom       : datastructure for ROM parameters
! Out result_dry       : name of datastructure for results (drying)
! Out compor           : name of <CARTE> COMPOR
! Out mesh             : name of mesh
! Out l_dry            : .true. if drying (concrete)
!
! --------------------------------------------------------------------------------------------------
!
    result_dry = ' '
    compor     = ' '
    mesh       = ' '
    call dismoi('NOM_MAILLA', model, 'MODELE', repk=mesh)
!
! - Create comportment <CARTE>
!
    call nxdocc(model, compor)
!
! - Read parameters for algorithm management
!
    call nxdomt(ds_algopara, ds_algorom)
!
! - Read parameters for drying
!
    call ntdcom(result_dry, l_dry)
!
! - Read convergence criteria
!
    call nxdocn(ther_crit_i, ther_crit_r)
!
! - Read parameters for input/output management
!
    call nonlinDSInOutRead('THER', result, ds_inout)
!
end subroutine
