      SUBROUTINE PJMA2P(NDIM,MOA2,MA2P,CORRES)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 07/02/2012   AUTEUR PELLET J.PELLET 
C RESPONSABLE PELLET J.PELLET
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT   NONE
C ----------------------------------------------------------------------
C COMMANDE PROJ_CHAMP / METHODE='ECLA_PG'
C
C BUT :  CREER UN MAILLAGE (MA2P) DONT LES NOEUDS SONT POSITIONNES SUR
C        LES POINTS DE GAUSS D'UN MODELE (MOA2).
C REMARQUE : ON UTILISE L'OPTION COOR_ELGA CE QUI CORRESPOND EN GENERAL
C            A LA FAMILLE DE POINTS DE GAUS "RIGI"
C ----------------------------------------------------------------------
C IN NDIM : 2/3 : DIMENSION DES MAILLES A PROJETER
C IN MOA2 : MODELE "2"
C IN/JXOUT MA2P : MAILLAGE 2 PRIME (OBTENU A PARTIR DES PG DU MODELE 2)
C IN/JXVAR : ON COMPLETE LA SD_CORRESP_2_MAILLA AVEC L'OBJET .PJEL
C ----------------------------------------------------------------------
      CHARACTER*16 CORRES
      CHARACTER*8 MA2P,MOA2
      INTEGER NDIM
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      CHARACTER*32 JEXNUM
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
      CHARACTER*32 JEXNOM
C ----------------------------------------------------------------------
      INTEGER NTGEO,IPO,IPG,NUNO2
      INTEGER IBID,IRET,NBNO2P,NNO2,INO2P
      INTEGER K,J1,J4,IPOI1,IPY5,IPY13
      INTEGER NBMA,NBPT,NBCMP
      INTEGER IMA,IPT,ICMP,IAD,IADIME
      INTEGER JTYPMA,JDIMT,JPO2,JLIMAT,NBMAT,NBTROU,JLITR
      INTEGER JCESD,JCESL,JCESV,IATYPM,JMAIL,ICO
      CHARACTER*8 NOM,MAIL2,KBID,NOMA
      CHARACTER*19 CHAMG,CES,CHGEOM,LIGREL
      CHARACTER*24 COODSC,LIMATO,LITROU
      REAL*8 XMOY(3),RAYO
C ----------------------------------------------------------------------
      CALL JEMARQ()

