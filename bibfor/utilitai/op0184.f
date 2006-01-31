      SUBROUTINE OP0184(IER)
      IMPLICIT   NONE
      INTEGER IER
C     -----------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 30/01/2006   AUTEUR LEBOUVIE F.LEBOUVIER 
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

C     LECTURE D'UN RESULTAT PLEXUS (PRESSION) SUR FICHIER IDEAS
C     LA PRESSION EST CALCULEE PAR PLEXUS SUR DES SEG2 (CONSTANTE)
C     LE MAILLAGE ASTER PEUT COMPORTER DES SEG2, DES SEG3, DES COQUES

C     -----------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX --------------------------
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
      CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
C     -----  FIN  COMMUNS NORMALISES  JEVEUX --------------------------

      INTEGER NBV,NBMAPL,IBID,NTOUT,NNUME,NP,IUL,IUNIFI
      INTEGER NBORDR,JNUME,N1,NLINST,JLIST,NBINST,NIS,NC,NFOR
      INTEGER IRET,JTITR,NBTITR,IFSIG,L,IPAS,K,NUMPAS,INO
      INTEGER IVAR(6),IORD,JPRES,IMA,NBNOAS,JNOMA,I,NNU
      INTEGER IADRNO,IMP,JDME,NTSEG,IMAMIN,JDCO,JDNO,NO1,NO2,NUTYEL
      INTEGER JCELV,JCELD,IDEC,NBELGR,NBELEM,LIEL,IEL,IADNO,NNO
      INTEGER JINST,NBTROU,LORDR,NTPOI,ITEST,IAD,IMAPL
      INTEGER NBORDT,TE,TYPELE,NBGREL,NBGR,IGR,ULISOP
      REAL*8 RBID,PRES,EPSI,TEMPS,TREF,CM(3),A(3),B(3),LA,LB,D2,D2MIN
      COMPLEX*16 CBID
      CHARACTER*6 KAR
      CHARACTER*8 RESU,NOMAPL,NOMAST,K8B,LISTR8,FORM,CRIT
      CHARACTER*8 NOMO,LPAIN(1),LPAOUT(1)
      CHARACTER*16 NOMCMD,CONCEP,NSYMB,NOMTE,K16NOM
      CHARACTER*19 NOMCH,LIGRMO,CHPRES,CAPRES
      CHARACTER*24 COORN,TYPMA,COORP,MLGCNX,LCHIN(1),LCHOUT(1)
      CHARACTER*24 NOLIEL,CHGEOM,OPTION,CONNEX
      CHARACTER*80 K80B,K80BM,K80BID
C     -----------------------------------------------------------------

      CALL JEMARQ()
      CALL INFMAJ()
      K80BM = ' '
      CALL GETRES(RESU,CONCEP,NOMCMD)

C     LECTURE DE LA NUMEROTATION DES DDL

      CALL GETVID(' ','MAIL_PLEXUS',0,1,1,NOMAPL,NBV)
      CALL DISMOI('F','NB_MA_MAILLA',NOMAPL,'MAILLAGE',NBMAPL,K8B,IER)
      CALL GETVID(' ','MAILLAGE',0,1,1,NOMAST,NBV)
      CALL DISMOI('F','NB_NO_MAILLA',NOMAST,'MAILLAGE',NBNOAS,K8B,IER)
      CALL WKVECT('&&OP0184.NOAST_MAPLEX','V V I',NBNOAS,JNOMA)
      COORN = NOMAST//'.COORDO    .VALE'
      CALL JEVEUO(COORN,'L',IADRNO)
      COORP = NOMAPL//'.COORDO    .VALE'
      CALL JEVEUO(COORP,'L',JDCO)
      TYPMA = NOMAPL//'.TYPMAIL'
      CALL JEVEUO(TYPMA,'L',JDME)
      MLGCNX = NOMAPL//'.CONNEX'
      CALL JENONU(JEXNOM('&CATA.TM.NOMTM','SEG2'),NTSEG)

