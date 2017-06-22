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

subroutine kndoub(long, lkn, nbkn, iret)
! person_in_charge: jacques.pellet at edf.fr
! A_UTIL
    implicit none
#include "asterfort/assert.h"
#include "asterfort/knindi.h"
    integer :: long, iret, nbkn
    character(len=*) :: lkn(nbkn)
! ---------------------------------------------------------------------
! BUT: VERIFIER QU'IL N'Y A PAS DE DOUBLONS DANS UNE LISTE DE KN
! ---------------------------------------------------------------------
!     ARGUMENTS:
! LONG   IN   I     : 8/16/24 : LONGUEUR DES CHAINES DE LKN
! LKN    IN   V(K*) : LISTE DES KN A VERIFIER
! NBKN   IN   I     : LONGUEUR DE LA LISTE LKN
! IRET   OUT  I     : CODE RETOUR :
!                     /0 : IL N'Y A PAS DE DOUBLONS
!                     /I1>0 : NUMERO DU 1ER DOUBLON DANS LKN
!----------------------------------------------------------------------
    integer :: k1, k2
! DEB
!
    ASSERT((long.eq.8).or.(long.eq.16).or.(long.eq.24))
!
    iret = 0
!
    do 10,k1 = 1,nbkn - 1
    k2 = knindi(long,lkn(k1),lkn(k1+1),nbkn-k1)
    if (k2 .gt. 0) then
        iret = k1
        goto 20
    endif
    10 end do
!
!
!
20  continue
!
!
end subroutine
