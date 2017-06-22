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

subroutine nmecev(sderro, acces, nomevd, action)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit     none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=24) :: sderro
    character(len=1) :: acces
    character(len=16) :: action, nomevd
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! ECHEC DU TRAITEMENT D'UNE ACTION - SAUVEGARDE/LECTURE POUR INFO
!
! ----------------------------------------------------------------------
!
!
! IN  SDERRO : SD ERREUR
! IN  ACCES  : TYPE ACCES 'E' OU 'L'
! I/O NOMEVD : NOM DE L'EVENEMENT
! I/O ACTION : NOM DE L'ACTION
!
!
!
!
    character(len=24) :: errevt
    integer :: jeeevt
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- ACCES SD
!
    errevt = sderro(1:19)//'.EEVT'
    call jeveuo(errevt, 'E', jeeevt)
!
    if (acces .eq. 'E') then
        zk16(jeeevt-1+1) = nomevd
        zk16(jeeevt-1+2) = action
    else if (acces.eq.'L') then
        nomevd = zk16(jeeevt-1+1)
        action = zk16(jeeevt-1+2)
    else
        ASSERT(.false.)
    endif
!
    call jedema()
end subroutine
