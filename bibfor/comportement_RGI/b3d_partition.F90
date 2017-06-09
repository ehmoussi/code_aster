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

subroutine b3d_partition(sige6, sige3, vsige33, vsige33t, siget6,&
                         sigec6, sigec3, siget3)
! person_in_charge: etienne.grimal at edf.fr
!=====================================================================
!=====================================================================
!=====================================================================
    implicit none
#include "asterfort/b3d_valp33.h"
#include "asterfort/x6x33.h"
#include "asterfort/transpos1.h"
#include "asterfort/b3d_chrep.h"
#include "asterfort/x33x6.h"
    real(kind=8) :: sige6(6)
    real(kind=8) :: sige3(3)
    real(kind=8) :: vsige33(3, 3)
    real(kind=8) :: vsige33t(3, 3)
    real(kind=8) :: siget6(6)
    real(kind=8) :: sigec6(6)
    real(kind=8) :: sigec3(3)
    real(kind=8) :: siget3(3)
!     declaration des varibles locales
    real(kind=8) :: sige33(3, 3)
    real(kind=8) :: x33(3, 3), siget33(3, 3), sigec33(3, 3), sige33p(3, 3), sige6p(6)
    integer :: i
!
!     rangement des contraintes effectives en tableau 3*3
    call x6x33(sige6, sige33)
!     diagonalisation contraintes effectives actuelles et valeurs propre
    call b3d_valp33(sige33, sige3, vsige33)
!     creation de la matrice de passage inverse
    call transpos1(vsige33t, vsige33, 3)
!     decomposition des contraintes principales en partie positive et a
!     la base principale (avec prise en compte des erreurs numeriques de
!     on suppose sige33p pas tout a fait diagonale par defaut et on util
!     que les contraintes normales positves pour faire la partition
    call b3d_chrep(sige33p, sige33, vsige33)
    call x33x6(sige33p, sige6p)
    do i = 1, 3
        siget3(i)=0.5d0*(sige33p(i,i)+abs(sige33p(i,i)))
        sigec3(i)=0.5d0*(sige33p(i,i)-abs(sige33p(i,i)))
        siget6(i)=siget3(i)
        sigec6(i)=sigec3(i)
    end do
    do i = 4, 6
        siget6(i)=0.d0
        sigec6(i)=sige6p(i)-siget6(i)
    end do
!     stockage des parties positives et negatives en base fixe
!     cas des contraintes de traction
    call x6x33(siget6, x33)
    call b3d_chrep(siget33, x33, vsige33t)
    call x33x6(siget33, siget6)
!     cas des contraintes de compression
    call x6x33(sigec6, x33)
    call b3d_chrep(sigec33, x33, vsige33t)
    call x33x6(sigec33, sigec6)
end subroutine
