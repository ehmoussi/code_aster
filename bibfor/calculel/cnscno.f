      SUBROUTINE CNSCNO(CNSZ,PRCHNZ,PROL0,BASEZ,CNOZ,KSTOP,IRET)
C RESPONSABLE PELLET J.PELLET
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 11/06/2012   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_6

      IMPLICIT NONE
      CHARACTER*(*) CNSZ,CNOZ,BASEZ,PRCHNZ,PROL0
      CHARACTER*1 KSTOP
C ------------------------------------------------------------------
C BUT : TRANSFORMER UN CHAM_NO_S (CNSZ) EN CHAM_NO (CNOZ)
C ------------------------------------------------------------------
C     ARGUMENTS:
C CNSZ    IN/JXIN  K19 : SD CHAM_NO_S A TRANSFORMER
C PRCHNZ  IN/JXVAR K19 : SD PROF_CHNO  (OU ' ')
C          SI PRCHNZ EXISTE ON CREE CNOZ CONFORMEMENT A PRCHNZ :
C             => SI CNSZ CONTIENT DES VALEURS QUE L'ON NE SAIT PAS
C                STOCKER DANS PRCHNZ, ON LES "OUBLIE"
C             => SI PRCHNZ EXIGE DES VALEURS QUE L'ON NE TROUVE PAS
C                DANS CNSZ :
C                  - SI PROL0='OUI' : ON PRENDS LA VALEUR "ZERO"
C                  - SI PROL0='NON' : ERREUR <F>

