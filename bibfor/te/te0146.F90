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

subroutine te0146(option, nomte)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/clcplq.h"
#include "asterfort/jevech.h"
#include "asterfort/tecach.h"
#include "asterfort/tecael.h"
#include "asterfort/utmess.h"
!
    character(len=16) :: option, nomte
!
!.....................................................................
!  BUT: CALCUL DE L'OPTION FERRAILLAGE POUR LES ELEMENTS DE COQUE
!.....................................................................
!_____________________________________________________________________
!
! CALCUL DES DENSITES DE FERRAILLAGE DANS LE BETON ARME
!              (METHODE DE CAPRA ET MAURY)
!
! VERSION DU 31/11/2018
!_____________________________________________________________________
!
! PARAMETRES D'ECHANGE ENTRE CODE_ASTER ET CLCPLQ 
! (POINT D'ENTREE DU CALCUL DE FERRAILLAGE PAR CAPRA ET MAURY)
!
!   PARAMETRES D'ENTREE (FOURNIS PAR CODE_ASTER)
!
!     TYPCMB     TYPE DE COMBINAISON :
!                   0 = ELU, 1 = ELS
!     TYPCO      TYPE DE CODIFICATION :
!                   1 = BAEL91, 2 = EUROCODE 2
!     VALOCOMP   VALORISATION DE LA COMPRESSION POUR LES ACIERS TRANSVERSAUX
!                   0 = COMPRESSION NON PRISE EN COMPTE
!                   1 = COMPRESSION PRISE EN COMPTE
!     CEQUI      COEFFICIENT D'EQUIVALENCE ACIER/BETON
!     ENROBS     ENROBAGE DES ARMATURES SUPERIEURES
!     ENROBI     ENROBAGE DES ARMATURES INFERIEURES
!     SIGACI     CONTRAINTE ADMISSIBLE DANS L'ACIER
!     SIGBET     CONTRAINTE ADMISSIBLE DANS LE BETON
!     ALPHACC    COEFFICIENT DE SECURITE SUR LA RESISTANCE
!                   DE CALCUL DU BETON EN COMPRESSION
!     GAMMAS     COEFFICIENT DE SECURITE SUR LA RESISTANCE
!                   DE CALCUL DES ACIERS
!     GAMMAC     COEFFICIENT DE SECURITE SUR LA RESISTANCE
!                   DE CALCUL DU BETON
!     FACIER     LIMITE D'ELASTICITE DES ACIERS (CONTRAINTE)
!     FBETON     RESISTANCE EN COMPRESSION DU BETON (CONTRAINTE)
!     CLACIER    CLASSE DE DUCTILITE DES ACIERS (POUR L'EC2) :
!                   CLACIER = 0 ACIER PEU DUCTILE (CLASSE A)
!                   CLACIER = 1 ACIER MOYENNEMENT DUCTILE (CLASSE B)
!                   CLACIER = 2 ACIER FORTEMENT DUCTILE (CLASSE C)
!     UC         UNITE DES CONTRAINTES :
!                   0 = CONTRAINTES EN Pa
!                   1 = CONTRAINTES EN MPa
!     HT         EPAISSEUR DE LA COQUE
!     RHOACIER   MASSE VOLUMIQUE DES ACIERS
!     EFFRTS     TORSEUR DES EFFORTS ET DES MOMENTS (DIM 8)
!
!   PARAMETRES DE SORTIE (RENVOYES A CODE_ASTER)
!
!     DNSITS     DENSITES DE FERRAILLAGE (DIM 5) :
!                   1 A 4 : ACIER LONGITUDINAL (EN M2/M)
!                   5 ACIERS TRANSVERSAUX (EN M2/M2)
!     DNSVOL     DENSITE VOLUMIQUE D'ARMATURE (Kg/M3)
!     CONSTRUC   INDICATEUR DE COMPLEXITE DE CONSTRUCTIBILITE (-)
!     IERR       CODE RETOUR (0 = OK)
!---------------------------------------------------------------------
!
!
    real(kind=8) :: cequi, sigaci, sigbet, alphacc, effrts(8), dnsits(5)
    real(kind=8) :: ht, enrobi, enrobs, gammac, gammas
    real(kind=8) :: facier, fbeton, rhoacier, dnsvol, areinf, ashear
    real(kind=8) :: astirr, rhocrit, datcrit, lcrit, construc
    real(kind=8) :: reinf, shear, stirrups, unite
    integer :: ierr, jepais, jefge, jfer1, jfer2, itab(7), nno
    integer :: typcmb, typco, clacier, uc, ino, icmp, iret, k
    integer :: iadzi, iazk24, compress
!
    call tecael(iadzi, iazk24, noms=0)
!
    call jevech('PCACOQU', 'L', jepais)
    call jevech('PFERRA1', 'L', jfer1)
    call jevech('PFERRA2', 'E', jfer2)
    ht = zr(jepais)
!
    call jevech('PEFFORR', 'L', jefge)
    call tecach('OOO', 'PEFFORR', 'L', iret, nval=7, itab=itab)
    ASSERT(iret.eq.0)
    nno = itab(3)
    ASSERT(nno.gt.0.and.nno.le.9)
    ASSERT(itab(2).eq.8*nno)
!
!       -- CALCUL DE LA CONTRAINTE MOYENNE :
!       ------------------------------------
!
    do icmp = 1, 8
        effrts(icmp) = 0.d0
        do ino = 1, nno
            effrts(icmp) = effrts(icmp) + zr(jefge-1+(ino-1)*8+icmp)/nno
        end do
    end do
!
!       -- RECUPERATION DES DONNEES DE L'UTILISATEUR :
!       ----------------------------------------------
!     FER1_R = TYPCOMB TYPCO  COMPRESS CEQUI ENROBS ENROBI SIGACI SIGBET ALPHACC
!                 1      2      3        4      5     6       7     8      9
!              GAMMAS GAMMAC FACIER FBETON CLACIER UC RHOACIER AREINF ASHEAR
!                10     11     12     13     14    15    16      17     18
!              ASTIRR RHOCRIT DATCRIT LCRIT
!                19     20      21     22
!
    typcmb = nint(zr(jfer1-1+1))
    typco = nint(zr(jfer1-1+2))
    compress = int(zr(jfer1-1+3))
    cequi = zr(jfer1-1+4)
    enrobs = zr(jfer1-1+5)
    enrobi = zr(jfer1-1+6)
    sigaci = zr(jfer1-1+7)
    sigbet = zr(jfer1-1+8)
    alphacc = zr(jfer1-1+9)
    gammas = zr(jfer1-1+10)
    gammac = zr(jfer1-1+11)
    facier = zr(jfer1-1+12)
    fbeton = zr(jfer1-1+13)
    clacier = int(zr(jfer1-1+14))
    uc = int(zr(jfer1-1+15))
    rhoacier = zr(jfer1-1+16)
    areinf = zr(jfer1-1+17)
    ashear = zr(jfer1-1+18)
    astirr = zr(jfer1-1+19)
    rhocrit = zr(jfer1-1+20)
    datcrit = zr(jfer1-1+21)
    lcrit = zr(jfer1-1+22)
!
!       -- CALCUL PROPREMENT DIT :
!       --------------------------
!
!   VERIFICATION DE LA COHERENCE DES PARAMETRES
    if (ht.le.enrobi .or. ht.le.enrobs) then
        call utmess('F', 'CALCULEL_72')
    endif
!
!       -- INITIALISATION DES VARIABLES DE SORTIES :
!       --------------------------------------------
!
    dnsvol = 0.d0
    construc = 0.d0
    do k = 1, 5
        dnsits(k) = 0.d0
    end do
!
    call clcplq(typcmb, typco, compress, cequi, enrobs, enrobi, sigaci, sigbet,&
                alphacc, gammas, gammac, facier, fbeton, clacier,&
                uc, ht, effrts, dnsits, ierr)
!
    if (uc.eq.0) then
        unite = 1.d0
    else if (uc.eq.1) then
        unite = 1e-3
    endif
!
!       -- CALCUL DE LA DENSITE VOLUMIQUE D'ARMATURE :
!       ----------------------------------------------
!
    if (rhoacier.gt.0) then
        dnsvol = rhoacier*(dnsits(1)+dnsits(2)+dnsits(3)+dnsits(4)+dnsits(5)*ht*unite)/(ht*unite)
        if (dnsits(5).eq.-1.d0) then
!           Vrai uniquement pour le calcul du ferraillage transversal au BAEL
!           (pour lequel les aciers d'effort tranchant ne sont pas calculés)
            dnsvol = rhoacier*((dnsits(1)+dnsits(2)+dnsits(3)+dnsits(4)))/(ht*unite)
        endif
    else
        dnsvol = -1.d0
    endif
!
!       -- CALCUL DE L'INDICATEUR DE CONSTRUCTIBILITE :
!       -----------------------------------------------
!
    if (rhoacier.gt.0) then
        reinf = areinf*dnsvol/rhocrit
        shear = ashear*dnsits(5)/datcrit
        if (shear.lt.0.d0) shear = 0.d0
        stirrups = astirr*dnsits(5)*(ht-enrobs-enrobi)/(datcrit*lcrit)
        if (stirrups.lt.0.d0) stirrups = 0.d0
        construc = (reinf+shear+stirrups)/(areinf+ashear+astirr)
    else
        construc = -1.d0
    endif
!
!       -- GESTION DES ALARMES EMISES :
!       -------------------------------
!
    if (ierr.eq.1010) then
!       ELU PIVOT B : section trop comprimée
!       on fixe toutes les densités de ferraillage de l'élément à -1
        call utmess('A', 'CALCULEL_83')
        do k = 1, 5
            dnsits(k) = -1.d0
            dnsvol = -1.d0
            construc = -1.d0
        end do
    endif
!
    if (ierr.eq.1030) then
!       ELU PIVOT C : section trop comprimée
!       on fixe toutes les densités de ferraillage de l'élément à -1
        call utmess('A', 'CALCULEL_79')
        do k = 1, 5
            dnsits(k) = -1.d0
            dnsvol = -1.d0
            construc = -1.d0
        end do
    endif
!
    if (ierr.eq.1040.or.ierr.eq.1100) then
!       ELU BETON TROP CISAILLE : densité transversale fixée à -1 pour l'élément
        call utmess('A', 'CALCULEL_81')
        dnsits(5) = -1.d0
        dnsvol = -1.d0
        construc = -1.d0
    endif
!
    if (ierr.eq.1050) then
!       ELS PIVOT B : section trop comprimée
!       on fixe toutes les densités de ferraillage de l'élément à -1
        call utmess('A', 'CALCULEL_84')
        do k = 1, 5
            dnsits(k) = -1.d0
            dnsvol = -1.d0
            construc = -1.d0
        end do
    endif
!
    if (ierr.eq.1070) then
!       ELS PIVOT C : section trop comprimée
!       on fixe toutes les densités de ferraillage de l'élément à -1
        call utmess('A', 'CALCULEL_86')
        do k = 1, 5
            dnsits(k) = -1.d0
            dnsvol = -1.d0
            construc = -1.d0
        end do
    endif
!
    if (ierr.eq.1080) then
!       ELU : au moins une facette est en pivot C et aucune ne dépasse le critère
!       en compression, la densité de ferraillage est fixée à -1 pour l'élément
        call utmess('A', 'CALCULEL_78')
        do k = 1, 5
            dnsits(k) = -1.d0
            dnsvol = -1.d0
            construc = -1.d0
        end do
    endif
!
    if (ierr.eq.1090) then
!       ELS : au moins une facette est en pivot C et aucune ne dépasse le critère
!       en compression, la densité de ferraillage est fixée à -1 pour l'élément
        call utmess('A', 'CALCULEL_87')
        do k = 1, 5
            dnsits(k) = -1.d0
            dnsvol = -1.d0
            construc = -1.d0
        end do
    endif
!
    if (ierr.eq.1100) then
!       ELS BETON TROP CISAILLE : densité transversale fixée à -1 pour l'élément
!        call utmess('A', 'CALCULEL_81')
        write(6,*) 'alarme'
        dnsits(5) = -1.d0
        dnsvol = -1.d0
        construc = -1.d0
    endif
!
!       -- STOCKAGE DES RESULTATS DANS FER2 :
!       -------------------------------------
!   FER2_R =  DNSXI DNSXS DNSYI DNSYS DNST DNSVOL CONSTRUC
!               1     2     3     4    5     6       7
!
    zr(jfer2-1+1)= dnsits(1)
    zr(jfer2-1+2)= dnsits(3)
    zr(jfer2-1+3)= dnsits(2)
    zr(jfer2-1+4)= dnsits(4)
    zr(jfer2-1+5)= dnsits(5)
    zr(jfer2-1+6)= dnsvol
    zr(jfer2-1+7)= construc
!
end subroutine
