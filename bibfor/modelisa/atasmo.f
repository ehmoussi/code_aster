      SUBROUTINE ATASMO(AZ,NUMEDZ,ATAZ,BASEZ,NBLIG)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 18/04/2005   AUTEUR VABHHTS J.PELLET 
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
      IMPLICIT NONE

C     ATASMO  --  LE BUT DE CETTE ROUTINE EST DE CREER LA MATR_ASSE
C                 DE NOM ATA.
C                 LE .VALE DE CETTE MATR_ASSE VA CONTENIR LES TERMES
C                 DU PRODUIT DE MATRICES AT*A.
C                 A EST 'CONCEPTUELLEMENT' UNE MATRICE RECTANGLE
C                 DE 'HAUTEUR' NBLIG ET DE LARGEUR NEQ.
C                 A EST 'INFORMATIQUEMENT' UNE COLLECTION NUMEROTEE
C                 COMPORTANT NBLIG OBJETS QUI SONT DES VECTEURS DE REELS
C                 DE LONGUEUR NEQ.
C                 CHACUN DE CES VECTEURS EST UNE LIGNE DE LA MATRICE A.
C                 LA MATR_ASSE ATA VA DONC ETRE SYMETRIQUE ET A
C                 VALEURS REELLES. D'AUTRE PART ON VA LUI AFFECTER
C                 UN PROFIL MORSE.

C   ARGUMENT        E/S  TYPE         ROLE
C    AZ              IN    K*     NOM DE LA COLLECTION DES VECTEURS
C                                 LIGNES (I.E. AZ EST LA MATRICE
C                                 RECTANGULAIRE POUR LAQUELLE ON VA
C                                 CALCULER LE PRODUIT AZ_T*AZ).
C    NUMEDZ         IN    K*      NOM DU NUME_DDL DECRIVANT LES
C                                 LIGNES DE LA MATRICE AZ
C    ATAZ           OUT    K*     NOM DE LA MATR_ASSE SYMETRIQUE
C                                 A VALEURS REELLES DONT LE .VALE
C                                 CONTIENT LE PRODUIT AT*A.
C                                 LE PROFIL DE CETTE MATRICE EST
C                                 EN LIGNE DE CIEL.
C                                 CE PROFIL EST DETERMINE DANS LA
C                                 ROUTINE.
C    BASEZ           IN    K*     NOM DE LA BASE SUR LAQUELLE ON
C                                 CREE LA MATR_ASSE.
C.========================= DEBUT DES DECLARATIONS ====================
C ----- COMMUNS NORMALISES  JEVEUX
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8,MA
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*32 JEXNUM,JEXNOM,JEXATR
C -----  ARGUMENTS
      CHARACTER*(*) AZ,NUMEDZ,ATAZ,BASEZ
C -----  VARIABLES LOCALES
      INTEGER J,K,IIMAX,JHBID,IDSUIV,DIMACV,JACNBT,JCONL,NBLIG2
      INTEGER JAC1ER,ILIG,IDLIGM,NDDLT,JACV,JACI,IILIB,IDLM,IDDL,JDDL
      INTEGER IEQ,JHCOL,NEQ,NBLIG,JADIA,NCOEF,JVALE,DECAL,IER,JREFA,KK
      INTEGER JABLO,JIABL,I,JDESC,JREFE,IBID,II1,II2,III,II,JJ
      CHARACTER*1 K1BID,BASE
      CHARACTER*14 NUMDDL,NUMEDD
      CHARACTER*19 ATA
      CHARACTER*24 KHCOL,KADIA,KABLO,KIABL,KDESC,KREFA,KCONL,KVALE
      CHARACTER*24 KREFE,A,KSUIV,KHBID
      REAL*8 UN,VI,VJ,VIJ

C ========================= DEBUT DU CODE EXECUTABLE ==================
      CALL JEMARQ()


