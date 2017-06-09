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

subroutine permr8(tab, shift, nbr)
! aslint: disable=W1306
    implicit none
#include "asterfort/assert.h"
    integer :: shift, nbr
    real(kind=8) :: tab(nbr)
!
!-----------------------------------------------------------------------
! PERMUTATION CIRCULAIRE DES ELEMENTS D'UN TABLEAU DE REAL*8
!
! IN : TAB   = TABLEAU A PERMUTER
!      SHIFT = INDICE DU TABLEAU PAR LEQUEL ON SOUHAITE DEBUTER
!      NBR   = NOMBRE D'ELEMENTS DU TABLEAU
!
! OUT : TAB = TABLEAU AVEC PERMUTATION
!
!-----------------------------------------------------------------------
!
    integer :: i
    real(kind=8) :: tampon(nbr)
!
    ASSERT((shift.ge.1).and.(shift.le.nbr))
!
    do 10 i = 1, nbr
        tampon(i) = tab( mod(i+shift-2,nbr) + 1 )
10  end do
!
    do 20 i = 1, nbr
        tab(i) = tampon(i)
20  end do
!
end subroutine
