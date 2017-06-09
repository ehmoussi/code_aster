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

subroutine gdstag(stoudy, kp, nno, ajacob, en,&
                  enprim, x0k, tetak, qim, qikm1,&
                  qik, x0pg, tetag, tetapg, rotm,&
                  rotkm1, rotk)
!
! FONCTION: POUR UN ELEMENT DE POUTRE EN GRAND DEPLACEMENT, CALCULE
!           CERTAINES GRANDEURS STATIQUES AUX POINTS DE GAUSS.
!
!     IN  : STOUDY    : 0 EN STATIQUE
!                       1 EN DYNAMIQUE
!           KP        : NUMERO DU POINT DE GAUSS
!           NNO       : NOMBRE DE NOEUDS
!           AJACOB    : JACOBIEN
!           EN        : FONCTIONS DE FORME
!           ENPRIM    : DERIVEES DES FONCTIONS DE FORME
!           X0K       : COORDONNEES ACTUALISEES DES NOEUDS
!           TETAK     : VECTEUR-INCREMENT DE ROTATION DES NOEUDS
!           QIM       : VECTEUR-ROTATION A L'INSTANT PRECEDENT
!           QIKM1     : VECTEUR-ROTATION A L'ITERATION PRECEDENTE
!           QIK       : VECTEUR-ROTATION ACTUEL
!
!     OUT, AU POINT DE GAUSS NUMERO KP:
!           X0PG      : DERIVEES DES COORDONNEES PAR RAP. A L'ABS. CURV.
!           TETAG     : VECTEUR-INCREMENT DE ROTATION
!           TETAPG    : DERIVEE DU PRECEDENT PAR RAP. A L'ABS. CURV.
!           ROTM      : MATRICE DE ROTATION A L'INSTANT PRECEDENT
!           ROTKM1    : MATRICE DE ROTATION A L'ITERATION PRECEDENTE
!           ROTK      : MATRICE DE ROTATION ACTUELLE
! ------------------------------------------------------------------
    implicit none
#include "asterfort/marota.h"
    real(kind=8) :: en(3, 2), enprim(3, 2), x0k(3, 3), tetak(3, 3), qim(3, 3)
    real(kind=8) :: qikm1(3, 3), qik(3, 3), x0pg(3), tetag(3), tetapg(3)
    real(kind=8) :: rotm(3, 3), rotkm1(3, 3), rotk(3, 3), qigm(3), qigkm1(3)
    real(kind=8) :: qigk(3)
!
!
!-----------------------------------------------------------------------
    integer :: ic, kp, ne, nno
    real(kind=8) :: ajacob, demi, stoudy, un, unsurj, zero
!-----------------------------------------------------------------------
    zero = 0.d0
    demi = 5.d-1
    un = 1.d0
    do 1 ic = 1, 3
        x0pg(ic) = zero
        tetag(ic) = zero
        tetapg(ic) = zero
        qigk(ic) = zero
 1  end do
    unsurj = un / ajacob
    do 3 ic = 1, 3
        do 2 ne = 1, nno
            x0pg(ic) = x0pg(ic) + unsurj*enprim(ne,kp)*x0k(ic,ne)
            tetag(ic) = tetag(ic) + en(ne,kp)*tetak(ic,ne)
            tetapg(ic) = tetapg(ic) + unsurj*enprim(ne,kp)*tetak(ic, ne)
            qigk(ic) = qigk(ic) + en(ne,kp)*qik(ic,ne)
 2      end do
 3  end do
    call marota(qigk, rotk)
!
    if (stoudy .lt. demi) goto 9999
!
    do 11 ic = 1, 3
        qigm (ic) = zero
        qigkm1 (ic) = zero
11  end do
    do 13 ic = 1, 3
        do 12 ne = 1, nno
            qigm (ic) = qigm (ic) + en(ne,kp)*qim (ic,ne)
            qigkm1 (ic) = qigkm1 (ic) + en(ne,kp)*qikm1 (ic,ne)
12      end do
13  end do
    call marota(qigm, rotm)
    call marota(qigkm1, rotkm1)
!
9999  continue
end subroutine
