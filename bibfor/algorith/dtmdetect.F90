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

subroutine dtmdetect(sd_dtm_, sd_int_, buffdtm, buffint, reinteg)
    implicit none
!
! person_in_charge: hassan.berro at edf.fr
!
! dtmdetect : Detects a change in the state of non-linearities between between
!             instants i and i-1 by analyzing the saved internal variables and
!             NL_SAVE1
! 
#include "jeveux.h"
#include "asterc/r8prem.h"
#include "asterfort/dtmeigen.h"
#include "asterfort/dtmget.h"
#include "asterfort/dtmproj.h"
#include "asterfort/dtmupmat.h"
#include "asterfort/intget.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
#include "asterfort/nlget.h"
#include "asterfort/utmess.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
!
!   -0.1- Input/output arguments
    character(len=*) , intent(in) :: sd_dtm_
    character(len=*) , intent(in) :: sd_int_
    integer, pointer              :: buffdtm(:)
    integer, pointer              :: buffint(:)
    integer          , intent(out):: reinteg
!
!   -0.2- Local variables
    integer               :: i, nbnoli, nlcase1, nlcase2, ifm
    integer               :: info
    character(len=8)      :: sd_dtm, sd_int, sd_nl
    real(kind=8)          :: epsi, time
!
    integer,      pointer :: buffnl(:)=> null()
    integer,      pointer :: vindx(:)=> null()
    integer,      pointer :: nlcase_i(:)=> null()
    real(kind=8), pointer :: nlsav1(:) => null()
    real(kind=8), pointer :: nlsav2(:) => null()
!
!   0 - Initializations
    sd_dtm  = sd_dtm_
    sd_int  = sd_int_
    epsi    = r8prem()
!
    reinteg = 0
    call dtmget(sd_dtm, _NB_NONLI, iscal=nbnoli, buffer=buffdtm)
    if (nbnoli.gt.0) then
        
        call dtmget(sd_dtm, _SD_NONL  , kscal=sd_nl, buffer=buffdtm)
        call dtmget(sd_dtm, _NL_BUFFER, vi=buffnl, buffer=buffdtm)
        call nlget (sd_nl , _INTERNAL_VARS, vr=nlsav2, buffer=buffnl)
        call nlget (sd_nl , _INTERNAL_VARS_INDEX, vi=vindx, buffer=buffnl)

        call dtmget(sd_dtm, _NL_SAVES, vr=nlsav1   , buffer=buffdtm)
        call dtmget(sd_dtm, _NL_CASE , iscal=nlcase1, buffer=buffdtm)

        AS_ALLOCATE(vi=nlcase_i, size=nbnoli)
        do i = 1, nbnoli
            nlcase_i(i) = 0
            if (abs(nlsav2(vindx(i))).gt.epsi) nlcase_i(i) = 1
         end do
!       --- Define an integer in base10, corresponding to the non-linearity case.
!         python equivalent : nlcase2 = sum([nlcase_i[i]*2**m for m in range(nbnoli)])
        nlcase2 = 0
        do i = 1, nbnoli
            nlcase2 = nlcase2 + nlcase_i(i)*2**(i-1)
        end do
        AS_DEALLOCATE(vi=nlcase_i)
!
!       1 - Did we detect a change in the system's state ?
        if (nlcase2.ne.nlcase1) then
            call intget(sd_int, TIME, iocc=1, rscal=time, buffer=buffint)
    
            call dtmupmat(sd_dtm, sd_int, buffdtm, buffint, nlcase2,&
                          reinteg)

!           --- If no reintegration is required, that is the change has occurred properly,
!               calculate a new projection basis corresponding to the new matrices
            if (reinteg.ne.1) then
                if (nlcase2 .ne. 0) then
                    call dtmeigen(sd_dtm, sd_int, nlcase1, buffdtm, buffint)
                else
                    call infmaj()
                    call infniv(ifm, info)
                    if (info.eq.2) then
                        call intget(sd_int, TIME, iocc=1, rscal=time, buffer=buffint)
                        call utmess('I', 'DYNAMIQUE_93', sr=time)
                    end if                   
                end if
                call dtmproj (sd_dtm, sd_int, nlcase1, buffdtm, buffint)
            end if
        end if
    end if

end subroutine
