      SUBROUTINE PSMENF ( CHOIX, TYPFON, NOMFON, IRET )
C
C     PARAMETRES SENSIBLES - MEMORISATION DES NOMS DES FONCTIONS
C     *          *           **               *        *
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 01/07/2003   AUTEUR GNICOLAS G.NICOLAS 
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
C     ------------------------------------------------------------------
C     MEMORISE LES NOMS DES FONCTIONS FIGEES UTILES AUX CALCULS
C     DE SENSIBILITE
C     C'EST UN TABLEAU DE K8.
C     A LA PLACE NUMERO I, ON TROUVE LE NOM DE LA FONCTION DE TYPE I,
C     I ETANT POSITIF OU NUL.
C     LA SIGNIFICATION DE CE TYPE DE FONCTION EST ETABLIE DANS OP0129
C     QUI DECODE LA COMMANDE MEMO_NOM_SENSI
C     ------------------------------------------------------------------
C IN  CHOIX   : /'E' : ON ECRIT DANS LA STRUCTURE DE MEMORISATION
C               /'L' : ON LIT   DANS LA STRUCTURE DE MEMORISATION
C IN  TYPFON  : TYPE DE LA FONCTION
C I/O NOMFON  : NOM DE LA FONCTION
C    SI CHOIX='E' : NOMFON EST UNE DONNEE
C                   SI NOMFON EST DEJA RENSEIGNE => ERREUR <F>
C    SI CHOIX='L' : NOMFON EST UNE SORTIE
C OUT IRET    : CODE_RETOUR :
C                     0 -> TOUT S'EST BIEN PASSE
C                     1 -> LE TYPE DE FONCTION N'EST PAS RENSEIGNE
C                     2 -> LA STRUCTURE DE MEMORISATION EST INCONNUE
C
C     ------------------------------------------------------------------
C
      IMPLICIT NONE
C
C 0.1. ==> ARGUMENTS
C
      CHARACTER*1 CHOIX
      INTEGER TYPFON
      CHARACTER*8 NOMFON
      INTEGER IRET
C
C 0.2. ==> COMMUNS
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'PSMENF' )
C
      CHARACTER*13 PREFIX
C
      INTEGER IAUX
      INTEGER ADMEMO, IEX
      INTEGER LONMAX, LGMINI
C
      CHARACTER*8 SAUX08
      CHARACTER*18 NOMSTR
C
C     ------------------------------------------------------------------
C====
C 1. PREALABLES
C====
C
      CALL JEMARQ()
C
      CALL SEMECO ( 'PREFIXE', SAUX08, SAUX08,
     >               PREFIX,
     >               SAUX08, IAUX, SAUX08, SAUX08, SAUX08,
     >               IRET )
C
      NOMSTR = PREFIX // '.NOMF'
C                         45678
C
      LGMINI = TYPFON + 1
      IRET = 0
C
C====
C 2. EN ECRITURE
C    . SI LA STRUCTURE N'EXISTE PAS, ELLE EST ALLOUEE AU NOMBRE MAXIMUM
C    . SI ELLE EXISTE, ON L'ALLONGE EVENTUELLEMENT SI LE TYPE DE LA
C      FONCTION A MEMORISER EST SUPERIEUR A CEUX DEJA PRESENTS.
C====
C
      IF ( CHOIX.EQ.'E' ) THEN
C
        IF ( TYPFON.LT.0 ) THEN
          CALL UTDEBM ( 'A', NOMPRO, 'TYPFON DOIT ETRE POSITIF OU NUL.')
          CALL UTIMPI ( 'L', 'MAIS IL VAUT ', 1, TYPFON )
          CALL UTFINM
          CALL UTMESS ( 'F', NOMPRO, 'ERREUR DE PROGRAMMATION')
        ENDIF
C
        CALL JEEXIN ( NOMSTR, IEX )
        IF ( IEX.EQ.0 ) THEN
          CALL WKVECT ( NOMSTR, 'G V K8', LGMINI, ADMEMO )
        ELSE
          CALL JELIRA ( NOMSTR, 'LONMAX', LONMAX, SAUX08 )
          IF ( LGMINI.GT.LONMAX ) THEN
            CALL JUVECA ( NOMSTR, LGMINI )
          ENDIF
          CALL JEVEUO ( NOMSTR, 'E', ADMEMO )
        ENDIF
C
        IF ( ZK8(ADMEMO+TYPFON).NE.'        ' ) THEN
          CALL UTDEBM ( 'A', NOMPRO, 'LA FONCTION')
          CALL UTIMPI ( 'L', 'NUMERO ', 1, TYPFON )
          CALL UTFINM
          CALL UTMESS ( 'F', NOMPRO,
     >                  'EST DEJA MEMORISEE : '//ZK8(ADMEMO+TYPFON))
        ENDIF
        ZK8(ADMEMO+TYPFON) = NOMFON
C
C====
C 3. EN LECTURE
C====
C
      ELSEIF ( CHOIX.EQ.'L' ) THEN
C
        CALL JEEXIN ( NOMSTR, IEX )
C
        IF ( IEX.EQ.0 ) THEN
          IRET = 2
        ELSE
          CALL JELIRA ( NOMSTR, 'LONMAX', LONMAX, SAUX08 )
          IF ( LGMINI.GT.LONMAX ) THEN
            IRET = 1
          ELSE
            CALL JEVEUO ( NOMSTR, 'L', ADMEMO )
            NOMFON = ZK8(ADMEMO+TYPFON)
            IF ( NOMFON.EQ.'        ' ) THEN
              IRET = 1
            ENDIF
          ENDIF
        ENDIF
C
        IF ( IRET.NE.0 ) THEN
          NOMFON = '????????'
        ENDIF
C
C====
C 4. MAUVAIX CHOIX
C====
C
      ELSE
        CALL UTMESS ( 'A', NOMPRO, 'CHOIX=/E/L SVP.')
        CALL UTMESS ( 'F', NOMPRO, 'ERREUR DE PROGRAMMATION')
      ENDIF
C
      CALL JEDEMA()
C
      END
