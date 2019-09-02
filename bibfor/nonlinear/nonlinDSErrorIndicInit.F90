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
subroutine nonlinDSErrorIndicInit(model, ds_constitutive, ds_errorindic)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/Behaviour_type.h"
#include "asterfort/comp_meca_l.h"
#include "asterfort/jeveuo.h"
#include "asterfort/cetule.h"
#include "asterfort/infdbg.h"
#include "asterfort/utmess.h"
!
character(len=24), intent(in) :: model
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
type(NL_DS_ErrorIndic), intent(inout) :: ds_errorindic
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Error indicators
!
! Initializations for error indicator management datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  ds_constitutive  : datastructure for constitutive laws management
! IO  ds_errorindic    : datastructure for error indicator
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    real(kind=8), pointer :: v_valv(:) => null()
    integer :: nb_affe, i_affe, iret
    character(len=16), pointer :: v_compor_vale(:) => null()
    integer, pointer :: v_compor_desc(:) => null()
    character(len=16) :: rela_comp, rela_thmc, rela_meca
    aster_logical :: l_kit_thm, l_erre_thm
    real(kind=8) :: tbgrca(3)
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE',ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE13_74')
    endif
!
! - Initializations (incremental way for global error)
!
    ds_errorindic%erre_thm_glob = 0.d0
    l_erre_thm  = ds_errorindic%l_erre_thm
!
! - Get value of THETA
!
    call jeveuo(ds_constitutive%carcri(1:19)//'.VALV', 'L', vr = v_valv)
    ds_errorindic%parm_theta = v_valv(PARM_THETA_THM)
!
! - Checks for behaviour
!
    call jeveuo(ds_constitutive%compor(1:19)//'.VALE', 'L', vk16 = v_compor_vale)
    call jeveuo(ds_constitutive%compor(1:19)//'.DESC', 'L', vi   = v_compor_desc)
    nb_affe = v_compor_desc(3)
    do i_affe = 1, nb_affe
        rela_comp = v_compor_vale(RELA_NAME+COMPOR_SIZE*(i_affe-1))
        rela_thmc = v_compor_vale(THMC_NAME+COMPOR_SIZE*(i_affe-1))
        rela_meca = v_compor_vale(MECA_NAME+COMPOR_SIZE*(i_affe-1))
        call comp_meca_l(rela_comp, 'KIT_THM', l_kit_thm)
        if (l_erre_thm) then
            if (.not. l_kit_thm .and. rela_thmc .ne. 'VIDE') then
                call utmess('F', 'INDICATEUR_23')
            endif
            if (l_erre_thm) then
                if (rela_thmc .ne. 'LIQU_SATU' .and. rela_meca .ne. 'ELAS' .and.&
                    rela_thmc .ne. 'VIDE') then
                    call utmess('F', 'INDICATEUR_25')
                endif
            endif
        endif
    enddo
!
! - Caracteristics lengths
!
    if (ds_errorindic%l_erre_thm) then
        call cetule(model, tbgrca, iret)
        ds_errorindic%adim_l = tbgrca(1)
        ds_errorindic%adim_p = tbgrca(2)
    endif
!
end subroutine
