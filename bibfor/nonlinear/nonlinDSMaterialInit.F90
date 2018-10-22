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
subroutine nonlinDSMaterialInit(model      , mate     , cara_elem,&
                                compor     , hval_incr,&
                                nume_dof   , time_init,&
                                ds_material)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/detrsd.h"
#include "asterfort/utmess.h"
#include "asterfort/nmvcre.h"
#include "asterfort/nmvcfo.h"
#include "asterfort/assvec.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmvcle.h"
!
character(len=24), intent(in) :: model, mate, cara_elem
character(len=24), intent(in) :: compor
character(len=19), intent(in) :: hval_incr(*)
character(len=24), intent(in) :: nume_dof
real(kind=8), intent(in) :: time_init
type(NL_DS_Material), intent(inout) :: ds_material
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Material parameters management
!
! Initializations for material parameters management
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  mate             : name of material characteristics (field)
! In  cara_elem        : name of elementary characteristics (field)
! In  compor           : name of comportment definition (field)
! In  hval_incr        : hat-variable for incremental values
! In  nume_dof         : name of numbering object (NUME_DDL)
! IO  ds_material      : datastructure for material parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=19) :: vect_elem, vect_asse, varc_prev
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE13_8')
    endif
!
! - Save material field
!
    ds_material%field_mate = mate
!
! - Create external state variables for reference state
!
    call nmvcre(model, mate, cara_elem, ds_material%varc_refe)
!
! - Create external state variables for initial time
!
    call nmchex(hval_incr, 'VALINC', 'COMMOI', varc_prev)
    call nmvcle(model, mate, cara_elem, time_init, varc_prev)
!
! - Compute CHAR_MECA_*_R at initial time
!
    vect_elem = '&&VARCINIT_ELEM'
    vect_asse = ds_material%fvarc_init(1:19)
    call nmvcfo('-'   , model    , mate     , cara_elem, compor,&
                ds_material%varc_refe, hval_incr, vect_elem)
    call assvec('V', vect_asse, 1, vect_elem, [1.d0],&
                nume_dof, ' ', 'ZERO', 1)
    call detrsd('RESUELEM', vect_elem)
!
end subroutine
