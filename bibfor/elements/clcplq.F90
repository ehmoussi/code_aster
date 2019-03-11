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

subroutine clcplq(typcmb, typco, compress, cequi, enrobs, enrobi, sigaci,&
                  sigbet, alphacc, gammas, gammac, facier,&
                  fbeton, clacier, uc, ht, effrts, dnsits, ierr)

!_____________________________________________________________________
!
!     CLCPLQ
!
!      CALCUL DES ARMATURES EN ACIER DANS LES ELEMENTS DE PLAQUE
!
!      I TYPCMB   TYPE DE COMBINAISON (0 = ELU, 1 = ELS)
!      I COMPRESS CODIFICATION UTILISEE (1 = BAEL91, 2 = EC2)
!      I VALCP    VALORISATION DE LA COMPRESSION POUR LES ACIERS TRANSVERSAUX
!                 (0 = NON, 1 = OUI)
!      I CEQUI    COEFFICIENT D'EQUIVALENCE ACIER/BETON
!      I ENROBS   ENROBAGE DES ARMATURES SUPERIEURES
!      I ENROBI   ENROBAGE DES ARMATURES INFERIEURES
!      I SIGACI   CONTRAINTE ADMISSIBLE DANS L'ACIER
!      I SIGBET   CONTRAINTE ADMISSIBLE DANS LE BETON
!      I ALPHACC  COEFFICIENT DE SECURITE SUR LA RESISTANCE
!                 DE CALCUL DU BETON EN COMPRESSION
!      I GAMMAS   COEFFICIENT DE SECURITE SUR LA RESISTANCE
!                 DE CALCUL DES ACIERS
!      I GAMMAC   COEFFICIENT DE SECURITE SUR LA RESISTANCE
!                 DE CALCUL DU BETON
!      I FACIER   LIMITE D'ELASTICITE DES ACIERS (CONTRAINTE)
!      I FBETON   RESISTANCE EN COMPRESSION DU BETON (CONTRAINTE)
!      I CLACIER  CLASSE DE DUCTILITE DES ACIERS (UTILISE POUR EC2) :
!                     CLACIER = 0 ACIER PEU DUCTILE (CLASSE A)
!                     CLACIER = 1 ACIER MOYENNEMENT DUCTILE (CLASSE B)
!                     CLACIER = 2 ACIER FORTEMENT DUCTILE (CLASSE C)
!      I UC       UNITE DES CONTRAINTES :
!                     UC = 0 CONTRAINTES EN Pa
!                     UC = 1 CONTRAINTES EN MPa
!      I HT       EPAISSEUR DE LA COQUE
!      I EFFRTS   (DIM 8) TORSEUR DES EFFORTS, MOMENTS, ...
!
!      O DNSITS   (DIM 5) DENSITES
!                     1..4 : SURFACES D'ACIER LONGITUDINAL
!                     5 : TRANSVERSAL
!      O IERR     CODE RETOUR (0 = OK)
!
!_____________________________________________________________________
!
!
    implicit none
!
!
#include "asterfort/cafelu.h"
#include "asterfort/cafels.h"
#include "asterfort/clcopt.h"
#include "asterfort/cftelu.h"
#include "asterfort/cftels.h"
#include "asterfort/trgfct.h"
#include "asterfort/utmess.h"
!
!
    integer :: typcmb
    integer :: typco
    integer :: compress
    real(kind=8) :: cequi
    real(kind=8) :: enrobs
    real(kind=8) :: enrobi
    real(kind=8) :: sigaci
    real(kind=8) :: sigbet
    real(kind=8) :: alphacc
    real(kind=8) :: gammas
    real(kind=8) :: gammac
    real(kind=8) :: facier
    real(kind=8) :: fbeton
    integer ::  clacier
    integer ::  uc
    real(kind=8) :: ht
    real(kind=8) :: effrts(8)
    real(kind=8) :: dnsits(5)
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
!       DENSITE DE FERRAILLAGE TRANSVERSAL
    real(kind=8) :: dnstra
!       SECTIONS DES ACIERS INFERIEURS SUIVANT LES 36 FACETTES
    real(kind=8) :: ai(36)
!       SECTIONS DES ACIERS SUPERIEURS SUIVANT LES 36 FACETTES
    real(kind=8) :: as(36)
!       VARIABLE D'ITERATION
    integer :: i
!
!
!   INITIALISATION DES VARIABLES
!
    ierr = 0
    nb_fac_comp_elu = 0
    nb_fac_comp_els = 0
!
!   INITIALISATION DES FACETTES
!
    call trgfct(fcttab)
    do 5 i = 1, 5
        dnsits(i) = -1.d0
 5  continue
