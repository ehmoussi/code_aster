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

subroutine preml2(n1, diag, col, delg, xadj1,&
                  adjnc1, estim, adress, parend, fils,&
                  frere, anc, nouv, supnd, dhead,&
                  qsize, llist, marker, invsup, local,&
                  global, lfront, nblign, decal, lgsn,&
                  debfac, debfsn, seq, lmat, adpile,&
                  chaine, suiv, place, nbass, ncbloc,&
                  lgbloc, nbloc, lgind, nbsnd, ier)
! person_in_charge: olivier.boiteau at edf.fr
! aslint: disable=W1304,W1504
    implicit none
#include "asterfort/facsmb.h"
#include "asterfort/infniv.h"
#include "asterfort/mltblc.h"
#include "asterfort/mltpas.h"
#include "asterfort/mltpos.h"
    integer :: col(*)
    integer :: n1, diag(0:n1), adpile(n1), estim, lgind
    integer :: xadj1(n1+1), adjnc1(*), decal(*), mxfact
    integer :: delg(*), adress(*), parend(*)
    integer(kind=4) :: local(*), global(*)
    integer :: fils(n1), frere(n1)
    integer :: lfront(n1), nblign(n1), lgsn(n1), debfac(n1+1), debfsn(n1)
    integer :: chaine(n1), suiv(n1), place(n1), nbass(n1)
    integer :: anc(n1), nouv(n1), supnd(n1), ier
    integer :: invsup(n1), lmat, seq(n1)
    integer :: ncbloc(*), lgbloc(*), nbloc
!     VARIABLES LOCALES
    integer :: dhead(*), qsize(*), llist(*), marker(*)
    integer :: nbsnd, i, long
    integer :: ifm, niv
!
!
!------------------------------------------------------------
!     1) A PARTIR DE DIAG ET COL -> ADJNC1 AVEC TOUS
!     LES DDL ASTER 1:N1
!     2) CALCUL DE ADJNC2 EN ENLEVANT LES LAMBDA
!     DE LAGRANGE 1:N2
!     (1:N1) -> (1:N2) PAR NUM P EN SENS INVERSE PAR NUM Q
!     3) POUR CHQE REL.LIN. I,RL(1,I) = LAMBD1 RL(2,I) = LAMBD2
!     POUR LES BLOCAGES : LBD1(NOBL) = NO DU LAMBDA1
!     QUI BLOQUE LE DDL NOBL
!     4) GENMMD SUR ADJNC2
!     5) POUR LES REL.LIN.,ON FAIT RL1(I)=LAMBD1,I ETANT
!     LE DDL DE REL.LIN.
!     DONT L'IMAGE PAR LA NOUVELLE NUMEROTATION EST
!     L'INF DES DDL. ENCADRES
!     6) ON ECRIT LA NOUVELLE NUMEROTATION DE TOUS LES DDL
!     APRES GENMMD
!     => TAB NOUV ET ANC (1:N1) <-> (1:N2)
!     --> AVEC LES R.L. ON CREE UN NOUVEAU SUPERND EGAL
!     AU LAMBDA1 DE LA
!     RELATION.(EN EFFET  ON NE PEUT PAS TOUJOURS
!     L'AMALGAMER AU PREMIER
!     SN ENCADRE PAR CE LAMBDA1 !! )
!     LAMBDA2 LUI EST AMALGAME AU DERNIER ND ENCADRE
!     NBSND : NBRE DE SND AVEC LES LAMBDA1 = NBSN + NRL
!
!     PARENTD REPRESENTE LE NOUVEL ARBRE D'ELIMINATION
!     RQE GENERALE AVEC LES REL.LIN. ON UTILISE LA DONNEE SUIVANTE :
!     LES DDL ENCADRES SONT DEFINIS PAR
!     ( COL(J),J=DIAG(LAMBDA2-1)+2,DIAG(LAMBDA2)-1 )
!----------------------------------- FACTORISATION SYMBOLIQUE
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    diag(0) = 0
!*************************************************************
!*************************************************************
    call facsmb(n1, nbsnd, supnd, invsup, parend,&
                xadj1, adjnc1, anc, nouv, fils,&
                frere, local, global, adress, lfront,&
                nblign, lgsn, debfac, debfsn, chaine,&
                place, nbass, delg, lgind, ier)
    if (ier .ne. 0) goto 999
!*************************************************************
!*************************************************************
!
!-----RECUPERATION DU NIVEAU D'IMPRESSION
!
    call infniv(ifm, niv)
!------------------------------------------------------------
!     IF (NIV.EQ.1) THEN
!     WRITE(IFM,*)'FACTORISATION SYMBOLIQUE: '//
!     *  'TEMPS CPU',TEMPS(3),
!     *  ' + TEMPS CPU SYSTEME ',TEMPS(6)
!     ENDIF
    if (niv .eq. 2) then
        write(ifm,*)'RESULTATS DE FACSMB '//&
     &        'LONGUEUR DE LA FACTORISEE ',(debfac(n1+1)-1)
    endif
!     EVALUATION DE MXFACT
    mxfact = 0
    do 110 i = 1, nbsnd
        long = debfsn(1+i) - debfsn(i)
        mxfact = max(long,mxfact)
110  end do
!-------------------------------ESTIMATION DE LA PILE
!*************************************************************
!*************************************************************
    call mltpos(nbsnd, parend, fils, frere, adpile,&
                lfront, seq, dhead, estim, qsize,&
                suiv, marker, llist)
!*************************************************************
!*************************************************************
!
    if (niv .eq. 2) then
!     WRITE(IFM,*)'RENUMEROTATION DE L''ARBRE D''ELIMI'//
!     +            'NATION:'//
!     *  'TEMPS CPU',TEMPS(3),
!     *  ' + TEMPS CPU SYSTEME ',TEMPS(6)
        write(ifm,*)'RESULTATS DE MLTPOS '// ' LONGUEUR DE LA PILE ',&
        estim
    endif
!-----------------------------------CALCUL DE LA REPARTITION
!     EN BLOCS
    call mltblc(nbsnd, debfsn, mxfact, seq, nbloc,&
                decal, lgbloc, ncbloc)
!--------------------------------CALCUL DES ADRESSES DES
    if (niv .eq. 2) then
        write(ifm,*)'RESULTATS DE MLTBLC '// 'NBRE DE BLOCS ',nbloc
        do 120 i = 1, nbloc
            write(ifm,*)'LONGUEUR DU BLOC ',i, ': ',lgbloc(i),&
            'NOMBRE DE SUPERNOEUDS DU BLOC ',i, ': ',ncbloc(i)
120      continue
    endif
!     COEFFICIENTS INITIAUX
!*************************************************************
!*************************************************************
    call mltpas(n1, nbsnd, supnd, xadj1, adjnc1,&
                anc, nouv, seq, global, adress,&
                nblign, lgsn, nbloc, ncbloc, lgbloc,&
                diag, col, lmat, place)
!     PRNO,DEEQ,NEC,LBD2,NRL,RL,MARKER)
!
!*************************************************************
!*************************************************************
!     IF (NIV.EQ.2) THEN
!     WRITE(IFM,*)'POINTEUR DES TERMES INITIAUX: '//
!     *   'TEMPS CPU',TEMPS(3),
!     *   ' + TEMPS CPU SYSTEME ',TEMPS(6)
!     ENDIF
999  continue
end subroutine
