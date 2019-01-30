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
subroutine nonlinInitDisp(list_func_acti, sdnume   , nume_dof,&
                          hval_algo     , hval_incr)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/isnnem.h"
#include "asterfort/assert.h"
#include "asterfort/copisd.h"
#include "asterfort/dismoi.h"
#include "asterfort/isfonc.h"
#include "asterfort/initia.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nmchex.h"
!
integer, intent(in) :: list_func_acti(*)
character(len=19), intent(in) :: sdnume
character(len=24), intent(in) :: nume_dof
character(len=19), intent(in) :: hval_algo(*), hval_incr(*)
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Initializations of displacements
!
! --------------------------------------------------------------------------------------------------
!
! In  list_func_acti   : list of active functionnalities
! In  sdnume           : datastructure for dof positions
! In  nume_dof         : name of numbering object (NUME_DDL)
! In  hval_incr        : hat-variable for incremental values fields
! In  hval_algo        : hat-variable for algorithms fields
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_grot
    integer :: nb_equa
    character(len=19) :: disp_prev, disp_curr, disp_cumu_inst
    integer :: jv_ndro
    real(kind=8), pointer :: v_disp_curr(:) => null()
    real(kind=8), pointer :: v_disp_cumu(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
!
! - Initializations
!
    call dismoi('NB_EQUA', nume_dof, 'NUME_DDL', repi=nb_equa)
    jv_ndro = isnnem()
!
! - Active functionnalites
!
    l_grot = isfonc(list_func_acti,'GD_ROTA')
!
! - Access to large rotations DOF
!
    if (l_grot) then
        call jeveuo(sdnume(1:19)//'.NDRO', 'L', jv_ndro)
    endif
!
! - Get hat variables
!
    call nmchex(hval_incr, 'VALINC', 'DEPMOI', disp_prev)
    call nmchex(hval_incr, 'VALINC', 'DEPPLU', disp_curr)
    call nmchex(hval_algo, 'SOLALG', 'DEPDEL', disp_cumu_inst)
!
! - Prepare fields
!
    call copisd('CHAMP_GD', 'V', disp_prev, disp_curr)
!
! - Set fields to "zero"
!
    call jeveuo(disp_cumu_inst//'.VALE', 'E', vr = v_disp_cumu)
    call jeveuo(disp_curr//'.VALE', 'L', vr = v_disp_curr)
    call initia(nb_equa, l_grot, zi(jv_ndro), v_disp_curr, v_disp_cumu)
!
end subroutine