C     -- RECUPERATION DU NOM DU MAILLAGE 2
      CALL DISMOI('F','NOM_MAILLA',MOA2,'MODELE',IBID,MAIL2,IRET)
      CALL JEVEUO(MAIL2//'.TYPMAIL','L',JTYPMA)

C     -- RECUPERATION DU CHAMP DE COORDONNEES DU MAILLAGE 2
      CHGEOM=MAIL2//'.COORDO'


C     -- ON REDUIT LE LIGREL DE MOA2 SUR MAILLES DE DIMENSION NDIM :
      LIGREL='&&PJMA2P.LIGREL'
      LIMATO='&&PJMA2P.LIMATOT'
      LITROU='&&PJMA2P.LITROU'
      CALL DISMOI('F','NB_MA_MAILLA',MAIL2,'MAILLAGE',NBMAT,KBID,IRET)
      CALL WKVECT(LIMATO,'V V I',NBMAT,JLIMAT)
C     -- ON NE CONSERVE QUE LES MAILLES DU MODELE :
      CALL JEVEUO(MOA2//'.MAILLE','L',JMAIL)
      ICO=0
      DO 10,K=1,NBMAT
        IF (ZI(JMAIL-1+K).EQ.0)GOTO 10
        ICO=ICO+1
        ZI(JLIMAT-1+ICO)=K
   10 CONTINUE
      CALL ASSERT(ICO.GT.0)
      CALL JUVECA(LIMATO,ICO)
C     -- ON NE CONSERVE QUE LES MAILLES DE DIMENSION NDIM :
      CALL UTFLMD(MAIL2,LIMATO,NDIM,NBTROU,LITROU)
      CALL ASSERT(NBTROU.GT.0)
      CALL JEVEUO(LITROU,'L',JLITR)
      CALL EXLIM1(ZI(JLITR),NBTROU,MOA2,'V',LIGREL)
      CALL JEDETR(LIMATO)
      CALL JEDETR(LITROU)



C     1.  CALCUL DU CHAMP DE COORDONNEES DES ELGA (CHAMG):
C     -------------------------------------------------------
      CHAMG='&&PJMA2P.PGCOOR'
      CALL CALCUL('S','COOR_ELGA',LIGREL,1,CHGEOM,'PGEOMER',1,CHAMG,
     &            'PCOORPG ','V','OUI')

C     -- TRANSFORMATION DE CE CHAMP EN CHAM_ELEM_S
      CES='&&PJMA2P.PGCORS'
      CALL CELCES(CHAMG,'V',CES)

      CALL JEVEUO(CES//'.CESD','L',JCESD)
      CALL JEVEUO(CES//'.CESL','L',JCESL)
      CALL JEVEUO(CES//'.CESV','E',JCESV)
      NBMA=ZI(JCESD-1+1)

C     2.1 MODIFICATION DES COORDONNEES DE CERTAINS PG (PYRAM/FPG27)
C         CAR CES POINTS DE GAUSS SONT EN "DEHORS" DES PYRAMIDES
C     ----------------------------------------------------------------
      CALL JENONU(JEXNOM('&CATA.TM.NOMTM','PYRAM5'),IPY5)
      CALL JENONU(JEXNOM('&CATA.TM.NOMTM','PYRAM13'),IPY13)
      DO 80,IMA=1,NBMA
        IF (ZI(JTYPMA-1+IMA).EQ.IPY5 .OR.
     &      ZI(JTYPMA-1+IMA).EQ.IPY13) THEN
          NBPT=ZI(JCESD-1+5+4*(IMA-1)+1)
          IF (NBPT.EQ.27) THEN
            DO 20,ICMP=1,3
              XMOY(ICMP)=0.D0
   20       CONTINUE
C           -- XMOY : CENTRE DE LA PYRAMIDE :
            DO 40,IPT=1,15
              DO 30,ICMP=1,3
                CALL CESEXI('C',JCESD,JCESL,IMA,IPT,1,ICMP,IAD)
                CALL ASSERT(IAD.GT.0)
                XMOY(ICMP)=XMOY(ICMP)+ZR(JCESV-1+IAD)
   30         CONTINUE
   40       CONTINUE
            DO 50,ICMP=1,3
              XMOY(ICMP)=XMOY(ICMP)/15
   50       CONTINUE

C           -- ON "RAMENE" LES 12 DERNIERS PG VERS LE CENTRE (10%) :
            DO 70,IPT=16,27
              DO 60,ICMP=1,3
                CALL CESEXI('C',JCESD,JCESL,IMA,IPT,1,ICMP,IAD)
                CALL ASSERT(IAD.GT.0)
                RAYO=ZR(JCESV-1+IAD)-XMOY(ICMP)
                ZR(JCESV-1+IAD)=ZR(JCESV-1+IAD)-0.6D0*RAYO
   60         CONTINUE
   70       CONTINUE
          ENDIF
        ENDIF
   80 CONTINUE


C     2. CALCUL DE NBNO2P : NOMBRE DE NOEUDS (ET DE MAILLES) DE MA2P
C        CALCUL DE '.PJEF_EL'
C     ----------------------------------------------------------------
      NBNO2P=0

C     NBMA*27*2 = NB MAX DE MAILLES * NB DE PG MAX PAR MAILLE * 2
C     ON CREE UN TABLEAU, POUR CHAQUE JPO2, ON STOCKE DEUX VALEURS :
C      * LA PREMIERE VALEUR EST LE NUMERO DE LA MAILLE
C      * LA DEUXIEME VALEUR EST LE NUMERO DU PG DANS CETTE MAILLE
      CALL WKVECT(CORRES//'.PJEF_EL','V V I',NBMA*27*2,JPO2)

      IPO=1
      DO 100,IMA=1,NBMA
        CALL JEVEUO(JEXNUM('&CATA.TM.TMDIM',ZI(JTYPMA-1+IMA)),'L',JDIMT)
        IF (ZI(JDIMT).EQ.NDIM) THEN
          NBPT=ZI(JCESD-1+5+4*(IMA-1)+1)
          IF (NBPT.EQ.0)GOTO 100
          CALL JENUNO(JEXNUM(MAIL2//'.NOMMAI',IMA),NOMA)
          DO 90,IPG=1,NBPT
            ZI(JPO2-1+IPO)=IMA
            ZI(JPO2-1+IPO+1)=IPG
            IPO=IPO+2
   90     CONTINUE
          NBNO2P=NBNO2P+NBPT
        ENDIF
  100 CONTINUE


C     3. CREATION DU .DIME DU NOUVEAU MAILLAGE
C        IL Y A AUTANT DE MAILLES QUE DE NOEUDS
C        TOUTES LES MAILLES SONT DES POI1
C     --------------------------------------------------
      CALL WKVECT(MA2P//'.DIME','V V I',6,IADIME)
      ZI(IADIME-1+1)=NBNO2P
      ZI(IADIME-1+3)=NBNO2P
      ZI(IADIME-1+6)=3


C     4. CREATION DU .NOMNOE ET DU .NOMMAI DU NOUVEAU MAILLAGE
C     ---------------------------------------------------------
      CALL JECREO(MA2P//'.NOMNOE','V N K8')
      CALL JEECRA(MA2P//'.NOMNOE','NOMMAX',NBNO2P,' ')
      CALL JECREO(MA2P//'.NOMMAI','V N K8')
      CALL JEECRA(MA2P//'.NOMMAI','NOMMAX',NBNO2P,' ')


      NOM(1:1)='N'
      DO 110,K=1,NBNO2P
        CALL CODENT(K,'G',NOM(2:8))
        CALL JECROC(JEXNOM(MA2P//'.NOMNOE',NOM))
  110 CONTINUE
      NOM(1:1)='M'
      DO 120,K=1,NBNO2P
        CALL CODENT(K,'G',NOM(2:8))
        CALL JECROC(JEXNOM(MA2P//'.NOMMAI',NOM))
  120 CONTINUE



C     5. CREATION DU .CONNEX ET DU .TYPMAIL DU NOUVEAU MAILLAGE
C     ----------------------------------------------------------
      CALL JECREC(MA2P//'.CONNEX','V V I','NU','CONTIG','VARIABLE',
     &            NBNO2P)
      CALL JEECRA(MA2P//'.CONNEX','LONT',NBNO2P,' ')
      CALL JEVEUO(MA2P//'.CONNEX','E',IBID)

      CALL WKVECT(MA2P//'.TYPMAIL','V V I',NBNO2P,IATYPM)
      CALL JENONU(JEXNOM('&CATA.TM.NOMTM','POI1'),IPOI1)

      NUNO2=0
      DO 130,IMA=1,NBNO2P
        ZI(IATYPM-1+IMA)=IPOI1
        NNO2=1
        CALL JECROC(JEXNUM(MA2P//'.CONNEX',IMA))
        CALL JEECRA(JEXNUM(MA2P//'.CONNEX',IMA),'LONMAX',NNO2,KBID)
        NUNO2=NUNO2+1
        ZI(IBID-1+NUNO2)=NUNO2
  130 CONTINUE



C     -- CREATION DU .REFE DU NOUVEAU MAILLAGE
C     --------------------------------------------------
      CALL WKVECT(MA2P//'.COORDO    .REFE','V V K24',4,J4)
      ZK24(J4)='MA2P'


C     -- CREATION DE COORDO.VALE DU NOUVEAU MAILLAGE
C     --------------------------------------------------
      CALL WKVECT(MA2P//'.COORDO    .VALE','V V R',3*NBNO2P,J1)

      INO2P=0
      DO 160,IMA=1,NBMA
        NBPT=ZI(JCESD-1+5+4*(IMA-1)+1)
        NBCMP=ZI(JCESD-1+5+4*(IMA-1)+3)
        IF (NBPT.EQ.0)GOTO 160
        CALL JEVEUO(JEXNUM('&CATA.TM.TMDIM',ZI(JTYPMA-1+IMA)),'L',JDIMT)

        IF (ZI(JDIMT).EQ.NDIM) THEN
          CALL ASSERT(NBCMP.GE.3)
          DO 150,IPT=1,NBPT
            INO2P=INO2P+1
            DO 140,ICMP=1,3
              CALL CESEXI('C',JCESD,JCESL,IMA,IPT,1,ICMP,IAD)
              IF (IAD.GT.0) THEN
                ZR(J1-1+3*(INO2P-1)+ICMP)=ZR(JCESV-1+IAD)
              ENDIF
  140       CONTINUE
  150     CONTINUE
        ENDIF
  160 CONTINUE
      CALL ASSERT(INO2P.EQ.NBNO2P)


C     -- CREATION DU .DESC DU NOUVEAU MAILLAGE
C     --------------------------------------------------
      COODSC=MA2P//'.COORDO    .DESC'

      CALL JENONU(JEXNOM('&CATA.GD.NOMGD','GEOM_R'),NTGEO)
      CALL JECREO(COODSC,'V V I')
      CALL JEECRA(COODSC,'LONMAX',3,' ')
      CALL JEECRA(COODSC,'DOCU',0,'CHNO')
      CALL JEVEUO(COODSC,'E',IAD)
      ZI(IAD)=NTGEO
      ZI(IAD+1)=-3
      ZI(IAD+2)=14

      CALL DETRSD('CHAM_ELEM',CHAMG)
      CALL DETRSD('CHAM_ELEM_S',CES)

      CALL JEDEMA()
      END
