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

subroutine cafelu(typco, alphacc, effm, effn, ht, enrobs,&
                  enrobi, facier, fbeton, gammas, gammac,&
                  clacier, uc, dnsinf, dnssup, ierr)
!______________________________________________________________________
!
!     CC_ELU
!
!      DETERMINATION DES ARMATURES EN FLEXION COMPOSEE, CONDITIONS ELU
!
!      I TYPCO    CODIFICATION UTILISEE (1 = BAEL91, 2 = EC2)
!      I ALPHACC  COEFFICIENT DE SECURITE SUR LA RESISTANCE
!                 DE CALCUL DU BETON EN COMPRESSION
!      I EFFM     MOMENT DE FLEXION
!      I EFFN     EFFORT NORMAL
!      I HT       EPAISSEUR DE LA COQUE
!      I ENROBS   ENROBAGE DES ARMATURES SUPERIEURES
!      I ENROBI   ENROBAGE DES ARMATURES INFERIEURES
!      I FACIER   LIMITE D'ELASTICITE DES ACIERS (CONTRAINTE)
!      I FBETON   RESISTANCE EN COMPRESSION DU BETON (CONTRAINTE)
!      I GAMMAS   COEFFICIENT DE SECURITE SUR LA RESISTANCE
!                 DE CALCUL DES ACIERS
!      I GAMMAC   COEFFICIENT DE SECURITE SUR LA RESISTANCE
!                 DE CALCUL DU BETON
!      I CLACIER  CLASSE DE DUCTILITE DES ACIERS (UTILISE POUR EC2) :
!                     CLACIER = 0 ACIER PEU DUCTILE (CLASSE A)
!                     CLACIER = 1 ACIER MOYENNEMENT DUCTILE (CLASSE B)
!                     CLACIER = 3 ACIER FORTEMENT DUCTILE (CLASSE C)
!      I ES       MODULE D'YOUNG DE L'ACIER
!      I UC       UNITE DES CONTRAINTES :
!                     UC = 0 CONTRAINTES EN Pa
!                     UC = 1 CONTRAINTES EN MPa
!
!      O DNSINF   DENSITE DE L'ACIER INFERIEUR
!      O DNSSUP   DENSITE DE L'ACIER SUPERIEUR
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
    integer :: typco
    real(kind=8) :: alphacc
    real(kind=8) :: effm
    real(kind=8) :: effn
    real(kind=8) :: ht
    real(kind=8) :: enrobs
    real(kind=8) :: enrobi
    real(kind=8) :: facier
    real(kind=8) :: fbeton
    real(kind=8) :: gammas
    real(kind=8) :: gammac
    integer :: clacier
    integer :: uc
    real(kind=8) :: dnsinf
    real(kind=8) :: dnssup
    integer :: ierr
!
!
!       ENROBAGE A CONSIDERER (C_SUP OU C_INF)
    real(kind=8) :: enrob
!       HAUTEUR UTILE (H/2 - C)
    real(kind=8) :: hu
!       BRAS DE LEVIER PAR RAPPORT A LA FIBRE SUPERIEURE
    real(kind=8) :: d
!       COEFFICIENT LIE A L'UNITE CHOISIE (Pa OU MPa)
    real(kind=8) :: unite_pa, unite_m
!       MOMENTS REDUITS
    real(kind=8) :: m_inf, mu_inf
!       PARAMETRES DU DIAGRAMME RECTANGULAIRE SIMPLIFIE
    real(kind=8) :: eta, lambda
