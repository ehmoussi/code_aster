      SUBROUTINE DIINIT(INSTAN,PARTPS,DERNIE,RESULT,NBOBSE,
     &                  NUMINI,LOBSER,NUOBSE,NOMTAB,MAILL2,
     &                  NBOBAR,LISINS,LISOBS,MATE  ,CARELE,
     &                  SDSUIV,SDDYNA)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 08/11/2007   AUTEUR SALMONA L.SALMONA 
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
C RESPONSABLE MABBAS M.ABBAS
C TOLE CRP_20
C
      IMPLICIT      NONE
      LOGICAL       LOBSER
      INTEGER       DERNIE,NBOBSE,NUOBSE,NUMINI,NBOBAR
      REAL*8        INSTAN
      CHARACTER*8   RESULT,MAILL2
      CHARACTER*19  PARTPS,NOMTAB,LISOBS,LISINS,SDDYNA
      CHARACTER*24  CARELE,SDSUIV,MATE
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (STRUCTURES DE DONNES)
C
C CREATION SD DISCRETISATION, ARCHIVAGE ET OBSERVATION
C
C ----------------------------------------------------------------------
C
C
C IN  INSTAN : INSTANT INITIAL QUAND ETAT_INIT (OU R8VIDE)
C I/O PARTPS : SD DISCRETISATION
C IN  DERNIE : DERNIER NUMERO ARCHIVE (OU 0 SI NON REENTRANT)
C OUT NBOBSE : NOMBRE DE PAS A OBSERVER
C OUT NUMINI : NUMERO DU PREMIER INSTANT DE CALCUL DANS LISTE
C                 D'INSTANT D'OBSERVATION
C OUT LOBSER : BOOLEEN OBSERVATION
C IN  INSTAM : PREMIER INSTANT DE CALCUL
C IN  RESULT : NOM UTILISATEUR DU RESULTAT
C OUT NUOBSE : ??
C OUT NOMTAB : NOM DE LA TABLE RESULTAT DE L'OBSERVATION
C OUT MAILL2 : MAILLAGE OBSERVATION (?)
C OUT NBOBAR : LONGUEUR DU CHAMP OBSERVE
C OUT LISINS : LISTE D'INSTANTS DE L'OBSERVATION
C I/O LISOBS : SD LISTE OBSERVATION
C IN  MATE   : NOM DU CHAMP DE MATERIAU
C IN  CARELE : NOM DU CHAMP DE CARACTERISTIQUES ELEMENTAIRES
C IN  SDDYNA : NOM DE LA SD DEDIEE A LA DYNAMIQUE (CF NDLECT)
C IN  SDSUIV : NOM DE LA SD POUR SUIVI DDL
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      INTEGER      ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8       ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16   ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL      ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8  ZK8
      CHARACTER*16    ZK16
      CHARACTER*24        ZK24
      CHARACTER*32            ZK32
      CHARACTER*80                ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      REAL*8    ZERO,UN
      PARAMETER (ZERO=0.D0,UN= 1.0D+00)
      INTEGER      JINST,JTEMPS,JLIARC,JARCH,JMETH,JERRE
      INTEGER      JEXCL,JINFO,JNIVTP,JINSAR,JORDAR
      INTEGER      NUMFIN,SENS,POS
      INTEGER      IRET,I,IBID,IRE1,IRE2
      INTEGER      NLIARC,NUMARC,FREARC
      INTEGER      NUMINS
      INTEGER      NB,N1,N2,N3,N4,N5,NOCC,NM
      INTEGER      NBTEMP,NBINST,NBRPAS,NBPLUS,NBITER
      INTEGER      LONG,NORDAR
      INTEGER      KKKMA,ITER1,ITER2
      REAL*8       DELTAT,DELMIN,TOLE,INST,RATIO,PASMIN,R8BID
      REAL*8       R8VIDE
      REAL*8       VALE,INSTAR,DIFF
      REAL*8       DT,DTMIN,INS
      LOGICAL      TEST,LINSTI,NDYNLO
      CHARACTER*8  K8BID,MECA
      CHARACTER*16 CHRONO,K16BID,METHOD,NOMCMD
      CHARACTER*19 LISARC
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      CHRONO = ' '
      LISINS = ' '
      LINSTI = .FALSE.
      NBOBSE = 0
      LOBSER = .FALSE.
      CALL GETRES(K8BID,K8BID,NOMCMD)
