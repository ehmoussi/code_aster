      SUBROUTINE JEDUPC ( CLAIN, SCHIN, IPOS, CLAOUT, SCHOUT, DUPCOL)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF JEVEUX  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*(*)       CLAIN, SCHIN,       CLAOUT, SCHOUT
      INTEGER                           IPOS
      LOGICAL                                                 DUPCOL
C ----------------------------------------------------------------------
C     RECOPIE LES OBJETS DE LA CLASSE CLAIN POSSEDANT LA SOUS-CHAINE
C     SCHIN EN POSITION IPOS DANS LA CLASSE CLAOUT AVEC LA SOUS-CHAINE
C     DISTINCTE SCHOUT
C
C IN  CLAIN  : NOM DE LA CLASSE EN ENTREE (' ' POUR TOUTES LES BASES)
C IN  SCHIN  : SOUS-CHAINE EN ENTREE
C IN  IPOS   : POSITION DE LA SOUS-CHAINE
C IN  CLAOUT : NOM DE LA CLASSE EN SORTIE
C IN  SCHOUT : SOUS-CHAINE EN SORTIE
C IN  DUPCOL : .TRUE. DUPLIQUE LES OBJETS PARTAGEABLES D'UNE COLLECTION
C              .FALSE. S'ARRETE SUR ERREUR
C
C ----------------------------------------------------------------------
      CHARACTER *6     PGMA
      COMMON /KAPPJE/  PGMA
      PARAMETER  ( N = 5 )
      CHARACTER*2      DN2
      CHARACTER*5      CLASSE
      CHARACTER*8                  NOMFIC    , KSTOUT    , KSTINI
      COMMON /KFICJE/  CLASSE    , NOMFIC(N) , KSTOUT(N) , KSTINI(N) ,
     &                 DN2(N)
      INTEGER          NRHCOD    , NREMAX    , NREUTI
      COMMON /ICODJE/  NRHCOD(N) , NREMAX(N) , NREUTI(N)
      CHARACTER*1      GENR    , TYPE
      CHARACTER*4      DOCU
      CHARACTER*8      ORIG
      CHARACTER*32     RNOM
      COMMON /KATRJE/  GENR(8) , TYPE(8) , DOCU(2) , ORIG(1) , RNOM(1)
      COMMON /JKATJE/  JGENR(N), JTYPE(N), JDOCU(N), JORIG(N), JRNOM(N)
      INTEGER          L1,L2,J,ICIN
      CHARACTER*75     CMESS
      CHARACTER*32     NOMIN,NOMOUT,SCHOU2
      CHARACTER*1      KCLAS

C DEB ------------------------------------------------------------------
      PGMA = 'JEDUPC'
C
      L1 = LEN ( SCHIN )
      IF ( IPOS + L1 .GT. 25 .OR. IPOS .LT. 0 .OR. L1 .EQ. 0 ) THEN
        CMESS = ' LONGUEUR OU POSITION DE LA SOUS-CHAINE '//SCHIN//
     &          ' INVALIDE'
        CALL U2MESK('S','JEVEUX_01',1,CMESS)
      ENDIF
      L2 = LEN ( SCHOUT)
      SCHOU2=SCHOUT
C
      IF ( L1 .NE. L2 ) THEN
        CMESS = ' LONGUEUR DE LA SOUS-CHAINE '//SCHOUT//
     &          ' DIFFERENTE DE LA SOUS-CHAINE '//SCHIN
        CALL U2MESK('S','JEVEUX_01',1,CMESS)
      ENDIF
C
      IF ( IPOS + L2 .GT. 25 .OR. IPOS .LT. 0 .OR. L2 .EQ. 0 ) THEN
        CMESS = ' LONGUEUR OU POSITION DE LA SOUS-CHAINE '//SCHIN//
     &          ' INVALIDE'
        CALL U2MESK('S','JEVEUX_01',1,CMESS)
      ENDIF
      IF ( SCHIN(1:L1) .EQ. SCHOUT(1:L2) ) THEN
        CMESS = ' SOUS-CHAINES IDENTIQUES :'//SCHIN//' : '//SCHOUT
        CALL U2MESK('S','JEVEUX_01',1,CMESS)
      ENDIF
C
      KCLAS = CLAIN (1:MIN(1,LEN(CLAIN)))
      IF ( KCLAS .EQ. ' ' ) THEN
        NCLA1 = 1
        NCLA2 = INDEX ( CLASSE , '$' ) - 1
        IF ( NCLA2 .LT. 0 ) NCLA2 = N
      ELSE
        NCLA1 = INDEX ( CLASSE , KCLAS)
        NCLA2 = NCLA1
      ENDIF
      DO 100 ICIN = NCLA1 , NCLA2
        KCLAS = CLASSE(ICIN:ICIN)
        DO 150 J=1,NREMAX(ICIN)
          NOMIN = RNOM(JRNOM(ICIN)+J)
          IF ( NOMIN(1:1) .EQ. '?' .OR.
     &         NOMIN(25:32) .NE. '        ' ) GOTO 150
          IF ( SCHIN .EQ. NOMIN(IPOS:IPOS+L1-1) ) THEN
            NOMOUT = NOMIN
            NOMOUT = NOMOUT(1:IPOS-1)//SCHOU2(1:L2)//NOMOUT(IPOS+L1:32)
            CALL JEDUPO(NOMIN, CLAOUT, NOMOUT, DUPCOL)
          ENDIF
 150    CONTINUE
 100  CONTINUE
C FIN ------------------------------------------------------------------


      END
