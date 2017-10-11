! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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
!
subroutine thmGetBehaviourChck()
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/THM_type.h"
#include "asterfort/Behaviour_type.h"
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Some checks between behaviour and model
!
! --------------------------------------------------------------------------------------------------
!
    integer :: vali(2)
!
! --------------------------------------------------------------------------------------------------
!
    if (ds_thm%ds_elem%l_dof_pre1 .and. ds_thm%ds_elem%l_dof_pre2) then
        if (ds_thm%ds_behaviour%nb_pres .ne. 2) then
            vali(1) = 2
            vali(2) = ds_thm%ds_behaviour%nb_pres
            call utmess('F', 'THM1_60', sk   = ds_thm%ds_behaviour%rela_thmc,&
                                        ni   = 2,&
                                        vali = vali)
        endif
        if (ds_thm%ds_behaviour%nb_phase(1) .ne. ds_thm%ds_elem%nb_phase(1)) then
            vali(1) = ds_thm%ds_elem%nb_phase(1)
            vali(2) = ds_thm%ds_behaviour%nb_phase(1)
            call utmess('F', 'THM1_61', sk   = ds_thm%ds_behaviour%rela_thmc,&
                                        ni   = 2,&
                                        vali = vali)
        endif
        if (ds_thm%ds_behaviour%nb_phase(2) .ne. ds_thm%ds_elem%nb_phase(2)) then
            vali(1) = ds_thm%ds_elem%nb_phase(2)
            vali(2) = ds_thm%ds_behaviour%nb_phase(2)
            call utmess('F', 'THM1_62', sk   = ds_thm%ds_behaviour%rela_thmc,&
                                        ni   = 2,&
                                        vali = vali)
        endif
    endif
    if (ds_thm%ds_elem%l_dof_pre1 .and. .not. ds_thm%ds_elem%l_dof_pre2) then
        if (ds_thm%ds_behaviour%nb_pres .ne. 1) then
            vali(1) = 2
            vali(2) = ds_thm%ds_behaviour%nb_pres
            call utmess('F', 'THM1_60', sk   = ds_thm%ds_behaviour%rela_thmc,&
                                        ni   = 2,&
                                        vali = vali)
        endif
        if (ds_thm%ds_behaviour%nb_phase(1) .ne. ds_thm%ds_elem%nb_phase(1)) then
            vali(1) = ds_thm%ds_elem%nb_phase(1)
            vali(2) = ds_thm%ds_behaviour%nb_phase(1)
            call utmess('F', 'THM1_61', sk   = ds_thm%ds_behaviour%rela_thmc,&
                                        ni   = 2,&
                                        vali = vali)
        endif
    endif
    if (.not. ds_thm%ds_elem%l_dof_pre1 .and. .not. ds_thm%ds_elem%l_dof_pre2) then
        if (ds_thm%ds_behaviour%nb_pres .ne. 0) then
            vali(1) = 2
            vali(2) = ds_thm%ds_behaviour%nb_pres
            call utmess('F', 'THM1_60', sk   = ds_thm%ds_behaviour%rela_thmc,&
                                        ni   = 2,&
                                        vali = vali)
        endif
    endif
!
    if (ds_thm%ds_behaviour%l_meca) then
        if (.not. ds_thm%ds_elem%l_dof_meca) then
            call utmess('F', 'THM1_63', sk = ds_thm%ds_behaviour%rela_thmc)
        endif
    endif
    if (.not.ds_thm%ds_behaviour%l_meca) then
        if (ds_thm%ds_elem%l_dof_meca) then
            call utmess('F', 'THM1_64', sk = ds_thm%ds_behaviour%rela_thmc)
        endif
    endif
!
    if (ds_thm%ds_behaviour%l_temp) then
        if (.not. ds_thm%ds_elem%l_dof_ther) then
            call utmess('F', 'THM1_65', sk = ds_thm%ds_behaviour%rela_thmc)
        endif
    endif
    if (.not.ds_thm%ds_behaviour%l_temp) then
        if (ds_thm%ds_elem%l_dof_ther) then
            call utmess('F', 'THM1_66', sk = ds_thm%ds_behaviour%rela_thmc)
        endif
    endif
!
end subroutine
