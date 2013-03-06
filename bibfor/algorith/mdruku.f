      SUBROUTINE MDRUKU (METHOD,TINIT,TFIN,DT,DTMIN,DTMAX,NBSAUV,
     &                   NBOBJS,NEQGEN,PULSAT,PULSA2,MASGEN,DESCMM,
     &                   RIGGEN,DESCMR,RGYGEN,LAMOR,AMOGEN,DESCMA,
     &                   GYOGEN,FONCV,FONCA,TYPBAS,BASEMO,LFLU,NBCHOC,
     &                   INTITU,LOGCHO,DPLMOD,PARCHO,NOECHO,
     &                   NBREDE,DPLRED,PARRED,FONRED,NBREVI,DPLREV,
     &                   FONREV,COEFM,LIAD,INUMOR,IDESCF,NOFDEP,NOFVIT,
     &                   NOFACC,NOMFON,PSIDEL,MONMOT,NBRFIS,FK,DFK,
     &                   ANGINI,FONCP,NBPAL,DTSTO,VROTAT,PRDEFF,
     &                   NOMRES,NBEXCI,NOMMAS,NOMRIG,NOMAMO)      
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 04/03/2013   AUTEUR ALARCON A.ALARCON 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
C
      INTEGER      DESCMM,DESCMR,DESCMA,PALMAX,NBREDE,NBREVI,DIMNAS,
     &             NBPAS,NEQGEN,NBSAUV,NBCHOC,NBRFIS,NBEXCI,ETAUSR,
     &             LOGCHO(NBCHOC,*),LIAD(*),INUMOR(*),IDESCF(*),
     &             NBPAL,NBOBJS,IAPP,IARCHI,ISTO1,ISTO2,ISTO3,ISTO4,
     &             JCHOR,JREDI,JREDR,JREVI,JREVR,JVINT,NBCONV,NBMXCV,
     &             NBSAUI,NBSCHO,IM,IND,IADRK,IARG,IBID,IVERI,JACCE,
     &             IER,IRET,JACCI,JACCS,JAMGY,JDCHO,
     &             JDEPI,JDEPL,JDEPS,JERDE,JERVI,JFCHO,JFEXT,
     &             JICHO,JINST,JKDE,JKVI,JM,JMASS,JORDR,JPASS,
     &             JREDC,JREDD,JREVC,JREVD,JRIGY,JTRA1,JVCHO,
     &             JVITE,JVITI,JVITS,N1,N100,NBPASC,JREFA,NM,NPM
      PARAMETER    (PALMAX=20)
      PARAMETER    (DIMNAS=8)
      REAL*8       PULSAT(*),PULSA2(*),MASGEN(*),RIGGEN(*),AMOGEN(*),
     &             PARCHO(*),PARRED(*),DPLREV(*),DPLRED(*),RGYGEN(*),
     &             DPLMOD(NBCHOC,NEQGEN,*),GYOGEN(*),DT,DT2,DTSTO,TFIN,
     &             VROTAT,CONV,FACOBJ,TINIT,ANGINI,EPSI,ERRT,R8BID1,
     &             TEMPS,COEFM(*),PSIDEL(*),DEUX,POW,R8PREM,
     &             FSAUV(PALMAX,3),VROTIN,AROTIN,DTMAX,DTMIN,TOL
      LOGICAL      LAMOR,LFLU,PRDEFF,ADAPT,FLAGDT      
      CHARACTER*3   FINPAL(PALMAX)
      CHARACTER*4   INTK,NOMSYM(3)
      CHARACTER*6   TYPAL(PALMAX)
      CHARACTER*8   CNPAL(PALMAX),BASEMO,NOECHO(NBCHOC,*),FONRED(*),
     &             FONREV(*),INTITU,NOMRES,MONMOT,FK(2),DFK(2),VITVAR,
     &             NOMMAS,NOMRIG,NOFDEP(*),NOFVIT(*),NOFACC(*),
     &             NOMFON(*),FONCV,FONCA,FONCP,NAMERK,NOMAMO,KREFD
      CHARACTER*14  MATPRE
      CHARACTER*16 TYPBAS,METHOD
      CHARACTER*19  MATASM
      CHARACTER*24  CPAL
C
C
C
C ======================================================================
C TOLE CRP_20 CRP_21
C
      CALL JEMARQ()
