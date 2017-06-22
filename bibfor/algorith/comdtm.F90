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

subroutine comdtm()
    implicit none
!  Transient calculations on a reduced basis : DYNA_VIBRA (//TRAN//GENE)
! ----------------------------------------------------------------------
!
#include "jeveux.h"
#include "asterfort/dtmcalc.h"
#include "asterfort/dtminfo.h"
#include "asterfort/dtminit.h"
#include "asterfort/dtmprep.h"
#include "asterfort/dtmget.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetc.h"
#include "asterfort/jemarq.h"
#include "asterfort/utimsd.h"
#include "asterfort/dtmclean.h"
!
    character(len=8) :: sd_dtm, sd_int
!
    call jemarq()
!
    sd_dtm = '&&DTM&&&'

!   Verifies and reads all input data about the transient calculation in generalized
!   coordinates, with possible punctual nonlinearities. All information is saved in 
!   the temoporary work data structure : sd_dtm
    call dtmprep(sd_dtm)

!   Writes down some user information about the time integration parameters before
!   actually proceding with the calculations
    call dtminfo(sd_dtm)
    ! call utimsd(6, 2, .false._1, .true._1, sd_dtm, 1, 'V')

!   Initializes the calculation, by reading the initial state and calculating 
!   an initial acceleration if needed
    sd_int = '&&INTEGR'
    call dtminit(sd_dtm, sd_int)

!   Allocates memory, and loops over the time steps and integrates the dynamic
!   equations of motions as required. Archiving is accomplished within this routine
    call dtmcalc(sd_dtm, sd_int)
!   call dtmget(sd_dtm,'CALC_SD',kscal=nomres)
!   call utimsd(6, 2, .false._1, .true._1, nomres, 1, 'G')
!

    ! clean
    call dtmclean(sd_dtm)


    call jedema()
end subroutine
