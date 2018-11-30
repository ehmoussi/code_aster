! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

subroutine cftelu(typco, effrts, effn, effm, efft, ht, enrobs, enrobi, facier,&
                  fbeton, alphacc, gammac, gammas, uc, compress, dnstra, ierr)
!______________________________________________________________________
!
!     CFTELU
!
!      CALCUL DU FERRAILLAGE TRANSVERSAL A L'ELU
!
!      I TYPCO    CODIFICATION UTILISEE (1 = BAEL91, 2 = EC2)
!      I EFFRTS   (DIM 8) TORSEUR DES EFFORTS, MOMENTS, ...
!      I EFFN     EFFORT NORMAL
!      I EFFT     EFFORT TRANCHANT
!      I HT       EPAISSEUR DE LA COQUE
!      I ENROBS   ENROBAGE DES ARMATURES SUPERIEURES
!      I ENROBI   ENROBAGE DES ARMATURES INFERIEURES
!      I FACIER   LIMITE D'ELASTICITE DES ACIERS (CONTRAINTE)
!      I FBETON   RESISTANCE EN COMPRESSION DU BETON (CONTRAINTE)
!      I ALPHACC  COEFFICIENT DE SECURITE SUR LA RESISTANCE
!                 DE CALCUL DU BETON EN COMPRESSION
!      I GAMMAC   COEFFICIENT DE SECURITE SUR LA RESISTANCE
!                 DE CALCUL DU BETON
!      I GAMMAS   COEFFICIENT DE SECURITE SUR LA RESISTANCE
!                 DE CALCUL DES ACIERS
!      I UC       UNITE DES CONTRAINTES :
!                     UC = 0 CONTRAINTES EN Pa
!                     UC = 1 CONTRAINTES EN MPa
!      I COMPRESS PRISE EN COMPTE DE LA COMPRESSION
!                     COMPRESS = 0 NON
!                     COMPRESS = 1 OUI
!
!      O DNSTRA   DENSITE DE FERRAILLAGE TRANSVERSAL
!      O IERR     CODE RETOUR (0 = OK)
!
!______________________________________________________________________
!
!
    implicit none
!
!
#include "asterfort/utmess.h"
!
!
    integer ::typco
    real(kind=8) :: effrts(8)
    real(kind=8) :: effn
    real(kind=8) :: effm
    real(kind=8) :: efft
    real(kind=8) :: ht
    real(kind=8) :: enrobs
    real(kind=8) :: enrobi
    real(kind=8) :: facier
    real(kind=8) :: fbeton
    real(kind=8) :: alphacc
    real(kind=8) :: gammac
    real(kind=8) :: gammas
    integer :: uc
    integer :: compress
    real(kind=8) :: dnstra
    integer :: ierr
!
!
!       NORME DES EFFORTS DE CISAILLEMENT
    real(kind=8) :: sigmat
!       COEFFICIENT LIE A L'UNITE CHOISIE (Pa OU MPa)
    real(kind=8) :: unite_pa, unite_m
!       COEFFICIENT DE REDUCTION DE LA RESISTANCE DU BETON
!       FISSURE A L'EFFORT TRANCHANT
    real(kind=8) :: nu_1
!       CONTRAINTE DE CONCEPTION DU BETON
    real(kind=8) :: fcd
!       CONTRAINTE DANS LE BETON MOYENNEE SUR TOUTE LA HAUTEUR DE
!       LA SECTION DUE A L'EFFORT NORMAL DE CALCUL
    real(kind=8) :: sigma_cp
!       NOTATION SILMPLIFIEE : SIGMA_CP / FCD
    real(kind=8) :: ratio
!       PARAMETRE D'ETAT DE CONTRAINTE DANS LA MEMBRANE COMPRIMEE
    real(kind=8) :: alpha_cw
!       BRAS DE LEVIER ENTRE LE CENTRE DE GRAVITE DE LA SECTION DE
!       BETON COMPRIME ET LE CENTRE DE GRAVITE DES ACIERS TENDUS
    real(kind=8) :: z
!       PARAMETRE D'INCLINAISON DES BIELLES DE BETON
    real(kind=8) :: X
!       COTANGENTE DE L'ANGLE D'INCLINAISON DES BIELLES
    real(kind=8) :: cotheta
!
    dnstra = 0.d0
!
!
!   CALCUL POUR CODIFICATION = BAEL91
!
    if (typco.eq.1) then
        if (effm.ge.0.d0) then
            z = 0.9*(ht-enrobi)
        else
            z = 0.9*(ht-enrobs)
        endif
        sigmat = sqrt(effrts(7)*effrts(7)+effrts(8)*effrts(8))/z
        dnstra = sigmat / (facier/gammas)
!
!   CALCUL POUR CODIFICATION = EC2
!
    else if (typco.eq.2) then
!
!       CALCULS INTERMEDIAIRES
        if (uc.eq.0) then
            unite_pa = 1.e6
            unite_m = 1.
        else if (uc.eq.1) then
            unite_pa = 1.
            unite_m = 1e-3
        endif
        if (gammas.gt.1.25) then
            nu_1 = min(0.6,max(0.9-(fbeton/(200.d0*unite_pa)),0.5))
        else
            nu_1 = 0.6*(1.-(fbeton/(250.d0*unite_pa)))
        endif
        fcd = fbeton*alphacc/gammac
        if (compress.eq.0) then
            sigma_cp = 0.d0
        else
            sigma_cp = -effn/ht
        endif
        ratio = sigma_cp/(fcd*unite_m)
        if (ratio.le.0.) then
            alpha_cw = 1.d0
        else if (ratio.lt.0.25) then
            alpha_cw = 1.d0+ratio
        else if (ratio.lt.0.5) then
            alpha_cw = 1.25
        else
            alpha_cw = 2.5*(1.d0-ratio)
        endif
!
!       CALCUL DE LA DENSITE DE FERRAILLAGE TRANSVERSALE
        if (effm.ge.0.d0) then
            z = 0.9*(ht-enrobi)
        else
            z = 0.9*(ht-enrobs)
        endif
        X = efft/(alpha_cw*nu_1*fcd*z)
        if (X.le.0.3448) then
            cotheta = 2.5
        else if (X.le.0.5) then
            cotheta = (1.d0+sqrt(1.d0-4.*(X**2)))/(2.*X)
        else
!           SECTION TROP CISAILLEE
            ierr = 1040
            goto 997
        endif
        dnstra = efft/((facier/gammas)*z*cotheta)
   endif
!
997  continue
end subroutine
