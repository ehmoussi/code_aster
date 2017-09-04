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

subroutine dtmforc_calcnoli(sd_dtm_, sd_nl_, buffdtm, buffnl,&
                        time   ,dt, depl  , vite, fext,&
                        nbmode,nlacc,nlcase,idx_start,idx_end)
    implicit none

!
! person_in_charge: hassan.berro at edf.fr
!
! dtmforc_choc : Calculates the stop/choc forces at the current step (t)
!
!       nl_ind           : nonlinearity index (for sd_nl access)
!       sd_dtm_, buffdtm : dtm data structure and its buffer
!       sd_nl_ , buffnl  : nl  data structure and its buffer
!       time             : current instant t
!       depl, vite       : structural modal displacement and velocity at "t"
!       fext_nl          : projected total non-linear force
!       fext_tgt         : projected tangential component of the fext_nl
!
#include "jeveux.h"
#include "asterc/r8prem.h"
#include "asterc/r8maem.h"
#include "asterfort/assert.h"
#include "asterfort/distno.h"
#include "asterfort/dtmget.h"
#include "asterfort/fnorm.h"
#include "asterfort/fointe.h"
#include "asterfort/ftang.h"
#include "asterfort/dtmforc_choc.h"
#include "asterfort/dtmforc_ants.h"
#include "asterfort/dtmforc_flam.h"
#include "asterfort/dtmforc_decr.h"
#include "asterfort/dtmforc_dvis.h"
#include "asterfort/dtmforc_rede.h"
#include "asterfort/dtmforc_revi.h"
#include "asterfort/dtmforc_rotf.h"
#include "asterfort/dtmforc_yacs.h"
#include "asterfort/dtmforc_lub.h"
#include "asterfort/ftang_rail.h"
#include "asterfort/gloloc.h"
#include "asterfort/jeveuo.h"
#include "asterfort/locglo.h"
#include "asterfort/nlget.h"
#include "asterfort/nlsav.h"
#include "asterfort/tophys.h"
#include "asterfort/tophys_ms.h"
#include "asterfort/togene.h"
#include "asterfort/utmess.h"
#include "asterfort/vecini.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"

!
!   -0.1- Input/output arguments
    integer               , intent(in)  :: nbmode,nlacc,nlcase,idx_start,idx_end
    character(len=*)      , intent(in)  :: sd_dtm_
    character(len=*)      , intent(in)  :: sd_nl_
    integer     , pointer , intent(in)  :: buffdtm  (:)
    integer     , pointer , intent(in)  :: buffnl   (:)
    real(kind=8)          , intent(in)  :: time
    real(kind=8), pointer , intent(in)  :: depl     (:)
    real(kind=8), pointer , intent(in)  :: vite     (:)
    real(kind=8), pointer , intent(out) :: fext  (:)
    real(kind=8)          , intent(in)  :: dt
!
!   -0.2- Local variables
    integer           :: i,   par_coorno(2)
    integer           ::  nl_ind,nl_type
    real(kind=8)      ::  eps
    character(len=8)  :: sd_dtm, sd_nl
!
    real(kind=8)    , pointer :: fext_nl(:) => null()
    real(kind=8)    , pointer :: fext_tgt(:)=> null()
!
    data par_coorno  /_COOR_NO1, _COOR_NO2/
!
!   0 - Initializations
    sd_dtm = sd_dtm_
    sd_nl  = sd_nl_
    eps = r8prem()

        call nlget (sd_nl,  _F_TOT_WK , vr=fext_nl , buffer=buffnl)
        call nlget (sd_nl,  _F_TAN_WK , vr=fext_tgt, buffer=buffnl)


do nl_ind  = idx_start, idx_end
   call nlget(sd_nl, _NL_TYPE, iocc=nl_ind, iscal=nl_type, buffer=buffnl)
   select case (nl_type)
!
!
        case(NL_CHOC)
        
            call dtmforc_choc(nl_ind, sd_dtm, sd_nl, buffdtm, buffnl,&
                                              time, depl, vite, fext_nl, fext_tgt)

!                   --- Special case of choc nonlinearities that can be
!                       implicitely treated
            if ((nlcase.eq.0).or.(nlacc.eq.1)) then
                do i=1, nbmode
                    fext(i) = fext(i) + fext_nl(i)
                end do
            else
                do i=1, nbmode
                    fext(i) = fext(i) + fext_tgt(i)
                end do
            end if
    case(NL_BUCKLING)
        call dtmforc_flam(nl_ind, sd_dtm, sd_nl, buffdtm, buffnl,&
                          time, depl, vite, fext)

    case(NL_ANTI_SISMIC)
        call dtmforc_ants(nl_ind, sd_dtm, sd_nl, buffdtm, buffnl,&
                          time, depl, vite, fext)

    case(NL_DIS_VISC)
        call dtmforc_dvis(nl_ind, sd_dtm, sd_nl, buffdtm, buffnl,&
                          time, dt, depl, vite, fext)

    case(NL_DIS_ECRO_TRAC)
        call dtmforc_decr(nl_ind, sd_dtm, sd_nl, buffdtm, buffnl,&
                          time, dt, depl, vite, fext)

    case(NL_CRACKED_ROTOR)
        call dtmforc_rotf(nl_ind,sd_dtm, sd_nl, buffdtm, buffnl,&
                          time, depl, fext)
! !
    ! TODO: change the name to NL_YACS
    case(NL_LUBRICATION)
         ! we will deal with it later
         continue
!
    case(NL_YACS)
        ! we will deal with it later
        continue
! 
    case(NL_FX_RELATIONSHIP)
        call dtmforc_rede(nl_ind, sd_dtm, sd_nl, buffdtm, buffnl,&
                          depl, fext)
! ! 
    case(NL_FV_RELATIONSHIP)
        call dtmforc_revi(nl_ind, sd_dtm, sd_nl, buffdtm, buffnl,&
                          vite, fext)
    
    !
    case default
        ASSERT(.false.)
        
    end select
end do


end subroutine
