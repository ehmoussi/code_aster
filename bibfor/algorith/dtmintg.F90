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

subroutine dtmintg(sd_dtm_, sd_int_, buffdtm, buffint)
    implicit none
!
! person_in_charge: hassan.berro at edf.fr
!
! dtmintg : Integrate from t_i to t_i+1 the differential equations of motion
!           using the integration method specified in the sd_int.
! 
#include "jeveux.h"
#include "blas/dcopy.h"
#include "asterfort/assert.h"
#include "asterfort/dtmget.h"
#include "asterfort/intadapt1.h"
#include "asterfort/intadapt2.h"
#include "asterfort/intdevo.h"
#include "asterfort/inteuler.h"
#include "asterfort/intitmi.h"
#include "asterfort/intnewm.h"
#include "asterfort/intruku32.h"
#include "asterfort/intruku54.h"
#include "asterfort/nlget.h"
!
!   -0.1- Input/output arguments
    character(len=*) , intent(in) :: sd_dtm_
    character(len=*) , intent(in) :: sd_int_
    integer, pointer              :: buffdtm(:)
    integer, pointer              :: buffint(:)
!
!   -0.2- Local variables
    integer               :: nbnoli, method
    character(len=8)      :: sd_dtm, sd_int, sd_nl
    real(kind=8), pointer :: nlsav1(:) => null()
    real(kind=8), pointer :: nlsav2(:) => null()
    integer, pointer      :: buffnl(:) => null()
!
!   0 - Initializations
    sd_dtm = sd_dtm_
    sd_int = sd_int_
!
    call dtmget(sd_dtm, _SCHEMA_I, iscal=method, buffer=buffdtm)
    call dtmget(sd_dtm, _NB_NONLI, iscal=nbnoli, buffer=buffdtm)
    if (nbnoli.gt.0) then
        call dtmget(sd_dtm, _SD_NONL  , kscal=sd_nl, buffer=buffdtm)
        call dtmget(sd_dtm, _NL_BUFFER, vi=buffnl, buffer=buffdtm)
        call nlget (sd_nl , _INTERNAL_VARS, vr=nlsav2, buffer=buffnl)
        call dtmget(sd_dtm, _NL_SAVES, vr=nlsav1, buffer=buffdtm)
        call dcopy(size(nlsav2), nlsav2, 1, nlsav1, 1)
    end if

    select case (method)
!
        case(_SCH_EULER)
            call inteuler(sd_dtm, sd_int, buffdtm, buffint)
!
        case(_SCH_DEVOGE)
            call intdevo(sd_dtm, sd_int, buffdtm, buffint)
!
        case(_SCH_NEWMARK)
            call intnewm(sd_dtm, sd_int, buffdtm, buffint)
!
        case(_SCH_RUNGE_KUTTA_32)
            call intruku32(sd_dtm, sd_int, buffdtm, buffint)
!
        case(_SCH_RUNGE_KUTTA_54)
            call intruku54(sd_dtm, sd_int, buffdtm, buffint)
!
        case(_SCH_ADAPT_ORDRE1)
            call intadapt1(sd_dtm, sd_int, buffdtm, buffint)
!
        case(_SCH_ADAPT_ORDRE2)
            call intadapt2(sd_dtm, sd_int, buffdtm, buffint)
!
        case(_SCH_ITMI)
            call intitmi(sd_dtm, sd_int, buffdtm, buffint)
!
        case default
            ASSERT(.false.)
!
    end select

end subroutine
