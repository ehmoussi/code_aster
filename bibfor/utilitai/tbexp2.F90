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

subroutine tbexp2(nomta, para)
    implicit none
#include "asterf_types.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/tbexip.h"
#include "asterfort/utmess.h"
    character(len=*) :: nomta, para
!      EXISTENCE D'UN PARAMETRE DANS UNE TABLE.
! ----------------------------------------------------------------------
! IN  : NOMTA  : NOM DE LA STRUCTURE "TABLE".
! IN  : PARA   : PARAMETRE A CHERCHER
! ----------------------------------------------------------------------
    character(len=4) :: typpar
    character(len=24) :: valk(2)
    aster_logical :: exist
! DEB------------------------------------------------------------------
!
    call jemarq()
!
    call tbexip(nomta, para, exist, typpar)
!
    if (.not.exist) then
        valk (1) = para
        valk (2) = nomta
        call utmess('F', 'UTILITAI6_93', nk=2, valk=valk)
    endif
!
    call jedema()
end subroutine