C
      NBOBJS=1
      CALL CODENT(NBOBJS,'D0',INTK)
      NAMERK='&&RK'//INTK
      CALL MDALLO(NAMERK,BASEMO,NOMMAS,NOMRIG,NOMAMO,NEQGEN,DT,NBSAUV,
     &            NBCHOC,NOECHO,INTITU,NBREDE,FONRED,NBREVI,
     &            FONREV,JDEPS,JVITS,JACCS,JPASS,JORDR,JINST,
     &            JFCHO,JDCHO,JVCHO,JICHO,JREDC,JREDD,JREVC,JREVD,
     &            METHOD,IBID,NOMSYM,'TRAN','VOLA')
C
C
      DEUX = 2.D0
      EPSI = R8PREM()
      JCHOR = 1
      JREDR = 1
      JREDI = 1
      JREVR = 1 
      JREVI = 1
      JVINT = 1
      ISTO1 = 0
      ISTO2 = 0
      ISTO3 = 0
      ISTO4 = 0
      IARCHI = 0
      NBSCHO = NBSAUV * 3 * NBCHOC
      NBSAUI = NBSAUV
C     PUISSANCE POUR LE CALCUL DU DT ADAPTATIF
      IF (METHOD(13:14).EQ.'54') POW=1.D0/6.D0
      IF (METHOD(13:14).EQ.'32') POW=1.D0/4.D0
C     RAPPORT D'AUGMENTATION DES OBJETS VOLATILES
      FACOBJ=1.5D0
C  COUPLAGE EDYOS : CONVERGENCE EDYOS :
      CONV = 1.D0
      NBCONV = 0
C  COUPLAGE EDYOS : NOMBRE MAXIMAL DE TENTATIVES DE REPRISE DES DONNEES
C  PRECEDENTES EN CAS DE NON-CONVERGENCE EDYOS :
      NBMXCV = 10
C     PAS DE LAME FLUIDE POUR LE SCHEMA RUNGE-KUTTA
      IF (LFLU) THEN
        CALL U2MESS('F','ALGORITH5_21')
      ENDIF
C      
      DO 111 IAPP = 1,PALMAX
        TYPAL(IAPP)='      '
        FINPAL(IAPP)='   '
        CNPAL(IAPP)=' '
 111   CONTINUE
C
C  GESTION DE LA VITESSE VARIABLE MACHINES TOURNANTES
      CALL WKVECT('&&RUKUT.AMOGYR','V V R8',NEQGEN*NEQGEN,JAMGY)
      CALL WKVECT('&&RUKUT.RIGGYR','V V R8',NEQGEN*NEQGEN,JRIGY)
      IF ( LAMOR ) THEN
        DO 100 IM = 1,NEQGEN
          AMOGEN(IM) = DEUX * AMOGEN(IM) * PULSAT(IM)
 100    CONTINUE
      ELSE
        CALL GETVTX(' ','VITESSE_VARIABLE',1,IARG,0,VITVAR,N1)
        IF(N1.NE.0)THEN
           CALL GETVTX(' ','VITESSE_VARIABLE',1,IARG,1,VITVAR,N1)
        ELSE
           VITVAR=' '
        ENDIF
        VROTIN = 0.D0
        AROTIN = 0.D0
        IF (VITVAR.EQ.'OUI') THEN
          CALL FOINTE('F ',FONCV,1,'INST',TINIT,VROTIN,IER)
          CALL FOINTE('F ',FONCA,1,'INST',TINIT,AROTIN,IER)
          DO 113 IM = 1 , NEQGEN
            DO 114 JM = 1 , NEQGEN
              IND = JM + NEQGEN*(IM-1)
              ZR(JAMGY+IND-1) = AMOGEN(IND) + VROTIN * GYOGEN(IND)
              ZR(JRIGY+IND-1) = RIGGEN(IND) + AROTIN * RGYGEN(IND)
 114        CONTINUE
 113      CONTINUE
        ELSE
          DO 117 IM = 1 , NEQGEN
            DO 118 JM = 1 , NEQGEN
              IND = JM + NEQGEN*(IM-1)
              ZR(JAMGY+IND-1) = AMOGEN(IND)
              ZR(JRIGY+IND-1) = RIGGEN(IND)
 118        CONTINUE
 117      CONTINUE
        ENDIF
      ENDIF

