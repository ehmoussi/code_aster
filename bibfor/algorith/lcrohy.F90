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

subroutine lcrohy(x, dp, em, ep)
!
    implicit none
#include "asterfort/gdclhy.h"
#include "asterfort/lcdete.h"
    real(kind=8) :: dp, em(6), ep(6), x
!
! ----------------------------------------------------------------------
!                          LOI DE ROUSSELIER
!         CORRECTION HYDROSTATIQUE DE LA DEFORMATION ELASTIQUE
! ----------------------------------------------------------------------
! IN  X       TRACE DE LA DEFORMATION (INCONNUE PRINCIPALE DE L'INTEG.)
! IN  DP      INCREMENT DE DEFORMATION PLASTIQUE CUMULEE
! IN  EM      DEFORMATION ELASTIQUE AU DEBUT DU PAS DE TEMPS
! VAR EP      DEFORMATION ELASTIQUE (XX,YY,ZZ,RAC2*XY,RAC2*XZ,RAC2*YZ)
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
! ----------------------------------------------------------------------
    integer :: ij
    real(kind=8) :: bem(6), detbem, jelasm, jplasm, jplasp, jelasp
! ----------------------------------------------------------------------
!
!    CALCUL DE BE EN T-
    do 10 ij = 1, 6
        bem(ij) = kr(ij) - 2*em(ij)
10  end do
!
    call lcdete(bem, detbem)
    jelasm = sqrt(detbem)
    jplasm = jm/jelasm
    jplasp = jplasm * exp(x)
    jelasp = jp/jplasp
    call gdclhy(jelasp, ep)
!
end subroutine
