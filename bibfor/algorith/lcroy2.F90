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

function lcroy2(ymin)
    implicit none
    real(kind=8) :: lcroy2
#include "asterfort/lcrofg.h"
#include "asterfort/lcroty.h"
#include "asterfort/utmess.h"
    real(kind=8) :: ymin
!
! *********************************************************************
! *        INTEGRATION DE LA LOI DE ROUSSELIER LOCAL                  *
! *    RESOLUTION DE SEUIL(Y)=0 QUAND S(0)<0 AVEC S(YMIN)=0           *
! *    PAR UNE METHODE DE NEWTON AVEC BORNES CONTROLEES ET DICHOTOMIE *
! *     - LA BORNE INFERIEURE EST YINF=YMIN                           *
! *     - LA BORNE SUPERIEURE EST TELLE QUE:                          *
! *       YSUP*EXP(YSUP) =2*K*FONC*EQTR/3*SIG1                        *
! *********************************************************************
!
! IN  YMIN   : MINORANT DE LA SOLUTION ( S(YM)=0 )
! ----------------------------------------------------------------------
!  COMMON LOI DE COMPORTEMENT ROUSSELIER
!
    integer :: itemax, jprolp, jvalep, nbvalp
    real(kind=8) :: prec, young, nu, sigy, sig1, rousd, f0, fcr, acce
    real(kind=8) :: pm, rpm, fonc, fcd, dfcddj, dpmaxi,typoro
    common /lcrou/ prec,young,nu,sigy,sig1,rousd,f0,fcr,acce,&
     &               pm,rpm,fonc,fcd,dfcddj,dpmaxi,typoro,&
     &               itemax, jprolp, jvalep, nbvalp
! ----------------------------------------------------------------------
!  COMMON GRANDES DEFORMATIONS CANO-LORENTZ
!
    integer :: ind1(6), ind2(6)
    real(kind=8) :: kr(6), rac2, rc(6)
    real(kind=8) :: lambda, mu, deuxmu, unk, troisk, cother
    real(kind=8) :: jm, dj, jp, djdf(3, 3)
    real(kind=8) :: etr(6), dvetr(6), eqetr, tretr, detrdf(6, 3, 3)
    real(kind=8) :: dtaude(6, 6)
!
    common /gdclc/&
     &          ind1,ind2,kr,rac2,rc,&
     &          lambda,mu,deuxmu,unk,troisk,cother,&
     &          jm,dj,jp,djdf,&
     &          etr,dvetr,eqetr,tretr,detrdf,&
     &          dtaude
! ----------------------------------------------------------------------
!
    integer :: iter
    real(kind=8) :: s, seuil, dseuil, g, dg
    real(kind=8) :: y, dp, yinf, ysup
!
! 1 - CALCUL DES BORNES
!     LCROTY RESOUD UNE EQUATION DU TYPE Y*EXP(Y)=CONSTANTE
!
    yinf = ymin
    ysup = lcroty(2*unk*fonc*eqetr/(3.d0*sig1), prec, itemax)
!
! 2 - RESOLUTION PAR UNE METHODE DE NEWTON ENTRE LES BORNES
!
    y = ysup
    do 10 iter = 1, itemax
!
        call lcrofg(y, dp, s, seuil, dseuil)
        g = seuil
        dg = dseuil
        if (g .ge. 0) yinf = y
        if (g .le. 0) ysup = y
!
        if (abs(seuil)/sigy .le. prec) goto 100
!
        y = y - g/dg
        if (y .le. yinf .or. y .ge. ysup) y=(yinf+ysup)/2
!
10  end do
    call utmess('F', 'ALGORITH3_55')
!
100  continue
    lcroy2 = y
end function
