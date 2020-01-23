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
subroutine nonlinIntForceAsse(typeAsse, list_func_acti, sdnume, ds_material, ds_system)
!
use NonLin_Datastructure_type
use NonLinear_module, only : setNodalValuesGDVARINO
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/NonLinear_type.h"
#include "asterfort/vtaxpy.h"
#include "asterfort/assert.h"
#include "asterfort/assvec.h"
#include "asterfort/isfonc.h"
#include "asterfort/infdbg.h"
#include "asterfort/utmess.h"
#include "asterfort/nmdebg.h"
!
integer, intent(in) :: typeAsse, list_func_acti(*)
character(len=19), intent(in) :: sdnume
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_System), intent(in) :: ds_system
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Assembly for internal forces vector
!
! --------------------------------------------------------------------------------------------------
!
! In  typeAsse         : type of assembly
! In  list_func_acti   : list of active functionnalities
! In  sdnume           : datastructure for dof positions
! In  ds_material      : datastructure for material parameters
! In  ds_system        : datastructure for non-linear system management
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    aster_logical :: l_gdvarino
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE13_39')
    endif
!
! - Active functionnalities
!
    l_gdvarino = isfonc(list_func_acti, 'ENDO_NO')
!
! - Assemble
!
    if (typeAsse .eq. INTE_FORCE_COMB) then
!       Assemblage special: In: cninte + cnfnod + ds_material%fvarc_pred + COPRED
        ASSERT(ASTER_FALSE)
    elseif (typeAsse .eq. INTE_FORCE_INTE) then
!       Assemblage que de l'intégration (RAPH_MECA / FULL_MECA / RIGI_MECA_TANG)
        call assvec('V'               , ds_system%cnfint, 1     , ds_system%veinte, [1.d0],&
                    ds_system%nume_dof, ' '             , 'ZERO', 1)
    elseif (typeAsse .eq. INTE_FORCE_FNOD) then
!       Assemblage que de FORC_NODA
        call assvec('V'               , ds_system%cnfint, 1     , ds_system%vefnod, [1.d0],&
                    ds_system%nume_dof, ' '             , 'ZERO', 1)
!       For external state variables
        call vtaxpy(-1.d0, ds_material%fvarc_pred, ds_system%cnfint)
    else
        ASSERT(ASTER_FALSE)
    endif
!
! - For GDVARINO
!
    if (l_gdvarino .and. typeAsse .eq. INTE_FORCE_INTE) then
        call setNodalValuesGDVARINO(ds_system%nume_dof, sdnume, ds_system%cnfint)
    endif
!
! - Debug
!
    if (niv .ge. 2) then
        call nmdebg('VECT', ds_system%cnfint, 6)
    endif
!
end subroutine
