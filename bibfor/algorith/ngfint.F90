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

subroutine ngfint(option, typmod, ndim, nddl, neps,&
                  npg, w, b, compor, fami,&
                  mat, angmas, lgpg, crit, instam,&
                  instap, ddlm, ddld, ni2ldc, sigmam,&
                  vim, sigmap, vip, fint, matr,&
                  codret)
!
! aslint: disable=W1504
    implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/codere.h"
#include "asterfort/nmcomp.h"
#include "asterfort/r8inir.h"
#include "blas/dgemm.h"
#include "blas/dgemv.h"
    character(len=8) :: typmod(*)
    character(len=*) :: fami
    character(len=16) :: option, compor(*)
!
    integer :: ndim, nddl, neps, npg, mat, lgpg, codret
    real(kind=8) :: w(neps,npg), ni2ldc(neps,npg), b(neps,npg,nddl)
    real(kind=8) :: angmas(3), crit(*), instam, instap
    real(kind=8) :: ddlm(nddl), ddld(nddl)
    real(kind=8) :: sigmam(neps,npg), sigmap(neps,npg)
    real(kind=8) :: vim(lgpg, npg), vip(lgpg, npg), matr(nddl, nddl), fint(nddl)
! ----------------------------------------------------------------------
!     RAPH_MECA, RIGI_MECA_* ET FULL_MECA_*
! ----------------------------------------------------------------------
! IN  OPTION  : OPTION DE CALCUL
! IN  TYPMOD  : TYPE DE MODEELISATION                              (LDC)
! IN  NDIM    : DIMENSION DE L'ESPACE                              (LDC)
! IN  NDDL    : NOMBRE DE DEGRES DE LIBERTE
! IN  NEPS    : NOMBRE DE COMPOSANTES DE DEFORMATION ET CONTRAINTE
! IN  NPG     : NOMBRE DE POINTS DE GAUSS
! IN  W       : POIDS DES POINTS DE GAUSS
! IN  B       : MATRICE CINEMATIQUE : DEFORMATION = B.DDL
! IN  COMPOR  : COMPORTEMENT                                       (LDC)
! IN  MAT     : MATERIAU CODE                                      (LDC)
! IN  ANGMAS  : ANGLE DU REPERE LOCAL                              (LDC)
! IN  LGPG    : LONGUEUR DU TABLEAU DES VARIABLES INTERNES
! IN  CRIT    : CRITERES DE CONVERGENCE LOCAUX                     (LDC)
! IN  INSTAM  : INSTANT PRECEDENT                                  (LDC)
! IN  INSTAP  : INSTANT DE CALCUL                                  (LDC)
! IN  DDLM    : DDL A L'INSTANT PRECEDENT
! IN  DDLD    : INCREMENT DES DDL
! IN  LI2LDC  : CONVERSION CONTRAINTE STOCKEE -> CONTRAINTE LDC (RAC2)
! IN  SIGMAM  : CONTRAINTES A L'INSTANT PRECEDENT
! IN  VIM     : VARIABLES INTERNES A L'INSTANT PRECEDENT
! OUT SIGMAP  : CONTRAINTES DE CAUCHY (RAPH_MECA   ET FULL_MECA_*)
! OUT VIP     : VARIABLES INTERNES    (RAPH_MECA   ET FULL_MECA_*)
! OUT FINT    : FORCES INTERIEURES    (RAPH_MECA   ET FULL_MECA_*)
! OUT MATR    : MATRICE DE RIGIDITE   (RIGI_MECA_* ET FULL_MECA_*)
! OUT CODRET  : CODE RETOUR
! ----------------------------------------------------------------------
    aster_logical :: resi, rigi
    integer :: nepg, g, i, cod(npg)
    real(kind=8) :: sigm(neps,npg), sigp(neps,npg)
    real(kind=8) :: epsm(neps,npg), epsd(neps,npg)
    real(kind=8) :: dsidep(neps,neps,npg), dum(1)
    real(kind=8) :: ktgb(0:neps*npg*nddl-1)
! ----------------------------------------------------------------------
!
! - INITIALISATION
!
    nepg = neps*npg
!
    resi = option(1:9).eq.'FULL_MECA' .or. option(1:9).eq.'RAPH_MECA'
    rigi = option(1:9).eq.'FULL_MECA' .or. option(1:9).eq.'RIGI_MECA'
!
    if (rigi) dsidep = 0.d0
    if (resi) sigp = 0.d0
    cod = 0
!
!
!
! - CALCUL DES DEFORMATIONS GENERALISEES
!
    call dgemv('N', nepg, nddl, 1.d0, b,&
               nepg, ddlm, 1, 0.d0, epsm,&
               1)
    call dgemv('N', nepg, nddl, 1.d0, b,&
               nepg, ddld, 1, 0.d0, epsd,&
               1)
!
!
!
! - CALCUL DE LA LOI DE COMPORTEMENT
!
!    FORMAT LDC DES CONTRAINTES (AVEC RAC2)
     sigm = sigmam*ni2ldc
!
!    LOI DE COMPORTEMENT EN CHAQUE POINT DE GAUSS
    do g = 1, npg
        call nmcomp(fami, g, 1, ndim, typmod,&
                    mat, compor, crit, instam, instap,&
                    neps, epsm(:,g), epsd(:,g), neps, sigm(:,g),&
                    vim(1, g), option, angmas, 1, dum(1),&
                    sigp(:,g), vip(1, g), neps*neps, dsidep(:,:,g), 1,&
                    dum(1), cod(g))
        if (cod(g) .eq. 1) goto 900
    end do
!
!    FORMAT RESULTAT DES CONTRAINTES (SANS RAC2)
    if (resi) sigmap = sigp/ni2ldc 
!
!
!
! - FORCE INTERIEURE
!
    if (resi) then
!
!      PRISE EN CHARGE DU POIDS DU POINT DE GAUSS
        sigp = sigp*w
!
!      FINT = SOMME(G) WG.BT.SIGMA
        call dgemv('T', nepg, nddl, 1.d0, b,&
                   nepg, sigp, 1, 0.d0, fint,&
                   1)
!
    endif
!
!
!
! - CALCUL DE LA MATRICE DE RIGIDITE (STOCKAGE PAR LIGNES SUCCESSIVES)
!
    if (rigi) then
!
!      PRISE EN CHARGE DU POIDS DU POINT DE GAUSS  WG.DSIDEP
        do i = 1,neps
            dsidep(:,i,:) = dsidep(:,i,:)*w
        end do
!
!      CALCUL DES PRODUITS INTERMEDIAIRES (WG.DSIDEP).B POUR CHAQUE G
        do g = 1, npg
            call dgemm('N', 'N', neps, nddl, neps,&
                       1.d0, dsidep(1,1,g), neps, b(1, g, 1), nepg,&
                       0.d0, ktgb((g-1)*neps), nepg)
        end do
!
!      CALCUL DU PRODUIT FINAL SOMME(G) BT. ((WG.DSIDEP).B)  TRANSPOSE
        call dgemm('T', 'N', nddl, nddl, nepg,&
                   1.d0, ktgb, nepg, b, nepg,&
                   0.d0, matr, nddl)
!
    endif
!
!
!
! - SYNTHESE DU CODE RETOUR
900 continue
    if (resi) call codere(cod, npg, codret)
!
end subroutine
