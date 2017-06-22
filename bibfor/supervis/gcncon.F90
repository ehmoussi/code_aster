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

subroutine gcncon(type, result)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
    character(len=1) :: type
    character(len=*) :: result
!     ------------------------------------------------------------------
!     ATTRIBUTION D'UN NOM DE CONCEPT UNIQUE MEME EN POURSUITE
!     ------------------------------------------------------------------
! IN  TYPE   : K1 : TYPE DE CONCEPT PARMI
!                   '.' : LE CONCEPT EST DETRUIT A LA FIN DE L'EXECUTION
!                   '_' : LE CONCEPT EST CONSERVE POUR UNE POURSUITE
! OUT RESULT : K8 : NOM UNIQUE = TYPE//NUMERO_UNIQUE
!
!     --- VARIABLES LOCALES --------------------------------------------
    integer :: ipos
    integer :: ier
    character(len=24) :: numuni
    character(len=8) :: nomuni
!     ------------------------------------------------------------------
    call jemarq()
    numuni='&&_NUM_CONCEPT_UNIQUE'
!     ------------------------------------------------------------------
    if ((type.eq.'.') .or. (type.eq.'_') .or. (type.eq.'S')) then
        call jeexin(numuni, ier)
        if (ier .eq. 0) then
!           INITIALISATION D'UN NUM POUR CREER UN NOM DE CONCEPT UNIQUE
            call wkvect(numuni, 'G V I', 1, ipos)
            zi(ipos)=0
        endif
!        RECUPERATION, FORMATTAGE ET INCREMENTATION
        call jeveuo(numuni, 'E', ipos)
        write (nomuni,'(A,I7.7)') type,zi(ipos)
        result=nomuni
        zi(ipos)=zi(ipos)+1
        ASSERT(zi(ipos) .lt. 10000000)
    else
        call utmess('F', 'SUPERVIS_8', sk=type)
    endif
    call jedema()
end subroutine
