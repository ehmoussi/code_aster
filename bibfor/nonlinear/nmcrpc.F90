! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
subroutine nmcrpc(ds_inout, nume_reuse, time_curr)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/tbajli.h"
!
type(NL_DS_InOut), intent(in) :: ds_inout
integer, intent(in) :: nume_reuse
real(kind=8), intent(in) :: time_curr
!
! --------------------------------------------------------------------------------------------------
!
! *_NON_LINE
!
! Save parameters in output table
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_inout         : datastructure for input/output management
! In  nume_reuse       : index for reuse rsults datastructure
! In  time_curr        : current time
!
! --------------------------------------------------------------------------------------------------
!
    integer :: vali(1)
    character(len=8) :: k8bid
    complex(kind=8), parameter :: c16bid =(0.d0,0.d0)
    real(kind=8) :: valr(1)
!
! --------------------------------------------------------------------------------------------------
!
    vali(1) = nume_reuse
    valr(1) = time_curr
    k8bid = ' '
!
! - Add line in table
!
    call tbajli(ds_inout%table_io%tablName,&
                ds_inout%table_io%nbPara, ds_inout%table_io%paraName,&
                vali, valr, [c16bid], k8bid, 0)
!
end subroutine
