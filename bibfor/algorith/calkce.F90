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

subroutine calkce(nno, ndim, kbp, kbb, pm,&
                  dp, kce, rce)
! person_in_charge: sebastien.fayolle at edf.fr
! aslint: disable=W1306
    implicit none
!
#include "asterfort/matinv.h"
#include "asterfort/matmul.h"
#include "asterfort/r8inir.h"
#include "asterfort/transp.h"
    integer :: nno, ndim
    real(kind=8) :: kbp(ndim, nno), kbb(ndim, ndim), rce(nno)
    real(kind=8) :: kce(nno, nno), pm(nno), dp(nno)
!-----------------------------------------------------------------------
!          CALCUL DE LA MATRICE CE POUR LA CONDENSATION STATIQUE
!          ET DU PRODUIT CEP
!-----------------------------------------------------------------------
! IN  NNO     : NOMBRE DE NOEUDS DE L'ELEMENT
! IN  NDIM    : DIMENSION DE L'ESPACE
! IN  KBP     : DISTANCE DU POINT DE GAUSS A L'AXE (EN AXISYMETRIQUE)
! IN  KBB     : COORDONEES DES NOEUDS
! IN  PM      : P A L'INSTANT PRECEDENT
! IN  DP      : INCREMENT POUR P
! OUT CE      : MATRICE DE CONDENSATION STATIQUE
! OUT RCE     : PRODUIT MATRICE DE CONDENSATION-PRESSION
!-----------------------------------------------------------------------
!
    integer :: i
    real(kind=8) :: kpb(nno, ndim), kbbi(ndim, ndim)
    real(kind=8) :: det, pp(nno, 1), prod(ndim, nno)
!-----------------------------------------------------------------------
!
    call r8inir(nno*nno, 0.d0, kce, 1)
    call r8inir(nno, 0.d0, rce, 1)
    call r8inir(ndim*nno, 0.d0, prod, 1)
!
! - TRANSPOSITION DE LA MATRICE KBP
    call transp(kbp, ndim, ndim, nno, kpb,&
                nno)
!
! - INVERSE DE LA MATRICE KBB
    call matinv('S', ndim, kbb, kbbi, det)
!
! - PRODUIT DE L'INVERSE DE LA MATRICE KBB ET DE LA MATRICE KBP
    call matmul(kbbi, kbp, ndim, ndim, nno,&
                prod)
!
! - CALCUL DE KCE
    call matmul(kpb, prod, nno, ndim, nno,&
                kce)
!
! - CALCUL DU PRODUIT RCE
    do 1 i = 1, nno
        pp(i,1)=pm(i)+dp(i)
 1  end do
!
    call matmul(kce, pp, nno, nno, 1,&
                rce)
!
end subroutine
