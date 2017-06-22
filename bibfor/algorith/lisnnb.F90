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

subroutine lisnnb(lischa, nbchar)
!
!
    implicit     none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
    character(len=19) :: lischa
    integer :: nbchar
!
! ----------------------------------------------------------------------
!
! ROUTINE UTILITAIRE (LISTE_CHARGES)
!
! RETOURNE LE NOMBRE DE CHARGEMENTS
!
! ----------------------------------------------------------------------
!
!
! IN  LISCHA : SD LISTE DES CHARGES
! OUT NBCHAR : NOMBRE DE CHARGES
!
!
!
!
    character(len=24) :: nomcha
    integer :: iret
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    nomcha = lischa(1:19)//'.NCHA'
    call jeexin(nomcha, iret)
    if (iret .eq. 0) then
        nbchar = 0
    else
        call jelira(nomcha, 'LONMAX', nbchar)
    endif
!
    call jedema()
end subroutine
