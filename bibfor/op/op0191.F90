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

subroutine op0191()
!
!
! --------------------------------------------------------------------------------------------------
!
!     COMMANDE : MODI_REPERE
!
! --------------------------------------------------------------------------------------------------
!
    implicit none
!
#include "asterf_types.h"
#include "asterc/getres.h"
#include "asterfort/getvid.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/modirepcham.h"
#include "asterfort/modirepresu.h"
!
! --------------------------------------------------------------------------------------------------
!
    integer :: n0
    character(len=16) :: concep, nomcmd
    character(len=19) :: resuou, resuin
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
!   Récupération du nom de la commande
!       le nom utilisateur du résultat : resuou
!       le nom du concept résultat     : concep (en cas de reuse)
!       le nom de la commande          : nomcmd
    call getres(resuou, concep, nomcmd)
!
    call getvid(' ', 'CHAM_GD',  scal=resuin, nbret=n0)
    if ( n0.ne.0 ) then
        call modirepcham(resuou, resuin )
        goto 999
    endif
    call getvid(' ', 'RESULTAT', scal=resuin, nbret=n0)
    if ( n0.ne.0 ) then
        call modirepresu(resuou, resuin )
        goto 999
    endif
!
999 continue
    call jedema()
end subroutine
