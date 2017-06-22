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

subroutine fonimp(resu)
!
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=8) :: resu
!
!
!     ----------------------------------------------------------------
! FONCTION REALISEE:
!
!     OPERATEUR DEFI_FOND_FISS :
!          ROUTINE D'IMPRESSION EN INFO=2
!
!     ------------------------------------------------------------------
! ENTREE:
!        RESU   : NOM DE LA SD_FOND_FISS
!
!     ------------------------------------------------------------------
!
!
    character(len=24) :: fonoeu, fondfi
    integer :: jnoe, jfon
    integer :: lnoff, i
!
!
    call jemarq()
!
!
    fonoeu = resu//'.FOND.NOEU'
    call jelira(fonoeu, 'LONMAX', lnoff)
    call jeveuo(fonoeu, 'L', jnoe)
!
    fondfi = resu//'.FONDFISS'
    call jeveuo(fondfi, 'L', jfon)
!
!
    do 100 i = 1, lnoff
!        WRITE(6,*)'NOEUD ',ZK8(JNOE),ZR(JFON-1+4*(I-1)+4)
100  end do
!
    call jedema()
end subroutine
