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
subroutine nonlinDSMaterialTimeStep(model          , ds_material, cara_elem,&
                                    ds_constitutive, hval_incr  ,&
                                    nume_dof       , sddisc     , nume_inst)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/diinst.h"
#include "asterfort/detrsd.h"
#include "asterfort/utmess.h"
#include "asterfort/nmvcre.h"
#include "asterfort/nmvcfo.h"
#include "asterfort/assvec.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmvcle.h"
!
character(len=24), intent(in) :: model, cara_elem
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
character(len=19), intent(in) :: hval_incr(*)
character(len=24), intent(in) :: nume_dof
character(len=19), intent(in) :: sddisc
integer, intent(in) :: nume_inst
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Material parameters management
!
! Update material parameters for new time step
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  ds_material      : datastructure for material parameters
! In  ds_constitutive  : datastructure for constitutive laws management
! In  cara_elem        : name of elementary characteristics (field)
! In  hval_incr        : hat-variable for incremental values
! In  nume_dof         : name of numbering object (NUME_DDL)
! In  sddisc           : datastructure for time discretization
! In  nume_inst        : index of current time step
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=19) :: vect_elem, vect_asse, varc_curr
    real(kind=8) :: time_curr
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> ... Update material parameters for new time step'
    endif
!
! - Current time
!
    time_curr = diinst(sddisc, nume_inst)
!
! - Create external state variables for current time
!
    call nmchex(hval_incr, 'VALINC', 'COMPLU', varc_curr)
    call nmvcle(model, ds_material%field_mate, cara_elem, time_curr, varc_curr)
!
! - Compute CHAR_MECA_*_R for convergence criteria
!
    vect_elem = '&&VARCINIT_ELEM'
    vect_asse = ds_material%fvarc_curr(1:19)
    call nmvcfo('+'   , model    , ds_material%field_mate     , cara_elem, ds_constitutive%compor,&
                ds_material%varc_refe, hval_incr, vect_elem)
    call assvec('V', vect_asse, 1, vect_elem, [1.d0],&
                nume_dof, ' ', 'ZERO', 1)
    call detrsd('RESUELEM', vect_elem)
!
! - Compute CHAR_MECA_*_R for PREDICTOR
!
!    vect_elem = '&&VARCINIT_ELEM'
!    call nmvcpr(model    , ds_material%field_mate,&
!                cara_elem, ds_material%varc_refe , ds_constitutive%compor, &
!                hval_incr, nume_dof_ = nume_dof, base_ = 'V',&
!                vect_elem_prev_ = '&&VEVCOM',&
!                vect_elem_curr_ = '&&VEVCOP',&
!                cnvcpr_ = ds_material%fvarc_pred)
!    call detrsd('RESUELEM', vect_elem)
!
end subroutine
