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

subroutine mdfdas(dnorm, vnorm, vitloc, cost, sint,&
                  coefk1, coefk2, coefpy, coefc, coefad,&
                  xmax, fdispo, flocal)
    implicit none
!
!***********************************************************************
!    CALCULE LA FORCE DUE A LA PRESENCE D'UN DISPOSITIF ANTI SISMIQUE
!
!-----------------------------------------------------------------------
!   IN :  DNORM : DISTANCE NORMALE
!   OUT :  VNORM : VITESSE  NORMALE
!   IN :  VITLOC : VITESSE DANS LE REPERE LOCAL
!   IN :  ACCLOC : ACCELERATION DANS LE REPERE LOCAL
!   IN :  COST,SINT : DIRECTION DE LA NORMALE A L'OBSTACLE
!   IN :  COEFK1 : VALEUR DE RIGI_K1
!   IN :  COEFK2 : VALEUR DE RIGI_K2
!   IN :  COEFPY : VALEUR DE SEUIL_FX
!   IN :  COEFC : VALEUR DE C
!   IN :  COEFAD : VALEUR DE PUIS_ALPHA
!   IN :  XMAX : VALEUR DE DX_MAX
!   IN :  CNORM : AMORTISSEUR NORMALE DE CHOC
!   OUT :  FDISPO : FORCE NORMALE DUE AU DISPO ANTI SISMIQUE
!   OUT :  FLOCAL : FORCE NORMALE DE CHOC REP. LOCAL
!-----------------------------------------------------------------------
#include "asterc/r8prem.h"
!
    real(kind=8) :: vitloc(3), flocal(3), fdispo
    real(kind=8) :: coefk1, coefk2, coefpy, coefc, coefad, xmax, cost, sint
!-----------------------------------------------------------------------
    real(kind=8) :: dnorm, vnorm
!-----------------------------------------------------------------------
    vnorm = vitloc(2)*cost + vitloc(3)*sint
    if (abs(vnorm) .lt. r8prem()) then
        fdispo = -coefk2*dnorm - (coefk1-coefk2)*dnorm/sqrt(1.d0+( coefk1*dnorm/coefpy)**2)
    else
        fdispo = -coefk2*dnorm - (coefk1-coefk2)*dnorm/sqrt(1.d0+( coefk1*dnorm/coefpy)**2) - coe&
                 &fc*sign(1.d0,vnorm)*abs(vnorm* dnorm/xmax)**coefad
    endif
    flocal(1)=0.d0
    flocal(2)=fdispo*cost
    flocal(3)=fdispo*sint
end subroutine
