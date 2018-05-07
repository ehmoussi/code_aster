! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine te0146(option, nomte)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/clcplq.h"
#include "asterfort/jevech.h"
#include "asterfort/tecach.h"
#include "asterfort/tecael.h"
#include "asterfort/utmess.h"
! aslint: disable=W0104
    character(len=16) :: option, nomte
!.....................................................................
!  BUT: CALCUL DE L'OPTION FERRAILLAGE POUR LES ELEMENTS DE COQUE
!.....................................................................
!_____________________________________________________________________
!
! CALCUL DES ARMATURES DE BETON ARME (METHODE DE CAPRA ET MAURY).
!
! VERSION 1.2 DU 31/03/2010
!_____________________________________________________________________
!
!
! PARAMETRES D'ECHANGE ENTRE CODE_ASTER ET CLCPLQ (POINT D'ENTREE DU
! CALCUL DE FERRAILLAGE PAR CAPRA ET MAURY
!
!   PARAMETRES D'ENTREE (FOURNIS PAR CODE_ASTER)
!
!     TYPCMB  (I)   TYPE DE COMBINAISON :
!                   0 = ELU, 1 = ELS
!     TYPCO   (I)   TYPE DE CODIFICATION :
!                   0 = UTILISATEUR, 1 = BAEL91, 2 = EUROCODE 2
!     ES      (DP)  MODULE D'YOUNG DE L'ACIER
!     CEQUI   (DP)  COEFFICIENT D'EQUIVALENCE ACIER/BETON
!     ENROBS  (DP)  ENROBAGE DES ARMATURES SUPERIEURES
!     ENROBI  (DP)  ENROBAGE DES ARMATURES INFERIEURES
!     SIGACI  (DP)  CONTRAINTE ADMISSIBLE DANS L'ACIER
!     SIGBET  (DP)  CONTRAINTE ADMISSIBLE DANS LE BETON
!     COEFF1  (DP)  SI TYPCO = UTILISATEUR, COEFF1 = VALEUR DU PIVOT A
!                   SI TYPCO = BAEL91 ou EC2, COEFF1 = ALPHA_CC
!     COEFF2  (DP)  SI TYPCO = UTILISATEUR, COEFF2 = VALEUR DU PIVOT B
!     GAMMAS  (DP)  COEFFICIENT DE SECURITE SUR LA RESISTANCE
!                   DE CALCUL DES ACIERS
!     GAMMAC  (DP)  COEFFICIENT DE SECURITE SUR LA RESISTANCE
!                   DE CALCUL DU BETON
!     FACIER  (DP)  LIMITE D'ELASTICITE DES ACIERS (CONTRAINTE)
!     FBETON  (DP)  RESISTANCE EN COMPRESSION DU BETON (CONTRAINTE)
!     CLACIER (DP)  CLASSE DE DUCTILITE DES ACIERS (POUR L'EC2) :
!                   CLACIER = 0 ACIER PEU DUCTILE (CLASSE A)
!                   CLACIER = 1 ACIER MOYENNEMENT DUCTILE (CLASSE B)
!                   CLACIER = 2 ACIER FORTEMENT DUCTILE (CLASSE C)
!     UC      (DP)  UNITE DES CONTRAINTES :
!                   UC = 0 CONTRAINTES EN Pa
!                   UC = 1 CONTRAINTES EN MPa
!     HT      (DP)  EPAISSEUR DE LA COQUE
!     EFFRTS  (DP-DIM 8) TORSEUR DES EFFORTS ET DES MOMENTS
!
!   PARAMETRES DE SORTIE (RENVOYES A CODE_ASTER)
!
!     DNSITS  (DP-DIM 5) DENSITES DE FERRAILLAGE :
!                   1 A 4 : SURFACES D'ACIER LONGITUDINAL EN CM2/M
!                   5 TRANSVERSAL: EN CM2/M2
!     SIGMBE  (DP)  CONTRAINTE DU BETON
!     EPSIBE  (DP)  DEFORMATION DU BETON
!     IERR    (I)   CODE RETOUR (0 = OK)
!---------------------------------------------------------------------
!
!
    real(kind=8) :: cequi, sigaci, sigbet, coeff1, coeff2, effrts(8), dnsits(5)
    real(kind=8) :: sigmbe, epsibe, ht, enrobi, enrobs, es, gammac, gammas
    real(kind=8) :: facier, fbeton
    integer :: ierr, jepais, jefge, jfer1, jfer2, itab(7), nno
    integer :: typcmb, typco, clacier, uc, ino, icmp, iret, k
    integer :: iadzi, iazk24
!
    call tecael(iadzi, iazk24, noms=0)
!
    call jevech('PCACOQU', 'L', jepais)
    call jevech('PFERRA1', 'L', jfer1)
    call jevech('PFERRA2', 'E', jfer2)
    ht=zr(jepais)
!
    call jevech('PEFFORR', 'L', jefge)
    call tecach('OOO', 'PEFFORR', 'L', iret, nval=7,&
                itab=itab)
    ASSERT(iret.eq.0)
    nno=itab(3)
    ASSERT(nno.gt.0.and.nno.le.9)
    ASSERT(itab(2).eq.8*nno)
!
!       -- CALCUL DE LA CONTRAINTE MOYENNE :
!       ----------------------------------------------
    do icmp = 1, 8
        effrts(icmp) = 0.d0
        do ino = 1, nno
            effrts(icmp) = effrts(icmp) + zr(jefge-1+(ino-1)*8+icmp)/nno
        end do
    end do
!
!       -- RECUPERATION DES DONNEES DE L'UTILISATEUR :
!       ----------------------------------------------
!     FER1_R = TYPCOMB TYPCO  ES  CEQUI ENROBS ENROBI SIGACI SIGBET COEFF1
!                 1      2    3     4      5     6       7     8      9
!              COEFF2 GAMMAS GAMMAC FACIER FBETON CLACIER UC
!                10     11     12     13     14     15    16
    typcmb=nint(zr(jfer1-1+1))
    typco =nint(zr(jfer1-1+2))
    es    =zr(jfer1-1+3)
    cequi =zr(jfer1-1+4)
    enrobs=zr(jfer1-1+5)
    enrobi=zr(jfer1-1+6)
    sigaci=zr(jfer1-1+7)
    sigbet=zr(jfer1-1+8)
    coeff1=zr(jfer1-1+9)
    coeff2=zr(jfer1-1+10)
    gammas=zr(jfer1-1+11)
    gammac=zr(jfer1-1+12)
    facier=zr(jfer1-1+13)
    fbeton=zr(jfer1-1+14)
    clacier=int(zr(jfer1-1+15))
    uc=int(zr(jfer1-1+16))
!
!       -- CALCUL PROPREMENT DIT :
!       --------------------------
!   VERIFICATION DE LA COHERENCE DES PARAMETRES
    if (ht.le.enrobi .or. ht.le.enrobs) then
        call utmess('F', 'CALCULEL_72')
    endif
!
    sigmbe = 0.d0
    epsibe = 0.d0
    do k = 1, 5
        dnsits(k) = 0.d0
    end do
    call clcplq(typcmb, typco, es, cequi, enrobs, enrobi, sigaci, sigbet,&
                coeff1, coeff2, gammas, gammac, facier, fbeton, clacier, uc,&
                ht, effrts, dnsits, sigmbe, epsibe, ierr)
!
!   GESTION DES ALARMES EMISES
!
    if (ierr.eq.1010) then
!       ELU PIVOT B : section trop comprimée, on fixe la densité de ferraillage
!       de l'élément à -1 (sauf transversale)
        call utmess('A', 'CALCULEL_83')
        do k = 1, 4
            dnsits(k) = -1.d0
        end do
    endif
!
    if (ierr.eq.1030) then
!       ELU PIVOT C : section trop comprimée, on fixe la densité de ferraillage
!       de l'élément à -1 (sauf transversale)
        call utmess('A', 'CALCULEL_79')
        do k = 1, 4
            dnsits(k) = -1.d0
        end do
    endif
!
    if (ierr.eq.1040) then
!       ELU BETON TROP CISAILLE : densité transversale fixée à -1 pour l'élément
        call utmess('A', 'CALCULEL_81')
        dnsits(5) = -1.d0
    endif
!
    if (ierr.eq.1050) then
!       ELS PIVOT B : section trop comprimée, on fixe la densité de ferraillage
!       de l'élément à -1 (sauf transversale)
        call utmess('A', 'CALCULEL_84')
        do k = 1, 4
            dnsits(k) = -1.d0
        end do
    endif
!
    if (ierr.eq.1070) then
!       ELS PIVOT C : section trop comprimée, on fixe la densité de ferraillage
!       de l'élément à -1 (sauf transversale)
        call utmess('A', 'CALCULEL_86')
        do k = 1, 4
            dnsits(k) = -1.d0
        end do
    endif
!
    if (ierr.eq.1080) then
!       ELU : au moins une facette est en pivot C et aucune ne dépasse le critère
!       en compression, la densité de ferraillage est fixée à -1 pour l'élément
        call utmess('A', 'CALCULEL_78')
        do k = 1, 5
            dnsits(k) = -1.d0
        end do
    endif
!
    if (ierr.eq.1090) then
!       ELS : au moins une facette est en pivot C et aucune ne dépasse le critère
!       en compression, la densité de ferraillage est fixée à -1 pour l'élément
        call utmess('A', 'CALCULEL_87')
        do k = 1, 5
            dnsits(k) = -1.d0
        end do
    endif
!
!   STOCKAGE DES R2SULTATS
!   FER2_R =  DNSXI DNSXS DNSYI DNSYS DNST SIGMBE EPSIBE
!               1     2     3     4    5     6      7
!
    zr(jfer2-1+1)= dnsits(1)
    zr(jfer2-1+2)= dnsits(3)
    zr(jfer2-1+3)= dnsits(2)
    zr(jfer2-1+4)= dnsits(4)
    zr(jfer2-1+5)= dnsits(5)
    zr(jfer2-1+6)= sigmbe
    zr(jfer2-1+7)= epsibe
!
end subroutine
