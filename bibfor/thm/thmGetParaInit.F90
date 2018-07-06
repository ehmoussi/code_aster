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
!
subroutine thmGetParaInit(j_mater, l_check_)
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
#include "asterfort/THM_type.h"
!
integer, intent(in) :: j_mater
aster_logical, optional, intent(in) :: l_check_
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Get initial parameters (THM_INIT)
!
! --------------------------------------------------------------------------------------------------
!
! In  j_mater          : coded material address
! In  l_check          : check THM_INIT
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_temp_init, l_pre2_init
    integer :: nume_thmc, nume_init
    integer, parameter :: nb_para   =  5
    integer :: icodre(nb_para)
    real(kind=8) :: para_vale(nb_para)
    character(len=16), parameter :: para_name(nb_para) = (/ 'TEMP     ', 'PRE1     ',&
                                                            'PRE2     ', 'PORO     ',&
                                                            'PRES_VAPE'/)
    real(kind=8) :: para_vale2(1)
    integer :: icodre2(1)
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

!
! - Check: compatibility coupling law with initial parameters
!
    if (present(l_check_)) then
        nume_thmc = ds_thm%ds_behaviour%nume_thmc
        call rcvala(j_mater, ' '       , 'THM_INIT',&
                    0      , ' '       , [0.d0]    ,&
                    1      , 'COMP_THM', para_vale2,&
                    icodre2, 1)
        nume_init = nint(para_vale2(1))
        if (nume_init .ne. nume_thmc) then
            call utmess('F', 'THM1_34')
        endif
    endif
!
end subroutine
