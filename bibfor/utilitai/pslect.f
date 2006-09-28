      SUBROUTINE PSLECT ( MOTFAC, IOCC, BASENO, STPRIN, TYPERR,
     &                    NBPASE, INPSCO, CODRET )
C
C     PARAMETRES SENSIBLES - LECTURES
C     *          *           ****
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C     LIT LES PARAMETRES DE SENSIBILITE POUR LA COMMANDE EN COURS
C     CELA EST APPLICABLE AU COURS DU TRAITEMENT D'UNE COMMANDE
C ----------------------------------------------------------------------
C IN  MOTFAC  : NOM DU MOT CLE FACTEUR ASSOCIE
C               CHAINE BLANCHE POUR LE MOT-CLE SIMPLE SEUL
C IN  IOCC    : NUMERO D'OCCURENCE DU MOT-CLE FACTEUR
C IN  BASENO  : BASE DU NOM DES STRUCTURES DERIVEES
C IN  STPRIN  : NOM DE LA STRUCTURE PRINCIPALE
C IN  TYPERR  : COMPORTEMENT EN CAS D'ERREUR :
C               0 : ON RESSORT AVEC LE CODE DE RETOUR CODRET
C               NON NUL : ERREUR FATALE
C OUT NBPASE  : NOMBRE DE PARAMETRES DE SENSIBILITE
C OUT INPSCO  : STRUCTURE CONTENANT LA LISTE DES NOMS
C               VOIR LA DEFINITION DANS SEGICO
C OUT CODRET  : CODE DE RETOUR, 0 SI TOUT VA BIEN, NON NUL SINON
C ----------------------------------------------------------------------
C
      IMPLICIT   NONE
C
C 0.1. ==> ARGUMENTS
C
      INTEGER NBPASE, IOCC
      INTEGER TYPERR, CODRET
      CHARACTER*8 BASENO
      CHARACTER*(*) INPSCO
      CHARACTER*(*) MOTFAC, STPRIN
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
      PARAMETER ( NOMPRO = 'PSLECT' )
C
      INTEGER IAUX
C
      CHARACTER*3 TYPE
      CHARACTER*16 MOTCLE
      CHARACTER*24 LIPASE
C
C====
C 1. LECTURE DES ARGUMENTS DU MOT-CLE
C====
C
C               12   345678   9012345678901234
      LIPASE = '&&'//NOMPRO//'_PARA_SENSI     '
C
C               1234567890123456
      MOTCLE = 'SENSIBILITE     '
      CALL UTGETV ( MOTFAC, MOTCLE, IOCC, LIPASE, NBPASE, TYPE )
C
C====
C 2. CREATION DES INFORMATIONS SUR LA SENSIBILITE
C====
C
      CALL SEGICO ( 1,
     &              BASENO, NBPASE, LIPASE, STPRIN,
     &              INPSCO, IAUX, CODRET )
C
C====
C 3. MENAGE
C====
C
      IF ( CODRET.NE.0 ) THEN
        IF ( TYPERR.NE.0 ) THEN
          CALL U2MESS('F','ALGORITH6_34')
        ENDIF
      ENDIF
C
      CALL JEDETR ( LIPASE )
C
      END