C     --- FACTORISATION DE LA MATRICE MASSE ---
C
      IF (TYPBAS.EQ.'BASE_MODA') THEN
        CALL WKVECT('&&RUKUT.MASS','V V R8',NEQGEN*NEQGEN,JMASS)
        CALL DCOPY(NEQGEN*NEQGEN,MASGEN,1,ZR(JMASS),1)
        CALL TRLDS(ZR(JMASS),NEQGEN,NEQGEN,IRET)
        IF (IRET.NE.0) THEN
          CALL U2MESS('F','ALGORITH5_22')
        ENDIF
        CALL DCOPY(NEQGEN*NEQGEN,MASGEN,1,ZR(JMASS),1)
      ELSEIF (TYPBAS.EQ.'MODELE_GENE     ') THEN
        MATPRE='&&RUKUT.MATPRE'
        MATASM=ZK24(ZI(DESCMM+1))(1:19)
        CALL PRERES(' ','V',IRET,MATPRE,MATASM,IBID,-9999)
      ELSE
        CALL WKVECT('&&RUKUT.MASS','V V R8',NEQGEN,JMASS)
        CALL DCOPY(NEQGEN,MASGEN,1,ZR(JMASS),1)
C       ICI IL FAUT NORMALEMENT TRAITER LE CAS DE LAME FLUIDE
C       MAIS IL N'EST PAS PREVU DANS RUNGE-KUTTA
      ENDIF
C
C     --- PARAMETRES DU SCHEMA ADAPTATIF ---
C
      CALL GETVR8('SCHEMA_TEMPS','TOLERANCE',1,IARG,1,TOL,N1)
C      ON LAISSE L'OPTION POUR SCHEMA ADAPTATIF OU PAS
      ADAPT=.TRUE.
C
C     --- FACTORISATION DE LA MATRICE MASSE ---

C     --- VECTEURS DE TRAVAIL ---
C
      CALL WKVECT('&&RUKUT.DEPL','V V R8',NEQGEN,JDEPL)
      CALL WKVECT('&&RUKUT.VITE','V V R8',NEQGEN,JVITE)
      CALL WKVECT('&&RUKUT.ACCE','V V R8',NEQGEN,JACCE)
      CALL WKVECT('&&RUKUT.TRA1','V V R8',NEQGEN,JTRA1)
      CALL WKVECT('&&RUKUT.FEXT','V V R8',NEQGEN,JFEXT)
C
      IF (NBCHOC.NE.0 .AND. NBPAL.EQ.0 ) THEN
         CALL WKVECT('&&RUKUT.SCHOR','V V R8',NBCHOC*14,JCHOR)
