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

function ioriv1(num, noeud, vect, coor)
!.======================================================================
    implicit none
#include "asterfort/utmess.h"
!
!     IORIV1  --  ORIENTATION D'UNE MAILLE PAR RAPPORT A UN VECTEUR
!
!   ARGUMENT        E/S  TYPE         ROLE
!    NUM          IN/OUT  K*     NUMEROTATION DE LA MAILLE
!
!   CODE RETOUR IORIV1 : 0 SI LA MAILLE NE CONTIENT PAS LE NOEUD
!                       -1 OU 1 SINON (SELON QU'IL AIT OU NON
!                                      FALLU REORIENTER)
    integer :: num(2)
    real(kind=8) :: vect(2), coor(3, *)
    integer :: i, ioriv1, k, l, n1, n2, noeud
    real(kind=8) :: scal, x1, x2, xn, y1, y2, yn
#define x(i) coor(1,i)
#define y(i) coor(2,i)
!
!
!.========================= DEBUT DU CODE EXECUTABLE ==================
!
!     BOUCLE SUR LES SOMMETS
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    ioriv1=0
    do 10 i = 1, 2
        if (num(i) .eq. noeud) then
            n1=num(1)
            n2=num(2)
            x1=x(n1)
            y1=y(n1)
            x2=x(n2)
            y2=y(n2)
!     VECTEUR NORMAL AU SEGMENT
            xn=y2-y1
            yn=x1-x2
            scal=xn*vect(1)+yn*vect(2)
            if (scal .gt. 0) then
                ioriv1= 1
            else if (scal.lt.0) then
                ioriv1=-1
            else
                call utmess('F', 'MODELISA4_76')
            endif
        endif
10  end do
    if (ioriv1 .lt. 0) then
!       ON PERMUTE LES SOMMETS
        k=num(1)
        l=num(2)
        num(1)=l
        num(2)=k
    endif
!
end function
