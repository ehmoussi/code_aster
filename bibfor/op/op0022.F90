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

subroutine op0022()
    implicit none
!
!     COMMANDE : DEFI_LIST_ENTI
!
!
!     ------------------------------------------------------------------
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/assert.h"
#include "asterfort/dlidef.h"
#include "asterfort/dliext.h"
#include "asterfort/getvtx.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
#include "asterfort/liimpr.h"
#include "asterfort/titre.h"
    integer :: nv, niv, ifm
    character(len=8) :: resu
    character(len=16) :: concep, nomcmd, opera
!     ------------------------------------------------------------------
!
    call infmaj()
    call infniv(ifm, niv)
!
    call getvtx(' ', 'OPERATION', scal=opera, nbret=nv)
    call getres(resu, concep, nomcmd)
!
    if (opera .eq. 'DEFI') then
        call dlidef()
!
    else if (opera.eq.'NUME_ORDRE') then
        call dliext()
!
    else
        ASSERT(.false.)
    endif
!
!
!     --- TITRE ---
    call titre()
!
!     --- IMPRESSION ---
    if (niv .gt. 1) call liimpr(resu, niv, 'MESSAGE')
!
end subroutine
