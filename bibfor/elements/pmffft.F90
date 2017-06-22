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

subroutine pmffft(fv, sv)
    implicit none
!    -------------------------------------------------------------------
!     CALCUL DE : FV FOIS FV TRANSPOSE
!      FV VECTEUR (12)
!
!    * REMARQUE :
!      LA MATRICE EST STOCKEE TRIANGULAIRE INFERIEURE DANS UN TABLEAU
!      UNICOLONNE
!    -------------------------------------------------------------------
!  DONNEES NON MODIFIEES
!
! IN TYPE ! NOM    ! TABLEAU !             SIGNIFICATION
! IN -------------------------------------------------------------------
! IN R*8  ! FV   !     12   ! VECTEUR INT(BT KS G)
!
! OUT TYPE ! NOM   ! TABLEAU !             SIGNIFICATION
! OUT ------------------------------------------------------------------
! OUT R*8 !  SF   ! (12)    ! MATRICE ELEMENTAIRE UNICOLONNE
!
!
! LOC TYPE !  NOM  ! TABLEAU !              SIGNIFICATION
! LOC ------------------------------------------------------------------
! LOC I   ! IP     !   12    ! POINTEUR SUR L'ELEMENT DIAGONAL PRECEDENT
!
    integer :: ip(12), i, j
    real(kind=8) :: fv(12), sv(78)
    data ip/0,1,3,6,10,15,21,28,36,45,55,66/
!
!
    do 10 i = 1, 12
        do 20 j = 1, i
            sv(ip(i)+j)=fv(i)*fv(j)
20      continue
10  end do
!
end subroutine
