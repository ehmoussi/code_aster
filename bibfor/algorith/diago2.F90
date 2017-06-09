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

subroutine diago2(tens, vecp, valp)
!
    implicit none
#include "asterc/r8miem.h"
#include "asterfort/r8inir.h"
#include "asterfort/zerop2.h"
    real(kind=8) :: tens(3), valp(2), vecp(2, 2)
!
! ----------------------------------------------------------------------
!  DIAGONALISATION MATRICE 3x3 SYMETRIQUE PAR UNE METHODE DIRECTE
!    IN    TENS   : TENSEUR SOUS LA FORME
!                     (XX YY XY)
! ----------------------------------------------------------------------
!
    integer :: i, nrac, ind
!
    real(kind=8) :: trace, y(2), det(2)
    real(kind=8) :: a, dev(3)
!
    call r8inir(4, 0.d0, vecp, 1)
!
! -- PASSAGE AU DEVIATEUR
    trace=(tens(1)+tens(2))/2.d0
!
    dev(1)=tens(1)-trace
    dev(2)=tens(2)-trace
    dev(3)=tens(3)
!
! -- CALCUL DES COEFFICIENTS DU POLYNOME P2
!
    det(1)=dev(1)+dev(2)
    det(2)=dev(1)*dev(2)-dev(3)**2
!
    call zerop2(-det(1), det(2), valp, nrac)
!
! -- VECP DE LA 1ERE VALEUR PROPRE
! -- ON MULTIPLIE LES 2 VECT DE BASE PAR (A-LAMBDA_2.ID)
!      ON PRENDRA CELUI DONT LA NORME EST LA PLUS GRANDE
    do 10 ind = 1, 2
        if (ind .eq. 1) then
            vecp(1,ind)= dev(1)-valp(2)
            vecp(2,ind)= dev(3)
        else if (ind.eq.2) then
            vecp(1,ind)= dev(3)
            vecp(2,ind)= dev(2)-valp(2)
        endif
        y(ind)=vecp(1,ind)**2+vecp(2,ind)**2
10  end do
    ind=1
    if (y(2) .gt. y(1)) then
        ind=2
    endif
    a=sqrt(y(ind))
! -- CAS DE 2 VALEURS PROPRES EGALES
    if (a .lt. r8miem()) then
        call r8inir(4, 0.d0, vecp, 1)
        vecp(1,1)=1.d0
        vecp(2,2)=1.d0
    else
        do 20 i = 1, 2
            vecp(i,1)=vecp(i,ind)/a
20      continue
!
        vecp(1,2)=-vecp(2,1)
        vecp(2,2)=vecp(1,1)
!
    endif
!
    do 30 i = 1, 2
        valp(i)=valp(i)+trace
30  end do
!
end subroutine
