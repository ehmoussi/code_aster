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

subroutine rangen(prgene, isst, inumod, irang)
    implicit none
#include "jeveux.h"
!
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
    character(len=19) :: prgene
    integer :: isst, inumod, irang
!     DONNE LE NUMERO DU NOEUD
!           NUNOE = 0 SI LE NOEUD N'EXISTE PAS
!     DONNE LE NUMERO DU DDL ASSOCIE AU NOEUD ET A SA COMPOSANTE
!           NUDDL = 0 SI LE COUPLE (NOEUD,COMPOSANTE) N'EXISTE PAS
!     ------------------------------------------------------------
! IN  NUMEGE    : K14: NOM D'UN NUME_DDL
! IN  ISST   : I  : NUMERO DE LA SOUS-STRUCTURE
! IN  INUMOD : I  : NUMERO DU MODE DYNAMIQUE OU CONTRAINT ASSOCIEE A
!                   LA SOUS-STRUCTURE
! OUT IRANG  : I  : POSITION DANS LE VECTEUR DES DDLS GENERALISES
!                   DU MODE
!     -------------------------------------------------------------
!     -----------------------------------------------------------------
!     FONCTION EXTERNE
!     ----------------------------------------------------------------
!     ----------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: iaprno, ibid, iddl
!-----------------------------------------------------------------------
    call jemarq()
!
!
!     --- NUMERO DDL DU NOEUD NOEUD ET DE SA COMPOSANTE CMP
!
    call jenonu(jexnom(prgene//'.LILI', '&SOUSSTR'), ibid)
    call jeveuo(jexnum(prgene//'.PRNO', ibid), 'L', iaprno)
    iddl = zi(iaprno+2*isst-2)
    if (iddl .eq. 0) goto 9999
    irang = inumod + iddl - 1
!
9999  continue
    call jedema()
end subroutine
