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

subroutine intet0(angle, tet0, iax)
!    P. RICHARD     DATE 11/03/91
!-----------------------------------------------------------------------
!  BUT:  CALCULER LA MATRICE 6X6 DE CHANGEMENT DE REPERE PERMETTANT
!    D'EFFECTUER UNE ROTATION D'AXE OZ SUR LES DDL SUIVANTS:
    implicit none
#include "asterfort/utmess.h"
!
!                 DX  DY  DZ  DRX  DRY  DRZ  ? ? PRES PHI
!
!-----------------------------------------------------------------------
!
! ANGLE    /I/: NOMBRE DE SECTEURS
! TET0     /O/: MATRICE DE CHANGEMENT DE REPERE
! IAX      /O/: NUMERO AXE ROTATION (1-X,2-Y,3-Z)
!
!-----------------------------------------------------------------------
!
    real(kind=8) :: tet0(10, 10)
    integer :: i, iax, j, jj
    real(kind=8) :: a, angle, b
!-----------------------------------------------------------------------
!
    do 10 i = 1, 10
        do 20 j = 1, 10
            tet0(i,j)=0.d0
20      continue
10  end do
!
    a=cos(angle)
    b=sin(angle)
!
    if (iax .eq. 3) then
        do 30 i = 1, 2
            jj=3*(i-1)
            tet0(jj+1,jj+1)=a
            tet0(jj+2,jj+2)=a
            tet0(jj+1,jj+2)=-b
            tet0(jj+2,jj+1)=b
            tet0(jj+3,jj+3)=1.d0
30      continue
        tet0(7,7)=1.d0
        tet0(8,8)=1.d0
        tet0(9,9)=1.d0
        tet0(10,10)=1.d0
    else if (iax.eq.2) then
        do 40 i = 1, 2
            jj=3*(i-1)
            tet0(jj+1,jj+1)=a
            tet0(jj+3,jj+3)=a
            tet0(jj+1,jj+3)=b
            tet0(jj+3,jj+1)=-b
            tet0(jj+2,jj+2)=1.d0
40      continue
        tet0(7,7)=1.d0
        tet0(8,8)=1.d0
        tet0(9,9)=1.d0
        tet0(10,10)=1.d0
    else if (iax.eq.1) then
        do 50 i = 1, 2
            jj=3*(i-1)
            tet0(jj+2,jj+2)=a
            tet0(jj+3,jj+3)=a
            tet0(jj+2,jj+3)=-b
            tet0(jj+3,jj+2)=b
            tet0(jj+1,jj+1)=1.d0
50      continue
        tet0(7,7)=1.d0
        tet0(8,8)=1.d0
        tet0(9,9)=1.d0
        tet0(10,10)=1.d0
    else
        call utmess('F', 'ALGORITH13_28')
    endif
!
!
end subroutine
