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

subroutine maxblc(nomob, xmax)
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=*) :: nomob
    real(kind=8) :: xmax
!
!  BUT:
!
!   DETERMINER LE MAXIMUM DES TERMES D'UN BLOC D UNE MATRICE COMPLEXE
!
!-----------------------------------------------------------------------
!
! NOM----- / /:
!
! NOMOB    /I/: NOM K32 DE L'OBJET COMPLEXE
! XMAX     /M/: MAXIMUM REEL
!
!
!
!
!
    integer :: i, nbterm, llblo
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!
    call jemarq()
    call jeveuo(nomob(1:32), 'L', llblo)
    call jelira(nomob(1:32), 'LONMAX', nbterm)
!
    do 10 i = 1, nbterm
        xmax=max(xmax,abs(zc(llblo+i-1)))
10  end do
!
!
    call jedema()
end subroutine
