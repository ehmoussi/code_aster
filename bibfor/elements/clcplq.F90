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

subroutine clcplq(typcmb, typco, es, cequi, enrobs, enrobi, sigaci,&
                  sigbet, coeff1, coeff2, gammas, gammac, facier,&
                  fbeton, clacier, uc, ht, effrts, dnsits, sigmbe,&
                  epsibe, ierr)

!_____________________________________________________________________
!
!     CLCPLQ
!
!      ARMATURES DANS LES ELEMENTS DE PLAQUE
!
!      I TYPCMB  TYPE DE COMBINAISON (0 = ELU, 1 = ELS)
!      I TYPCO   CODIFICATION UTILISEE
!                (0 = UTILISATEUR, 1 = BAEL91, 2 = EC2)
!      I ES      MODULE D'YOUNG DE L'ACIER
!      I CEQUI   COEFFICIENT D'EQUIVALENCE ACIER/BETON
!      I ENROBS  ENROBAGE DES ARMATURES SUPERIEURES
!      I ENROBI  ENROBAGE DES ARMATURES INFERIEURES
!      I SIGACI  CONTRAINTE ADMISSIBLE DANS L'ACIER
!      I SIGBET  CONTRAINTE ADMISSIBLE DANS LE BETON
!      I COEFF1  SI TYPCO = UTILISATEUR :
!                    COEFF1 = VALEUR DU PIVOT A
!                SI TYPCO = BAEL91 ou EC2 :
!                    COEFF1 = COEFFICIENT ALPHA_CC
!      I COEFF2  SI TYPCO = UTILISATEUR :
!                    COEFF2 = VALEUR DU PIVOT B
!      I GAMMAS  COEFFICIENT DE SECURITE SUR LA RESISTANCE
!                DE CALCUL DES ACIERS
!      I GAMMAC  COEFFICIENT DE SECURITE SUR LA RESISTANCE
!                DE CALCUL DU BETON
!      I FACIER  LIMITE D'ELASTICITE DES ACIERS (CONTRAINTE)
!      I FBETON  RESISTANCE EN COMPRESSION DU BETON (CONTRAINTE)
!      I CLACIER CLASSE DE DUCTILITE DES ACIERS (UTILISE POUR EC2) :
!                    CLACIER = 0 ACIER PEU DUCTILE (CLASSE A)
!                    CLACIER = 1 ACIER MOYENNEMENT DUCTILE (CLASSE B)
!                    CLACIER = 2 ACIER FORTEMENT DUCTILE (CLASSE C)
!      I UC      UNITE DES CONTRAINTES :
!                    UC = 0 CONTRAINTES EN Pa
!                    UC = 1 CONTRAINTES EN MPa
!      I HT      EPAISSEUR DE LA COQUE
!      I EFFRTS  (DIM 8) TORSEUR DES EFFORTS, MOMENTS, ...
!      O DNSITS  (DIM 5) DENSITES
!                    1..4 : SURFACES D'ACIER LONGITUDINAL
!                    5 : TRANSVERSAL
!      O SIGMBE  VALEUR DE CONTRAINTE BETON (ELS)
!      O EPSIBE  VALEUR DE DEFORMATION BETON (ELU)
!      O IERR    CODE RETOUR (0 = OK)
!
!_____________________________________________________________________
!
!
    implicit none
!
!
#include "asterfort/clcels.h"
#include "asterfort/clcelu.h"
#include "asterfort/clcopt.h"
#include "asterfort/clctra.h"
#include "asterfort/trgfct.h"
#include "asterfort/utmess.h"
!
!
    integer :: typcmb
    integer :: typco
    real(kind=8) :: es
    real(kind=8) :: cequi
    real(kind=8) :: enrobs
    real(kind=8) :: enrobi
    real(kind=8) :: sigaci
    real(kind=8) :: sigbet
    real(kind=8) :: coeff1
    real(kind=8) :: coeff2
    real(kind=8) :: gammas
    real(kind=8) :: gammac
    real(kind=8) :: facier
    real(kind=8) :: fbeton
    integer ::  clacier
    integer ::  uc
    real(kind=8) :: ht
    real(kind=8) :: effrts(8)
    real(kind=8) :: dnsits(5)
    real(kind=8) :: sigmbe
    real(kind=8) :: epsibe
    integer :: ierr
!
!
!       NOMBRE DE DIVISIONS ENTRE -PI/2 ET +PI/2
    real(kind=8) :: fcttab(36, 5)
!       NOMBRE DE FACETTES COMPRIMEES EN PIVOT C (ELU ET ELS)
    real(kind=8) :: nb_fac_comp_elu, nb_fac_comp_els
!       EFFORT NORMAL DANS CETTE DIRECTION
    real(kind=8) :: effn
!       EFFORT TRANCHANT DANS CETTE DIRECTION
    real(kind=8) :: efft
!       MOMENT DE FLEXION DANS CETTE DIRECTION
    real(kind=8) :: effm
!       DEFORMATION (ELU)
    real(kind=8) :: epsib
!       DEFORMATION MAXIMUM (ELU)
    real(kind=8) :: epsimx
!       CONTRAINTE (ELS) DU BETON
    real(kind=8) :: sigma
!       CONTRAINTE MAXIMUM (ELS)
    real(kind=8) :: sigmmx
!       DENSITE DE FERRAILLAGE TRANSVERSAL
    real(kind=8) :: dnstra
