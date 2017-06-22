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

subroutine cgleff(typfis, nomfis, fonoeu, chfond, basfon,&
                  taillr, conf, lnoff)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jedupo.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/xrecff.h"
!
    character(len=8) :: typfis, nomfis
!
! person_in_charge: samuel.geniaut at edf.fr
!
!     SOUS-ROUTINE DE L'OPERATEUR CALC_G
!
!     BUT : LECTURE DE LA DESCRIPTION DU FOND DE FISSURE
!           -> CREATION DES OBJETS FONOEU, CHFOND ET BASFON
!           -> CALCUL DU NOMBRE DE NOEUDS (POINTS) DU FOND : LNOFF
!
!           X-FEM : TRAITEMENT DES MOTS-CLES NUME_FOND ET NB_POINT_FOND
!
!  IN :
!     TYPFIS : TYPE DE LA SD DECRIVANT LE FOND DE FISSURE
!            ('THETA' OU 'FONDIFSS' OU 'FISSURE')
!     NOMFIS : NOM DE LA SD DECRIVANT LE FOND DE FISSURE
!
!  OUT
!     FONOEU : NOMS DES NOEUDS DU FOND DE FISSURE
!     CHFOND : COORDONNES DES POINTS/NOEUDS DU FOND DE FISSURE
!     BASFON : BASE LOCALE AU FOND DE FISSURE
!     TAILLR : TAILLES DES MAILLES CONNECTEES AUX NOEUDS
!     CONF   : CONFIGURATION DE LA FISSURE EN FEM
!     LNOFF  : NOMBRE DE NOEUDS (OU POINTS) DU FOND DE FISSURE
!
! ======================================================================
!
    character(len=8) :: conf
    character(len=24) :: fonoeu, chfond, basfon, taillr
    character(len=24) :: noeuin, fondin, basein
    integer :: ier, lnoff
!
    call jemarq()
!
!     INITIALISATION DES OBJETS PROPRES A CALC_G
!
!     1) FONOEU = NOM DES NOEUDS DU FOND DE FISSURE
    fonoeu = '&&0100.FONDNOEU'
!
!     2) CHFOND = COORDONNEES DES POINTS/NOEUDS DU FOND DE FISSURE
    chfond = '&&0100.FONDFISS'
!
!     3) BASFON = BASE LOCALE AU FOND DE FISSURE
    basfon = '&&0100.BASEFOND'
!
!     4) TAILLR = TAILLES DES MAILLES CONNECTEES AUX NOEUDS
    taillr = '&&0100.TAILLR'
!
    conf = '        '
!
    if (typfis .eq. 'THETA') then
!
!       SI THETA : ON NE PEUT RIEN REMPLIR
!
!       RAJOUTER LA REGLE CAPY EXCLUS THETA ET NUME_FOND
!       RAJOUTER LA REGLE CAPY EXCLUS FOND_FISS ET NUME_FOND
!
    else if (typfis.eq.'FONDFISS') then
!
!       1) VERIF : FONOEU = NOM DES NOEUDS DU FOND DE FISSURE
        noeuin=nomfis//'.FOND.NOEU'
!
!       VERIF D'EXISTENCE (CET OBJET DOIT NORMALEMENT EXISTER CAR
!       LE CAS DES FONDS DOUBLES EST INTERDIT)
        call jeexin(noeuin, ier)
        ASSERT(ier.ne.0)
!
!       2) VERIF : CHFOND = COORDONNEES DES POINTS/NOEUDS DU FOND DE FISSURE
        fondin=nomfis//'.FONDFISS'
!
!       VERIF D'EXISTENCE (CET OBJET DOIT NORMALEMENT EXISTER)
        call jeexin(fondin, ier)
        ASSERT(ier.ne.0)
!
!       3) VERIF : BASEFON = BASE LOCALE AU FOND DE FISSURE
        basein=nomfis//'.BASEFOND'
!
!       VERIF D'EXISTENCE (CET OBJET N'EXISTE QUE SI CONFIG_INIT='COLLEE')
        call dismoi('CONFIG_INIT', nomfis, 'FOND_FISS', repk=conf)
        if (conf .eq. 'COLLEE') then
            call jeexin(basein, ier)
            ASSERT(ier.ne.0)
        endif
        
!       4) CREATION DE LA LISTE DES POINTS DU FOND A CALCULER
!       EN PRENANT EN COMPTE LES MOTS-CLES NUME_FOND ET NB_POINT_FOND
        call xrecff(nomfis, typfis, chfond, basfon, fonoeu, lnoff, conf)
!
!       5) TAILLR = TAILLES DES MAILLES CONNECTEES AUX NOEUDS
        taillr = nomfis//'.FOND.TAILLE_R'
! ======================================================================
!       CET OBJET N'EXISTE QUE SI CONFIG_INIT='COLLEE'
        if (conf .eq. 'COLLEE') then
            call jeexin(taillr, ier)
            ASSERT(ier.ne.0)
        endif
!
    else if (typfis.eq.'FISSURE') then
!
!       1) FONOEU N'EXISTE PAS EN X-FEM
!
!       2) VERIF : CHFOND = COORDONNEES DES POINTS/NOEUDS DU FOND DE FISSURE
        fondin=nomfis//'.FONDFISS'
!
!       VERIF D'EXISTENCE (CET OBJET DOIT NORMALEMENT EXISTER)
        call jeexin(fondin, ier)
        ASSERT(ier.ne.0)
!
!       3) VERIF : BASEFON = BASE LOCALE AU FOND DE FISSURE
        basein=nomfis//'.BASEFOND'
!
!       VERIF D'EXISTENCE (CET OBJET DOIT NORMALEMENT EXISTER)
        call jeexin(basein, ier)
        ASSERT(ier.ne.0)
!
!       4) CREATION DE LA LISTE DES POINTS DU FOND A CALCULER
!       EN PRENANT EN COMPTE LES MOTS-CLES NUME_FOND ET NB_POINT_FOND
        call xrecff(nomfis, typfis, chfond, basfon, fonoeu, lnoff, conf)
!
!       5) TAILLR = TAILLES DES MAILLES CONNECTEES AUX NOEUDS
        taillr = nomfis//'.FOND.TAILLE_R'
!
    endif
!
    call jedema()
!
end subroutine
