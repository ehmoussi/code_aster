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

subroutine expass(jxvrf)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/execop.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jxveri.h"
    integer :: jxvrf
!
!     Execution d'une passe specifique d'operateurs
!
! IN  jxvrf  : 1 = On doit faire jxveri (info depuis mcsimp jxveri
!                  sous debut, transmis par le jdc).
!
!     --- VARIABLES LOCALES --------------------------------------------
    character(len=8) :: nomres
    character(len=16) :: concep, nomcmd
!
    call jemarq()
!
    call execop()
    if (jxvrf .eq. 1) then
        call getres(nomres, concep, nomcmd)
        call jxveri()
    endif
!
    call jedema()
end subroutine