!       DEFORMATION DE CONCEPTION DES ACIERS QUI CONDITIONNE LE PIVOT A
!       (REPRESENTE EPSI_UD = 0.9*EPSI_UK POUR L'EC2)
    real(kind=8) :: piv_a
!       DEFORMATION EN % DE CONCEPTION EN COMPRESSION DU BETON QUI
!       CONDITIONNE LE PIVOT B (REPRESENTE EPSI_CU3 POUR L'EC2)
    real(kind=8) :: piv_b
!       CONTRAINTE DE CONCEPTION DES ACIERS
    real(kind=8) :: sigm_acier
!       CONTRAINTE DE CONCEPTION DE COMPRESSION DU BETON
    real(kind=8) :: sigm_beton
!       RATIO DE HAUTEUR COMPRIMEE DE LA SECTION AU PIVOT A
    real(kind=8) :: alpha_ab
!       MOMENT REDUIT LIMITE AU PIVOT C
    real(kind=8) :: mu_bc
!       VARIABLES DE CALCUL
    real(kind=8) :: alpha, N, force
!
!
!   INITIALISATION DU CODE RETOUR
    ierr = 0
!   INITIALISATION DES DENSITES DE FERRAILLAGE
    dnsinf = 0d0
    dnssup = 0d0
!
!   CALCULS PRELIMINAIRES
!
    if (effm.ge.0.) then
        enrob = enrobi
    else
        enrob = enrobs
    endif
    hu = 0.5*ht - enrob
    d = ht - enrob
    m_inf = abs(effm) - effn*hu
    if (typco.eq.1) then
!       CALCUL DES PARAMETRES POUR CODIFICATION = 'BAEL91'
        eta = 1.d0
        lambda = 0.8
        piv_a = 10.0E-3
        piv_b = 3.5E-3
        sigm_acier = facier/gammas
        sigm_beton = fbeton*alphacc/gammac
        unite_m = 1.
    else if (typco.eq.2) then
!       CALCUL DES PARAMETRES POUR CODIFICATION = 'EC2'
        if (uc.eq.0) then
            unite_pa = 1.e6
            unite_m = 1.
        else if (uc.eq.1) then
            unite_pa = 1.
            unite_m = 1.e-3
        endif
        eta = min(1.d0,1.d0-(fbeton-(50.d0*unite_pa))/(200.d0*unite_pa))
        lambda = min(0.8,0.8-(fbeton-(50.d0*unite_pa))/(400.d0*unite_pa))
        if (clacier.eq.0) then
            piv_a = 0.9*2.5e-2
        else if (clacier.eq.1) then
            piv_a = 0.9*5.e-2
        else
            piv_a = 0.9*7.5e-2
        endif
        piv_b = min(3.5E-3,0.26+3.5*0.01*(((90.d0*unite_pa-fbeton)/100.d0)**4))
        sigm_acier = facier/gammas
        sigm_beton = fbeton*alphacc/gammac
    endif
    alpha_ab = piv_b/(piv_a+piv_b)
    mu_inf = m_inf/(d**2.d0*sigm_beton*eta*unite_m)
    mu_bc = lambda*(1.d0-lambda/2.d0)
!
!   CALCULS DES DENSITES DE FERRAILLAGE A L'ELU
!
    if (mu_inf.lt.0.d0) then
!       SECTION ENTIEREMENT TENDUE
        dnssup = (effn*hu+effm)/(2.d0*hu)
        dnsinf = (effn*hu-effm)/(2.d0*hu)
    else
!       SECTION A MINIMA PARTIELLEMENT COMPRIMEE
        if (mu_inf.lt.mu_bc) then
!           SECTION PARTIELLEMENT TENDUE : PIVOT A ET B
            alpha = 1.d0-sqrt(1.d0-2.d0*mu_inf)
            N = alpha*d*eta*sigm_beton*unite_m + effn
            if (N.le.0.d0) then
!               PIVOT B : SECTION COMPRIMEE
                N = 0.d0
            endif
            if (effm.ge.0.d0) then
!               TEST SUR LE SIGNE DU MOMENT DE FLEXION
                dnssup = N
            else
                dnsinf = N
            endif
            if (effn.ne.0.d0) then
!               POUR EVITER LE FLOATING POINT EXCEPTION SI EFFN = 0
                force = effn/(1.d0-(2.d0*effm)/(ht*effn))
            else
                force = 0.d0
            endif
            if (force.lt.-1.d0*eta*sigm_beton*ht) then
!               PIVOT B : SECTION TROP COMPRIMEE
                ierr = 1010
                goto 998
            endif
        else
!           PIVOT C
            ierr = 1020
            dnssup = 0.0d0
            dnsinf = 0.0d0
            if (effn.lt.-1.d0*lambda*eta*sigm_beton*ht) then
!               PIVOT C : SECTION TROP COMPRIMEE
                ierr = 1030
                goto 998
            else
                goto 998
            endif
        endif
    endif
    dnsinf = dnsinf / sigm_acier
    dnssup = dnssup / sigm_acier
!
998  continue
end subroutine