C
C --- CONSTRUCTION DE LA LISTE D'INSTANTS
C
      CALL GETVTX('INCREMENT','EVOLUTION',1,1,1,CHRONO,N1)
      CALL GETVID('INCREMENT','LIST_INST'  ,1,1,1,LISINS,N1)

      CALL JEVEUO(LISINS // '.VALE', 'L', JINST)
      CALL JELIRA(LISINS // '.VALE', 'LONMAX', NBINST, K8BID)

      NBINST = NBINST-1
C
C --- VERIFICATIONS DIVERSES
C
C --- IL Y A AU MOINS UN INSTANT DE CALCUL

      IF (NBINST.LE.0) CALL U2MESS('F','ALGORITH2_86')

C --- VERIFICATION DU CARACTERE CROISSANT DE LA LISTE D'INSTANTS

      IF (CHRONO .NE. 'SANS') THEN
       DELMIN = ZR(JINST+1) - ZR(JINST)
       DO 10 I = 0,NBINST-1
        DELTAT = ZR(JINST + I+1) - ZR(JINST + I)
        DELMIN = MIN(DELTAT,DELMIN)
        IF (DELTAT.LE.0) CALL U2MESS('F','ALGORITH2_87')
10     CONTINUE

C --- TOLERANCE POUR ACCES PAR INSTANT
       CALL GETVR8('INCREMENT','PRECISION'     ,1,1,1,TOLE,N1)
       TOLE = DELMIN * TOLE
      END IF

C -- DETERMINATION DU NUMERO D'ORDRE INITIAL

      CALL GETVIS('INCREMENT','NUME_INST_INIT',1,1,1,NUMINI,N1)
      CALL GETVR8('INCREMENT','INST_INIT'     ,1,1,1,INST  ,N2)
      CALL GETFAC('ETAT_INIT',N3)

C    L'INSTANT DE L'ETAT INITIAL EXISTE-T-IL

      IF (INSTAN .EQ. R8VIDE()) N3=0

C    PAS D'OCCURENCE DES MOTS-CLES -> NUMERO INITIAL

      IF (N1+N2+N3 .EQ. 0) THEN
       IF (CHRONO .EQ. 'RETROGRADE') THEN
        NUMINI = NBINST
       ELSE
        NUMINI = 0
       END IF

C MOTS-CLES INST_INIT OU INSTANT DEFINI PAR ETAT_INIT

      ELSE IF (N1 .EQ. 0) THEN

C    EVOLUTION CHRONOLOGIQUE OU RETROGRADE UNIQUEMENT

       IF (CHRONO.EQ.'SANS') CALL U2MESS('F','ALGORITH2_88')

C   INSTANT DE L'ETAT INITIAL

       IF (N2 .EQ. 0) THEN
        INST = INSTAN
        CALL UTACLI(INST,ZR(JINST),NBINST,TOLE,NUMINI)

C SI INST NON PRESENT DANS LA LISTE D INSTANT
C ON CHERCHE L INSTANT LE PLUS PROCHE AVANT L'INSTANT CHERCHE
C (CAS CHRONOLOGIQUE) OU APRES L'INSTANT CHERCHE (CAS RETROGRADE)

        IF (NUMINI.LT.0) THEN
         LINSTI = .TRUE.
         DTMIN=INST-ZR(JINST)
         INS=ZR(JINST)
         DO 40 I=1,NBINST
          DT=INST-ZR(JINST+I)
          IF (CHRONO .EQ. 'RETROGRADE') THEN
           IF (DT.GE.0.D0) GOTO 45
           IF (DT.GT.DTMIN) THEN
            DTMIN=DT
            INS=ZR(JINST+I)
           ENDIF
          ELSE
           IF (DT.LE.0.D0) GOTO 45
           IF (DT.LT.DTMIN) THEN
            DTMIN=DT
            INS=ZR(JINST+I)
           ENDIF
          ENDIF
 40      CONTINUE
 45      CONTINUE
         INST=INS
        ENDIF
       ENDIF

C  ACCES A L'INSTANT INST

       CALL UTACLI(INST,ZR(JINST),NBINST,TOLE,NUMINI)
       IF (NUMINI .LT. 0) CALL U2MESS('F','ALGORITH2_89')
      END IF

C -- DETERMINATION DU NUMERO D'ORDRE FINAL

      CALL GETVIS('INCREMENT','NUME_INST_FIN',1,1,1,NUMFIN,N1)
      CALL GETVR8('INCREMENT','INST_FIN'     ,1,1,1,INST  ,N2)

C    PAS D'OCCURENCE DES MOTS-CLES -> NUMERO INITIAL

      IF (N1+N2 .EQ. 0) THEN
       IF (CHRONO .EQ. 'RETROGRADE') THEN
        NUMFIN = 0
       ELSE
        NUMFIN = NBINST
       END IF

C    MOT-CLE NUME_INST_FIN

      ELSE IF (N1 .EQ. 0) THEN

C   EVOLUTION CHRONOLOGIQUE OU RETROGRADE UNIQUEMENT

       IF (CHRONO.EQ.'SANS') CALL U2MESS('F','ALGORITH2_88')

C   ACCES A L'INSTANT INST

       CALL UTACLI(INST,ZR(JINST),NBINST,TOLE,NUMFIN)
       IF (NUMFIN .LT. 0) CALL U2MESS('F','ALGORITH2_90')
      END IF

C -- ECRITURE DE LA LISTE D'INSTANTS

      IF (NUMFIN.LT.0 .OR. NUMFIN.GT.NBINST) THEN
       CALL U2MESS('A','ALGORITH2_94')
       IF (CHRONO .EQ. 'RETROGRADE') THEN
        NUMFIN = 0
       ELSE
        NUMFIN = NBINST
       END IF
      END IF

      IF (CHRONO .EQ. 'RETROGRADE') THEN
       SENS = -1
       IF (NUMINI .LE. NUMFIN) CALL U2MESS('F','ALGORITH2_91')
      ELSE
       SENS = 1
       IF (NUMINI.GE.NUMFIN) CALL U2MESS('F','ALGORITH2_92')
      END IF

      IF (NUMINI.LT.0 .OR. NUMINI.GT.NBINST) THEN
        CALL U2MESS('F','ALGORITH2_93')
      ENDIF

      NBTEMP= (NUMFIN-NUMINI)*SENS
      CALL WKVECT(PARTPS // '.DITR','V V R8',NBTEMP+1,JTEMPS)
C  PARTPS // '.DINI' SERVIRA COMME INDICATEUR DU NIVEAU DE SUBDIVISION
C  DES PAS DE TEMPS : ON L INITIALISE ICI A 1
      CALL WKVECT(PARTPS // '.DINI','V V I' ,NBTEMP+1,JNIVTP)
      POS = 0
      DO 20 I = NUMINI, NUMFIN, SENS
       ZR(JTEMPS+POS) = ZR(JINST+I)
       ZI(JNIVTP+POS) = 1
       POS = POS+1
 20   CONTINUE
C  SI L'INSTANT INITIAL N'EXISTAIT PAS DANS LA LISTE D'INSTANTS
C  ON A PRIS PLUS HAUT L'INSTANT LE PLUS PROCHE PRECEDENT : ICI ON MET
C  LA BONNE VALEUR COMME INSTANT INITIAL
      IF (LINSTI) ZR(JTEMPS)=INSTAN

C     EVALUATION DE LA CONDITION DE COURANT EN EXPLICITE
      IF (NDYNLO(SDDYNA,'EXPLICITE')) THEN
        IF(NDYNLO(SDDYNA,'PROJ_MODAL'))THEN
          CALL GETVID('PROJ_MODAL','MODE_MECA',1,1,1,MECA,NM)
          CALL PASCOM(MECA,SDDYNA)
        ELSE
          CALL PASCOU(MATE,CARELE,SDDYNA)
        ENDIF
      ENDIF

C ======================================================================
C   INFORMATIONS SUR L'ARCHIVAGE
C ======================================================================

C -- LISTE D'ARCHIVAGE
C 22
      CALL WKVECT(PARTPS // '.DIAL','V V L',NBTEMP+1,JARCH)
      DO 25 I = 1, NBTEMP
        ZL(JARCH+I) = .FALSE.
 25   CONTINUE
      CALL GETVIS('ARCHIVAGE','PAS_ARCH' ,1,1,1,FREARC,N1)
      CALL GETVID('ARCHIVAGE','LIST_INST',1,1,1,LISARC,N2)
      CALL GETVR8('ARCHIVAGE','INST'     ,1,1,0,R8BID ,N3)
      N3 = -N3

C    AUCUN MOT-CLE : PAS_ARCH=1

      IF (N1+N2+N3 .EQ. 0) THEN
       FREARC = 1
       N1     = 1
      END IF

C    MOT-CLE FREQ_ARCH

      IF (N1 .GE. 1) THEN
       DO 30 I = FREARC, NBTEMP, FREARC
        ZL(JARCH+I) = .TRUE.
 30    CONTINUE

C    MOT_CLE LIST_INST OU INST

      ELSE
       IF (CHRONO.EQ.'SANS') CALL U2MESS('F','ALGORITH2_95')

C   PRECISION D'ACCES A LA LISTE D'INSTANTS

       CALL GETVR8('ARCHIVAGE','PRECISION'     ,1,1,1,TOLE,NOCC)
       TOLE = DELMIN * TOLE

C RECUPERATION DE LA LISTE DES INSTANTS A ARCHIVER

       IF (N3.GE.1) THEN
        LISARC = '&&DIINIT.LISARC'
        NLIARC =  N3
        CALL WKVECT(LISARC,'V V R8',N3,JLIARC)
        CALL GETVR8('ARCHIVAGE','INST',1,1,NLIARC,ZR(JLIARC),IRET)
       ELSE
        CALL JEVEUO(LISARC // '.VALE','L',JLIARC)
        CALL JELIRA(LISARC // '.VALE','LONMAX',NLIARC,K8BID)
       END IF

C    CONSTRUCTION DE LA LISTE D'ARCHIVAGE

       DO 50 I = 1,NLIARC
        INST = ZR(JLIARC-1+I)
        CALL UTACLI(INST,ZR(JTEMPS),NBTEMP,TOLE,NUMINS)
        IF (NUMINS.NE.-1) THEN
         ZL(JARCH+NUMINS) = .TRUE.
        ENDIF
50     CONTINUE
       FREARC  = 0
      END IF

C -- CHAMPS EXCLUS DE L'ARCHIVAGE

      CALL GETVTX('ARCHIVAGE','CHAM_EXCLU' ,1,1,0,K16BID,NB)
      NB = -NB
      IF (NB .NE. 0) THEN
       CALL WKVECT(PARTPS // '.DIEK','V V K16',NB,JEXCL)
       CALL GETVTX('ARCHIVAGE','CHAM_EXCLU',1,1,NB,ZK16(JEXCL),IBID)
      ENDIF

C -- DETERMINATION DU PREMIER NUMERO ARCHIVE

      CALL GETVTX('ARCHIVAGE','ARCH_ETAT_INIT',1,1,1,K16BID,N1)
      CALL GETVIS('ARCHIVAGE','NUME_INIT'     ,1,1,1,NUMARC,N2)
      CALL GETVIS('ETAT_INIT','NUME_ORDRE',1,1,1,IBID,N3)
      CALL GETVR8('ETAT_INIT','INST',1,1,1,R8BID ,N4)
      CALL GETVR8('ETAT_INIT','INST_ETAT_INIT',1,1,1,R8BID ,N5)

C    ARCHIVAGE DE L'ETAT INITIAL

      IF (N1.GE.1) THEN
       IF (DERNIE.NE.0) CALL U2MESS('F','ALGORITH2_96')
       NUMARC = 0

C    ARCHIVAGE A PARTIR D'UN NUMERO DONNE

      ELSE
       IF (N2.EQ.0) THEN
        IF ((N3.EQ.1).OR.(N4.EQ.1)) THEN
         IF ((DERNIE.EQ.0).OR.(N5.EQ.1)) THEN
          NUMARC=DERNIE+1
         ELSE
          DO 60 I=2,NBTEMP+1
           TEST = ZL(JARCH+I-1)
           IF ( TEST ) THEN
            VALE = ZR(JTEMPS+I-1)
            GOTO 1000
           ENDIF
  60      CONTINUE
 1000     CONTINUE
          CALL JELIRA(RESULT // '           .ORDR','LONUTI',LONG,K8BID)
          CALL JEVEUO(RESULT // '           .INST','L',JINSAR)
          CALL JEVEUO(RESULT // '           .ORDR','L',JORDAR)
          TEST = .FALSE.
          DO 70 I=1,LONG
           INSTAR = ZR(JINSAR+I-1)
           DIFF = ABS(INSTAR-VALE)
           IF (DIFF.LE.1.D-10) THEN
            NORDAR = ZI(JORDAR+I-1)
            TEST = .TRUE.
            GOTO 2000
           ENDIF
 70       CONTINUE
 2000     CONTINUE
          IF (TEST ) THEN
           NUMARC =NORDAR
          ELSE
           NUMARC=DERNIE+1
          ENDIF
         ENDIF
        ELSE
         NUMARC = DERNIE +1
        ENDIF
       ELSE

C  ON VERIFIE LES RISQUES D'ECRASEMENT

        IF (NUMARC.LE.DERNIE) THEN
         CALL GETVTX('ARCHIVAGE','DETR_NUME_SUIV',1,1,1,K16BID,NOCC)
         IF (NOCC.EQ.0) CALL U2MESS('F','ALGORITH2_97')

C  ON VERIFIE QU'ON NE CREE PAS DE TROUS DANS L'ARCHIVAGE

        ELSE IF (NUMARC.GT.DERNIE+1) THEN
         CALL U2MESS('F','ALGORITH2_98')
        END IF
       END IF
      END IF

C -- ECRITURE DE LA FREQUENCE ET DU PREMIER NUMERO D'ARCHIVAGE

      CALL WKVECT(PARTPS // '.DIIR','V V R8',8,JINFO)
      ZR(JINFO-1 + 1) = NUMARC
      ZR(JINFO-1 + 2) = FREARC

      IF (NOMCMD.EQ.'THER_LINEAIRE') GOTO 9999
C ======================================================================
C    SUBDIVISION AUTOMATIQUE DU PAS DE TEMPS
C ======================================================================

C --  RECUPERE LA METHODE DE DECOUPAGE ET SES PARAMETRES
      CALL WKVECT(PARTPS // '.METH','V V K16',1,JMETH)
      CALL GETVTX('INCREMENT','SUBD_METHODE',1,1,1,METHOD,N1)
      ZK16(JMETH) = METHOD

C     ZR(JINFO-1 + 1) <===> 'ARCHIVAGE','NUME_INIT'
C     ZR(JINFO-1 + 2) <===> 'ARCHIVAGE','PAS_ARCH'
C     ZR(JINFO-1 + 3) <===> 'SUBD_PAS'
C     ZR(JINFO-1 + 4) <===> 'SUBD_PAS_MINI'
C     ZR(JINFO-1 + 5) <===> 'SUBD_COEF_PAS_1'
C     ZR(JINFO-1 + 6) <===> 'SUBD_NIVEAU'
C     ZR(JINFO-1 + 7) <===> 'SUBD_ITER_IGNO'
C     ZR(JINFO-1 + 8) <===> 'SUBD_ITER_FIN'
      IF ( METHOD(1:6) .NE. 'AUCUNE' ) THEN
         IBID = 0
         CALL GETVIS('INCREMENT','SUBD_NIVEAU',1,1,1,IBID,N1)
         IF ((N1.NE.0).AND.(IBID.LT.1)) THEN
            CALL U2MESS('F','ALGORITH2_99')
         ENDIF
         ZR(JINFO-1 + 6) = IBID

         PASMIN = ZERO
         CALL GETVR8('INCREMENT','SUBD_PAS_MINI',1,1,1,PASMIN,N2)
         IF (PASMIN .GT. DELMIN) THEN
            CALL U2MESS('F','ALGORITH3_1')
         ENDIF
         ZR(JINFO-1 + 4) = PASMIN
         IF ( N1+N2 .EQ. 0 ) THEN
            CALL U2MESS('F','ALGORITH3_2')
         ENDIF

         NBRPAS = 4
         CALL GETVIS('INCREMENT','SUBD_PAS',1,1,1,NBRPAS,NOCC)
         IF (NBRPAS .LT. 2) THEN
            CALL U2MESS('F','ALGORITH3_3')
         ENDIF
         ZR(JINFO-1 + 3) = NBRPAS

         RATIO=UN
         CALL GETVR8('INCREMENT','SUBD_COEF_PAS_1',1,1,1,RATIO,NOCC)
         ZR(JINFO-1 + 5) = RATIO

C        SI C'EST LA SUBDIVION SIMPLE QUI EST FAITE
         IF     ( METHOD(1:8) .EQ. 'UNIFORME' ) THEN
            ZR(JINFO-1 + 7) = 0
            ZR(JINFO-1 + 8) = 0
            NBPLUS = 20
            ZK16(JMETH) = 'SIMPLE'
         ELSEIF ( METHOD(1:9) .EQ. 'EXTRAPOLE' ) THEN
C           RECUPERE L'OPTION DE L'EXTRAPOLATION
            K16BID = 'IGNORE_PREMIERES'
            CALL GETVTX('INCREMENT','SUBD_OPTION',1,1,1,K16BID,NOCC)
            IF     ( K16BID(1:16) .EQ. 'IGNORE_PREMIERES') THEN
               ZK16(JMETH) = 'EXTRAP_IGNO'
            ELSEIF ( K16BID(1:15) .EQ. 'GARDE_DERNIERES') THEN
               ZK16(JMETH) = 'EXTRAP_FIN'
            ELSE
               CALL U2MESK('F','ALGORITH3_4',1,K16BID)
            ENDIF

            IBID = 3
            CALL GETVIS('INCREMENT','SUBD_ITER_IGNO',1,1,1,IBID,NOCC)
            ZR(JINFO-1 + 7) = IBID
            IBID = 8
            CALL GETVIS('INCREMENT','SUBD_ITER_FIN',1,1,1,IBID,NOCC)
            ZR(JINFO-1 + 8) = IBID

            NBPLUS = 20
            CALL GETVIS('INCREMENT','SUBD_ITER_PLUS',1,1,1,NBPLUS,NOCC)
         ELSE
            CALL U2MESK('F','ALGORITH3_5',1,METHOD)

         ENDIF

C ------ CREATION DU TABLEAU DES ERREURS AU COURS DES ITERATIONS
C        UNIQUEMENT SI ON FAIT DE L'EXTRAPOLATION

C        RECUPERATION DES CRITERES DE CONVERGENCE GLOBAUX
         CALL GETVIS('CONVERGENCE','ITER_GLOB_MAXI',1,1,1,ITER1,IRET)
         IF (NOMCMD.EQ.'THER_NON_LINE') THEN
           ITER2=0
         ELSE
           CALL GETVIS('CONVERGENCE','ITER_GLOB_ELAS',1,1,1,ITER2,IRET)
         ENDIF
C        ON VERIFIE QUE C'EST COHERENT EN FONCTION DE LA METHODE
         IF      ( METHOD(7:10) .EQ. '_EXT' ) THEN
            IF ( (ZR(JINFO-1+7)+3) .GE. ITER1 ) THEN
               CALL U2MESS('F','ALGORITH3_6')
            ENDIF
         ELSE IF ( METHOD(7:10) .EQ. '_FIN' ) THEN
            IF ( (ZR(JINFO-1+8)+3) .GE. ITER1 ) THEN
               CALL U2MESS('F','ALGORITH3_7')
            ENDIF
         ENDIF

         NBITER = NINT(MAX(ITER1,ITER2)*(UN + NBPLUS/100.0D0)+0.6D0)
C        NATURE DU STOCKAGE
C          JEREUR + 0 : MAX( ITER_GLOB_MAXI , ITER_GLOB_ELAS )
C          JEREUR + 1 : MIN( ITER_GLOB_MAXI , ITER_GLOB_ELAS )
C          JEREUR + 2 : NBITER (DIMENSION DU VECTEUR)
C          JEREUR + 3 : RESI_GLOB_RELA
C          JEREUR + 4 : RESI_GLOB_MAXI
C          + 2 VALEURS PAR ITERATIONS PRECEDENTES
C          + 2 VALEURS POUR L'ITERATION EN COURS
C          + 2 VALEURS POUR L'ITERATION A VENIR
C        !!!! LE NUMERO DES ITERATIONS COMMENCE A ZERO
         CALL WKVECT(PARTPS // '.ERRE','V V R8',5+NBITER*2+2+2,JERRE)
         ZR(JERRE)   = MAX(ITER1,ITER2)
         ZR(JERRE+1) = MIN(ITER1,ITER2)
         ZR(JERRE+2) = NBITER
C        PAREIL QUE DANS NMDOCN
         CALL GETVR8('CONVERGENCE','RESI_GLOB_RELA',1,1,1,
     &                              ZR(JERRE+3),IRE1)
         IF (IRE1.LE.0) ZR(JERRE+3) = R8VIDE()
         CALL GETVR8('CONVERGENCE','RESI_GLOB_MAXI',1,1,1,
     &                              ZR(JERRE+4),IRE2)
         IF (IRE2.LE.0) ZR(JERRE+4) = R8VIDE()
         IF (IRE1.LE.0 .AND. IRE2.LE.0 ) THEN
            ZR(JERRE+3) = 1.0D-06
            ZR(JERRE+4) = 1.0D-06
         ENDIF
      ELSE
         CALL WKVECT(PARTPS // '.ERRE','V V R8',3,JERRE)
         ZR(JERRE)   = ZERO
         ZR(JERRE+1) = ZERO
         ZR(JERRE+2) = ZERO
      ENDIF

C ======================================================================
C   OBSERVATION
C ======================================================================
      CALL DYOBSE(NBINST,LISINS,LISOBS,NBOBSE,SDSUIV,RESULT)

      IF ( NBOBSE .NE. 0 ) THEN
         NUOBSE = 0
         NOMTAB = ' '
         CALL LTNOTB( RESULT, 'OBSERVATION', NOMTAB )
         CALL JEVEUO( '&&DYOBSE.MAILLA'   , 'L' , KKKMA )
         MAILL2 = ZK8(KKKMA)
         CALL JELIRA('&&DYOBSE.NOM_CHAM','LONUTI',NBOBAR,K8BID)
      ENDIF

9999  CONTINUE
      CALL JEDEMA()

      END
