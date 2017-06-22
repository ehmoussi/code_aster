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

subroutine knincl(long, lk1, l1, lk2, l2,&
                  iret)
! person_in_charge: jacques.pellet at edf.fr
! A_UTIL
    implicit none
#include "asterfort/assert.h"
#include "asterfort/knindi.h"
    integer :: l1, l2, iret, long
    character(len=*) :: lk1(l1), lk2(l2)
! ---------------------------------------------------------------------
! BUT: VERIFIER QU'UNE LISTE DE K8 (LK1) EST INCLUSE DANS UNE AUTRE
!      (LK2)
! ---------------------------------------------------------------------
!     ARGUMENTS:
! LONG   IN   I     : 8,16 OU 24 : LONGUEUR DES CHAINES DE LK1 ET LK2
! LK1    IN   V(K*) : LISTE DE K* QUI DOIT ETRE INCLUSE DANS LK2
! L1     IN   I     : LONGUEUR DE LA LISTE LK1
! LK2    IN   V(K*) : LISTE DES K* QUI DOIT CONTENIR LK1
! L2     IN   I     : LONGUEUR DE LA LISTE LK2
! IRET   OUT  I     : CODE RETOUR :
!                     /0 : OK : TOUS LES ELEMENTS DE LK1 SONT DANS LK2
!                     /I1>0 : NUMERO DU 1ER ELEMENT DE LK1 NON PRESENT
!                             DANS LK2
!----------------------------------------------------------------------
    integer :: k1, k2
! DEB
!
    ASSERT((long.eq.8).or.(long.eq.16).or.(long.eq.24))
!
    iret = 0
    do 10,k1 = 1,l1
!          -- ON VERIFIE QUE LK1(K1) SE TROUVE DANS LK2 :
    k2 = knindi(long,lk1(k1),lk2,l2)
!
    if (k2 .eq. 0) then
        iret = k1
        goto 20
    endif
!
    10 end do
!
20  continue
!
!
end subroutine
