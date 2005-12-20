      SUBROUTINE NUDEEQ(PRCHNO,NEQ,GDS,IDDLAG)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ASSEMBLA  DATE 31/08/2004   AUTEUR VABHHTS J.PELLET 
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
      IMPLICIT REAL*8 (A-H,O-Z)

C     ARGUMENTS:
C     ----------
      CHARACTER*19 PRCHNO
      INTEGER NEQ,GDS,IDDLAG
C ----------------------------------------------------------------------
C     BUT : CREER L'OBJET .DEEQ ET .DELG DANS UN PROF_CHNO.

C     IN:
C     PRCHNO : NOM D'UN PROF_CHNO (ISSU D'UN NUME_DDL)
C     NEQ    : NOMBRE D'EQUATIONS (OU DE DDL) DU PROF_CHNO
C     GDS    : NUMERO DE LA GRANDEUR SIMPLE ASSOCIEE AU CHAMP.
C     IDDLAG : ADRESSE DE L'OBJET DSCLAG CREE LOCALEMENT DANS NUEFFE

C     OUT:
C     PRCHNO EST COMPLETE DE L'OBJET ".DEEQ" V(I) DIM=2*NEQ
C         (CET OBJET EST DETRUIT S'IL EXISTE DEJA).
C     V((IDDL-1)*2+1)--> SI LE NOEUD SUPPORT DE L'EQUA. IDDL EST PHYS.:
C                           +NUMERO DU NOEUD
C                        SI LE NOEUD SUPPORT DE L'EQUA. IDDL EST UN
C                        LAGRANGE DE BLOCAGE :
C                           +NUMERO DU NOEUD PHYS. BLOQUE
C                        SI LE NOEUD SUPPORT DE L'EQUA. IDDL EST UN
C                        LAGRANGE DE LIAISON :
C                            0
C     V((IDDL-1)*2+2)--> SI LE NOEUD SUPPORT DE L'EQUA. IDDL EST PHYS.:
C                           + NUM. DANS L'ORDRE DU CATAL. DES GRAND.
C                           DE LA CMP CORRESPONDANT A L'EQUATION IDDL.
C                        SI LE NOEUD SUPPORT DE L'EQUA. IDDL EST UN
C                        LAGRANGE DE BLOCAGE :
C                           - NUM. DANS L'ORDRE DU CATAL. DES GRAND.
C                           DE LA CMP CORRESPONDANT AU BLOCAGE.
C                        SI LE NOEUD SUPPORT DE L'EQUA. IDDL EST UN
C                        LAGRANGE DE LIAISON :
C                            0
C     PRCHNO EST COMPLETE DE L'OBJET ".DELG" V(I) DIM=NEQ
C         (CET OBJET EST DETRUIT S'IL EXISTE DEJA).
C     V( IDDL ) --> 0  SI LE NOEUD SUPPORT DE L'EQUATION IDDL N'EST PAS
C                         UN NOEUD DE LAGRANGE
C                   -1 SI LE NOEUD SUPPORT DE L'EQUATION IDDL EST UN
C                         "1ER" NOEUD DE LAGRANGE
C                   -2 SI LE NOEUD SUPPORT DE L'EQUATION IDDL EST UN
C                         "2EME" NOEUD DE LAGRANGE
C ----------------------------------------------------------------------

C     FONCTIONS EXTERNES:
C     -------------------
      LOGICAL EXISDG
      INTEGER NBEC

C     VARIABLES LOCALES:
C     ------------------

C --------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*32 JEXNUM,JEXNOM,JEXATR,JEXR8
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8,K8BID,MA,BASE,NONO,NOCMP
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24,LIGREL
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      CHARACTER*1 K1BID
C ---------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------



      CALL JEMARQ()
      CALL DISMOI('F','NOM_MAILLA',PRCHNO(1:19),'NUME_EQUA',IBID,MA,IED)
      CALL DISMOI('F','NB_NO_MAILLA',MA,'MAILLAGE',NBNM,K8BID,IED)
      CALL DISMOI('F','NB_NL_MAILLA',MA,'MAILLAGE',NBNL,K8BID,IED)
      IF (NBNL.GT.0) CALL JEVEUO(MA//'.TYPL','L',IATYPL)


C     - BASE OU SE TROUVE LE NUME_EQUA :
      CALL JELIRA(PRCHNO(1:19)//'.NUEQ','CLAS',IBID,BASE)


C     - ALLOCATION DE ".DEEQ":
      CALL JEEXIN(PRCHNO(1:19)//'.DEEQ',IRET)
      IF (IRET.GT.0) CALL JEDETR(PRCHNO(1:19)//'.DEEQ')
      CALL WKVECT(PRCHNO(1:19)//'.DEEQ',BASE(1:1)//' V I',2*NEQ,IADEEQ)

C     - ALLOCATION DE ".DELG":
      CALL JEEXIN(PRCHNO(1:19)//'.DELG',IRET)
      IF (IRET.GT.0) CALL JEDETR(PRCHNO(1:19)//'.DELG')
      CALL WKVECT(PRCHNO(1:19)//'.DELG',BASE(1:1)//' V I',NEQ,IADELG)


C     - ADRESSE DE ".NUEQ":
      CALL JEVEUO(PRCHNO(1:19)//'.NUEQ','L',IANUEQ)

      CALL JELIRA(JEXNUM('&CATA.GD.NOMCMP',GDS),'LONMAX',NCMPMX,K1BID)
      NEC = NBEC(GDS)
      IF (NCMPMX.EQ.0) CALL UTMESS('F','NUDEEQ_1','LE NOMBRE MAXI DE'//
     &                             ' COMPOSANTE DE LA GRANDEUR EST NUL')
      IF (NEC.EQ.0) CALL UTMESS('F','NUDEEQ_2',
     &                          'LE NOMBRE D"ENTIERS'//' CODES EST NUL')
      NBLAG = 0


      CALL JELIRA(PRCHNO(1:19)//'.PRNO','NMAXOC',NBLIGR,K1BID)
      DO 30 I = 1,NBLIGR
        CALL JELIRA(JEXNUM(PRCHNO(1:19)//'.PRNO',I),'LONMAX',L,K1BID)
        IF (L.GT.0) THEN
          CALL JEVEUO(JEXNUM(PRCHNO(1:19)//'.PRNO',I),'L',IAPRNO)
C---- NBNO : SI I=1 --> NOMBRE DE NOEUDS DU MAILLAGE
C            SI I>1 --> NOMBRE DE NOEUDS SUPPLEMENTAIRES DU LIGREL I
          NBNO = L/ (NEC+2)
          IF ((I.EQ.1) .AND. (NBNO.NE. (NBNM+NBNL))) CALL UTMESS('F',
     &        'NUDEEQ','STOP 1')

          DO 20 J = 1,NBNO
C--- J : SI I=1 --> NUMERO DU NOEUD DU MAILLAGE
C        SI I>1 --> NUMERO DU NOEUD SUPPLEMENTAIRE DU
C                   LIGREL I (CHANGE DE SIGNE).
            IDDL = ZI(IAPRNO-1+ (J-1)* (NEC+2)+1) - 1
            IADG = IAPRNO - 1 + (J-1)* (NEC+2) + 3
            DO 10 K = 1,NCMPMX
              IF (EXISDG(ZI(IADG),K)) THEN
                IDDL = IDDL + 1
                IEQ = ZI(IANUEQ-1+IDDL)

                IF (I.EQ.1) THEN
                  IF ((NBNL.GT.0) .AND. (IEQ.NE.IDDL)) CALL UTMESS('F',
     &                'NUDEEQ','STOP 2')
                  ZI(IADEEQ-1+2* (IEQ-1)+1) = J
                  ZI(IADEEQ-1+2* (IEQ-1)+2) = K
                  ZI(IADELG-1+IEQ) = 0
                ELSE
                  ILAG = NBLAG + J
                  NOB = ZI(IDDLAG+ (ILAG-1)*3)
                  NDDLB = ZI(IDDLAG+ (ILAG-1)*3+1)
                  ZI(IADEEQ-1+2* (IEQ-1)+1) = NOB
                  ZI(IADEEQ-1+2* (IEQ-1)+2) = NDDLB
                  ZI(IADELG-1+IEQ) = -ZI(IDDLAG+ (ILAG-1)*3+2)
                END IF

              END IF
   10       CONTINUE
   20     CONTINUE
          IF (I.GT.1) NBLAG = NBLAG + NBNO
        END IF
   30 CONTINUE


C     -- ON VERIFIE QUE LES DDLS BLOQUES NE SONT PAS BLOQUES
C        PLUSIEURS FOIS (ON NE REGARDE QUE LES 10 1ERES CMPS):
C     -------------------------------------------------------
      CALL WKVECT('&&NUEFFE.LNOBLOQ','V V I',NBNM*10,JLBLQ)
      DO 40,IEQ = 1,NEQ
        NUNO = ZI(IADEEQ-1+2* (IEQ-1)+1)
        NUCMP = ZI(IADEEQ-1+2* (IEQ-1)+2)
        IF ((NUNO.GT.0) .AND. (NUCMP.LT.0) .AND. (NUCMP.GE.-10)) THEN
          NUCMP = -NUCMP
          ZI(JLBLQ-1+ (NUNO-1)*10+NUCMP) = ZI(JLBLQ-1+ (NUNO-1)*10+
     &      NUCMP) + 1
        END IF
   40 CONTINUE

      IER = 0
      DO 60,NUNO = 1,NBNM
        DO 50,NUCMP = 1,10
          IF (ZI(JLBLQ-1+ (NUNO-1)*10+NUCMP).GT.2) THEN
            IER = IER + 1
            CALL JENUNO(JEXNUM(MA//'.NOMNOE',NUNO),NONO)
            CALL JEVEUO(JEXNUM('&CATA.GD.NOMCMP',GDS),'L',JNCMP)
            NOCMP = ZK8(JNCMP-1+NUCMP)
            CALL UTMESS('E','NUDEEQ','LE NOEUD: '//NONO//
     &                  'COMPOSANTE: '//NOCMP//
     &                  ' EST BLOQUE PLUSIEURS FOIS.')
          END IF
   50   CONTINUE
   60 CONTINUE
      IF (IER.GT.0) CALL UTMESS('F','NUEFFE',
     &                          'ARRET DU AUX '//'ERREURS PRECEDENTES.')
      CALL JEDETR('&&NUEFFE.LNOBLOQ')


   70 CONTINUE
      CALL JEDEMA()
      END
