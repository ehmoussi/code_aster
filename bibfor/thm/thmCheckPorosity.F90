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

subroutine thmCheckPorosity(j_mater, meca)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/rcvala.h"
#include "asterfort/utmess.h"
!
integer, intent(in) :: j_mater
character(len=16), intent(in) :: meca
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Check porosity for some behaviours
!
! --------------------------------------------------------------------------------------------------
!
! In  j_mater          : coded material address
! In  meca             : relation for mechanical part
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: poro_init, poro_meca, poro_diff, poro_tole
    integer :: icodre(1)
    real(kind=8) :: para_vale(1)
!
! --------------------------------------------------------------------------------------------------
!  
    poro_init = ds_thm%ds_parainit%poro_init
!
! - Check
!
    if (meca .eq. 'BARCELONE') then
        poro_tole = 1.D-10
        call rcvala(j_mater, ' '      , meca,&
                    0      , ' '      , [0.d0]    ,&
                    1      , ['PORO'] , para_vale ,&
                    icodre , 0        )
        poro_meca = para_vale(1)
        poro_diff = abs(poro_meca-poro_init)
        if (abs(poro_diff) .gt. poro_tole) then
            call utmess('F', 'THM2_60', sk = meca)
        endif
    endif
    if (meca .eq. 'CAM_CLAY') then
        poro_tole = 1.D-6
        call rcvala(j_mater, ' '      , meca,&
                    0      , ' '      , [0.d0]    ,&
                    1      , ['PORO'] , para_vale ,&
                    icodre , 0        )
        poro_meca = para_vale(1)
        poro_diff = abs(poro_meca-poro_init)
        if (abs(poro_diff) .gt. poro_tole) then
            call utmess('F', 'THM2_60', sk = meca)
        endif
    endif
!
end subroutine
