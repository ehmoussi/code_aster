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
subroutine nzcomp(jv_mater , metaPara , nume_comp,&
                  dt10     , dt21     , inst2    ,&
                  tno0     , tno1     , tno2     ,&
                  meta_prev, meta_curr)
!
use Metallurgy_type
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/zacier.h"
#include "asterfort/zedgar.h"
#include "asterfort/Metallurgy_type.h"
!
integer, intent(in) :: jv_mater
type(META_MaterialParameters), intent(in) :: metaPara
integer, intent(in) :: nume_comp
real(kind=8), intent(in) :: dt10, dt21, inst2
real(kind=8), intent(in) :: tno0, tno1, tno2
real(kind=8), intent(in) :: meta_prev(*)
real(kind=8), intent(out) :: meta_curr(*)
!
! --------------------------------------------------------------------------------------------------
!
! METALLURGY - Compute phases
!
! General 
!
! --------------------------------------------------------------------------------------------------
!
! In  jv_mater            : coded material address
! In  metaPara            : material parameters for metallurgy
! In  nume_comp           : index of behaviour law for metallurgy
! In  tno0                : temperature at time N-1
! In  tno1                : temperature at time N
! In  tno2                : temperature at time N+1
! In  dt10                : increment of time [N-1, N]
! In  dt21                : increment of time [N, N+1]
! In  inst2               : value of time N+1
! In  meta_prev           : value of internal state variable at previous time step
! Out meta_curr           : value of internal state variable at current time step
!
! --------------------------------------------------------------------------------------------------
!
    select case (nume_comp)
!
    case (20002)
        call zacier(metaPara%steel,&
                    tno0, tno1, tno2,&
                    dt10, dt21,&
                    meta_prev, meta_curr)
    case (30001)
       call zedgar(jv_mater,&
                   tno1, tno2,&
                   inst2, dt21,&
                   meta_prev, meta_curr)
    case default
        ASSERT(ASTER_FALSE)
    end select
!
end subroutine
