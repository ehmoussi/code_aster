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

subroutine nmarex(motfac, sdarch)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/wkvect.h"
    character(len=19) :: sdarch
    character(len=16) :: motfac
!
! ----------------------------------------------------------------------
!
! ROUTINE *_NON_LINE (ARCHIVAGE)
!
! CONSTRUCTION CHAMPS EXCLUS DE L'ARCHIVAGE
!
! ----------------------------------------------------------------------
!
!
! IN  MOTFAC : MOT-FACTEUR POUR LIRE <CHAM_EXCL>
! IN  SDARCH : NOM DE LA SD ARCHIVAGE
!
!
!
!
    integer :: ibid
    integer :: nb
    character(len=24) :: arcexc
    integer :: jarexc
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- NOM DE LA SD
!
    arcexc = sdarch(1:19)//'.AEXC'
!
! --- CONSTRUCTION CHAMPS EXCLUS DE L'ARCHIVAGE
!
    call getvtx(motfac, 'CHAM_EXCLU', iocc=1, nbval=0, nbret=nb)
    nb = -nb
    if (nb .ne. 0) then
        call wkvect(arcexc, 'V V K16', nb, jarexc)
        call getvtx(motfac, 'CHAM_EXCLU', iocc=1, nbval=nb, vect=zk16(jarexc),&
                    nbret=ibid)
    endif
!
    call jedema()
!
end subroutine
