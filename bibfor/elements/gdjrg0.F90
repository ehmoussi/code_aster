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

subroutine gdjrg0(kp, nno, enprim, x00, y0,&
                  ajacob, rot0)
!
! FONCTION: POUR UN ELEMENT DE POUTRE EN GRAND DEPLACEMENT, CALCULE, AUX
!           POINTS DE GAUSS, LE JACOBIEN ET LA MATRICE DE ROTATION DES
!           AXES PRINCIPAUX D'INERTIE EN POSITION DE REFERENCE, PAR RAP-
!           PORT AUX AXES DE COORDONNEES GENERAUX.
!
!     IN  : KP        : NUMERO DU POINT DE GAUSS
!           NNO       : NOMBRE DE NOEUDS
!           ENPRIM    : DERIVEES DES FONCTIONS DE FORME
!           X00       : COORDONNEES DES NOEUDS EN POSITION DE REFERENCE
!           Y0        : VECTEUR DE COMPOSANTES ALPHA, BETA ET GAMMA:
!                       ANGLES NAUTIQUES DES AXES PRINCIPAUX PAR RAPPORT
!                       AUX AXES GENERAUX.
!
!     OUT : AJACOB : JACOBIEN
!           ROT0   : MATRICE DE ROTATION
! ------------------------------------------------------------------
    implicit none
#include "asterfort/matrot.h"
#include "asterfort/transp.h"
#include "blas/ddot.h"
    real(kind=8) :: enprim(3, 2), x00(3, 3), y0(3), rot(3, 3), rot0(3, 3), e1(3)
!
!-----------------------------------------------------------------------
    integer :: ic, kp, ne, nno
    real(kind=8) :: ajacob, zero
!-----------------------------------------------------------------------
    zero = 0.d0
    do 2 ic = 1, 3
        e1(ic) = zero
        do 1 ne = 1, nno
            e1(ic) = e1(ic) + enprim(ne,kp)*x00(ic,ne)
 1      end do
 2  end do
!
    ajacob=ddot(3,e1,1,e1,1)
    ajacob = sqrt(ajacob)
!
    call matrot(y0, rot)
    call transp(rot, 3, 3, 3, rot0,&
                3)
!
end subroutine
