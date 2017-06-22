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

subroutine invjac(nno, ipg, ipoids, idfde, coor,&
                  invja, jac)
    implicit none
#include "jeveux.h"
#include "asterfort/matini.h"
#include "asterfort/matinv.h"
    integer :: ipg, ipoids, idfde, nno
    real(kind=8) :: coor(1), jac
! ......................................................................
!    - FONCTION REALISEE:  CALCUL DE L'INVERSE DE LA MATRICE JACOBIENNE
!                          POUR LES ELEMENTS 3D
!
!    - ARGUMENTS:
!        DONNEES:     NNO           -->  NOMBRE DE NOEUDS
!                     POIDS         -->  POIDS DU POINT DE GAUSS
!              DFDRDE,DFRDN,DFRDK   -->  DERIVEES FONCTIONS DE FORME
!                     COOR          -->  COORDONNEES DES NOEUDS
!
!      RESULTAT :   INVJA         <--  INVERSE DE LA MATRICE JACOBIENNE
!                   JAC           <--  JACOBIEN
! ......................................................................
!
    integer :: i, j, ii, k
    real(kind=8) :: poids, g(3, 3)
    real(kind=8) :: de, dn, dk, invja(3, 3)
!
    poids = zr(ipoids+ipg-1)
!
    call matini(3, 3, 0.d0, g)
!
    do 100 i = 1, nno
        k = 3*nno*(ipg-1)
        ii = 3*(i-1)
        de = zr(idfde-1+k+ii+1)
        dn = zr(idfde-1+k+ii+2)
        dk = zr(idfde-1+k+ii+3)
        do 101 j = 1, 3
            g(1,j) = g(1,j) + coor(ii+j) * de
            g(2,j) = g(2,j) + coor(ii+j) * dn
            g(3,j) = g(3,j) + coor(ii+j) * dk
101      continue
100  end do
!
    call matinv('S', 3, g, invja, jac)
!
    jac = abs(jac)*poids
!
end subroutine
