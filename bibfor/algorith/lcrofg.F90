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

subroutine lcrofg(y, dp, s, seuil, dseuil)
    implicit none
#include "asterfort/lcrofs.h"
    real(kind=8) :: y, dp, s, seuil, dseuil
!
! **********************************************************
! *       INTEGRATION DE LA LOI DE ROUSSELIER LOCAL        *
! *          CALCUL DE DP DU SEUIL ET DE SA DERIVEE        *
! **********************************************************
!
! IN  Y       : PARAMETRE Y = K/SIG1 X
! OUT DP      : INCREMENT DE DEFORMATION PLASTIQUE CUMULEE
!                     DP = Y*SIG1*EXP(Y)/(FONC*K)
! OUT S       : VALEUR DE LA FONCTION S(Y)=-SIG1*FONC*EXP(-Y)+R
! OUT SEUIL   : VALEUR DU SEUIL(Y)=2*MU*EQETR-S(Y)-3*MU*DP
! OUT DSEUIL  : DERIVEE DU SEUIL PAR RAPPORT A Y
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
!
    real(kind=8) :: ds, ddp
!
! 1 - CALCULE DE DP - S ET LA DERIVEE DE S
!
    call lcrofs(y, dp, s, ds)
!
! 2 - CALCUL DU SEUIL ET DE SA DERIVEE
!
    ddp = sig1*(1+y)*exp(y)/(unk*fonc)
    seuil = deuxmu*eqetr - s - 3.d0*mu*dp
    dseuil = - 3.d0*mu*ddp - ds
!
end subroutine
