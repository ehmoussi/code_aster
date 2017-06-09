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

function iorim1(num1, num2, reorie)
    implicit none
#include "asterf_types.h"
    integer :: iorim1, num1(2), num2(2)
    aster_logical :: reorie
!     IORIM1  --  ORIENTATION D'UNE MAILLE PAR RAPPORT A UNE VOISINE
!
!   ARGUMENT        E/S  TYPE         ROLE
!    NUM1            IN    K*     NUMEROTATION DE LA MAILLE 1
!    NUM2          IN/OUT  K*     NUMEROTATION DE LA MAILLE 2
!
!   CODE RETOUR IORIM1 : 0 SI LES MAILLES NE SONT PAS CONTIGUES
!                       -1 OU 1 SINON (SELON QU'IL AIT OU NON
!                                      FALLU REORIENTER)
!
    integer :: i1, j1, k, l
#define egal(i1,j1) num1(i1).eq.num2(j1)
!
!.========================= DEBUT DU CODE EXECUTABLE ==================
!
! --- BOUCLES SUR LES SOMMETS
    do 10 i1 = 1, 2
        j1 = 3-i1
        if (egal(i1,i1)) then
            iorim1 = -1
            goto 100
        endif
        if (egal(i1,j1)) then
            iorim1 = 1
            goto 100
        endif
 10 end do
    iorim1 = 0
100 continue
!
! --- ON PERMUTE LES SOMMETS
    if (reorie .and. iorim1 .lt. 0) then
        k = num2(1)
        l = num2(2)
        num2(1) = l
        num2(2) = k
    endif
!
end function