C        INITIALISATION POUR LE FLAMBAGE
         CALL JEVEUO(NAMERK//'           .VINT','E',JVINT)
         CALL R8INIR(NBCHOC,0.D0,ZR(JVINT),1)
      ENDIF
      IF (NBREDE.NE.0) THEN
         CALL WKVECT('&&RUKUT.SREDR','V V R8',NBREDE,JREDR)
         CALL WKVECT('&&RUKUT.SREDI','V V I' ,NBREDE,JREDI)
      ENDIF   
      IF (NBREVI.NE.0) THEN
         CALL WKVECT('&&RUKUT.SREVR','V V R8',NBREVI,JREVR)
         CALL WKVECT('&&RUKUT.SREVI','V V I' ,NBREVI,JREVI)
      ENDIF
C    --- VECTEURS SPECIFIQUES A RUNGE-KUTTA ---
      CALL WKVECT('&&RUKUT.DEPI','V V R8',NEQGEN,JDEPI)
      CALL WKVECT('&&RUKUT.VITI','V V R8',NEQGEN,JVITI)
      CALL WKVECT('&&RUKUT.ACCI','V V R8',NEQGEN,JACCI)
      CALL WKVECT('&&RUKUT.ERDE','V V R8',NEQGEN,JERDE)
      CALL WKVECT('&&RUKUT.ERVI','V V R8',NEQGEN,JERVI)
      IF (METHOD(13:14).EQ.'54') THEN
          CALL WKVECT('&&RUKUT.KKDE','V V R8',NEQGEN*6,JKDE)
          CALL WKVECT('&&RUKUT.KKVI','V V R8',NEQGEN*6,JKVI)
      ELSEIF (METHOD(13:14).EQ.'32') THEN
          CALL WKVECT('&&RUKUT.KKDE','V V R8',NEQGEN*3,JKDE)
          CALL WKVECT('&&RUKUT.KKVI','V V R8',NEQGEN*3,JKVI)
      ENDIF
C     --- CONDITIONS INITIALES ---
C
      CALL MDINIT(BASEMO,NEQGEN,NBCHOC,ZR(JDEPL),ZR(JVITE),ZR(JVINT),
     &            IRET, TINIT)
      IF (IRET.NE.0) GOTO 9999
      IF (NBCHOC.GT.0.AND.NBPAL.EQ.0) THEN
         CALL DCOPY(NBCHOC,ZR(JVINT),1,ZR(JCHOR+13*NBCHOC),1)
      ENDIF 
C
C     --- FORCES EXTERIEURES ---
C
      IF (NBEXCI.NE.0) THEN
         CALL MDFEXT (TINIT,R8BID1,NEQGEN,NBEXCI,IDESCF,NOMFON,COEFM,
     &                LIAD,INUMOR,1,ZR(JFEXT))
      ENDIF
C
C   COUPLAGE AVEC EDYOS
C
        IF (NBPAL .GT. 0 ) THEN
          CPAL='C_PAL'
C     RECUPERATION DES DONNEES SUR LES PALIERS 
C     -------------------------------------------------     
          CALL JEVEUO(CPAL,'L',IADRK)
          DO 21 IAPP=1,NBPAL
            FSAUV(IAPP,1)= 0.D0
            FSAUV(IAPP,2)= 0.D0
            FSAUV(IAPP,3)= 0.D0
            TYPAL(IAPP)=ZK8(IADRK+(IAPP-1))(1:6)
            FINPAL(IAPP)=ZK8(IADRK+(IAPP-1)+PALMAX)(1:3)
            CNPAL(IAPP)=ZK8(IADRK+(IAPP-1)+2*PALMAX)(1:DIMNAS)
  21      CONTINUE
        ENDIF
C  FIN COUPLAGE AVEC EDYOS
C
C       CAS CLASSIQUE
C
        IF (NBPAL.NE.0) NBCHOC = 0
        CALL MDFNLI(NEQGEN,ZR(JDEPL),ZR(JVITE),
     &            ZR(JACCE),ZR(JFEXT),MASGEN,R8BID1,
     &            PULSA2,ZR(JAMGY),
     &            NBCHOC,LOGCHO,DPLMOD,PARCHO,NOECHO,ZR(JCHOR),
     &            NBREDE,DPLRED,PARRED,FONRED,ZR(JREDR),ZI(JREDI),
     &            NBREVI,DPLREV,FONREV,
     &            TINIT,NOFDEP,NOFVIT,NOFACC,NBEXCI,PSIDEL,MONMOT,
     &            NBRFIS,FK,DFK,ANGINI,FONCP,
     &            1,NBPAL,DT,DTSTO,VROTAT,
     &            TYPAL, FINPAL,CNPAL,PRDEFF,CONV,FSAUV)
        IF ((CONV.LE.0.D0) .AND. (NBCONV.GT.NBMXCV)) THEN
          CALL U2MESS('F','EDYOS_46')
        ELSEIF ((CONV.LE.0.D0) .AND. (NBCONV.LE.NBMXCV)) THEN
          NBCONV = NBCONV + 1
        ENDIF
C
C     --- ACCELERATIONS GENERALISEES INITIALES ---
C
        CALL MDACCE(TYPBAS,NEQGEN,PULSA2,MASGEN,DESCMM,RIGGEN,
     &              DESCMR,ZR(JFEXT),LAMOR,ZR(JAMGY),DESCMA,ZR(JTRA1),
     &              ZR(JDEPL),ZR(JVITE),ZR(JACCE))
C
C      ENDIF

C--- INITIALISATION DU TEMPS ET DT ---
C
C     L'UTILISATEUR IMPOSE UN DTMAX?
      FLAGDT=.FALSE.
      CALL GETVR8('INCREMENT','PAS_MAXI',1,IARG,1,R8BID1,NPM)
      IF (NPM.NE.0) FLAGDT=.TRUE.
C      
      TEMPS = TINIT
      IF (FLAGDT.AND.(DT.GT.DTMAX)) DT=DTMAX
      IF (DT.LT.DTMIN) DT=DTMIN
C
C     --- ARCHIVAGE DONNEES INITIALES ---
C
      CALL MDARNL (ISTO1,IARCHI,TINIT,DT,NEQGEN,
     &        ZR(JDEPL),ZR(JVITE),ZR(JACCE),
     &        ISTO2,NBCHOC,ZR(JCHOR),NBSCHO,
     &        ISTO3,NBREDE,ZR(JREDR),ZI(JREDI),
     &        ISTO4,NBREVI,ZR(JREVR),ZI(JREVI),
     &        ZR(JDEPS),ZR(JVITS),ZR(JACCS),ZR(JPASS),ZI(JORDR),
     &        ZR(JINST),ZR(JFCHO),ZR(JDCHO),ZR(JVCHO),ZI(JICHO),
     &        ZR(JVINT),ZI(JREDC),ZR(JREDD),ZI(JREVC),ZR(JREVD))
         
         ISTO1 = ISTO1 + 1
         IARCHI = IARCHI + 1
C
C     INITIALISATION AVANT LA BOUCLE DE L'ETAT INITIAL
      CALL DCOPY(NEQGEN,ZR(JVITE),1,ZR(JVITI),1)
      CALL DCOPY(NEQGEN,ZR(JDEPL),1,ZR(JDEPI),1)
      CALL DCOPY(NEQGEN,ZR(JACCE),1,ZR(JACCI),1)
C
C     --- BOUCLE TEMPORELLE ---
C
 6666 CONTINUE
       IF (TEMPS.LT.TFIN) THEN
C      GESTION DU DERNIER PAS DE TEMPS
       IF (TEMPS+DT.GE.TFIN) DT=TFIN-TEMPS
C
C ESTIMATION DE L'ETAT ET DE L'ERREUR A L'INSTANT SUIVANT
       IF (METHOD(13:14).EQ.'54') THEN
           CALL MDDP54(NEQGEN,ZR(JDEPL),ZR(JVITE),ZR(JACCE),ZR(JFEXT),
     &                 DT,DTSTO,LFLU,NBEXCI,IDESCF,NOMFON,COEFM,LIAD,
     &                 INUMOR,NBCHOC,LOGCHO,DPLMOD,PARCHO,NOECHO,
     &                 ZR(JCHOR),NBREDE,DPLRED,PARRED,FONRED,ZR(JREDR),
     &                 ZI(JREDI),NBREVI,DPLREV,FONREV,NOFDEP,NOFVIT,
     &                 NOFACC,PSIDEL,MONMOT,NBRFIS,FK,DFK,ANGINI,FONCP,
     &                 NBPAL,VROTAT,TYPAL,FINPAL,CNPAL,PRDEFF,CONV,
     &                 FSAUV,TYPBAS,PULSA2,MASGEN,DESCMM,RIGGEN,DESCMR,
     &                 LAMOR,DESCMA,ZR(JTRA1),TEMPS,TOL,ZR(JDEPI),
     &                 ZR(JVITI),ZR(JERDE),ZR(JERVI),ZR(JKDE),ZR(JKVI),
     &                 FONCA,FONCV,IARCHI,ZR(JRIGY),ZR(JAMGY),NBCONV,
     &                 NBMXCV,VITVAR,GYOGEN,RGYGEN,AMOGEN,ERRT)
       ELSEIF (METHOD(13:14).EQ.'32') THEN
           CALL MDBS32(NEQGEN,ZR(JDEPL),ZR(JVITE),ZR(JACCE),ZR(JFEXT),
     &                 DT,DTSTO,LFLU,NBEXCI,IDESCF,NOMFON,COEFM,LIAD,
     &                 INUMOR,NBCHOC,LOGCHO,DPLMOD,PARCHO,NOECHO,
     &                 ZR(JCHOR),NBREDE,DPLRED,PARRED,FONRED,ZR(JREDR),
     &                 ZI(JREDI),NBREVI,DPLREV,FONREV,NOFDEP,NOFVIT,
     &                 NOFACC,PSIDEL,MONMOT,NBRFIS,FK,DFK,ANGINI,FONCP,
     &                 NBPAL,VROTAT,TYPAL,FINPAL,CNPAL,PRDEFF,CONV,
     &                 FSAUV,TYPBAS,PULSA2,MASGEN,DESCMM,RIGGEN,DESCMR,
     &                 LAMOR,DESCMA,ZR(JTRA1),TEMPS,TOL,ZR(JDEPI),
     &                 ZR(JVITI),ZR(JERDE),ZR(JERVI),ZR(JKDE),ZR(JKVI),
     &                 FONCA,FONCV,IARCHI,ZR(JRIGY),ZR(JAMGY),NBCONV,
     &                 NBMXCV,VITVAR,GYOGEN,RGYGEN,AMOGEN,ERRT)
       ENDIF
C
C     ON PASSE A L'INSTANT SUIVANT OU ON ADAPTE LE PAS?
C
       IF ((ERRT.LT.1.D0).OR.(DT.LE.DTMIN).OR.(.NOT.ADAPT)) THEN
         CALL DCOPY(NEQGEN,ZR(JACCE),1,ZR(JACCI),1)
         CALL DCOPY(NEQGEN,ZR(JVITE),1,ZR(JVITI),1)
         CALL DCOPY(NEQGEN,ZR(JDEPL),1,ZR(JDEPI),1)
C         
         TEMPS=TEMPS+DT
C
         IF (ISTO1.LT.(NBSAUV)) THEN
C
         CALL MDARNL (ISTO1,IARCHI,TEMPS,DT,NEQGEN,
     &                ZR(JDEPL),ZR(JVITE),ZR(JACCE),
     &                ISTO2,NBCHOC,ZR(JCHOR),NBSCHO,
     &                ISTO3,NBREDE,ZR(JREDR),ZI(JREDI),
     &                ISTO4,NBREVI,ZR(JREVR),ZI(JREVI),
     &                ZR(JDEPS),ZR(JVITS),ZR(JACCS),ZR(JPASS),ZI(JORDR),
     &                ZR(JINST),ZR(JFCHO),ZR(JDCHO),ZR(JVCHO),ZI(JICHO),
     &                ZR(JVINT),ZI(JREDC),ZR(JREDD),ZI(JREVC),ZR(JREVD))
         ISTO1 = ISTO1 + 1
         IARCHI = IARCHI + 1
C
         ELSE
C
         ISTO1 = 0
         ISTO2 = 0
         ISTO3 = 0
         ISTO4 = 0
         NBOBJS = NBOBJS + 1
         CALL CODENT(NBOBJS,'D0',INTK)

         NAMERK='&&RK'//INTK
         NBSAUV = INT(NBSAUV*FACOBJ)
         NBSCHO = NBSAUV * 3 * NBCHOC
C 
      CALL MDALLO(NAMERK,BASEMO,NOMMAS,NOMRIG,NOMAMO,NEQGEN,DT,NBSAUV,
     &            NBCHOC,NOECHO,INTITU,NBREDE,FONRED,NBREVI,
     &            FONREV,JDEPS,JVITS,JACCS,JPASS,JORDR,JINST,
     &            JFCHO,JDCHO,JVCHO,JICHO,JREDC,JREDD,JREVC,JREVD,
     &            METHOD,IBID,NOMSYM,'TRAN','VOLA')
C
         CALL MDARNL (ISTO1,IARCHI,TEMPS,DT,NEQGEN,
     &                ZR(JDEPL),ZR(JVITE),ZR(JACCE),
     &                ISTO2,NBCHOC,ZR(JCHOR),NBSCHO,
     &                ISTO3,NBREDE,ZR(JREDR),ZI(JREDI),
     &                ISTO4,NBREVI,ZR(JREVR),ZI(JREVI),
     &                ZR(JDEPS),ZR(JVITS),ZR(JACCS),ZR(JPASS),ZI(JORDR),
     &                ZR(JINST),ZR(JFCHO),ZR(JDCHO),ZR(JVCHO),ZI(JICHO),
     &                ZR(JVINT),ZI(JREDC),ZR(JREDD),ZI(JREVC),ZR(JREVD))
         ISTO1 = ISTO1 + 1
         IARCHI = IARCHI + 1
         ENDIF

       ELSE
C     ON REMET A L'ETAT DU TEMPS COURANT LES VALEURS DE JACCE ET JVITE
C     CAR ELLES ONT ETE MODIFIEES ENTRETEMPS DANS MDDP54 ET MDBS32
C     ALORS QU'ON NE PASSE PAS A L'INSTANT SUIVANT
         CALL DCOPY(NEQGEN,ZR(JVITI),1,ZR(JVITE),1)
         CALL DCOPY(NEQGEN,ZR(JACCI),1,ZR(JACCE),1)

       ENDIF
C
C      ESTIMATION DU PROCHAIN PAS DE TEMPS
       IF (ADAPT) THEN
          DT2=0.9D0*DT*(1.D0/ERRT)**POW
C         ON EMPECHE DES CHANGEMENTS BRUTAUX DE PAS DE TEMPS
          IF (DT2.GT.(5.D0*DT)) THEN
             DT=5.D0*DT
          ELSEIF (DT2.LT.(0.2D0*DT)) THEN
             DT=0.2D0*DT
          ELSE
             DT=DT2 
          ENDIF
C
          IF ((DT.LE.DTMIN).AND.(ABS(TFIN-(TEMPS+DT)).GT.EPSI)) THEN
              CALL U2MESS('F','ALGORITH5_23')
          ENDIF
       ENDIF
C      BLOCAGE DE DT A DTMAX SI DEMANDE PAR L'UTILISATEUR
       IF (FLAGDT.AND.(DT.GT.DTMAX)) DT=DTMAX
C
C        --- VERIFICATION SI INTERRUPTION DEMANDEE PAR SIGNAL USR1 ---
         IF ( ETAUSR().EQ.1 ) THEN
          CALL CONCRK (NOMRES,IARCHI,FACOBJ,NBOBJS,'&&RK',NBSAUI,
     &                 BASEMO,NOMMAS,NOMRIG,NOMAMO,NEQGEN,DT,
     &                 NBCHOC,NOECHO,INTITU,NBREDE,FONRED,NBREVI,
     &                 FONREV,METHOD)
C          
            CALL SIGUSR()
         ENDIF
C
       GOTO 6666
C     
      ENDIF
C     CONCATENATION DE TOUS LES RESULTATS DANS UN SEUL OBJET SUR BASE 
C     GLOBALE DE LA BONNE TAILLE
      CALL CONCRK (NOMRES,IARCHI,FACOBJ,NBOBJS,'&&RK',NBSAUI,
     &             BASEMO,NOMMAS,NOMRIG,NOMAMO,NEQGEN,DT,
     &             NBCHOC,NOECHO,INTITU,NBREDE,FONRED,NBREVI,
     &             FONREV,METHOD)
C
 9999 CONTINUE

      CALL JEDETR('&&RUKUT.DEPL')
      CALL JEDETR('&&RUKUT.VITE')
      CALL JEDETR('&&RUKUT.ACCE')
      CALL JEDETR('&&RUKUT.TRA1')
      CALL JEDETR('&&RUKUT.FEXT')
      CALL JEDETR('&&RUKUT.MASS')
      CALL JEDETR('&&RUKUT.AMOGYR')
      CALL JEDETR('&&RUKUT.RIGGYR')
C
      CALL JEDETR('&&RUKUT.DEPI')
      CALL JEDETR('&&RUKUT.VITI')
      CALL JEDETR('&&RUKUT.ACCI')
      CALL JEDETR('&&RUKUT.ERDE')
      CALL JEDETR('&&RUKUT.ERVI')
      CALL JEDETR('&&RUKUT.KKDE')
      CALL JEDETR('&&RUKUT.KKVI')
C
      IF (NBCHOC.NE.0) THEN
         CALL JEDETR('&&RUKUT.SCHOR')
      ENDIF
      IF (NBREDE.NE.0) THEN
         CALL JEDETR('&&RUKUT.SREDR')
         CALL JEDETR('&&RUKUT.SREDI')
      ENDIF   
      IF (NBREVI.NE.0) THEN
         CALL JEDETR('&&RUKUT.SREVR')
         CALL JEDETR('&&RUKUT.SREVI')
      ENDIF
C
      CALL JEDEMA()
      END
