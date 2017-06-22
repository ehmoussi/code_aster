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

subroutine op0058()
    implicit none
!     OPERATEUR POST_GENE_PHYS
! ----------------------------------------------------------------------
! person_in_charge: hassan.berro at edf.fr
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/infmaj.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/pgpcal.h"
#include "asterfort/pgpcrt.h"
#include "asterfort/pgpext.h"
#include "asterfort/pgppre.h"
#include "asterfort/utimsd.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
!     ------------------------------------------------------------------
    character(len=8) :: sd_pgp
!     ------------------------------------------------------------------
    call jemarq()
    call infmaj()

    sd_pgp = '&&OP0058'

!   Verifies all input data, searches for node or elements number and field components
!   Extracts a reduced modal basis corresponding to the user's request 
    call pgppre(sd_pgp)
!   call utimsd(6, 2, .false._1, .true._1, sd_pgp, 1, 'V')


!   Creates a table (observation) which is given as the ouptut of the command
    call pgpcrt(sd_pgp)


!   Calculates the physical fields of interest according to the user's input, saves
!   the results in a sd_pgp data structure
    call pgpcal(sd_pgp)


!   Adds extra contributions to the results : static correction, multiply pinned systems
!   and entraining acceleration.
    call pgpext(sd_pgp)


    call jedema()
end subroutine
