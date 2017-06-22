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

subroutine dgmode(mode, imodel, ilong, nec, dg)
    implicit none
!          TROUVER LE DESCRIPTEUR-GRANDEUR ASSOCIE A UN MODE LOCAL
!          DE CARTE, CHAM_NO, OU CHAMELEM, SOUS FORME "IDEN"
!      ENTREE:
!          MODE  : NUMERO DE MODE LOCAL
!      SORTIE:
!          NEC   : NOMBRE D'ENTIERS-CODES
!          DG    : DESCRIPTEUR GRANDEUR DIMENSIONNE A NEC
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/nbec.h"
    integer :: dg(*), nec, mode, ilong, imodel
!
!-----------------------------------------------------------------------
    integer :: i, jmod, nbpt
!-----------------------------------------------------------------------
    call jemarq()
    nec = 0
    dg(1) = 0
!
    jmod = imodel+zi(ilong-1+mode)-1
    nec = nbec(zi(jmod-1+2))
    if (zi(jmod) .le. 3) then
        nbpt = zi(jmod-1+4)
        if (abs(nbpt) .lt. 10000) then
            do 1 i = 1, nec
                dg(i) = zi(jmod-1+4+i)
 1          continue
        endif
    endif
    call jedema()
end subroutine
