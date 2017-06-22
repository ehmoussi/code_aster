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

subroutine vrcomp_prep(vari, vari_r,&
                       compor_curr, compor_curr_r,&
                       compor_prev, compor_prev_r)
!
implicit none
!
#include "asterfort/carces.h"
#include "asterfort/cesred.h"
#include "asterfort/cestas.h"
#include "asterfort/celces.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/utmess.h"
!
!
    character(len=*), intent(in) :: vari
    character(len=19), intent(out) :: vari_r
    character(len=*), intent(in)  :: compor_curr
    character(len=19), intent(out) :: compor_curr_r
    character(len=*), intent(in)  :: compor_prev
    character(len=19), intent(out) :: compor_prev_r
!
! --------------------------------------------------------------------------------------------------
!
! Check compatibility of comportments
!
! Prepare fields
!
! --------------------------------------------------------------------------------------------------
!
! In  vari          : internal variable
! Out vari_r        : reduced field for internal variable
! In  compor_curr   : current comportment
! Out compor_curr_r : reduced field for current comportment
! In  compor_prev   : previous comportment
! Out compor_prev_r : reduced field for previous comportment
!
! --------------------------------------------------------------------------------------------------
!
    character(len=19) :: coto
    integer :: iret
!
! --------------------------------------------------------------------------------------------------
!
    coto          = '&&VRCOMP.COTO'
    vari_r        = '&&VRCOMP.VARI_R'
    compor_curr_r = '&&VRCOMP.COPP'
!
! - Create reduced CARTE on current comportement
!
    call carces(compor_curr, 'ELEM', ' ', 'V', coto,&
                'A', iret)
    call cesred(coto, 0, [0], 1, 'RELCOM',&
                'V', compor_curr_r)
    call detrsd('CHAM_ELEM_S', coto)
!
! - Create reduced field for internal variables
!
    call celces(vari, 'V', vari_r)
    call cestas(vari_r)
!
! - Create reduced CARTE on previous comportement
!
    if (compor_prev.eq.' ') then
        compor_prev_r = ' '
    else
        compor_prev_r = '&&VRCOMP.COPM'
        call carces(compor_prev, 'ELEM', ' ', 'V', coto,&
                    'A', iret)
        call cesred(coto, 0, [0], 1, 'RELCOM',&
                    'V', compor_prev_r)
        call detrsd('CHAM_ELEM_S', coto)
    endif
!
end subroutine
