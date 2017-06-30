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

subroutine thmGetParaInit(j_mater)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8nnem.h"
#include "asterc/r8prem.h"
#include "asterfort/rcvala.h"
#include "asterfort/utmess.h"
!
!
    integer, intent(in) :: j_mater
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Get initial parameters (THM_INIT)
!
! --------------------------------------------------------------------------------------------------
!
! In  j_mater      : coded material address
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_temp_init, l_pre2_init
    integer, parameter :: nb_para   =  5
    integer :: icodre(nb_para)
    real(kind=8) :: para_vale(nb_para)
    character(len=16), parameter :: para_name(nb_para) = (/ 'TEMP     ', 'PRE1     ',&
                                                            'PRE2     ', 'PORO     ',&
                                                            'PRES_VAPE'/)
!
! --------------------------------------------------------------------------------------------------
!
    para_vale(:) = r8nnem()
!
! - Read parameters
!
    call rcvala(j_mater, ' '      , 'THM_INIT',&
                0      , ' '      , [0.d0]    ,&
                nb_para, para_name, para_vale ,&
                icodre , 0        , nan='OUI')
    ds_thm%ds_parainit%temp_init = para_vale(1)
    ds_thm%ds_parainit%pre1_init = para_vale(2)
    ds_thm%ds_parainit%pre2_init = para_vale(3)
    ds_thm%ds_parainit%poro_init = para_vale(4)
    ds_thm%ds_parainit%prev_init = para_vale(5)
    l_temp_init                  = icodre(1) .eq. 0
    l_pre2_init                  = icodre(3) .eq. 0
!
! - Check: domain of parameters
!
    if (ds_thm%ds_behaviour%l_temp) then
        if (l_temp_init) then
            if (ds_thm%ds_parainit%temp_init .le. r8prem()) then
                call utmess('F', 'THM2_3')
            endif
        endif
    endif
    if (ds_thm%ds_behaviour%nb_pres .eq. 2) then
        if (l_pre2_init) then
            if (abs(ds_thm%ds_parainit%pre2_init) .le. r8prem()) then
                call utmess('F', 'THM2_4')
            endif
        endif
    endif
!
! - Check: compatibility coupling law with initial parameters
!
    if (ds_thm%ds_behaviour%l_temp) then
        if (.not. l_temp_init) then
            call utmess('F', 'THM2_1', sk=ds_thm%ds_behaviour%rela_thmc)
        endif
    endif
    if (ds_thm%ds_behaviour%nb_pres .eq. 2) then
        if (.not. l_pre2_init) then
            call utmess('F', 'THM2_2', sk=ds_thm%ds_behaviour%rela_thmc)
        endif
    endif
    if (ds_thm%ds_elem%l_dof_ther) then
        if (.not. l_temp_init) then
            call utmess('F', 'THM2_5')
        endif
    endif
!
end subroutine
