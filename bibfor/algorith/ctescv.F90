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

subroutine ctescv(cvec1, cvec0, cvec01, cvec00, ndim,&
                  xer)
    implicit none
!
!***********************************************************************
!    P. RICHARD                                 DATE 31/07/91
!-----------------------------------------------------------------------
!  BUT: < COMPLEXE TEST DE CONVERGENCE >
!
! TESTER LA CONVERGENCE PAR ESTIMATION DE LA COLINEARITE
!      DU VECTEUR COURANT AVEC CELUI DE L'ITERATION PRECEDANTE
!      RENVOIE L'ERREUR DE COLINEARITE RELATIVE
!     ET COPIE DU MODE DE L'ITERATION COURANTE DANS L'ANCIEN
!
!-----------------------------------------------------------------------
!
! CVEC1    /I/: VECTEUR ITERATION COURANTE
! CVEC0    /M/: VECTEUR ITERATION PRECEDENTE
! NDIM     /I/: DIMENSION DES VECTEURS
! XER      /O/: ERREUR RELATIVE DE COLINEARITE
!
!-----------------------------------------------------------------------
!
#include "asterc/r8miem.h"
#include "asterfort/zconju.h"
    complex(kind=8) :: cvec1(ndim), cvec0(ndim)
    complex(kind=8) :: cvec01(ndim), cvec00(ndim)
    complex(kind=8) :: cconj, cnorm, cprod
    real(kind=8) :: eps
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: i, ndim
    real(kind=8) :: pima, prea, xer
!-----------------------------------------------------------------------
    eps = r8miem()**(2.0d+0 / 3.0d+0)
!   PRODUIT SCALAIRE
!
!   Produit scalaire inv(M)*X1*X0
    cprod=dcmplx(0.d0,0.d0)
    do 10 i = 1, ndim
        call zconju(cvec1(i), prea, pima)
        cconj=dcmplx(prea,-pima)
        cprod=cprod+(cconj*cvec00(i))
10  end do
!
!
!   Produit scalaire inv(M)*X0*X0
    cnorm=dcmplx(0.d0,0.d0)
    do 15 i = 1, ndim
        call zconju(cvec01(i), prea, pima)
        cconj=dcmplx(prea,-pima)
        cnorm=cnorm+(cconj*cvec00(i))
15  end do
!
!    Ancien calcul d'erreur
!
!   Produit scalaire inv(M)*X1*X1
!      CNORM2=DCMPLX(0.D0,0.D0)
!      DO 16 I=1,NDIM
!        CALL ZCONJU(CVEC1(I),PREA,PIMA)
!        CCONJ2=DCMPLX(PREA,-PIMA)
!        CNORM2=CNORM2+(CCONJ2*CVEC0(I))
! 16   CONTINUE
!      WRITE(6,*)'CNORM2 = ',CNORM2
!
!   CALCUL ERREUR ORTHOGONALITE
!
!      XER=0.D0
!      DO 20 I=1,NDIM
!        CERRE=CVEC1(I)-(CNORM2*CVEC01(I)/CNORM)
!        CALL ZCONJU(CERRE,PREA,PIMA)
!        XMODU=(PREA**2)+(PIMA**2)
!        XER=XER+XMODU
! 20   CONTINUE
!
!      XER=(XER/(DBLE(CNORM2)))**0.5D0
!
    if (abs(cnorm) .lt. eps) then
        xer=100.d0
    else
        xer=abs(1.d0-abs(cprod)/abs(cnorm))
    endif
!
!
!  RECOPIE DU VECTEUR COURANT DANS LE PRECEDENT
!
    do 30 i = 1, ndim
        cvec0(i)=cvec1(i)
30  end do
!
end subroutine
