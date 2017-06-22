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

subroutine lisnch(lischa, nchar)
!
!
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
    character(len=19) :: lischa
    integer :: nchar
!
! ----------------------------------------------------------------------
!
! ROUTINE UTILITAIRE (LISTE_CHARGES)
!
! NOMBRE DE CHARGES DE LA SD LISTE_CHARGES
!
! ----------------------------------------------------------------------
!
!
! IN  LISCHA : NOM DE LA SD LISTE_CHARGES
! OUT NCHAR  : NOMBRE DE CHARGES DE LA SD LISTE_CHARGES
!
!
!
!
    character(len=24) :: charge
    integer :: iret
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- ACCES SD
!
    charge = lischa(1:19)//'.LCHA'
    nchar = 0
!
    call jeexin(charge, iret)
    if (iret .eq. 0) then
        goto 999
    else
        call jelira(charge, 'LONMAX', nchar)
    endif
!
999  continue
!
    call jedema()
end subroutine
