! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine ops005()
    implicit none
!
!
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/wkvect.h"
    character(len=1) :: kbid
    character(len=16) :: typres, nomcmd
    character(len=19) :: nomfon
    character(len=24) :: nomres, nompar
    integer :: lprol, lnova, nk, ir
!     ------------------------------------------------------------------
    call jemarq()
!
    call getres(nomfon, typres, nomcmd)
!
    nompar = ' '
    nomres = 'TOUTRESU'
    call wkvect(nomfon//'.PROL', 'G V K24', 6, lprol)
    zk24(lprol) = 'INTERPRE'
    zk24(lprol+1) = 'INTERPRE'
    zk24(lprol+2) = nompar
    zk24(lprol+3) = nomres
    zk24(lprol+4) = 'II      '
    zk24(lprol+5) = nomfon
    call getvtx(' ', 'NOM_PARA', scal=kbid, nbret=nk)
    if (nk .ne. 1) nk=-nk
    call wkvect(nomfon//'.NOVA', 'G V K24', nk, lnova)
    call getvtx(' ', 'NOM_PARA', nbval=nk, vect=zk24(lnova), nbret=ir)
!
    call jedema()
end subroutine
