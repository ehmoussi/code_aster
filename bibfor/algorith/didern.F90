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

function didern(sddisc, numins)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
    aster_logical :: didern
    integer :: numins
    character(len=19) :: sddisc
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (UTILITAIRE - DISCRETISATION)
!
! RETOURNE VRAI SI ON SORT DE LA LISTE
!
! ----------------------------------------------------------------------
!
!
! IN  SDDISC : SD DISCRETISATION
! IN  NUMINS : NUMERO DE L'INSTANT
! OUT DIINST : VRAI SI ON SORT DE LA LISTE D'INSTANT
!
! SI LE CALCUL N'EST PAS UN TRANSITOIRE -> TPSDIT N'EXISTE PAS ET ON
! SORT DE LA LISTE TOUT DE SUITE (LE CALCUL EST TERMINE)
!
!
!
!
    integer :: nbtemp, iret
    character(len=24) :: tpsdit
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- ACCES SD LISTE D'INSTANTS
!
    tpsdit = sddisc(1:19)//'.DITR'
    call jeexin(tpsdit, iret)
    if (iret .eq. 0) then
        didern = .true.
    else
        call jelira(tpsdit, 'LONMAX', nbtemp)
        nbtemp = nbtemp - 1
        didern = numins .eq. nbtemp
    endif
!
    call jedema()
end function
