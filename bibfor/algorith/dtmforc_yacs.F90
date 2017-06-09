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

subroutine dtmforc_yacs(sd_dtm_, sd_nl_, itime, time, dt, depl, vite, fext)
    use yacsnl_module, only : first_trandata, trandata, send_values, &
            retrieve_values, set_params ,CHAM_DEPL, CHAM_VITE, CHAM_FORCE

    implicit none
!
!
! dtmforc_yacs : send or receive force using yacs at the current step (t)
!
!       nl_ind           : nonlinearity index (for sd_nl access)
!       sd_dtm_, buffdtm : dtm data structure and its buffer
!       sd_nl_ , buffnl  : nl  data structure and its buffer
!       time             : current instant t
!       itime            : current time step iteration
!       depl             : structural modal displacement and velocity at "t"
!       fext             : projected total non-linear force
!
!person_in_charge: mohamed-amine.hassini at edf.fr
!========================================================================

#include "asterfort/utmess.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/dtmget.h"


!     1. Input / output arguments
      character(len=*) , intent(in) :: sd_dtm_
      character(len=*) , intent(in) :: sd_nl_
      real(kind=8), pointer , intent(in)  :: depl     (:)
      real(kind=8), pointer , intent(in)  :: vite     (:)
      real(kind=8), pointer , intent(out) :: fext     (:)
      real(kind=8),           intent(in)  :: time
      real(kind=8),           intent(in)  :: dt
      integer               , intent(in)  :: itime

!     2. local variables
      type(trandata), pointer             :: current => null()
      character(len=8)                    :: sd_dtm, sd_nl
      real(kind=8)                        :: tinit, tfin, dtmin, dtmax
      logical , save                      :: premier_passage = .true.

      


      ! thanks for visiting but there is nothing to do
      if( .not. associated( first_trandata ) ) return

      call jemarq()

      sd_dtm = sd_dtm_
      sd_nl  = sd_nl_

      ! this call should be performed from dtmprep_noli_lub not from here !
      ! but i can't do it since time step is not set when dtmprep_noli_xxx 
      ! are called
      !
      if (premier_passage) then
            premier_passage = .false.            
            call dtmget(sd_dtm, _INST_FIN, rscal = tfin)
            call dtmget(sd_dtm, _DT_MIN, rscal = dtmin)
            call dtmget(sd_dtm, _DT_MAX, rscal = dtmax)
            call dtmget(sd_dtm, _INST_INI, rscal = tinit)
            call set_params(itime, time, tinit, tfin, dt, dtmin, dtmax)
      endif

      
      ! in order to have parallel computing it is better 
      ! to send all informations first and then read on all inlet ports

      current => first_trandata
      do while( associated (current) )

           select case (current%type_cham)
                case (CHAM_DEPL)
                     call send_values(current, depl, itime, time)

                case (CHAM_VITE)
                     call send_values(current, vite, itime, time)

                case (CHAM_FORCE)
                    ! inlets port are handled after outlets ports to 
                    ! take advantage of yacs parallel computing
                    continue

                case default
                    ASSERT(.false.)
           end select
           current => current %next

      end do

      ! now you retrieve forces
      current => first_trandata
      do while( associated (current) )

           if( current%type_cham.eq.CHAM_FORCE) then
                call retrieve_values(current, fext, itime, time)
           endif
           current => current%next

      end do

      
      call jedema()

end subroutine