C          SI PRCHNZ N'EXISTE PAS ON CREE CNOZ EN FONCTION
C             DU CONTENU DE CNSZ
C             SI PRCHNZ  = ' ' ON CREE UN PROF_CHNO "SOUS-TERRAIN"
C             SI PRCHNZ /= ' ' ON CREE UN PROF_CHNO DE NOM PRCHNZ
C PROL0   IN   K3  :  POUR PROLONGER (OU NON) LE CHAMP PAR "ZERO"
C        /OUI /NON  ( CET ARGUMENT N'EST UTILISE QUE SI PRCHNZ /= ' ')
C        "ZERO" : / 0       POUR LES CHAMPS NUMERIQUES (R/C/I)
C                 / ' '     POUR LES CHAMPS "KN"
C                 / .FALSE. POUR LES CHAMPS DE "L"

C BASEZ   IN       K1  : BASE DE CREATION POUR CNOZ : G/V/L
C CNOZ    IN/JXOUT K19 : SD CHAM_NO A CREER
C KSTOP   IN       K1  : COMPORTEMENT EN CAS DE PROBLEME :
C              / 'A' : ON EMET UNE ALARME ET ON REND IRET > 0
C              / 'F' : ON EMET UNE ERREUR FATALE
C              / ' ' : ON N'EMET PAS DE MESSAGE
C IRET    OUT       I  : CODE DE RETOUR :
C              / 0 : OK
C              / 1 : LE CHAM_NO N'A PAS PU ETRE CREE
C----------------------------------------------------------------------

C---- COMMUNS NORMALISES  JEVEUX
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
      CHARACTER*24 ZK24,NOOJB
      CHARACTER*24 VALK(3)
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----------------------------------------------------------------
      INTEGER ICMP,NEC,JCNSK,JCNSD,JCNSV,JCNSL,GD,IEXI,NCMP,JCORR2
      INTEGER RESTE,IEC,CODE,NBNO,IBID,JNUCMP,JNUCM1,JCNSC,JREFN
      INTEGER NCMPMX,JREFE,NCMP1,NEQ2,JCMPGD,ICMP1,K,IEQ2,IEXI2,NBEC
      INTEGER JPRN2,INO,IDG2,ICO,JDESC,JDEEQ,JVALE,INDIK8,IRET,N1
      INTEGER LSHIFT
      CHARACTER*1 BASE,KBID
      CHARACTER*8 MA,NOMGD,NOMNO,NOMCMP
      LOGICAL LPCHNO
      CHARACTER*3 TSCA
      CHARACTER*19 CNS,CNO,PRCHNO,MESSAG
      CHARACTER*32 JEXNOM,JEXNUM
C     -----------------------------------------------------------------
      CALL JEMARQ()


      BASE=BASEZ
      CALL ASSERT((BASE.EQ.'G') .OR. (BASE.EQ.'V'))
      CNS=CNSZ
      CNO=CNOZ
C     CALL UTIMSD(6,2,.TRUE.,.TRUE.,CNS,1,' ')

      CALL JEVEUO(CNS//'.CNSK','L',JCNSK)
      CALL JEVEUO(CNS//'.CNSD','L',JCNSD)
      CALL JEVEUO(CNS//'.CNSC','L',JCNSC)
      CALL JEVEUO(CNS//'.CNSV','L',JCNSV)
      CALL JEVEUO(CNS//'.CNSL','L',JCNSL)

      MA=ZK8(JCNSK-1+1)
      NOMGD=ZK8(JCNSK-1+2)
      NBNO=ZI(JCNSD-1+1)
      NCMP1=ZI(JCNSD-1+2)

      CALL DISMOI('F','NB_EC',NOMGD,'GRANDEUR',NEC,KBID,IBID)
      CALL DISMOI('F','TYPE_SCA',NOMGD,'GRANDEUR',IBID,TSCA,IBID)
      CALL DISMOI('F','NB_CMP_MAX',NOMGD,'GRANDEUR',NCMPMX,KBID,IBID)
      CALL DISMOI('F','NB_EC',NOMGD,'GRANDEUR',NBEC,KBID,IBID)
      CALL DISMOI('F','NUM_GD',NOMGD,'GRANDEUR',GD,KBID,IBID)


C     -- SI CNO EXISTE DEJA, ON LE DETRUIT :
      CALL DETRSD('CHAM_NO',CNO)


C     1- REMPLISSAGE DE .TMP_NUCMP ET .TMP_NUCM1 :
C     --------------------------------------------
      CALL WKVECT('&&CNSCNO.TMP_NUCMP','V V I',NCMPMX,JNUCMP)
      CALL WKVECT('&&CNSCNO.TMP_NUCM1','V V I',NCMP1,JNUCM1)

      CALL JEVEUO(JEXNOM('&CATA.GD.NOMCMP',NOMGD),'L',JCMPGD)
      DO 10,ICMP1=1,NCMP1
        NOMCMP=ZK8(JCNSC-1+ICMP1)
        ICMP=INDIK8(ZK8(JCMPGD),NOMCMP,1,NCMPMX)
        CALL ASSERT(ICMP.GT.0)
        ZI(JNUCMP-1+ICMP)=ICMP1
        ZI(JNUCM1-1+ICMP1)=ICMP
   10 CONTINUE


      IF (PRCHNZ.EQ.' ') THEN
        IF (BASE.EQ.'G') THEN
          NOOJB='12345678.PRCHN00000.PRNO'
          CALL GNOMSD(NOOJB,15,19)
          PRCHNO=NOOJB(1:19)
        ELSE
          CALL GCNCON('.',PRCHNO)
        ENDIF
      ELSE
        PRCHNO=PRCHNZ
C       -- ON VEUT VERIFIER QUE PRCHNO EST COHERENT AVEC MA ET NOMGD :
        CALL JEEXIN(PRCHNO//'.PRNO',IEXI)
        IF (IEXI.GT.0) THEN
          VALK(1)=CNO
          VALK(2)=PRCHNO
          CALL JEEXIN(PRCHNO//'.REFN',IEXI2)
          IF (IEXI2.GT.0) THEN
C         -- SI PRCHNO VIENT D'UN NUME_EQUA, ON PEUT VERIFIER :
            CALL JEVEUO(PRCHNO//'.REFN','L',JREFN)
            IF ((ZK24(JREFN-1+1).NE.MA) .OR.
     &          (ZK24(JREFN-1+2).NE.NOMGD)) THEN
C             -- ON ACCEPTE : DEPL_R / DEPL_C
              IF ((NOMGD(1:5).EQ.'DEPL_') .AND.
     &            (ZK24(JREFN-1+2)(1:5).EQ.'DEPL_')) THEN
              ELSE
                CALL U2MESK('F','CALCULEL4_6',2,VALK)
              ENDIF
            ENDIF
          ELSE
C         -- SINON ON NE PEUT VERIFIER QUE LA LONGUEUR DE .PRNO :
            CALL JELIRA(JEXNUM(PRCHNO//'.PRNO',1),'LONMAX',N1,KBID)
            IF (N1.NE.NBNO*(NBEC+2)) CALL U2MESK('F','CALCULEL4_6',2,
     &          VALK)
          ENDIF
        ENDIF
      ENDIF


C     2- ON CREE (SI NECESSAIRE) LE PROF_CHNO  :
C     ------------------------------------------
      CALL JEEXIN(PRCHNO//'.PRNO',IEXI)
      LPCHNO=(IEXI.EQ.0)
      IF (LPCHNO) THEN

C       2.1 ON COMPTE LES CMPS PORTEES PAR CNS :
        NEQ2=0
        DO 20,K=1,NBNO*NCMP1
          IF (ZL(JCNSL-1+K))NEQ2=NEQ2+1
   20   CONTINUE
        IF (NEQ2.EQ.0) THEN
          VALK(1)=CNS
          VALK(2)=CNO
          MESSAG='CALCULEL2_12'
          GOTO 70

        ENDIF

C       2.2 ALLOCATION DES OBJETS :
        CALL CRPRN2(PRCHNO,BASE,NBNO,NEQ2,NEC)

C       2.3 REMPLISSAGE DE .PRNO :
        CALL JEVEUO(JEXNUM(PRCHNO//'.PRNO',1),'E',JPRN2)
        DO 40,INO=1,NBNO
          DO 30,ICMP1=1,NCMP1
            IF (ZL(JCNSL-1+(INO-1)*NCMP1+ICMP1)) THEN
              ICMP=ZI(JNUCM1-1+ICMP1)
              IEC=(ICMP-1)/30+1
              RESTE=ICMP-30*(IEC-1)
              CODE=LSHIFT(1,RESTE)
              IDG2=JPRN2-1+((2+NEC)*(INO-1))+2+IEC
              ZI(IDG2)=IOR(ZI(IDG2),CODE)
              ZI(JPRN2-1+((2+NEC)*(INO-1))+2)=ZI(JPRN2-1+
     &          ((2+NEC)*(INO-1))+2)+1
            ENDIF
   30     CONTINUE
   40   CONTINUE

        ICO=0
        DO 50,INO=1,NBNO
          ZI(JPRN2-1+((2+NEC)*(INO-1))+1)=ICO+1
          ICO=ICO+ZI(JPRN2-1+((2+NEC)*(INO-1))+2)
   50   CONTINUE
        CALL JELIBE(PRCHNO//'.PRNO')

C       2.4 CREATION  DE .DEEQ :
C       POUR DES RAISONS DE PERFORMANCES, IL VAUT MIEUX LE
C       FAIRE PLUTARD.
      ENDIF


C     4- ON CREE LE .REFE :
C     ------------------------
      CALL WKVECT(CNO//'.REFE',BASE//' V K24',4,JREFE)
      ZK24(JREFE-1+1)=MA
      ZK24(JREFE-1+2)=PRCHNO
      ZK24(JREFE-1+3)=' '
      ZK24(JREFE-1+4)=' '


C     5- ON CREE LE .DESC :
C     ------------------------
      CALL WKVECT(CNO//'.DESC',BASE//' V I',2,JDESC)
      CALL JEECRA(CNO//'.DESC','DOCU',IBID,'CHNO')
      ZI(JDESC-1+1)=GD
      ZI(JDESC-1+2)=1


C     5-BIS ON CREE SI NECESSAIRE LE .DEEQ DU PROF_CHNO
C     ----------------------------------------------------
      IF (LPCHNO) THEN
        CALL CMPCHA(CNO,'&&CNSCNO.NOMCMP','&&CNSCNO.CORR1',
     &              '&&CNSCNO.CORR2',NCMP,NCMPMX)
        CALL JEVEUO('&&CNSCNO.CORR2','L',JCORR2)
C       -- POUR ECONOMISER LA MEMOIRE (PENDANT PTEEQU)
C          ON LIBERE TEMPORAIREMENT .CNSV ET .CNSL :
        CALL JELIBE(CNS//'.CNSV')
        CALL JELIBE(CNS//'.CNSL')
        CALL PTEEQU(PRCHNO,BASE,NEQ2,GD,NCMP,ZI(JCORR2))

        CALL JEDETR('&&CNSCNO.NOMCMP')
        CALL JEDETR('&&CNSCNO.CORR1')
        CALL JEDETR('&&CNSCNO.CORR2')
        CALL JEVEUO(CNS//'.CNSV','L',JCNSV)
        CALL JEVEUO(CNS//'.CNSL','L',JCNSL)
      ENDIF


C     6- ON CREE ET ON REMPLIT LE .VALE :
C     -----------------------------------
      CALL JELIRA(PRCHNO//'.NUEQ','LONMAX',NEQ2,KBID)
      CALL JEVEUO(PRCHNO//'.DEEQ','L',JDEEQ)
      CALL WKVECT(CNO//'.VALE',BASE//' V '//TSCA,NEQ2,JVALE)

      DO 60,IEQ2=1,NEQ2
        INO=ZI(JDEEQ-1+2*(IEQ2-1)+1)
        ICMP=ZI(JDEEQ-1+2*(IEQ2-1)+2)
        IF (INO*ICMP.GT.0) THEN
          NOMCMP=ZK8(JCMPGD-1+ICMP)
          ICMP1=ZI(JNUCMP-1+ICMP)

          IF (ICMP1.EQ.0) THEN
            IF (PROL0.EQ.'NON') THEN
              CALL JENUNO(JEXNUM(MA//'.NOMNOE',INO),NOMNO)
              VALK(1)=NOMCMP
              VALK(2)=NOMNO
              VALK(3)=CNO
              MESSAG='CALCULEL2_13'
              GOTO 70

            ELSE
              CALL ASSERT(PROL0.EQ.'OUI')
              IF (TSCA.EQ.'R') THEN
                ZR(JVALE-1+IEQ2)=0.D0

              ELSEIF (TSCA.EQ.'C') THEN
                ZC(JVALE-1+IEQ2)=(0.D0,0.D0)

              ELSEIF (TSCA.EQ.'I') THEN
                ZI(JVALE-1+IEQ2)=0

              ELSEIF (TSCA.EQ.'L') THEN
                ZL(JVALE-1+IEQ2)=.FALSE.

              ELSEIF (TSCA.EQ.'K8') THEN
                ZK8(JVALE-1+IEQ2)=' '

              ELSE
                CALL ASSERT(.FALSE.)
              ENDIF
              GOTO 60

            ENDIF
          ENDIF

          IF (ZL(JCNSL-1+(INO-1)*NCMP1+ICMP1)) THEN
            IF (TSCA.EQ.'R') THEN
              ZR(JVALE-1+IEQ2)=ZR(JCNSV-1+(INO-1)*NCMP1+ICMP1)

            ELSEIF (TSCA.EQ.'C') THEN
              ZC(JVALE-1+IEQ2)=ZC(JCNSV-1+(INO-1)*NCMP1+ICMP1)

            ELSEIF (TSCA.EQ.'I') THEN
              ZI(JVALE-1+IEQ2)=ZI(JCNSV-1+(INO-1)*NCMP1+ICMP1)

            ELSEIF (TSCA.EQ.'L') THEN
              ZL(JVALE-1+IEQ2)=ZL(JCNSV-1+(INO-1)*NCMP1+ICMP1)

            ELSEIF (TSCA.EQ.'K8') THEN
              ZK8(JVALE-1+IEQ2)=ZK8(JCNSV-1+(INO-1)*NCMP1+ICMP1)

            ELSE
              CALL ASSERT(.FALSE.)
            ENDIF

          ELSE
            IF (PROL0.EQ.'NON') THEN
              CALL JENUNO(JEXNUM(MA//'.NOMNOE',INO),NOMNO)
              VALK(1)=NOMCMP
              VALK(2)=NOMNO
              VALK(3)=CNO
              MESSAG='CALCULEL2_13'
              GOTO 70

            ELSE
              CALL ASSERT(PROL0.EQ.'OUI')
              IF (TSCA.EQ.'R') THEN
                ZR(JVALE-1+IEQ2)=0.D0

              ELSEIF (TSCA.EQ.'C') THEN
                ZC(JVALE-1+IEQ2)=(0.D0,0.D0)

              ELSEIF (TSCA.EQ.'I') THEN
                ZI(JVALE-1+IEQ2)=0

              ELSEIF (TSCA.EQ.'L') THEN
                ZL(JVALE-1+IEQ2)=.FALSE.

              ELSEIF (TSCA.EQ.'K8') THEN
                ZK8(JVALE-1+IEQ2)=' '

              ELSE
                CALL ASSERT(.FALSE.)
              ENDIF
              GOTO 60

            ENDIF
          ENDIF
        ENDIF
   60 CONTINUE

      IRET=0
      GOTO 80


C     -- MESSAGES D'ERREUR:
C     ---------------------
   70 CONTINUE
      CALL ASSERT(KSTOP.EQ.'F' .OR. KSTOP.EQ.'A' .OR. KSTOP.EQ.' ')
      IRET=1
      CALL DETRSD('CHAMP',CNO)
      IF (KSTOP.EQ.' ')GOTO 80

      IF (MESSAG.EQ.'CALCULEL2_12') THEN
        CALL U2MESK(KSTOP,'CALCULEL2_12',2,VALK)
      ELSEIF (MESSAG.EQ.'CALCULEL2_13') THEN
        CALL U2MESK(KSTOP,'CALCULEL2_13',3,VALK)
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF



   80 CONTINUE
      CALL JEDETR('&&CNSCNO.TMP_NUCMP')
      CALL JEDETR('&&CNSCNO.TMP_NUCM1')
      CALL JEDEMA()
C     CALL UTIMSD(6,2,.TRUE.,.TRUE.,CNO,1,' ')
      END
