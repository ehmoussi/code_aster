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
! person_in_lload_name: mickael.abbas at edf.fr
!
subroutine nonlinDynaMDampCompute(phase    , sddyna     ,&
                                  nume_dof , ds_measure ,&
                                  hval_incr, hval_veasse)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmtime.h"
#include "asterfort/dismoi.h"
#include "asterfort/ndynkk.h"
#include "asterfort/ndynlo.h"
#include "asterfort/jeveuo.h"
#include "asterfort/fmodam.h"
!
character(len=10), intent(in) :: phase
character(len=19), intent(in) :: sddyna
character(len=24), intent(in) :: nume_dof
type(NL_DS_Measure), intent(inout) :: ds_measure
character(len=19), intent(in) :: hval_incr(*)
character(len=19), intent(in) :: hval_veasse(*)
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Dynamic - Compute modal damping
!
! --------------------------------------------------------------------------------------------------
!
! In  phase            : "prediction" or "correction"
! In  sddyna           : datastructure for dynamic
! In  model            : name of model
! In  nume_dof         : name of numbering object (NUME_DDL)
! In  ds_material      : datastructure for material parameters
! IO  ds_measure       : datastructure for measure and statistics management
! In  hval_incr        : hat-variable for incremental values fields
! In  hval_veelem      : hat-variable for elementary vectors
! In  hval_veasse      : hat-variable for vectors (node fields)
!
! --------------------------------------------------------------------------------------------------
!
    character(len=19) :: vect_asse
    character(len=19) :: vite_iter, vite_curr
    real(kind=8), pointer :: v_vect_asse(:) => null()
    integer :: nb_equa
    character(len=24) :: valmod, basmod
    character(len=19) :: sdammo
    aster_logical :: nreavi
    real(kind=8), pointer :: v_vite_iter(:) => null()
    real(kind=8), pointer :: v_vite_curr(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call nmchex(hval_incr, 'VALINC', 'VITPLU', vite_curr)
    call nmchex(hval_incr, 'VALINC', 'VITKM1', vite_iter)
    call nmchex(hval_veasse, 'VEASSE', 'CNAMOD', vect_asse)
    call jeveuo(vite_iter(1:19)//'.VALE', 'E', vr = v_vite_iter)
    call jeveuo(vite_curr(1:19)//'.VALE', 'E', vr = v_vite_curr)
    call jeveuo(vect_asse(1:19)//'.VALE', 'E', vr = v_vect_asse)
!
! - Initializations
!
    call dismoi('NB_EQUA', nume_dof, 'NUME_DDL', repi=nb_equa)
    call ndynkk(sddyna, 'SDAMMO', sdammo)
    valmod = sdammo(1:19)//'.VALM'
    basmod = sdammo(1:19)//'.BASM'
    nreavi = ndynlo(sddyna,'NREAVI')
!
! - Launch timer
!
    call nmtime(ds_measure, 'Init'  , '2nd_Member')
    call nmtime(ds_measure, 'Launch', '2nd_Member')
!
! - Compute
!
    if (phase .eq. 'Prediction') then
        call fmodam(nb_equa, v_vite_iter, valmod, basmod, v_vect_asse)
    elseif (phase .eq. 'Correction') then
        call fmodam(nb_equa, v_vite_curr, valmod, basmod, v_vect_asse)
        if (nreavi) then
            call fmodam(nb_equa, v_vite_curr, valmod, basmod, v_vect_asse)
        endif
    else
        ASSERT(ASTER_FALSE)
    endif
!
! - Stop timer
!
    call nmtime(ds_measure, 'Stop', '2nd_Member')
!
end subroutine
