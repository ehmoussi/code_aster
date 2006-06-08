      SUBROUTINE PSTYST ( NBMCSR, NBMC, COREFE, MCREFE,
     >                    NBMOSI, LIMOSI, LIVALE, LIMOFA,
     >                    STYPSE )
C
C     PARAMETRE SENSIBLE - TYPE DE SENSIBILITE - SOUS-TYPE
C     *         *          **                    *    *
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 01/07/2003   AUTEUR GNICOLAS G.NICOLAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.         
C ======================================================================
C RESPONSABLE GNICOLAS G.NICOLAS
C ----------------------------------------------------------------------
C IN  NBMCSR  : NOMBRE DE MOTS-CLES DE REFERENCE
C IN  NBMC    : NOMBRE DE MOTS-CLES EQUIVALENTS
C IN  COREFE  : LISTE DES CODE DE REFERENCE
C IN  MCREFE  : LISTE DES MOTS-CLES DE REFERENCE, A LA SUITE LES UNS
C               DES AUTRES
C IN  NBMOSI  : NOMBRE DE MOTS-CLES SIMPLES CORRESPONDANT A UN
C               PARAMETRE SENSIBLE UTILISE
C IN  LIMOSI  : LA STRUCTURE K80 CONTENANT LES MOTS-CLES CONCERNES
C IN  LIVALE  : LA STRUCTURE K80 CONTENANT LES VALEURS CONCERNEES
C IN  LIMOFA  : LA STRUCTURE K80 CONTENANT LES MOTS-CLES FACTEURS
C OUT STYPSE  : SOUS-TYPE DE SENSIBILITE
C ----------------------------------------------------------------------
C     ARBORESCENCE DE LA GESTION DES PARAMETRES SENSIBLES :
C  NTTYSE --!
C  METYSE --> PSTYSE --> PSTYPR --> SEGICO
C
C  NTTYSE --!
C  METYSE --> PSTYSS --> PSREMC --> SEMECO
C                    --> PSTYST
C  NTDOTH --!
C  NMDOME --> PSTYPA --> SEGICO
C                    --> PSREMC --> SEMECO
C ----------------------------------------------------------------------
C
      IMPLICIT   NONE
C
C 0.1. ==> ARGUMENTS
C
      INTEGER NBMCSR, NBMC(NBMCSR), NBMOSI
C
      CHARACTER*24 COREFE(NBMCSR), MCREFE(*)
      CHARACTER*(*) LIMOSI, LIVALE, LIMOFA
      CHARACTER*24 STYPSE
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
      PARAMETER ( NOMPRO = 'PSTYST' )
C
      INTEGER IAUX, JAUX, KAUX
      INTEGER NUMERO
      INTEGER LG1, LG2
      INTEGER ADMOSI, ADVALE, ADMOFA
C
      INTEGER LXLGUT
C
C====
C 1. DECODAGE
C====
C
      CALL JEVEUO ( LIMOSI, 'L', ADMOSI )
                    CALL JEVEUO ( LIMOFA, 'L', ADMOFA )
                    CALL JEVEUO ( LIVALE, 'L', ADVALE )
C
C BOUCLE 11 : ON PARCOURT TOUS LES MOTS-CLES A EXAMINER
C
      DO 11 , IAUX = 1 , NBMOSI
C
CGN      PRINT *,NOMPRO,', MOT-CLE SIMPLE ',IAUX,' :
CGN     >  ',ZK80(ADMOSI+IAUX-1)
CGN      PRINT *,'... MOT-CLE FACTEUR : ',ZK80(ADMOFA+IAUX-1)
CGN      PRINT *,'... VALEUR : ',ZK80(ADVALE+IAUX-1)
        LG1 = LXLGUT (ZK80(ADMOSI+IAUX-1))
C
C BOUCLE 111 : POUR LE MOT-CLE SIMPLE ZK80(ADMOSI+IAUX-1) CORRESPONDANT
C              AU IAUX-IEME PARAMETRE SENSIBLE, ON PARCOURT LES
C              NBMCSR TYPES DE MOTS-CLES SIMPLES DE REFERENCE
C
        NUMERO = 0
C
        DO 111 , JAUX = 1 , NBMCSR
C
C BOUCLE 112 : POUR LE MOT-CLE ZK80(ADMOSI+IAUX-1) ET POUR LE TYPE DE
C              MOTS-CLES DE REFERENCE COREFE(JAUX), ON PARCOURT TOUS
C              LES MOTS-CLES DE REFERENCE POSSIBLES
C
          DO 112 , KAUX = 1 , NBMC(JAUX)
            NUMERO = NUMERO + 1
            LG2 = LXLGUT(MCREFE(NUMERO))
C
C           ON A TROUVE UN MOT-CLE SIMPLE DE LA MEME LONGUEUR
C
            IF ( LG1.EQ.LG2 ) THEN
C
C             ON A TROUVE LE MOT-CLE IDENTIQUE
C
              IF ( ZK80(ADMOSI+IAUX-1)(1:LG1).EQ.
     >             MCREFE(NUMERO)(1:LG1) ) THEN
                LG1 = LXLGUT(STYPSE)
C
C               AUCUN SOUS-TYPE N'A ETE ENREGISTRE : ON DECLARE QUE
C               C'EST CELUI DE CE MOT-CLE DE REFERENCE ET ON PASSE AU
C               MOT-CLE A TRAITER SUIVANT (BOUCLE 11)
C
                IF ( LG1.EQ.0 ) THEN
                  STYPSE = COREFE(JAUX)
                  GOTO 11
                ELSE
C
C               UN SOUS-TYPE A DEJA ETE ENREGISTRE :
C               . SI C'EST CELUI DE CE MOT-CLE DE REFERENCE, ON PASSE
C                 AU MOT-CLE A TRAITER SUIVANT (BOUCLE 11)
C               . SI C'EST UN AUTRE MOT-CLE, IL Y A ERREUR
C
                  LG2 = LXLGUT(COREFE(JAUX))
                  IF ( LG1.EQ.LG2 .AND.
     >                 STYPSE(1:LG1).EQ.COREFE(JAUX) ) THEN
                    GOTO 11
                  ELSE
                    CALL JEVEUO ( LIVALE, 'L', ADVALE )
                    CALL JEVEUO ( LIMOFA, 'L', ADMOFA )
                    CALL UTMESS ( 'A', NOMPRO,
     >     'LES SOUS-TYPES DE SENSIBILITE POUR L''INFLUENCE DE '
     >     //ZK80(ADVALE+IAUX-1)//' SONT INCOHERENTS.' )
                    CALL UTMESS ( 'A', NOMPRO,
     >      'ON A '//STYPSE(1:LG1)//' ET '//COREFE(JAUX))
                    CALL UTMESS ( 'F', NOMPRO, 'ERREUR DE DONNEES' )
                  ENDIF
                ENDIF
              ENDIF
            ENDIF
C
  112     CONTINUE
C
  111   CONTINUE
C
C       SI ON ARRIVE ICI, IL Y A ERREUR : AUCUN TYPE N'A PU ETRE TROUVE
C
        CALL JEVEUO ( LIVALE, 'L', ADVALE )
        CALL UTMESS ( 'A', NOMPRO,
     >     'IMPOSSIBLE DE TROUVER UN SOUS-TYPE DE SENSIBILITE POUR'//
     >     ' L''INFLUENCE DE ' //ZK80(ADVALE+IAUX-1) )
        CALL UTMESS ( 'F', NOMPRO, 'ERREUR DE PROGRAMMATION' )
C
   11 CONTINUE
C
      END