C IL PEUT Y AVOIR DES POI1 DANS LES ELEMENTS PLEXUS ON LES IGNORE

      CALL JENONU(JEXNOM('&CATA.TM.NOMTM','POI1'),NTPOI)
      ITEST = 0

      DO 50 INO = 1,NBNOAS
        DO 10 I = 1,3
          CM(I) = ZR(IADRNO+3*INO-3+I-1)
   10   CONTINUE
        IMAMIN = 0
        D2MIN = 1.D10
        DO 40 IMP = 1,NBMAPL
          NUTYEL = ZI(JDME+IMP-1)
          IF (NUTYEL.EQ.NTPOI) THEN
            ITEST = -1
            GO TO 40
          ELSE IF (NUTYEL.EQ.NTSEG) THEN
            GO TO 20
          ELSE
            CALL UTMESS('F','OP0184',
     & 'MAILLAGE AUTRE QUE SEG2                                OU POI1 '
     &                  )
          END IF
   20     CONTINUE
          CALL JEVEUO(JEXNUM(MLGCNX,IMP),'L',JDNO)
          NO1 = ZI(JDNO)
          NO2 = ZI(JDNO+1)
          DO 30 I = 1,3
            A(I) = ZR(JDCO+ (NO1-1)*3+I-1)
            B(I) = ZR(JDCO+ (NO2-1)*3+I-1)
   30     CONTINUE
          CALL PJ3DA4(CM,A,B,LA,LB,D2)
          IF (D2.LT.D2MIN) THEN
            IMAMIN = IMP
            D2MIN = D2
          END IF
   40   CONTINUE
        ZI(JNOMA-1+INO) = IMAMIN
   50 CONTINUE
