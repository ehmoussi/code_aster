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

subroutine cftels(typco, effn, effm, efft, ht, fbeton, sigbet,&
                  sigaci, enrobs, enrobi, uc, compress, dnstra, ierr)

!_____________________________________________________________________
!
!     CFTELS
!
!      CALCUL DU FERRAILLAGE TRANSVERSAL A L'ELS
!
!      I TYPCO    CODIFICATION UTILISEE (1 = BAEL91, 2 = EC2)
!      I EFFN     EFFORT NORMAL
!      I EFFM     MOMENT DE FLEXION
!      I EFFT     EFFORT TRANCHANT
!      I HT       EPAISSEUR DE LA COQUE
!      I FBETON   RESISTANCE EN COMPRESSION DU BETON (CONTRAINTE)
!      I SIGBET   CONTRAINTE ADMISSIBLE DANS LE BETON
!      I SIGACI   CONTRAINTE ADMISSIBLE DANS L'ACIER
!      I ENROBS   ENROBAGE DES ARMATURES SUPERIEURES
!      I ENROBI   ENROBAGE DES ARMATURES INFERIEURES
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
!_____________________________________________________________________
!
!
    implicit none
!
!
#include "asterfort/utmess.h"
!
!
    integer ::typco
    real(kind=8) :: effn
    real(kind=8) :: effm
    real(kind=8) :: efft
    real(kind=8) :: ht
    real(kind=8) :: fbeton
    real(kind=8) :: sigbet
    real(kind=8) :: sigaci
    real(kind=8) :: enrobs
    real(kind=8) :: enrobi
    integer :: uc
    integer :: compress
    real(kind=8) :: dnstra
    integer :: ierr
!
!
!       COEFFICIENT LIE A L'UNITE CHOISIE (Pa OU MPa)
    real(kind=8) :: unite_pa, unite_m
!       COEFFICIENT DE REDUCTION DE LA RESISTANCE DU BETON
!       FISSURE A L'EFFORT TRANCHANT
    real(kind=8) :: nu_1
!       RESISTANCE MOYENNE EN TRACTION
    real(kind=8) :: fctm
!       NOTATION SILMPLIFIEE : SIGMA_CP / SIGMA_CW
    real(kind=8) :: ratio
!       PARAMETRE D'ETAT DE CONTRAINTE DANS LA MEMBRANE COMPRIMEE
    real(kind=8) :: alpha_cw
!       BRAS DE LEVIER ENTRE LE CENTRE DE GRAVITE DE LA SECTION DE
!       BETON COMPRIME ET LE CENTRE DE GRAVITE DES ACIERS TENDUS
    real(kind=8) :: z
!       CONTRAINTE DANS LE BETON MOYENNEE SUR TOUTE LA HAUTEUR DE
!       LA SECTION DUE A L'EFFORT NORMAL DE CALCUL
    real(kind=8) :: sigma_cp
!       COTANGENTE DE L'ANGLE D'INCLINAISON DES BIELLES
    real(kind=8) :: cotheta_0
!       PARAMETRE D'INCLINAISON DES BIELLES DE BETON
    real(kind=8) :: X
!       PARAMETRE DE CALCUL DU CISAILLEMENT DU BETON
    real(kind=8) :: Xmin
!       PARAMETRE DE PARTICIPATION DU BETON AU CISAILLEMENT
    real(kind=8) :: Vfd
!
    dnstra = 0.d0
!
!   CALCUL POUR CODIFICATION = BAEL91
!
    if (typco.eq.1) then
        dnstra = -1.d0
        goto 995
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
            unite_pa = 1.d0
            unite_m = 1.e-3
        endif
        nu_1 = min(0.6,max(0.9-(fbeton/(200.d0*unite_pa)),0.5))
        if (fbeton.le.50.d0*unite_pa) then
            fctm = 0.3*(fbeton**(2.d0/3.d0))
        else
            fctm = 2.12*log(1.d0+((fbeton+8.d0*unite_pa)/10.d0))
        endif
        if (compress.eq.0) then
            sigma_cp = 0.d0
        else
            sigma_cp = -effn/ht
        endif
        ratio = sigma_cp/(sigbet*unite_m)
        if (ratio.le.0.d0) then
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
        if (sigma_cp.ge.0.d0) then
            cotheta_0 = 1.2+0.2*(sigma_cp/(fctm*unite_m))
        else
            cotheta_0 = max(1.d0,1.2+0.9*(sigma_cp/(fctm*unite_m)))
        endif
        X = efft/(alpha_cw*z*nu_1*sigbet)
        Xmin = cotheta_0/(1.d0+(cotheta_0**2))
        if (X.le.Xmin) then
!           PARTICIPATION DU BETON AU CISAILLEMENT
            if (sigma_cp.gt.0.d0) then 
                Vfd = 0.068*z*(1.d0-(cotheta_0/4.d0))*sigbet
            else
                Vfd = 0.068*z*(1.d0-(0.36/cotheta_0))*sigbet
            endif
        else
!           BETON TROP CISAILLE
            ierr = 1100
            goto 995
        endif
        if (efft.gt.Vfd) then
            dnstra = (efft-Vfd)/(sigaci*z*cotheta_0)
        else
            dnstra = 0.d0
        endif
    endif
!
995  continue
end subroutine
