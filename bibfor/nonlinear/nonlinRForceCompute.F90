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
subroutine nonlinRForceCompute(model      , ds_material , cara_elem, list_load,&
                               nume_dof   , ds_measure  , vect_lagr,&
                               hval_veelem, hval_veasse_, cndiri_)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/vebtla.h"
#include "asterfort/assvec.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmtime.h"
#include "asterfort/infdbg.h"
#include "asterfort/utmess.h"
#include "asterfort/nmdebg.h"
!
character(len=24), intent(in) :: model, cara_elem
type(NL_DS_Material), intent(in) :: ds_material
character(len=19), intent(in) :: list_load
character(len=24), intent(in) :: nume_dof
type(NL_DS_Measure), intent(inout) :: ds_measure
character(len=19), intent(in) :: vect_lagr
character(len=19), intent(in) :: hval_veelem(*)
character(len=19), optional, intent(in) :: hval_veasse_(*)
character(len=19), optional, intent(in) :: cndiri_
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Compute force for Dirichlet boundary conditions (dualized) - BT.LAMBDA
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  cara_elem        : name of elementary characteristics (field)
! In  ds_material      : datastructure for material parameters
! In  list_load        : name of datastructure for list of loads
! In  nume_dof         : name of numbering object (NUME_DDL)
! IO  ds_measure       : datastructure for measure and statistics management
! In  vect_lagr        : vector with Lagrange multipliers
! In  hval_veelem      : hat-variable for elementary vectors
! In  hval_veasse      : hat-variable for vectors (node fields)
! In  cndiri           : nodal field for support reaction
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=19) :: vediri, cndiri
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE11_11')
    endif
!
! - Get hat variables
!
    call nmchex(hval_veelem, 'VEELEM', 'CNDIRI', vediri)
    if (present(hval_veasse_)) then
        call nmchex(hval_veasse_, 'VEASSE', 'CNDIRI', cndiri)
    else
        cndiri = cndiri_
    endif
!
! - Launch timer
!
    call nmtime(ds_measure, 'Init'  , '2nd_Member')
    call nmtime(ds_measure, 'Launch', '2nd_Member')
!
! - Elementary vectors
!
    call vebtla('V'      , model, ds_material%field_mate, cara_elem, vect_lagr,&
                list_load, vediri)
!
! - Assembling
!
    call assvec('V', cndiri, 1, vediri, [1.d0],&
                nume_dof, ' ', 'ZERO', 1)

!
! - Stop timer
!
    call nmtime(ds_measure, 'Stop', '2nd_Member')
!
! - Debug
!
    if (niv .ge. 2) then
        call nmdebg('VECT', cndiri, 6)
    endif
!
end subroutine
