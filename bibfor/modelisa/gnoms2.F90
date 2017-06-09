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

subroutine gnoms2(noojb, k1, k2)
    implicit none
! person_in_charge: jacques.pellet at edf.fr
! BUT :
!  TROUVER UN NOM POSSIBLE POUR UN OBJET JEVEUX QUI RESPECTE :
!     - CE NOM VAUT NOOJB (DONNE EN ENTREE) SAUF POUR LA SOUS-CHAINE
!           NOOJB(K1:K2)
!     - LE NOM DE L'OBJET N'EXISTE PAS ENCORE DANS LES BASES OUVERTES
!     - LE NOM (K1:K2) EST UN NUMERO ('0001','0002', ...)
!
! VAR : NOOJB : NOM D'UN OBJET JEVEUX  (K24)
! IN  : K1,K2 : INDICES DANS NOOJB DE LA SOUS-CHAINE "NUMERO"
!     -----------------------------------------------------------------
!
#include "asterfort/assert.h"
#include "asterfort/codent.h"
#include "asterfort/jeexin.h"
#include "asterfort/utmess.h"
    integer :: inum, iret, k1, k2, nessai, ndigit, iessai
    character(len=24) :: noojb, noojb1
!     -----------------------------------------------------------------
    ASSERT(k2.gt.k1)
    ASSERT(k1.gt.8)
    ASSERT(k2.le.24)
!
    ndigit=min(k2-k1+1,4)
    nessai=int(10**ndigit)
!
    noojb1 = noojb
    inum = -1
    do 10, iessai=1,nessai
    inum = inum + 1
!        ASSERT(INUM.LE.9998)
    call codent(inum, 'D0', noojb1(k1:k2))
    call jeexin(noojb1, iret)
    if (iret .eq. 0) goto 20
    10 end do
    call utmess('F', 'MODELISA4_69')
!
20  continue
    noojb=noojb1
!
!
end subroutine
