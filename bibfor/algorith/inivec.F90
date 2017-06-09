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

subroutine inivec(vec, neq, id, nbcp)
!    P. RICHARD     DATE 27/11/90
!-----------------------------------------------------------------------
!  BUT:  INITIALISER TOUTES LES COMPOSANTES D'UN VECTEUR A ZERO SAUF
!   CELLES D'UNE LISTE EGALES A UN
    implicit none
#include "asterfort/utmess.h"
!
!-----------------------------------------------------------------------
!
! VEC      /M/: VECTEUR A INITIALISER
! NEQ      /I/: DIMENSION DU VECTEUR
! ID       /I/: LISTE DES RANGS DES COMPOSANTES NON NULLES
! NBCP     /I/: NOMBRE DE COMPOSANTES A INITIALISER A UN
!
!-----------------------------------------------------------------------
!
    integer :: i, j, nbcp, id(nbcp), neq
    real(kind=8) :: vec(neq)
!
!-----------------------------------------------------------------------
!
    do 10 i = 1, neq
        vec(i)=0.d0
10  end do
!
    do 20 j = 1, nbcp
        if (id(j) .gt. neq) then
            call utmess('A', 'ALGORITH4_35')
        else
            vec(id(j))=1.d0
        endif
20  end do
!
end subroutine