!
!   BOUCLE SUR LES FACETTES DE CAPRA ET MAURY
!   DETERMINATION DU FERRAILLAGE POUR CHACUNE DES FACETTES
!
    do 10 i = 1, 36
        effn = fcttab(i,1) * effrts(1) + fcttab(i,2) * effrts(2) + fcttab(i,3) * effrts(3)
        effm = fcttab(i,1) * effrts(4) + fcttab(i,2) * effrts(5) + fcttab(i,3) * effrts(6)
        efft = abs(effrts(7)*fcttab(i,4) + effrts(8)*fcttab(i,5))
!
!       CALCUL DU FERRAILLAGE A L'ELU
!
        if (typcmb .eq. 0) then
!           CALCUL DES ACIERS DE FLEXION A L'ELU
            call cafelu(typco, alphacc, effm, effn, ht, enrobs, enrobi, facier,&
                        fbeton, gammas, gammac, clacier, uc, ai(i), as(i), ierr)
!
!           GESTION DES ALARMES EMISES POUR LES ACIERS DE FLEXION A L'ELU
            if (ierr.eq.1010) then
!               Facette en pivot B trop comprimée !
!               Alarme dans te0146 + on sort de la boucle + densité = -1 pour l'élément
                goto 999
            endif
            if (ierr .eq. 1020) then
!              Facette en pivot C sans dépassement du critère trop comprimée
!              Alarme dans te0146 + densité = -1 pour cet élément
               call utmess('A', 'CALCULEL_77')
                nb_fac_comp_elu = nb_fac_comp_elu + 1
            endif
            if (ierr.eq.1030) then
!               Facette en pivot C trop comprimée !
!               Alarme dans te0146 + on sort de la boucle + densité = -1 pour l'élément
                goto 999
            endif
!
!           CALCUL DU FERRAILLAGE TRANSVERSAL A L'ELU
            if (ierr.eq.0) then
!               Calcul si aucune alarne émise pour les aciers de flexion
                call cftelu(typco, effrts, effn, effm, efft, ht, enrobs, enrobi, facier,&
                            fbeton, alphacc, gammac, gammas, uc, compress, dnstra, ierr)
!               Récupération de la densité d'acier d'effort tranchant maximale
                if (dnstra.gt.dnsits(5)) then
                    dnsits(5) = dnstra
                endif
!
!               GESTION DES ALARMES EMISES POUR LE FERRAILLAGE TRANSVERSAL A L'ELU
                if (ierr.eq.1040) then
!                   Béton trop cisaillé !
!                   Alarme dans te0146 + on sort de la boucle + dnstra = -1 pour l'élément
                    goto 999
                endif
            endif
!
!       CALCUL DU FERRAILLAGE A L'ELS
!
        else
!           CALCUL DES ACIERS DE FLEXION A L'ELS
            call cafels(cequi, effm, effn, ht, enrobs, enrobi, sigaci, sigbet,&
                        uc, ai(i), as(i), ierr)
!
!           GESTION DES ALARMES EMISES POUR LES ACIERS DE FLEXION A L'ELS
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
!
!           CALCUL DU FERRAILLAGE TRANSVERSAL A L'ELS
            if (ierr.eq.0) then
!               Calcul si aucune alarne émise pour les aciers de flexion
                call cftels(typco, effn, effm, efft, ht, fbeton, sigbet, sigaci, enrobs,&
                            enrobi, uc, compress, dnstra, ierr)
!               Récupération de la sectiond transversale maximale
                if (dnstra.gt.dnsits(5)) then
                    dnsits(5) = dnstra
                endif
            endif
!
!           GESTION DES ALARMES EMISES POUR LE FERRAILLAGE TRANSVERSAL A L'ELS
                if (ierr.eq.1100) then
!                   Béton trop cisaillé !
!                   Alarme dans te0146 + on sort de la boucle + dnstra = -1 pour l'élément
                    goto 999
                endif
        endif
10  continue
!
!   GESTION DES ALARMES EMISES POUR TOUTES LES FACETTES
    if (nb_fac_comp_elu.gt.0.d0) then
!       ELU : au moins une facette est en pivot C et aucune ne dépasse le critère
!       en compression : Alarme dans te0146 + densité de ferraillage fixée à -1
        ierr = 1080
        goto 999
    endif
!
    if (nb_fac_comp_els.gt.0.d0) then
!       ELS : au moins une facette est en pivot C et aucune ne dépasse le critère
!       en compression : Alarme dans te0146 + densité de ferraillage fixée à -1
        ierr = 1090
        goto 999
    endif
!
!   OPTIMISATION DES FERRAILLAGES
!
    call clcopt(fcttab, ai, dnsits(1), dnsits(2))
    call clcopt(fcttab, as, dnsits(3), dnsits(4))
!
999  continue
end subroutine
