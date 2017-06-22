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

subroutine ngpipe(typilo, npg, neps, nddl, b,&
                  li2ldc, typmod, mat, compor, lgpg,&
                  ddlm, sigm, vim, ddld, ddl0,&
                  ddl1, tau, etamin, etamax, copilo)
!
!
    implicit none
!
#include "asterc/r8vide.h"
#include "asterfort/pil000.h"
#include "asterfort/r8inir.h"
#include "blas/dgemv.h"
    character(len=8) :: typmod(*)
    character(len=16) :: typilo, compor(*)
!
    integer :: npg, neps, nddl, mat, lgpg
    real(kind=8) :: ddlm(nddl), ddld(nddl), ddl0(nddl), ddl1(nddl)
    real(kind=8) :: sigm(0:neps*npg-1), vim(lgpg, npg), tau
    real(kind=8) :: copilo(5, npg), etamin, etamax
    real(kind=8) :: b(neps, npg, nddl), li2ldc(0:neps-1)
!.......................................................................
!
!     BUT:  CALCUL  DES COEFFICIENTS DE PILOTAGE POUR PRED_ELAS
!.......................................................................
! IN  TYPILO : MODE DE PILOTAGE: 'DEFORMATION', 'PRED_ELAS'
! IN  NPG    : NOMBRE DE POINTS DE GAUSS
! IN  NEPS   : NOMBRE DE COMPOSANTES DE DEFORMATIONS / CONTRAINTES
! IN  NDDL   : NOMBRE DE DDL DANS L'ELEMENT
! IN  B      : MATRICE CINEMATIQUE
! IN  LI2LDC : CONVERSION CONTRAINTE --> AVEC RACINE DE DEUX
! IN  TYPMOD : TYPE DE MODELISATION
! IN  MAT    : MATERIAU CODE
! IN  COMPOR : COMPORTEMENT
! IN  LGPG   : "LONGUEUR" DES VARIABLES INTERNES POUR 1 POINT DE GAUSS
!             CETTE LONGUEUR EST UN MAJORANT DU NBRE REEL DE VAR. INT.
! IN  DDLM   : DDL U,ALPHA,MU EN T-
! IN  SIGM   : CONTRAINTES DE CAUCHY EN T- (INUTILE)
! IN  VIM    : VARIABLES INTERNES EN T-
! IN  DDLD   : INCREMENT DE DDL U,ALPHA,MU A L'ITERATION NEWTON COURANTE
! IN  DDL0   : CORRECTION DE DDL U,ALPHA,MU POUR FORCES FIXES
! IN  DDL1   : CORRECTION DE DDL U,ALPHA,MU POUR FORCES PILOTEES
! OUT COPILO : COEFFICIENTS A0 ET A1 POUR CHAQUE POINT DE GAUSS
! ----------------------------------------------------------------------
    integer :: npgmax, epsmax
    parameter (npgmax=27,epsmax=20)
! ----------------------------------------------------------------------
    integer :: g, nepg, ieg
    real(kind=8) :: sigmam(0:epsmax*npgmax-1)
    real(kind=8) :: epsm(0:epsmax*npgmax-1), epsd(0:epsmax*npgmax-1)
    real(kind=8) :: epsp(0:epsmax*npgmax-1)
! ----------------------------------------------------------------------
#define os(g)   (g-1)*neps
! ----------------------------------------------------------------------
!
!
! -- INITIALISATION
!
    call r8inir(npg*5, r8vide(), copilo, 1)
    nepg = neps*npg
!
!
! -- DEFORMATIONS
!
    call dgemv('N', nepg, nddl, 1.d0, b,&
               nepg, ddlm, 1, 0.d0, epsm,&
               1)
    call dgemv('N', nepg, nddl, 1.d0, b,&
               nepg, ddld, 1, 0.d0, epsp,&
               1)
    call dgemv('N', nepg, nddl, 1.d0, b,&
               nepg, ddl0, 1, 1.d0, epsp,&
               1)
    call dgemv('N', nepg, nddl, 1.d0, b,&
               nepg, ddl1, 1, 0.d0, epsd,&
               1)
!
!
! -- PRETRAITEMENT SI NECESSAIRE
    if (typilo .eq. 'PRED_ELAS') then
        do 10 ieg = 0, nepg-1
            sigmam(ieg) = sigm(ieg)*li2ldc(mod(ieg,neps))
10      continue
    endif
!
! -- TRAITEMENT DE CHAQUE POINT DE GAUSS
!
    do 20 g = 1, npg
        call pil000(typilo, compor, neps, tau, mat,&
                    vim(1, g), sigmam(os(g)), epsm(os(g)), epsp(os(g)), epsd(os(g)),&
                    typmod, etamin, etamax, copilo(1, g))
20  end do
!
end subroutine
