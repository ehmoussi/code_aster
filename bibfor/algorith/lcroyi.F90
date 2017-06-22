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

function lcroyi()
    implicit none
    real(kind=8) :: lcroyi
!
! *********************************************************************
! *       INTEGRATION DE LA LOI DE ROUSSELIER LOCAL                   *
! *  CALCUL DES BORNES INF ET SUP DE LA FONCTION S(Y) QUAND S(0)<0    *
! *  ET RESOLUTION DE S(Y)=0                                          *
! *  PAR UNE METHODE DE NEWTON AVEC BORNES CONTROLEES ET DICHOTOMIE   *
! *  - LA BORNE SUPERIEURE EST TELLE QUE YSUP=LOG(SIG1*FONC/RM)       *
! *  - LA BORNE INFERIEURE EST TELLE QUE YINF =LOG(SIG1*G/R(PM+DPSUP) *
! *********************************************************************
!
! ----------------------------------------------------------------------
!  COMMON LOI DE COMPORTEMENT ROUSSELIER
!
#include "asterfort/lcrofs.h"
#include "asterfort/rcfonc.h"
#include "asterfort/utmess.h"
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
    real(kind=8) :: y, e, dp, rp, s, ds, yinf, ysup, pente, aire
!
!
! 1 - CALCUL DU MAJORANT
!
    e = sig1*fonc / rpm
    ysup = log(e)
    y = ysup
    call lcrofs(y, dp, s, ds)
!
! 2 - CALCUL DU MINORANT
!
    call rcfonc('V', 1, jprolp, jvalep, nbvalp,&
                p = pm+dp, rp = rp, rprim = pente, airerp = aire)
    e = sig1*fonc / rp
    yinf = max(0.d0, log(e))
!
! 3 - RESOLUTION PAR UNE METHODE DE NEWTON ENTRE LES BORNES
!
    do iter = 1, itemax
        if (abs(s)/sigy .le. prec) goto 100
!
        y = y - s/ds
        if (y .le. yinf .or. y .ge. ysup) y=(yinf+ysup)/2
!
        call lcrofs(y, dp, s, ds)
        if (s .le. 0) yinf = y
        if (s .ge. 0) ysup = y
    end do
    call utmess('F', 'ALGORITH3_55')
!
!
100 continue
    lcroyi = y
end function
