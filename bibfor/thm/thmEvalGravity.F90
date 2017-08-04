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
subroutine thmEvalGravity(j_mater, time, grav)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/rcvala.h"
#include "asterfort/utmess.h"
!
integer, intent(in) :: j_mater
real(kind=8), intent(in) :: time
real(kind=8), intent(out) :: grav(3)
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute gravity
!
! --------------------------------------------------------------------------------------------------
!
! In  j_mater          : coded material address
! In  time             : current time
! Out grav             : gravity
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: grav_func(1)
    integer, parameter :: nb_resu = 3
    integer :: icodre(nb_resu)
    real(kind=8) :: resu_vale(nb_resu)
    character(len=16), parameter :: resu_name(nb_resu) = (/'PESA_X','PESA_Y','PESA_Z'/)
!
! --------------------------------------------------------------------------------------------------
!
    grav(:)      = 0.d0
    resu_vale(:) = 0.d0
!
! - Get parameters
!
    call rcvala(j_mater, ' '      , 'THM_DIFFU',&
                0      , ' '      , [0.0d0]    ,&
                nb_resu, resu_name, resu_vale  ,&
                icodre , 0        , nan='NON') 
!
! - Get function
!
    call rcvala(j_mater  , ' '        , 'THM_DIFFU',&
                1        , 'INST'     , [time]     ,&
                1        , 'PESA_MULT', grav_func  ,&
                icodre(1), 0          , nan='NON')
    if (icodre(1) .eq. 1) then
        grav_func(1) = 1.d0
    endif
!
    grav(1) = grav_func(1)*resu_vale(1)
    grav(2) = grav_func(1)*resu_vale(2)
    grav(3) = grav_func(1)*resu_vale(3)
!
end subroutine
