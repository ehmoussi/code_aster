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

subroutine ltcrsd(litab, base)
    implicit   none
#include "asterfort/assert.h"
#include "asterfort/jeecra.h"
#include "asterfort/wkvect.h"
    character(len=*) :: litab, base
!      CREER UNE SD L_TABLE DE NOM "LITAB" SUR UNE BASE "BASE"
!      LA STRUCTURE D'UNE L_TABLE :
!       .LTNT : K16 : REPERTOIRE DES NOMS SYMBOLIQUES
!       .LTNS : K24 : NOMS DES TABLE
!
! IN  : LITAB  : NOM DE LA SD L_TABLE A CREER.
! IN  : BASE   : BASE SUR LAQUELLE ON CREE LA SD L_TABLE
!
!     REMARQUE :
!        LA L_TABLE EST ALLOUEE A LA LONGUEUR 7, PUIS ELLE S'AGRANDIT
!        DE 6 EN 6
!     ------------------------------------------------------------------
    character(len=1) :: baselt
    character(len=19) :: listab
    integer :: jbid
! DEB------------------------------------------------------------------
!
    baselt = base(1:1)
    ASSERT(baselt.eq.'V' .or. baselt.eq.'G')
!
    listab = litab
!
!     --- CREATION DU .LTNT ---
!
    call wkvect(listab//'.LTNT', baselt//' V K16', 7, jbid)
    call jeecra(listab//'.LTNT', 'LONUTI', 0)
!
!     --- CREATION DU .LTNS ---
!
    call wkvect(listab//'.LTNS', baselt//' V K24', 7, jbid)
    call jeecra(listab//'.LTNS', 'LONUTI', 0)
!
end subroutine
