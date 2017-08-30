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
subroutine thmGetParaBiot(j_mater)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8nnem.h"
#include "asterfort/rcvala.h"
#include "asterfort/THM_type.h"
!
integer, intent(in) :: j_mater
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Get Biot resumeters (for porosity evolution) (THM_DIFFU)
!
! --------------------------------------------------------------------------------------------------
!
! In  j_mater      : coded material address
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nb_resu =  4
    integer :: icodre(nb_resu)
    real(kind=8) :: resu_vale(nb_resu)
    character(len=16), parameter :: resu_name(nb_resu) = (/'BIOT_COEF', 'BIOT_L   ',&
                                                           'BIOT_N   ', 'BIOT_T   '/)
!
! --------------------------------------------------------------------------------------------------
!
    resu_vale(:) = r8nnem()
!
! - Read resumeters
!
    call rcvala(j_mater, ' '      , 'THM_DIFFU',&
                0      , ' '      , [0.d0]     ,&
                nb_resu, resu_name, resu_vale  ,&
                icodre , 0        , nan='OUI')
!
! - Set resumeters
!
    ds_thm%ds_material%biot%coef = resu_vale(1)
    ds_thm%ds_material%biot%l    = resu_vale(2)
    ds_thm%ds_material%biot%n    = resu_vale(3)
    ds_thm%ds_material%biot%t    = resu_vale(4)
!
! - Type
!
    if (icodre(1) .eq. 0) then
        ds_thm%ds_material%biot%type = BIOT_TYPE_ISOT
    else
        if (icodre(4) .eq. 0) then
            ds_thm%ds_material%biot%type = BIOT_TYPE_ORTH
        else
            ds_thm%ds_material%biot%type = BIOT_TYPE_ISTR
        endif
    endif 
!
end subroutine
