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

subroutine op0185()
    implicit none
!     OPERATEUR COPIER
!======================================================================
!----------------------------------------------------------------------
!     VARIABLES LOCALES
!----------------------------------------------------------------------
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/assert.h"
#include "asterfort/copisd.h"
#include "asterfort/cotsti.h"
#include "asterfort/getvid.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
!
    character(len=8) :: sd1, sd2
    character(len=16) :: typsup, typinf, oper
    integer :: iret
!----------------------------------------------------------------------
    call jemarq()
    call getres(sd2, typsup, oper)
    call getvid(' ', 'CONCEPT', scal=sd1, nbret=iret)
!
    typinf=cotsti(typsup)
    ASSERT(typinf.ne.'INCONNU')
    call copisd(typinf, 'G', sd1, sd2)
!
    call jedema()
end subroutine
