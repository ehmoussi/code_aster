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

function iorim2(num1, n1, num2, n2, reorie)
    implicit none
#include "asterf_types.h"
    integer :: iorim2, n1, n2, num1(n1), num2(n2)
    aster_logical :: reorie
!     IORIM2  --  ORIENTATION D'UNE MAILLE PAR RAPPORT A UNE VOISINE
!
!   ARGUMENT        E/S  TYPE         ROLE
!    NUM1            IN    K*     NUMEROTATION DE LA MAILLE 1
!    NUM2          IN/OUT  K*     NUMEROTATION DE LA MAILLE 2
!    N1              IN    K*     NOMBRE DE NOEUDS DE LA MAILLE 1
!    N2              IN    K*     NOMBRE DE NOEUDS DE LA MAILLE 2
!
!   CODE RETOUR IORIM2 : 0 SI LES MAILLES NE SONT PAS CONTIGUES
!                       -1 OU 1 SINON (SELON QU'IL AIT OU NON
!                                      FALLU REORIENTER)
!
!     DONNEES POUR TRIA3,TRIA6,TRIA7,QUAD4,QUAD8,QUAD9
!     NOMBRE DE SOMMETS EN FONCTION DU NOMBRE DE NOEUDS DE L'ELEMENT
    integer :: nso(9), nso1, nso2, i1, j1, i2, j2, i, k, l
    data nso /0,0,3,4,0,3,3,4,4/
!
#define egal(i1,j1,i2,j2) (num1(i1).eq.num2(i2)).and. \
    (num1(j1).eq.num2(j2))
!
!.========================= DEBUT DU CODE EXECUTABLE ==================
!
    nso1 = nso(n1)
    nso2 = nso(n2)
!     BOUCLES SUR LES ARETES
    do 10 i1 = 1, nso1
        j1 = i1 + 1
        if (j1 .gt. nso1) j1 = 1
        do 10 i2 = 1, nso2
            j2 = i2 + 1
            if (j2 .gt. nso2) j2 = 1
            if (egal(i1,j1,i2,j2)) then
                iorim2 = -1
                goto 100
            endif
            if (egal(i1,j1,j2,i2)) then
                iorim2 = 1
                goto 100
            endif
 10     continue
    iorim2 = 0
100 continue
!
! --- ON PERMUTE LES SOMMETS
    if (reorie .and. iorim2 .lt. 0) then
        k = num2(2)
        l = num2(nso2)
        num2(2) = l
        num2(nso2) = k
!        ON PERMUTE LES NOEUDS INTERMEDIAIRES
        if (n2 .ne. nso2) then
            do 200 i = 1, nso2/2
                k = num2(nso2+i)
                l = num2(2*nso2+1-i)
                num2(nso2+i) = l
                num2(2*nso2+1-i) = k
200         continue
        endif
    endif
!
end function
