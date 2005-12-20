      SUBROUTINE PSRESE ( MOTFAC, IOCC, TYPRES, RESULT, TYPERR,
     >                    NBPASS, NORECG, CODRET )
C
C     PARAMETRES SENSIBLES - RESULTAT - SENSIBILITE
C     *          *           **         **
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 17/06/2002   AUTEUR GNICOLAS G.NICOLAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR   
C (AT YOUR OPTION) ANY LATER VERSION.                                 
C
C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT 
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF          
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU    
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.                            
C
C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE   
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,       
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.      
C ======================================================================
C RESPONSABLE GNICOLAS G.NICOLAS
C ----------------------------------------------------------------------
C     POUR LA COMMANDE EN COURS, SOUS LE MOT-CLE FACTEUR MOTFAC,
C     ON A (EVENTUELLEMENT) DEFINI DES PARAMETRES DE SENSIBILITE AVEC
C     LE MOT-CLE SIMPLE HABITUEL.
C     CE PROGRAMME RETOURNE :
C     . LE NOMBRE DE PASSAGES A FAIRE POUR LES POST-TRAITEMENTS
C     . UN TABLEAU CONTENANT DES COUPLES (NOM COMPOSE, NOM DU PARAMETRE
C       SENSIBLE), LE NOM COMPOSE ETANT BATI A PARTIR DU RESULTAT DONNE
C     SI LE RESULTAT N'EST PAS DEFINI OU SI AUCUN PARAMETRE SENSIBLE
C     N'EST PRESENT, LE TABLEAU SE LIMITE A UN COUPLE (RESULTAT,BLANC) ;
C     ON RENVOIE ALORS NBPASS = 1
C     CELA EST APPLICABLE AU COURS DU TRAITEMENT D'UNE COMMANDE
C ----------------------------------------------------------------------
C IN  MOTFAC  : NOM DU MOT CLE FACTEUR ASSOCIE
C               CHAINE BLANCHE POUR LE MOT-CLE SIMPLE SEUL
C IN  IOCC    : NUMERO D'OCCURENCE DU MOT-CLE FACTEUR
C IN  TYPRES  : 1. ON EXPLOITE UN RESULTAT
C               2. ON EXPLOITE UNE GRANDEUR
C IN  RESULT  : RESULTAT PRINCIPAL
C IN  TYPERR  : COMPORTEMENT EN CAS D'ERREUR :
C               0 : ON RESSORT AVEC LE CODE DE RETOUR CODRET
C               NON NUL : ERREUR FATALE
C OUT NBPASS  : NOMBRE DE PASSAGES EN POST-TRAITEMENT
C OUT NORECG  : STRUCTURE QUI CONTIENT LES NBPASS COUPLES
C               (NOM COMPOSE, NOM DU PARAMETRE SENSIBLE)
C               ELLE N'EST PAS ALLOUEE EN ENTREE DE CE PROGRAMME ; ELLE
C               LE SERA EN SORTIE
C OUT CODRET  : CODE DE RETOUR, 0 SI TOUT VA BIEN, NON NUL SINON
C ----------------------------------------------------------------------
C
      IMPLICIT   NONE
C
C 0.1. ==> ARGUMENTS
C
      INTEGER IOCC, TYPRES, NBPASS
      INTEGER TYPERR, CODRET
C
      CHARACTER*(*) MOTFAC, NORECG, RESULT
C
C 0.2. ==> COMMUNS
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'PSRESE' )
C
      INTEGER LXLGUT
C
      INTEGER NBPASE
      INTEGER ADRECG, IAUX
C
C====
C 1. RECHERCHE DU NOMBRE DE PARAMETRES SENSIBLES
C    REMARQUE : SI NBPASE EST NON NUL, PSNOCO ALLOUERA ET REMPLIRA
C               LA STRUCTURE NORECG
C====
C
      IF ( TYPRES.EQ.1 ) THEN
C
        CALL PSNOCO ( MOTFAC, IOCC, RESULT, TYPERR,
     >                NBPASE, NORECG, CODRET )
C
      ELSEIF ( TYPRES.EQ.2 ) THEN
        NBPASE = 0
        CODRET = 0
C
      ELSE
C
        CALL UTDEBM ( 'A', NOMPRO, 'TYPRES DOIT VALOIR 1 OU 2,' )
        CALL UTIMPI ( 'S', 'MAIS ON A DONNE ', 1, TYPRES )
        CALL UTFINM
        CALL UTMESS ( 'F', NOMPRO, 'ERREUR DE PROGRAMMATION' )
C
      ENDIF
C
C====
C 2. NOMBRE DE PASSAGES
C====
C
      IF ( CODRET.EQ.0 ) THEN
C
C 2.1. ==> LE NOMBRE DE PASSAGES VAUT AU MINIMUM 1
C
      NBPASS = MAX(NBPASE,1)
C
C 2.2. ==> CREATION D'UNE STRUCTURE SIMPLIFIEE SI PAS DE SENSIBILITE
C
      IF ( NBPASE.EQ.0 ) THEN
C
        CALL WKVECT ( NORECG, 'V V K24', 2*NBPASS, ADRECG )
C                         123456789012345678901234
        ZK24(ADRECG)   = '                        '
        ZK24(ADRECG+1) = '                        '
        IAUX = LXLGUT(RESULT)
        ZK24(ADRECG)(1:IAUX) = RESULT(1:IAUX)
C
      ENDIF
C
      ENDIF
C
      END
