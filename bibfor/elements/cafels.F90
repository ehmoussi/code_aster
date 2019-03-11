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

subroutine cafels(cequi, effm, effn, ht, enrobs, enrobi, sigaci,&
                  sigbet, uc, dnsinf, dnssup, ierr)
!______________________________________________________________________
!
!     CAFELS
!
!      CALCUL DES ACIERS EN FLEXION COMPOSEE A L'ELS
!
!      I CEQUI   COEFFICIENT D'EQUIVALENCE ACIER/BETON
!      I EFFM    MOMENT DE FLEXION
!      I EFFN    EFFORT NORMAL
!      I HT      EPAISSEUR DE LA COQUE
!      I ENROBS  ENROBAGE DES ARMATURES SUPERIEURES
!      I ENROBI  ENROBAGE DES ARMATURES INFERIEURES
!      I SIGACI  CONTRAINTE ADMISSIBLE DANS L'ACIER
!      I SIGBET  CONTRAINTE ADMISSIBLE DANS LE BETON
!
!      O DNSINF  DENSITE DE L'ACIER INFERIEUR
!      O DNSSUP  DENSITE DE L'ACIER SUPERIEUR
!      O IERR    CODE RETOUR (0 = OK)
!______________________________________________________________________
!
    implicit none
!
!
#include "asterfort/utmess.h"
!
!
    real(kind=8) :: cequi
    real(kind=8) :: effm
    real(kind=8) :: effn
    real(kind=8) :: ht
    real(kind=8) :: enrobs
    real(kind=8) :: enrobi
    real(kind=8) :: sigaci
    real(kind=8) :: sigbet
    integer :: uc
    real(kind=8) :: dnsinf
    real(kind=8) :: dnssup
    integer :: ierr
!
!
!       COEFFICIENT LIE A L'UNITE CHOISIE (Pa OU MPa)
    real(kind=8) :: unite_m
!       ENROBAGE A CONSIDERER
    real(kind=8) :: enrob
!       BRAS DE LEVIER PAR RAPPORT A LA FIBRE SUPERIEURE
    real(kind=8) :: d
!       HAUTEUR UTILE (H/2 - C)
    real(kind=8) :: hu 
!       MOMENTS REDUITS
    real(kind=8) :: m_inf, mu
!       MOMENT REDUIT DU PASSAGE PIVOT A PIVOT B
    real(kind=8) :: mu_ab
!       MOMENT REDUIT LIMITE AU PIVOT C
    real(kind=8) :: mu_bc
!       RATIO DE HAUTEUR COMPRIMEE DE LA SECTION AU PIVOT A
    real(kind=8) :: alpha_ab
!       RACINE DE L'EQUATION D'EQUILIBRE EN FLEXION
    real(kind=8) :: alpha
!       DENSITE DE FERRAILLAGE INTERMEDIAIRE
    real(kind=8) :: dns
!       VARIABLE INTERMEDIAIRE DE CALCUL POUR LE PIVOT A
    real(kind=8) :: phi
!       VARIABLE INTERMEDIAIRE DE CALCU POUR LE PIVOT B
    real(kind=8) :: sigma_s
!       CONSTANTE PI
    real(kind=8) :: pi
!       VARIABLES DE CALCUL
    real(kind=8) :: force
!
!
!   INITIALISATION DU CODE RETOUR
    ierr = 0
!   INITIALISATION DES DENSITES DE FERRAILLAGE
    dnsinf = 0d0
    dnssup = 0d0
    dns = 0.d0
!
!   CALCULS INTERMEDIAIRES
!
    if (uc.eq.0) then
        unite_m = 1.
    else if (uc.eq.1) then
        unite_m = 1.e-3
    endif
    if (effm.ge.0.) then
        enrob = enrobi
    else
        enrob = enrobs
    endif
    d = ht - enrob
    hu = ht/2 - enrob
    alpha_ab = cequi*sigbet/(cequi*sigbet+sigaci)
    mu_ab = 0.5*alpha_ab*(1.d0-alpha_ab/3.d0)
    mu_bc = 1.d0/3.d0
    m_inf = abs(effm) - effn*hu
    mu = m_inf/(d**2.d0*sigbet*unite_m)
!
!   CALCUL DES DENSITES DE FERRAILLAGE A L'ELS
!
    if (mu.lt.0) then
!       PIVOT A : SECTION ENTIEREMENT TENDUE
        dnssup = (m_inf+effn*(d-enrob))/(sigaci*(d-enrob))
        dnsinf = (-m_inf)/(sigaci*(d-enrob))
    else 
        if (mu.lt.mu_ab) then
!           PIVOT A : SECTION PARTIELLEMENT TENDUE
            pi = 2.d0*asin(1.d0) 
            phi = acos(-1.d0/(1.d0+2.d0*cequi*mu*sigbet/sigaci)**(1.5))
            alpha = 1.d0+2.d0*(1.d0+2.d0*cequi*mu*sigbet/sigaci)**(0.5)*&
                    cos(pi/3.d0+phi/3.d0)
            dns = m_inf/((1.d0-alpha/3.d0)*sigaci*d)+effn/sigaci
            if (dns.le.0.d0) then
                dns = 0.d0
            endif
        else if (mu.lt.mu_bc) then
!           PIVOT B : SECTION PARTIELLEMENT TENDUE
            alpha = (3.d0-sqrt(3.d0*(3.d0-8.d0*mu)))/2.d0
            sigma_s = (1.d0-alpha)/alpha*cequi*sigbet
            dns = m_inf/((1.d0-alpha/3.d0)*(d*sigma_s))+effn/sigma_s
            if (dns.le.0.d0) then
                dns = 0.d0
            endif
!           force = effn/(3.d0/4.d0 - 2.d0*effm/(2.d0*ht*effn))
            force = (8.d0*ht*effn**2)/(6.d0*ht*effn-12.d0*effm)
            if (force.lt.-1.d0*sigbet*ht) then
!               PIVOT B : SECTION TROP COMPRIMEE
                ierr = 1050
                goto 996
            endif
        else
!           PIVOT C
            ierr = 1060
            dnssup = 0.0d0
            dnsinf = 0.0d0
            force = (ht*effn**2)/(ht*effn+6.d0*effm)
            if (force.lt.-1.d0*sigbet*ht) then
!               PIVOT C : SECTION TROP COMPRIMEE
                ierr = 1070
                goto 996
            else
                goto 996
            endif
        endif
        if (effm.ge.0.d0) then 
            dnssup = dns
        else
            dnsinf = dns
        endif
    endif
!
996  continue
end subroutine
