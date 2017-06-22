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

subroutine dfdm2j(nno, ipg, idfde, coor, jac)
    implicit none
#include "jeveux.h"
    integer :: nno, ipg, idfde
    real(kind=8) :: coor(1), jac
! ......................................................................
!    - FONCTION REALISEE:  CALCUL DU JACOBIEN (AVEC SIGNE)
!               POUR LES ELEMENTS 2D
!
!    - ARGUMENTS:
!        DONNEES:     NNO           -->  NOMBRE DE NOEUDS
!                     DFRDE,DFRDK   -->  DERIVEES FONCTIONS DE FORME
!                     COOR          -->  COORDONNEES DES NOEUDS
!
!        RESULTATS:   JAC           <--  JACOBIEN AU POINT DE GAUSS
! ......................................................................
!
    integer :: i, ii, k
    real(kind=8) :: de, dk, dxde, dxdk, dyde, dydk
!
!
    dxde = 0.d0
    dxdk = 0.d0
    dyde = 0.d0
    dydk = 0.d0
    do 100 i = 1, nno
        k = 2*nno*(ipg-1)
        ii = 2*(i-1)
        de = zr(idfde-1+k+ii+1)
        dk = zr(idfde-1+k+ii+2)
        dxde = dxde + coor(2*i-1)*de
        dxdk = dxdk + coor(2*i-1)*dk
        dyde = dyde + coor(2*i )*de
        dydk = dydk + coor(2*i )*dk
100  end do
!
    jac = dxde*dydk - dxdk*dyde
!
end subroutine