C TEST SUR LA PRESENCE DE MAILLE PONCTUELLE
      IF (ITEST.NE.0) CALL UTMESS('I','OP0184',
     &'MAILLES PONCTUELLES                           PLEXUS POI1 IGNOREE
     &S')

C     --- QUELS SONT LES INSTANTS A RELIRE ---

      NBORDR = 0
      CALL GETVTX(' ','TOUT_ORDRE',0,1,1,K8B,NTOUT)
      IF (NTOUT.EQ.0) THEN
        CALL GETVIS(' ','NUME_ORDRE',0,1,0,IBID,NNUME)
        IF (NNUME.NE.0) THEN
          NBORDR = -NNUME
          CALL WKVECT('&&OP0184.NUME_ORDRE','V V I',NBORDR,JNUME)
          CALL GETVIS(' ','NUME_ORDRE',0,1,NBORDR,ZI(JNUME),N1)
        ELSE
          CALL GETVID(' ','LIST_ORDRE',0,1,1,LISTR8,NNU)
          IF (NNU.NE.0) THEN
            CALL JEVEUO(LISTR8//'.VALE','L',JNUME)
            CALL JELIRA(LISTR8//'.VALE','LONMAX',NBORDR,K8B)
          ELSE
            CALL GETVID(' ','LIST_INST',0,1,1,LISTR8,NLINST)
            IF (NLINST.NE.0) THEN
              CALL JEVEUO(LISTR8//'.VALE','L',JLIST)
              CALL JELIRA(LISTR8//'.VALE','LONMAX',NBORDR,K8B)
            ELSE
              CALL GETVR8(' ','INST',0,1,0,RBID,NIS)
              IF (NIS.NE.0) THEN
                NBINST = -NIS
                CALL WKVECT('&&OP0184.INST','V V R',NBORDR,JLIST)
                CALL GETVR8(' ','INST',0,1,NBORDR,ZR(JLIST),N1)
              END IF
            END IF
          END IF
        END IF
      END IF

C     --- LECTURE DE LA PRECISION ET DU CRITERE ---

      CALL GETVR8(' ','PRECISION',0,1,1,EPSI,NP)
      CALL GETVTX(' ','CRITERE',0,1,1,CRIT,NC)

C     FORMAT IDEAS OBLIGATOIRE

      CALL GETVTX(' ','FORMAT',0,1,1,FORM,NFOR)

      IF (FORM.NE.'IDEAS') THEN
        CALL UTMESS('F','OP0184','LE FORMAT DOIT ETRE IDEAS')
      END IF
      CALL JEEXIN(NOMAPL//'           .TITR',IRET)
      IF (IRET.EQ.0) THEN
        CALL UTMESS('F','OP0184','LE MAILLAGE DOIT ETRE ISSU D''IDEAS')
      ELSE
        CALL JEVEUO(NOMAPL//'           .TITR','L',JTITR)
        CALL JELIRA(NOMAPL//'           .TITR','LONMAX',NBTITR,K8B)
        IF (NBTITR.GE.1) THEN
          IF (ZK80(JTITR) (10:31).NE.'AUTEUR=INTERFACE_IDEAS') THEN
          CALL UTMESS('F','OP0184','LE MAILLAGE DOIT ETRE ISSU D''IDEAS'
     &                  )
          END IF
        ELSE
          CALL UTMESS('A','OP0184',' MAILLAGE NON ISSU D''IDEAS')
        END IF
      END IF

C     CREATION DE LA SD RESULTAT

      NBORDT = MAX(1,NBORDR)
      CALL RSCRSD(RESU,'EVOL_CHAR',NBORDT)

C     CREATION DU CHAMP DE PRESSION

      CALL GETVID(' ','MODELE',0,1,1,NOMO,NBV)
      CHGEOM = NOMAST//'.COORDO'
      LPAIN(1) = 'PGEOMER'
      LCHIN(1) = CHGEOM
      LPAOUT(1) = 'PPRES_R'
      CHPRES = '&&OP0184.CHPRES'
      LCHOUT(1) = CHPRES
      LIGRMO = NOMO//'.MODELE'
      OPTION = 'TOU_INI_ELNO'
      CALL CALCUL('S',OPTION,LIGRMO,1,LCHIN,LPAIN,1,LCHOUT,LPAOUT,'V')
      CALL JEVEUO(CHPRES//'.CELD','L',JCELD)
      CALL JEVEUO(CHPRES//'.CELV','E',JCELV)
      CONNEX = NOMAST//'.CONNEX'
      NOLIEL = LIGRMO//'.LIEL'
      NBGR = NBGREL(LIGRMO)

      CAPRES = '&&OP0184.PRES'
      CALL WKVECT(CAPRES,'V V R',NBMAPL,JPRES)

      CALL GETVIS(' ','UNITE',0,1,1,IFSIG,L)
      K16NOM = ' '
      IF ( ULISOP ( IFSIG, K16NOM ) .EQ. 0 )  THEN 
        CALL ULOPEN(IFSIG,' ',' ','NEW','O')
      ENDIF 
      IPAS = 0

C     LECTURE DES DATASET DU FICHIER IDEAS
C     ON NE LIT QUE DES CHAMPS CONSTANTS PAR ELEMENTS

   60 CONTINUE

      READ (IFSIG,'(A6)',END=160,ERR=180) KAR
      IF (KAR.EQ.'    56') THEN
        READ (IFSIG,'(40A2)',END=180) K80B
        READ (IFSIG,'(40A2)',END=180) K80B
        READ (IFSIG,'(40A2)',END=180) K80B
        READ (IFSIG,'(A80)',END=180) K80B
C LECTURE DE LA VARIABLE PRESSION EN FONCTION DU TYPE
C DE MATERIAU PLEXUS UTILISE


        IF (.NOT. (K80B(49:52).EQ.'MULT'.OR.K80B(49:
     &      52).EQ.'EAU '.OR.K80B(49:52).EQ.'FLUI')) GO TO 60
        READ (IFSIG,'(40A2)',END=180) K80BID
        K8B = K80BID(1:8)
      ELSE IF (KAR.EQ.'  2414') THEN
        READ (IFSIG,'(1I10)',END=180) IBID
        READ (IFSIG,'(40A2)',END=180) K80B
        READ (IFSIG,'(1I10)',END=180) IBID
        IF (IBID.NE.2) GO TO 60
        READ (IFSIG,'(40A2)',END=180) K80B
        READ (IFSIG,'(40A2)',END=180) K80B
        READ (IFSIG,'(40A2)',END=180) K80B
        READ (IFSIG,'(A80)',END=180) K80BM
        READ (IFSIG,'(40A2)',END=180) K80B
      ELSE
        GO TO 60
      END IF
      READ (IFSIG,'(6I10)',END=180) (IVAR(K),K=1,6)

C        IVAR(3) : TYPE DE DONNEE =0 POUR UNKNOWN
C        IVAR(5) : TYPE DE DONNEE =2 POUR REELLE
C        IVAR(6) : NOMBRE DE VALEURS PAR ELEMENT =20 ICI POUR MULT


      IF (K80B(49:52).EQ.'MULT') THEN
        IF (IVAR(3).NE.0) GO TO 60
        IF (IVAR(5).NE.2) GO TO 60
        IF (IVAR(6).NE.20) GO TO 60
      ELSE IF (K80B(49:52).EQ.'FLUI') THEN
        IF (IVAR(3).NE.0) GO TO 60
        IF (IVAR(5).NE.2) GO TO 60
        IF (IVAR(6).NE.2) GO TO 60
      ELSE IF (K80BM(49:52).EQ.'FLUI') THEN
        IF (IVAR(3).NE.0) GO TO 60
        IF (IVAR(5).NE.2) GO TO 60
        IF (IVAR(6).NE.2) GO TO 60
      ELSE
        IF (IVAR(3).NE.0) GO TO 60
        IF (IVAR(5).NE.2) GO TO 60
        IF (IVAR(6).NE.10) GO TO 60
      END IF


C        VERIFICATION QUE LE DATASET EST AU BON INSTANT

      IF (KAR.EQ.'    56') THEN
        READ (IFSIG,'(4I10)',END=180) IBID,IBID,IBID,NUMPAS
        READ (IFSIG,'(E13.5)',END=180) TEMPS
      ELSE
        READ (IFSIG,'(8I10)',END=180) IBID
        READ (IFSIG,'(8I10)',END=180) IBID
        READ (IFSIG,'(6E13.5)',END=180) TEMPS
        READ (IFSIG,'(6E13.5)',END=180) RBID
      END IF

      IF (NTOUT.NE.0) THEN
        GO TO 90
      ELSE
        IF (NBORDR.NE.0) THEN
          IF (KAR.EQ.'  2414') THEN
            CALL UTMESS('F','OP0184',
     &                  'AVEC LE 2414, ON NE TRAITE PAS LES NUME_ORDRE')
          END IF
          DO 70 IORD = 1,NBORDR
            IF (ZI(JNUME+IORD-1).EQ.NUMPAS) GO TO 90
   70     CONTINUE
        ELSE IF (NBINST.NE.0) THEN
          DO 80 IORD = 1,NBINST
            TREF = ZR(JLIST+IORD-1)
            IF (CRIT(1:4).EQ.'RELA') THEN
              IF (ABS(TREF-TEMPS).LE.ABS(EPSI*TEMPS)) GO TO 90
            ELSE IF (CRIT(1:4).EQ.'ABSO') THEN
              IF (ABS(TREF-TEMPS).LE.ABS(EPSI)) GO TO 90
            END IF
   80     CONTINUE
        END IF
        GO TO 60
      END IF
   90 CONTINUE
      IPAS = IPAS + 1

C        LECTURE DES PRESSIONS

  100 CONTINUE
      READ (IFSIG,'(I10)',END=180) IMA
      IF (IMA.EQ.-1) GO TO 110
      READ (IFSIG,'(E13.5)',END=180) PRES
      ZR(JPRES-1+IMA) = PRES
      IF (K80BM(49:52).EQ.'FLUI') THEN
        GO TO 100
      ELSE IF (K80B(49:52).EQ.'MULT') THEN
        READ (IFSIG,'(E13.5)',END=180) RBID
        READ (IFSIG,'(E13.5)',END=180) RBID
        READ (IFSIG,'(E13.5)',END=180) RBID
      ELSE
        READ (IFSIG,'(E13.5)',END=180) RBID
      END IF

      GO TO 100
  110 CONTINUE

      DO 140 IGR = 1,NBGR
        IDEC = ZI(JCELD-1+ZI(JCELD-1+4+IGR)+8)
        TE = TYPELE(LIGRMO,IGR)
        CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',TE),NOMTE)
        IF (NOMTE.EQ.'MEDKTR3' .OR. NOMTE.EQ.'MEDKQU4' .OR.
     &      NOMTE.EQ.'MET3SEG3' .OR. NOMTE.EQ.'MEC3TR7H' .OR.
     &      NOMTE.EQ.'MEC3QU9H') THEN
          NBELGR = NBELEM(LIGRMO,IGR)
          CALL JEVEUO(JEXNUM(NOLIEL,IGR),'L',LIEL)
          DO 130 IEL = 1,NBELGR
            IMA = ZI(LIEL-1+IEL)
            CALL JEVEUO(JEXNUM(CONNEX,IMA),'L',IADNO)
            CALL JELIRA(JEXNUM(CONNEX,IMA),'LONMAX',NNO,K8B)
            IAD = JCELV - 1 + IDEC - 1 + NNO* (IEL-1)
            DO 120 I = 1,NNO
              INO = ZI(IADNO-1+I)
              IMAPL = ZI(JNOMA+INO-1)
              PRES = ZR(JPRES-1+IMAPL)
C  SUITE AUX CORRECTIONS SUR LE SIGNE DE LA PRESSION
C  ON NE MODIFIE SURTOUT PAS LA PRESSION LUE
C  ==> LES TE SAVENT CE QU4ILS ONT A FAIRE
              ZR(IAD+I) = PRES
  120       CONTINUE
  130     CONTINUE
        END IF
  140 CONTINUE

      NSYMB = 'PRES'
      CALL RSEXCH(RESU,NSYMB,IPAS,NOMCH,IRET)
      IF (IRET.EQ.100) THEN
      ELSE IF (IRET.EQ.110) THEN
        CALL RSAGSD(RESU,0)
        CALL RSEXCH(RESU,NSYMB,IPAS,NOMCH,IRET)
      ELSE
        CALL UTDEBM('F','OP0184','APPEL ERRONE')
        CALL UTIMPI('L','  ARCHIVAGE NUMERO : ',1,IPAS)
        CALL UTIMPI('L','  CODE RETOUR DE RSEXCH : ',1,IRET)
        CALL UTFINM()
      END IF
      CALL COPISD('CHAMP_GD','G',CHPRES,NOMCH)
      CALL RSNOCH(RESU,NSYMB,IPAS,' ')
      CALL RSADPA(RESU,'E',1,'INST',IPAS,0,JINST,K8B)
      ZR(JINST) = TEMPS
      DO 150 I = 1,NBMAPL
        ZR(JPRES-1+I) = 0.D0
  150 CONTINUE

      GO TO 60

  160 CONTINUE

      CALL UTDEBM('I','OP0184','LECTURE DES CHAMPS:')
      CALL RSORAC(RESU,'LONUTI',IBID,RBID,K8B,CBID,EPSI,CRIT,NBORDR,1,
     &            NBTROU)
      IF (NBORDR.LE.0) THEN
        CALL UTMESS('F','OP0184','AUCUN CHAMP LU.')
      END IF
      CALL WKVECT('&&OP0184.NUME_ORDR','V V I',NBORDR,LORDR)
      CALL RSORAC(RESU,'TOUT_ORDRE',IBID,RBID,K8B,CBID,EPSI,CRIT,
     &            ZI(LORDR),NBORDR,NBTROU)
      DO 170 IORD = 1,NBORDR
        CALL RSADPA(RESU,'L',1,'INST',ZI(LORDR+IORD-1),0,JINST,K8B)
        CALL UTIMPI('L','  NUMERO D''ORDRE : ',1,ZI(LORDR+IORD-1))
        CALL UTIMPR('L','            '//'INST'//' : ',1,ZR(JINST))
  170 CONTINUE
      CALL UTFINM()

      CALL TITRE

      IUL  = IUNIFI( 'RESULTAT' )
      CALL RSINFO ( RESU, IUL )

      GO TO 190

  180 CONTINUE
      CALL UTMESS('F','OP0184','PB LECTURE DU FICHIER IDEAS')

  190 CONTINUE
      CALL JEDEMA()

      END
