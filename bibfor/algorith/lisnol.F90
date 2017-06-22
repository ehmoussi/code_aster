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

subroutine lisnol(lischa, genchz, nomlis, nbch)
!
!
    implicit      none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/lisdef.h"
#include "asterfort/lisnnb.h"
    character(len=19) :: lischa
    character(len=24) :: nomlis
    integer :: nbch, nbtmp(2)
    character(len=*) :: genchz
!
! ----------------------------------------------------------------------
!
! ROUTINE UTILITAIRE (LISTE_CHARGES)
!
! CREATION OBJETS CONTENANT LA LISTE DES INDEX POUR LE GENRE DONNE
!
! ----------------------------------------------------------------------
!
!
! IN  LISCHA : SD LISTE DES CHARGES
! IN  GENCHA : GENRE DE LA CHARGE (VOIR LISDEF)
! OUT NOMLIS : LISTE DES INDEX DES CHARGES
! OUT NBCH   : LONGUEUR DE NOMLIS
!
! ----------------------------------------------------------------------
!
    integer :: nbchar
    integer :: ibid, iposit(2)
    character(len=8) :: k8bid
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    nbch = 0
    call lisnnb(lischa, nbchar)
!
    if (nbchar .ne. 0) then
!
! ----- POSITION DE L'ENTIER CODE POUR CE GENRE DE CHARGE
!
        call lisdef('POSG', genchz, ibid, k8bid, iposit)
!
! ----- LISTE DES INDEX DE CHARGE POUR CE GENRE
!
        call lisdef('IDNS', nomlis, iposit(1), k8bid, nbtmp)
        nbch = nbtmp(1)
    endif
!
    call jedema()
end subroutine