C --- 1. INITIALISATIONS :
C     ---------------------
      BASE = BASEZ
      A = AZ
      ATA = ATAZ
      NUMEDD = NUMEDZ
      CALL GCNCON('_',NUMDDL)
      CALL DETRSD('MATR_ASSE',ATA)
      CALL DETRSD('NUME_DDL',NUMDDL)
      CALL COPISD('NUME_EQUA',BASE,NUMEDD//'.NUME',NUMDDL//'.NUME')
C     UNE DROLE DE GLUTE A RESORBER :
      CALL JEDUP1(NUMEDD//'.MLTF.RENU',BASE,NUMDDL//'.MLTF.RENU')

      UN = 1.0D0


      CALL JELIRA(A,'NMAXOC',NBLIG2,K1BID)
      CALL ASSERT(NBLIG.GT.0)
      CALL ASSERT(NBLIG.LE.NBLIG2)
      CALL JELIRA(A,'LONMAX',NEQ,K1BID)
      CALL ASSERT(NEQ.GT.0)
      CALL ASSERT(NBLIG.LE.NEQ)

      KADIA = NUMDDL//'.SMOS.ADIA'
      CALL WKVECT(KADIA,BASE//' V I',NEQ,JADIA)


C     IIMAX   LONGUEUR MAXIMUM ADMISSIBLE DE KHBID ET ISUIV
C             DANS LA ROUTINE MOINSR IIMAX EST AUGMENTE SI NECESS.
C     KHBID   TABLE DES NUMEROS DE LIGNE
C     ISUIV   TABLE DES CHAINAGES DE LA STRUCTURE CHAINEE
C            (ADIA,HCOL,ISUIV) QUI EST CONTRUITE AVANT D'OBTENIR LA
C               STRUCTURE COMPACTE (ADIA,HCOL) DE LA MATRICE .
      KHBID = '&&ATASMO.SMOS.HCOL'
      KSUIV = '&&ATASMO.ANCIEN.ISUIV'
C     ON COMMENCE AVEC IIMAX=100
      IIMAX = 100
      CALL WKVECT(KHBID,'V V I',IIMAX,JHBID)
      CALL WKVECT(KSUIV,'V V I',IIMAX,IDSUIV)


C     2. CALCUL DE DIMACV
C        DIMACV= NOMBRE TOTAL DE TERMES NON NULS DANS A
C        -- ALLOCATION DE &&ATASMO.ACOMPAC_NBT
C        -- ALLOCATION DE &&ATASMO.ACOMPAC_1ER
C     ----------------------------------------------------------------
      DIMACV = 0
      CALL WKVECT('&&ATASMO.ACOMPAC_NBT','V V I',NBLIG,JACNBT)
      CALL WKVECT('&&ATASMO.ACOMPAC_1ER','V V I',NBLIG,JAC1ER)
      DO 20 ILIG = 1,NBLIG
        CALL JEVEUO(JEXNUM(A,ILIG),'L',IDLIGM)
        NDDLT = 0
        DO 10 J = 1,NEQ
          IF (ZR(IDLIGM+J-1).NE.0.D0) NDDLT = NDDLT + 1
   10   CONTINUE
C       CALL ASSERT(NDDLT.GT.0)  : PARFOIS NDDLT=0 (SSNV128K)
        ZI(JACNBT-1+ILIG) = NDDLT
        ZI(JAC1ER-1+ILIG) = DIMACV + 1
        DIMACV = DIMACV + NDDLT
        CALL JELIBE(JEXNUM(A,ILIG))
   20 CONTINUE
C     CALL ASSERT(DIMACV.GT.0)  : PARFOIS DIMACV=0 (SSNV128K)
      DIMACV = MAX(DIMACV,1)


C     3. COMPACTAGE DE A : ON NE CONSERVE QUE LES TERMES /= 0 AINSI
C        QUE LES INDICES CORRESPONDANT :
C     ----------------------------------------------------------------
      CALL WKVECT('&&ATASMO.ACOMPAC_V','V V R',DIMACV,JACV)
      CALL WKVECT('&&ATASMO.ACOMPAC_I','V V I',DIMACV,JACI)
      K = 0
      DO 40,ILIG = 1,NBLIG
        CALL JEVEUO(JEXNUM(A,ILIG),'L',IDLIGM)
        DO 30,J = 1,NEQ
          IF (ZR(IDLIGM+J-1).NE.0.D0) THEN
            K = K + 1
            ZI(JACI-1+K) = J
            ZR(JACV-1+K) = ZR(IDLIGM+J-1)
          END IF
   30   CONTINUE
        CALL JELIBE(JEXNUM(A,ILIG))
   40 CONTINUE


C     4. OBJETS DU NUME_DDL : .HCOL ET .ADIA :
C     ----------------------------------------
C     IILIB  : 1-ERE PLACE LIBRE
      IILIB = 1
      CALL WKVECT('&&ATASMO.LMBID','V V I',1,IDLM)

C     4.1 : ON FORCE LA PRESENCE DES TERMES DIAGONAUX:
      DO 50 IEQ = 1,NEQ
        ZI(IDLM) = IEQ
        CALL MOINSR(ZI(IDLM),1,IDLM,JADIA,IDSUIV,KSUIV,JHBID,KHBID,
     &              IILIB,IIMAX)
   50 CONTINUE


C     4.2 : ON INSERE LES VRAIS TERMES :
      DO 70 ILIG = 1,NBLIG
C       NDDLT : NOMBRE DE TERMES NON NULS POUR ILIG
        NDDLT = ZI(JACNBT-1+ILIG)
        IDLM = JACI - 1 + ZI(JAC1ER-1+ILIG)

C       -- INSERTION DES COLONNES DE L'ELEMENT DANS
C           LA STRUCTURE CHAINEE
        DO 60 IDDL = 0,NDDLT - 1
          CALL MOINSR(ZI(IDLM+IDDL),IDDL+1,IDLM,JADIA,IDSUIV,KSUIV,
     &                JHBID,KHBID,IILIB,IIMAX)
   60   CONTINUE
   70 CONTINUE


C     DESIMBRIQUATION DE CHAINES POUR OBTENIR LA STRUCTURE COMPACTE
C     (ZI(JADIA),HCOL) DE LA MATRICE
      KHCOL = NUMDDL//'.SMOS.HCOL'
      CALL WKVECT(KHCOL,BASE//' V I',IIMAX,JHCOL)
      CALL MOINIP(NEQ,NCOEF,ZI(JADIA),ZI(IDSUIV),ZI(JHBID),ZI(JHCOL))


C     5. OBJETS DU NUME_DDL : .ABLO, .IABL, .DESC, .REFE:
C     ----------------------------------------------------
      KABLO = NUMDDL//'.SMOS.ABLO'
      CALL WKVECT(KABLO,BASE//' V I',2,JABLO)
      ZI(JABLO) = 0
      ZI(JABLO+1) = NEQ

      KIABL = NUMDDL//'.SMOS.IABL'
      CALL WKVECT(KIABL,BASE//' V I',NEQ,JIABL)
      DO 80 I = 1,NEQ
        ZI(JIABL+I-1) = 1
   80 CONTINUE

      KDESC = NUMDDL//'.SMOS.DESC'
      CALL WKVECT(KDESC,BASE//' V I',6,JDESC)
      ZI(JDESC+1-1) = NEQ
      ZI(JDESC+2-1) = NCOEF
      ZI(JDESC+3-1) = 1
      ZI(JDESC+4-1) = NCOEF

      KREFE = NUMDDL//'.SMOS.REFE'
      CALL WKVECT(KREFE,BASE//' V K24',1,JREFE)
      ZK24(JREFE+1-1) (1:14) = NUMDDL
      CALL JEECRA(KREFE,'DOCU',IBID,'SMOS')


C     6. OBJETS: MATR_ASSE.REFA ET MATR_ASSE.CONL:
C     --------------------------------------------------
      KREFA = ATA//'.REFA'
      CALL WKVECT(KREFA,BASE//' V K24',4,JREFA)
      CALL DISMOI('F','NOM_MAILLA',NUMEDD,'NUME_DDL',IBID,MA,IER)
      ZK24(JREFA-1+1) = MA
      ZK24(JREFA-1+2) = NUMDDL//'.NUME'
      ZK24(JREFA-1+3) = NUMDDL//'.SMOS'
      CALL JEECRA(KREFA,'DOCU',IBID,'ASSE')
      KCONL = ATA//'.CONL'
      CALL WKVECT(KCONL,BASE//' V R',NEQ,JCONL)
      DO 90 I = 1,NEQ
        ZR(JCONL+I-1) = UN
   90 CONTINUE


C     7. OBJET: MATR_ASSE.VALE :
C     --------------------------------------------------
      KVALE = ATA//'.VALE'
      CALL JECREC(KVALE,BASE//' V R','NU','DISPERSE','CONSTANT',1)
      CALL JEECRA(KVALE,'LONMAX',NCOEF,' ')
      CALL JEECRA(KVALE,'DOCU',IBID,'MS')
      CALL JECROC(JEXNUM(KVALE,1))
      CALL JEVEUO(JEXNUM(KVALE,1),'E',JVALE)
      DO 140 ILIG = 1,NBLIG
C       NDDLT : NOMBRE DE TERMES NON NULS POUR ILIG
        NDDLT = ZI(JACNBT-1+ILIG)
        IDLM = JACI - 1 + ZI(JAC1ER-1+ILIG)
        DECAL = ZI(JAC1ER-1+ILIG)

C       -- CALCUL DE .VALE(II,JJ) :
        DO 130,J = 1,NDDLT
          VJ = ZR(JACV-1+DECAL-1+J)
          JJ = ZI(JACI-1+DECAL-1+J)
          CALL ASSERT(JJ.LE.NEQ)
          II2 = ZI(JADIA-1+JJ)
          IF (JJ.EQ.1) THEN
            II1 = 1
          ELSE
            II1 = ZI(JADIA-1+JJ-1) + 1
          END IF
          CALL ASSERT(II2.GE.II1)
          DO 120,I = 1,J
            VI = ZR(JACV-1+DECAL-1+I)
            II = ZI(JACI-1+DECAL-1+I)
            VIJ = VI*VJ
C           -- CUMUL DE VIJ DANS .VALE :
            DO 100,III = II1,II2
              IF (ZI(JHCOL-1+III).EQ.II) GO TO 110
  100       CONTINUE
            CALL ASSERT(.FALSE.)
  110       CONTINUE
            ZR(JVALE-1+III) = ZR(JVALE-1+III) + VIJ
  120     CONTINUE
  130   CONTINUE
  140 CONTINUE


C     9. MENAGE :
C     ------------
      CALL JEDETR('&&ATASMO.SMOS.HCOL')
      CALL JEDETR('&&ATASMO.ANCIEN.ISUIV')
      CALL JEDETR('&&ATASMO.ACOMPAC_NBT')
      CALL JEDETR('&&ATASMO.ACOMPAC_1ER')
      CALL JEDETR('&&ATASMO.ACOMPAC_V')
      CALL JEDETR('&&ATASMO.ACOMPAC_I')
      CALL JEDETR('&&ATASMO.LMBID')

      CALL JEDEMA()
      END
