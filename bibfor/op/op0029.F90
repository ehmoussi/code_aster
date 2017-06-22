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

subroutine op0029()
    implicit none
#include "asterfort/comdtm.h"
#include "asterfort/comdlt.h"
#include "asterfort/comdlh.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/utmess.h"
!   Local variables
    character(len=4) :: typcal, bascal
!
!   0 - Initializations
    call jemarq()

!   --------------------------------------------------------------------------------------
!   1 - Calculation type (transient or harmonic) and basis (physical or reducted)
!   --------------------------------------------------------------------------------------

    call getvtx(' ', 'TYPE_CALCUL', iocc=1, scal=typcal)
    call getvtx(' ', 'BASE_CALCUL', iocc=1, scal=bascal)

    if (typcal.eq.'HARM') then
        call comdlh()
    else
        if (bascal.eq.'PHYS') then
            call comdlt()
        else
            call comdtm()
        end if
    end if
    call utmess('I','DYNAMIQUE_97')
    call jedema()
end subroutine