!       SECTIONS DES ACIERS INFERIEURS SUIVANT LES 36 FCTTAB
    real(kind=8) :: ai(36)
!       SECTIONS DES ACIERS SUPERIEURS SUIVANT LES 36 FCTTAB
    real(kind=8) :: as(36)
!       VARIABLE D'ITERATION
    integer :: i
!
!
!   INITIALISATION DU CODE ERREUR + FACETTE COMPRIMEE PIVOT C
!
    ierr = 0
    nb_fac_comp_elu = 0
    nb_fac_comp_els = 0
!
!   INITIALISATION DES FACETTES
!
    call trgfct(fcttab)
    do 5 i = 1, 5
        dnsits(i) = -1d0
 5  continue
    sigmmx = 0d0
    epsimx = 0d0
!
!   BOUCLE SUR LES FACETTES DE CAPRA ET MAURY
!   DETERMINATION DU FERRAILLAGE POUR CHACUNE DES FACETTES
!
    do 10 i = 1, 36
        effn = fcttab(i,1) * effrts(1) + fcttab(i,2) * effrts(2) + fcttab(i,3) * effrts(3)
        effm = fcttab(i,1) * effrts(4) + fcttab(i,2) * effrts(5) + fcttab(i,3) * effrts(6)
        efft = abs(effrts(7)*fcttab(i,4) + effrts(8)*fcttab(i,5))
!
!       CALCUL A L'ELU
!
        if (typcmb .eq. 0) then
!           CALCUL DES ACIERS DE FLEXION
            call clcelu(typco, coeff1, coeff2, effm, effn, ht, enrobs, enrobi, sigaci,&
                        sigbet, facier, fbeton, gammas, gammac, clacier, es, uc, ai(i),&
                        as(i), epsib, ierr)
            if (epsib .gt. epsimx) epsimx = epsib
!
!           CALCUL DU FERRAILLAGE TRANSVERSAL
            call clctra(typco, effrts, effn, effm, efft, ht, enrobs, enrobi, facier,&
                        fbeton, sigaci, coeff1, gammac, gammas, uc, dnstra, ierr)
!           Récupération de la sectiond transversale maximale
            if (dnstra.gt.dnsits(5)) then
                dnsits(5) = dnstra
            endif
!
!           GESTION DES ALARMES EMISES A L'ELU
            if (ierr.eq.1010) then
!               Facette en pivot B trop comprimée !
!               Alarme dans te0146 + on sort de la boucle + densité = -1 pour l'élément
                goto 999
            endif
            if (ierr .eq. 1020) then
!              Facette en pivot C : Alarme dans te0146 + densité = -1 pour cet élément
               call utmess('A', 'CALCULEL_77')
                nb_fac_comp_elu = nb_fac_comp_elu + 1
            endif
            if (ierr.eq.1030) then
!               Facette en pivot C trop comprimée !
!               Alarme dans te0146 + on sort de la boucle + densité = -1 pour l'élément
                goto 999
            endif
            if (ierr.eq.1040) then
!               Aciers transversaux : béton trop cisaillé !
!               Alarme dans te0146 + on sort de la boucle + densité = -1 pour l'élément
                goto 999
            endif
!
!       CALCUL A L'ELS
!
        else
!           CALCUL DES ACIERS DE FLEXION
            call clcels(cequi, effm, effn, ht, enrobs, enrobi, sigaci, sigbet,&
                        ai(i), as(i), sigma, ierr)
!
!           GESTION DES ALARMES EMISES A L'ELS
            if (ierr.eq.1050) then
!               Facette en pivot B trop comprimée !
!               Alarme dans te0146 + on sort de la boucle + densité = -1 pour l'élément
                goto 999
            endif
            if (ierr .eq. 1060) then
!              Facette en pivot C : Alarme dans te0146 + densité = -1 pour cet élément
               call utmess('A', 'CALCULEL_85')
                nb_fac_comp_els = nb_fac_comp_els + 1
            endif
            if (ierr.eq.1070) then
!               Facette en pivot c trop comprimée !
!               Alarme dans te0146 + on sort de la boucle + densité = -1 pour l'élément
                goto 999
            endif
            if (sigma.gt.sigbet) then
                call utmess('F', 'CALCULEL_80')
                goto 999
            endif
            if (sigma .gt. sigmmx) sigmmx = sigma
            if (ierr .ne. 0) goto 999
        endif
10  continue
!
!   GESTION DES ALARMES EMISES POUR TOUTES LES FACETTES
    if (nb_fac_comp_elu .gt. 0) then
!       ELU : au moins une facette est en pivot C et aucune ne dépasse le critère
!       en compression : Alarme dans te0146 + densité de ferraillage fixée à -1
        ierr = 1080
        goto 999
    endif
!
    if (nb_fac_comp_els .gt. 0) then
!       ELS : au moins une facette est en pivot C et aucune ne dépasse le critère
!       en compression : Alarme dans te0146 + densité de ferraillage fixée à -1
        ierr = 1090
        goto 999
    endif
!
    if (typcmb .eq. 0) then
        epsibe = epsimx
    else
        sigmbe = sigmmx
    endif
!
!   OPTIMISATION DES FERRAILLAGES
!
    call clcopt(fcttab, ai, dnsits(1), dnsits(2))
    call clcopt(fcttab, as, dnsits(3), dnsits(4))
!
999  continue
end subroutine
