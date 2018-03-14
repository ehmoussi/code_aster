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
subroutine nmpilr(list_func_acti, nume_dof, matass, hval_veasse, ds_contact,&
                  eta           , residu  )
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/dismoi.h"
#include "asterfort/isfonc.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmpcin.h"
#include "asterfort/nmequi.h"
!
integer, intent(in) :: list_func_acti(*)
character(len=24), intent(in) :: nume_dof
character(len=19), intent(in) :: matass, hval_veasse(*)
type(NL_DS_Contact), intent(in) :: ds_contact
real(kind=8), intent(in) :: eta
real(kind=8), intent(out) :: residu
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm (PILOTAGE)
!
! Compute maximum of out-of-balance force

! --------------------------------------------------------------------------------------------------
!
! In  list_func_acti   : list of active functionnalities
! In  nume_dof         : name of numbering object (NUME_DDL)
! In  matass           : matrix
! In  hval_veasse      : hat-variable for vectors (node fields)
! In  ds_contact       : datastructure for contact management
! In  eta              : coefficient for pilotage (continuation)
! Out residu           : value of maximum of out-of-balance force
!
! --------------------------------------------------------------------------------------------------
!
    character(len=19) :: cnfext, cnfint, cndiri, cnbudi, cndipi, cndfdo, cnequi, cnsstr
    integer :: i_equa, nb_equa
    aster_logical :: l_load_cine, l_disp, l_pilo, l_macr
    integer, pointer :: v_ccid(:) => null()
    real(kind=8), pointer :: v_cnequi(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Active functionnalities
!
    l_load_cine = isfonc(list_func_acti, 'DIRI_CINE')
    l_macr      = isfonc(list_func_acti, 'MACR_ELEM_STAT')
    l_disp      = ASTER_TRUE
    l_pilo      = ASTER_TRUE
!
! - Hat variables
!
    call nmchex(hval_veasse, 'VEASSE', 'CNDIRI', cndiri)
    call nmchex(hval_veasse, 'VEASSE', 'CNFINT', cnfint)
    call nmchex(hval_veasse, 'VEASSE', 'CNFEXT', cnfext)
    call nmchex(hval_veasse, 'VEASSE', 'CNBUDI', cnbudi)
    call nmchex(hval_veasse, 'VEASSE', 'CNDIPI', cndipi)
    call nmchex(hval_veasse, 'VEASSE', 'CNSSTR', cnsstr)
    cndfdo = '&&CNCHAR.DFDO'
!
! - For kinematic loads
!
    if (l_load_cine) then
        call nmpcin(matass)
        call jeveuo(matass(1:19)//'.CCID', 'L', vi=v_ccid)
    endif
!
! - Compute lack of balance forces
!
    cnequi = '&&CNCHAR.DONN'
    call nmequi(l_disp     , l_pilo, l_macr, cnequi,&
                cnfint     , cnfext, cndiri, cnsstr,&
                ds_contact_ = ds_contact,&
                cnbudi_ = cnbudi, cndfdo_ = cndfdo,&
                cndipi_ = cndipi, eta_    = eta)
    call jeveuo(cnequi(1:19)//'.VALE', 'L', vr=v_cnequi)
!
    call dismoi('NB_EQUA', nume_dof, 'NUME_DDL', repi=nb_equa)
    residu = 0.d0
!
! - Compute
!
    do i_equa = 1, nb_equa
        if (l_load_cine) then
            if (v_ccid(i_equa) .eq. 1) then
                cycle
            endif
        endif
        residu = max(residu,abs(v_cnequi(i_equa)))
    end do
!
    call jedema()
end subroutine
