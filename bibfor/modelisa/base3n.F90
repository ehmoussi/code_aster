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

subroutine base3n(x1, mat33)
    implicit none
#include "asterfort/assert.h"
#include "asterfort/normev.h"
#include "asterfort/provec.h"
    real(kind=8) :: x1(3), mat33(3, 3)
    real(kind=8) :: norme
! person_in_charge: jacques.pellet at edf.fr
! ======================================================================
!     BUT : CALCULE UNE MATRICE ORTHORMEE MAT33 DONT LE 1ER VECTEUR
!           EST COLINEAIRE A X1
!     REMARQUE : IL EXISTE DE NOMBREUSES BASES AYANT CETTE PROPRIETE.
! ======================================================================
    real(kind=8) :: v1(3), v2(3), v3(3)
    integer :: k, k1
!
!
!     -- CALCUL DE V1 :
    do 10,k=1,3
    v1(k)=x1(k)
    10 end do
    call normev(v1, norme)
!
!
!     -- CALCUL DE V2 :
!     -- ON CHERCHE UNE COMPOSANTE (K1) PAS TROP PETITE DANS V1 :
    do 20,k=1,3
    if (abs(v1(k)) .ge. 0.5d0) k1=k
    20 end do
!
    if (k1 .eq. 1) then
        v2(2)=1.d0
        v2(3)=0.d0
        v2(1)=-v1(2)
    else if (k1.eq.2) then
        v2(3)=1.d0
        v2(1)=0.d0
        v2(2)=-v1(3)
    else if (k1.eq.3) then
        v2(1)=1.d0
        v2(2)=0.d0
        v2(3)=-v1(1)
    else
        ASSERT(.false.)
    endif
    call normev(v2, norme)
!
!
!     -- CALCUL DE V3 :
    call provec(v1, v2, v3)
    call normev(v3, norme)
!
!
!     -- RECOPIE DE V1, V2, V3 DANS MAT33 :
    do 30,k=1,3
    mat33(k,1)=v1(k)
    mat33(k,2)=v2(k)
    mat33(k,3)=v3(k)
    30 end do
!
!
end subroutine
