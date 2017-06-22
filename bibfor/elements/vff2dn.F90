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

subroutine vff2dn(ndim, nno, ipg, ipoids, idfde,&
                  coor, nx, ny, jac)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
    integer, intent(in) :: ndim, nno, ipoids, idfde, ipg
    real(kind=8), intent(in) :: coor(1)
    real(kind=8), intent(out) :: nx, ny, jac
! ......................................................................
!    - BUT:  CALCULER LA VALEUR DU POIDS D'INTEGRATION EN 1 POINT DE
!            GAUSS POUR UN SEGMENT PLAN  A 2 OU 3 NOEUDS.
!      CALCULE AUSSI LA NORMALE AU SEGMENT AU POINT DE GAUSS.
!
!    - ARGUMENTS:
!        DONNEES:
!        IPG      -->  NUMERO DU POINT DE GAUSS
!        NDIM     -->  1 (SEGMENT)
!        IPOIDS   -->  ADRESSE DES POIDS DE GAUSS
!        NNO      -->  NOMBRE DE NOEUDS
!        DFDE     -->  ADRESSES DES DERIVEES DES FONCTIONS DE FORME
!        COOR     -->  COORDONNEES DES NOEUDS
!
!        RESULTATS:    NX,NY    <--  COMPOSANTES DE LA NORMALE
!                      JAC      <--  PRODUIT DU JACOBIEN ET DU POIDS
!
!  REMARQUE :
!    - LES SEGMENTS DOIVENT ETRE "PLANS" (DANS OXY)
! ......................................................................
!
    integer :: i, k
    real(kind=8) :: dx, dxds, dyds
!
    ASSERT(ndim.eq.1)
    dxds = 0.d0
    dyds = 0.d0
    do 1 i = 1, nno
        k = nno*(ipg-1)
        dx = zr(idfde-1+k+i)
        dxds = dxds + dx * coor(2*i-1)
        dyds = dyds + dx * coor(2*i)
 1  end do
    jac = sqrt(dxds**2 + dyds**2)
    nx = dyds/jac
    ny = -dxds/jac
    jac = zr(ipoids + ipg-1) * jac
end subroutine
