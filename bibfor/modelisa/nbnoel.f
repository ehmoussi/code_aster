      SUBROUTINE NBNOEL(CHAR  ,NOMA  ,TYPENT,NGRMA ,NMA   ,
     &                  CALCMA,INDQUA,INPROJ,NBMA  ,NBNO  ,
     &                  NBNOQU)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 10/09/2007   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*8 CHAR
      CHARACTER*8 NOMA
      CHARACTER*8 TYPENT
      INTEGER     NGRMA,NMA
      CHARACTER*8 CALCMA(*)
      INTEGER     INDQUA,INPROJ
      INTEGER     NBMA,NBNO,NBNOQU
C     
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (TOUTES METHODES - LECTURE DONNEES)
C
C NOMBRE DE MAILLES, DE NOEUDS ET DE NOEUDS QUADRATIQUES DE GROUPES DE
C MAILLE OU DE MAILLES
C      
C ----------------------------------------------------------------------
C
C
C IN  CHAR   : NOM UTILISATEUR DU CONCEPT DE CHARGE
C IN  NOMA   : NOM DU MAILLAGE
C IN  TYPENT : MOT-CLE (GROUP_MA ou MAILLE)
C IN  NGRMA  : NOMBRE DE GROUP_MA DANS LE MOT-CLE
C IN  NMA    : NOMBRE DE MAILLES DANS LE MOT-CLE
C IN  CALCMA : VECTEUR DE CHARACTER*8 DE TRAVAIL
C              CONTIENT SOIT LE NOM DES GROUP_MA, SOIT LE NOM DES
C              MAILLES
C IN  INDQUA : VAUT 0 LORSQUE L'ON DOIT PRENDRE LES NOEUDS MILIEUX
C              VAUT 1 LORSQUE L'ON DOIT IGNORER LES NOEUDS MILIEUX
C IN  INPROJ : VAUT 2 SI PROJECTION = QUADRATIQUE
C              VAUT 1 SI PROJECTION = LINEAIRE
C OUT NBMA   : NOMBRE DE MAILLES
C OUT NBNO   : NOMBRE DE NOEUDS
C OUT NBNOQU : NOMBRE DE NOEUDS QUADRATIQUES
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      CHARACTER*32 JEXNUM,JEXNOM
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER IATYMA,ITYP,NUTYP,JGRO,NBMAIL,NUMAIL
      INTEGER NOEUSO,NOEUMI,N1
      INTEGER IGRMA,IMA
      INTEGER IBID,IER
      CHARACTER*1  K1BID
      CHARACTER*8  NOMTM,NOMO
      CHARACTER*19 LIGRMO
      CHARACTER*24 GRMAMA,MAILMA
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C 
      MAILMA = NOMA(1:8)//'.NOMMAI'
      GRMAMA = NOMA(1:8)//'.GROUPEMA'
      NBNO   = 0
      NBNOQU = 0
      NBMA   = 0
      CALL JEVEUO(NOMA(1:8)//'.TYPMAIL','L',IATYMA)
      CALL DISMOI('F','NOM_MODELE',CHAR(1:8),'CHARGE',IBID,
     &            NOMO,IER)
      LIGRMO = NOMO(1:8)//'.MODELE'
C
C --- COMPTAGE DES NOEUDS
C
      IF (TYPENT.EQ.'GROUP_MA') THEN
        DO 50 IGRMA = 1,NGRMA
          CALL JEVEUO(JEXNOM(GRMAMA,CALCMA(IGRMA)),'L',JGRO)
          CALL JELIRA(JEXNOM(GRMAMA,CALCMA(IGRMA)),'LONMAX',
     &                NBMAIL,K1BID)
          NBMA = NBMA + NBMAIL
          DO 40 IMA = 1,NBMAIL
            NUMAIL = ZI(JGRO-1+IMA)
            ITYP   = IATYMA - 1 + NUMAIL
            NUTYP  = ZI(ITYP)
            CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',NUTYP),NOMTM)
            CALL JELIRA(JEXNUM(NOMA//'.CONNEX',NUMAIL),'LONMAX',N1,
     &                  K1BID)
            CALL NBNOCP(LIGRMO,NOMTM ,N1    ,NUMAIL,INDQUA,
     &                  INPROJ,NOEUMI,NOEUSO)
            NBNO   = NBNO   + NOEUSO
            NBNOQU = NBNOQU + NOEUMI
   40     CONTINUE
   50   CONTINUE
      ELSE IF (TYPENT.EQ.'MAILLE') THEN
        NBMA = NMA
        DO 90 IMA = 1,NBMA
          CALL JENONU(JEXNOM(MAILMA,CALCMA(IMA)),NUMAIL) 
          ITYP  = IATYMA - 1 + NUMAIL
          NUTYP = ZI(ITYP)       
          CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',NUTYP),NOMTM)
          CALL JELIRA(JEXNUM(NOMA//'.CONNEX',NUMAIL),'LONMAX',N1,
     &                K1BID)
          CALL NBNOCP(LIGRMO,NOMTM ,N1    ,NUMAIL,INDQUA,
     &                INPROJ,NOEUMI,NOEUSO)
          NBNO   = NBNO + NOEUSO
          NBNOQU = NBNOQU + NOEUMI
   90   CONTINUE
      END IF
      CALL JEDEMA()
      END
