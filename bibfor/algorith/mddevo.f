      SUBROUTINE MDDEVO (NBPAS,DT,NBMODE,PULSAT,PULSA2,
     &                   MASGEN,AMOGEN,BASEMO,
     &                   TINIT,IPARCH,NBSAUV,
     &                   NBCHOC,LOGCHO,DPLMOD,PARCHO,NOECHO,
     &                   NBREDE,DPLRED,PARRED,FONRED,
     &                   NBREVI,DPLREV,FONREV,
     &                   DEPSTO,VITSTO,ACCSTO,IORSTO,TEMSTO,
     &                   FCHOST,DCHOST,VCHOST, ICHOST,
     &                   IREDST,DREDST,
     &                   COEFM,LIAD,INUMOR,IDESCF,
     &                   NOFDEP,NOFVIT,NOFACC,NOMFON,PSIDEL,MONMOT,
     &                   NOMRES)
C
      IMPLICIT     REAL*8 (A-H,O-Z)
C
      INTEGER      LOGCHO(*),IORSTO(*),IREDST(*),IPARCH(*),ICHOST(*)
      REAL*8       PULSAT(*),PULSA2(*),MASGEN(*),
     &             AMOGEN(*),PARCHO(*),PARRED(*),DEPSTO(*),VITSTO(*),
     &             ACCSTO(*),TEMSTO(*),FCHOST(*),DCHOST(*),VCHOST(*),
     &             DREDST(*),DPLRED(*),DPLREV(*),
     &             DPLMOD(NBCHOC,NBMODE,*)
      CHARACTER*8  BASEMO,NOECHO(*),FONRED(*),FONREV(*),NOMRES,MONMOT
      LOGICAL      LPSTO
C
      REAL*8       COEFM(*),PSIDEL(*)
      INTEGER      LIAD(*),INUMOR(*),IDESCF(*)
      CHARACTER*8  NOFDEP(*),NOFVIT(*),NOFACC(*),NOMFON(*)
C
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C TOLE CRP_21
C
C     ALGORITHME DE DEVOGELAERE
C     ------------------------------------------------------------------
C IN  : NBPAS  : NOMBRE DE PAS
C IN  : DT     : PAS DE TEMPS
C IN  : NBMODE : NOMBRE DE MODES
C IN  : PULSAT : PULSATIONS MODALES
C IN  : PULSA2 : PULSATIONS MODALES AU CARREES
C IN  : MASGEN : MASSES GENERALISEES
C                MATRICE DE MASSE GENERALISEE
C IN  : AMOGEN : AMORTISSEMENTS REDUITS
C                MATRICE D'AMORTISSEMENT
C IN  : BASEMO : NOM K8 DE LA BASE MODALE DE PROJECTION SI C'EST UN
C                MODE MECA K8BID LORS D'UN CALCUL PAR SOUS_STUCTURATION
C IN  : TINIT  : TEMPS INITIAL
C IN  : IPARCH : VECTEUR DES PAS D'ARCHIVAGE
C IN  : NBSAUV : NOMBRE DE PAS ARCHIVE
C IN  : NBCHOC : NOMBRE DE NOEUDS DE CHOC
C IN  : LOGCHO : INDICATEUR D'ADHERENCE ET DE FORCE FLUIDE
C IN  : DPLMOD : TABLEAU DES DEPL MODAUX AUX NOEUDS DE CHOC
C IN  : PARCHO : TABLEAU DES PARAMETRES DE CHOC
C IN  : NOECHO : TABLEAU DES NOMS DES NOEUDS DE CHOC
C IN  : NBREDE : NOMBRE DE RELATION EFFORT DEPLACEMENT (RED)
C IN  : DPLRED : TABLEAU DES DEPLACEMENTS MODAUX AUX NOEUDS DE RED
C IN  : PARRED : TABLEAU DES PARAMETRES DE RED
C IN  : FONRED : TABLEAU DES FONCTIONS AUX NOEUDS DE RED
C IN  : NBREVI : NOMBRE DE RELATION EFFORT VITESSE (REV)
C IN  : DPLREV : TABLEAU DES DEPLACEMENTS MODAUX AUX NOEUDS DE REV
C IN  : FONREV : TABLEAU DES FONCTIONS AUX NOEUDS DE REV
C IN  : LIAD   : LISTE DES ADRESSES DES VECTEURS CHARGEMENT
C IN  : NOFDEP : NOM DE LA FONCTION DEPL_IMPO
C IN  : NOFVIT : NOM DE LA FONCTION VITE_IMPO
C IN  : PSIDEL : TABLEAU DE VALEURS DE PSI*DELTA
C IN  : MONMOT : = OUI SI MULTI-APPUIS
C ----------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
C     ------------------------------------------------------------------
C
      REAL*8 R8BID2,R8BID3,R8BID4,R8BID5,R8B,TPS1(4)
      CHARACTER*8  TRAN
C
      CALL JEMARQ()
      ZERO = 0.D0
      R8B = ZERO
      JVINT = 1
      CALL WKVECT('&&MDDEVO.BID','V V R8',NBMODE,JBID1)
      DO 10 I=1,NBMODE
       ZR(JBID1+I-1)=ZERO
 10   CONTINUE
      R8BID2=ZERO
      R8BID3=ZERO
      R8BID4=ZERO
      R8BID5=ZERO
      DEUX = 2.D0
      QUATRE = 4.D0
      SIX = 6.D0
      DT1 = DT / DEUX
      DT2 = DT / QUATRE
      DT3 = DT / SIX
      DT4 = DT * DT / 24.D0
      DT5 = DT * DT / SIX
      DT6 = DT * DT / 8.D0
      ISTO1 = 0
      ISTO2 = 0
      ISTO3 = 0
      LPSTO = .FALSE.
      NBMOD1 = NBMODE - 1
      NBSCHO = NBSAUV * 3 * NBCHOC
C
C     --- VECTEURS DE TRAVAIL ---
      CALL WKVECT('&&MDDEVO.DEPL','V V R8',4*NBMODE,JDEPL)
      CALL WKVECT('&&MDDEVO.VITE','V V R8',4*NBMODE,JVITE)
      CALL WKVECT('&&MDDEVO.ACCE','V V R8',  NBMODE,JACCE)
      CALL WKVECT('&&MDDEVO.TRA1','V V R8',  NBMODE,JTRA1)
      CALL WKVECT('&&MDDEVO.FEXT','V V R8',4*NBMODE,JFEXT)
      IF (NBCHOC.NE.0) THEN
         CALL WKVECT('&&MDDEVO.SCHOR','V V R8',NBCHOC*14,JCHOR)
C        INITIALISATION POUR LE FLAMBAGE
         CALL JEVEUO(NOMRES//'           .VINT','E',JVINT)
         CALL R8INIR(NBCHOC,0.D0,ZR(JVINT),1)
      ENDIF
      IF (NBREDE.NE.0) THEN
         CALL WKVECT('&&MDDEVO.SREDR','V V R8',NBREDE,JREDR)
         CALL WKVECT('&&MDDEVO.SREDI','V V I' ,NBREDE,JREDI)
      ENDIF
C
      JDEP1 = JDEPL
      JDEP2 = JDEP1 + NBMODE
      JDEP3 = JDEP2 + NBMODE
      JDEP4 = JDEP3 + NBMODE
      JVIT1 = JVITE
      JVIT2 = JVIT1 + NBMODE
      JVIT3 = JVIT2 + NBMODE
      JVIT4 = JVIT3 + NBMODE
      JFEX1 = JFEXT
      JFEX2 = JFEX1 + NBMODE
      JFEX3 = JFEX2 + NBMODE
      JFEX4 = JFEX3 + NBMODE
C
C     --- CONDITIONS INITIALES ---
      CALL MDINIT(BASEMO,NBMODE,NBCHOC,ZR(JDEP2),ZR(JVIT2),ZR(JVINT),
     &            IRET)
      IF (IRET.NE.0) GOTO 9999
      IF (NBCHOC.GT.0) THEN
         CALL DCOPY(NBCHOC,ZR(JVINT),1,ZR(JCHOR+13*NBCHOC),1)
      ENDIF
C
C     --- FORCES EXTERIEURES ---
      CALL GETFAC('EXCIT',NBEXCI)
      IF (NBEXCI.NE.0) THEN
         CALL MDFEX2 (TINIT,NBMODE,NBEXCI,IDESCF,NOMFON,COEFM,LIAD,
     &                INUMOR,ZR(JFEX2))
      ENDIF
C
C     --- CONTRIBUTION DES FORCES NON LINEAIRES ---
      CALL MDFNLI(NBMODE,ZR(JDEP2),ZR(JVIT2),ZR(JBID1),
     &            ZR(JFEX2),R8BID2,R8BID3,R8BID4,R8BID5,
     &            NBCHOC,LOGCHO,DPLMOD,PARCHO,NOECHO,ZR(JCHOR),
     &            NBREDE,DPLRED,PARRED,FONRED,ZR(JREDR),ZI(JREDI),
     &            NBREVI,DPLREV,FONREV,
     &            TINIT,NOFDEP,NOFVIT,NOFACC,NBEXCI,PSIDEL,MONMOT)
C
C     --- INITIALISATION DE L'ALGORITHME ---
      DO 100 IM = 0,NBMOD1
         IM1 = IM + 1
         AMOGEN(IM1) = DEUX * PULSAT(IM1) * AMOGEN(IM1)
         ZR(JFEX1+IM) = ZR(JFEX2+IM)
         G2 = ( ZR(JFEX2+IM) / MASGEN(IM1) ) - PULSA2(IM1)*ZR(JDEP2+IM)
         ZR(JDEP1+IM) = ZR(JDEP2+IM) - DT1*ZR(JVIT2+IM) +
     &                  DT6 * ( G2 - AMOGEN(IM1)*ZR(JVIT2+IM) )
         G1 = (ZR(JFEX1+IM) / MASGEN(IM1)) - PULSA2(IM1)*ZR(JDEP1+IM)
         ZR(JVIT1+IM) = ( 1.D0 / ( 4.D0 - DT * AMOGEN(IM1) ) ) *
     &                  ( ZR(JVIT2+IM)*( 4.D0 + DT*AMOGEN(IM1) )
     &                  - DT * ( G1 + G2 ) )
         ZR(JACCE+IM) = G2 - AMOGEN(IM1)*ZR(JVIT2+IM)

 100  CONTINUE
C
C     --- ARCHIVAGE DONNEES INITIALES ---
      TARCHI = TINIT
      CALL MDARCH(ISTO1,0,TINIT,DT,NBMODE,ZR(JDEP2),ZR(JVIT2),ZR(JACCE),
     &            ISTO2,NBCHOC,ZR(JCHOR),NBSCHO,ISTO3,NBREDE,ZR(JREDR),
     &            ZI(JREDI),DEPSTO,VITSTO,ACCSTO,R8B,LPSTO, IORSTO,
     &            TEMSTO,FCHOST,DCHOST,VCHOST,ICHOST,
     &            ZR(JVINT),IREDST,DREDST )
C
      TEMPS = TINIT + DT1
      CALL UTTCPU (1,'INIT',4,TPS1)
      N100 = NBPAS/100 + 1
C
C     --- BOUCLE TEMPORELLE ---
C
      DO 30 I = 1 , NBPAS
C
         IF (I.EQ.1.OR.MOD(I,N100).EQ.0) CALL UTTCPU (1,'DEBUT',4,TPS1)
C
         DO 32 IM = 0,NBMOD1
            IM1 = IM + 1
            G1 = (ZR(JFEX1+IM) / MASGEN(IM1)) - PULSA2(IM1)*ZR(JDEP1+IM)
            G2 = (ZR(JFEX2+IM) / MASGEN(IM1)) - PULSA2(IM1)*ZR(JDEP2+IM)
C
C              --- DEPLACEMENTS GENERALISES AU DEMI PAS ---
            X2 = QUATRE*G2 - G1 - AMOGEN(IM1) *
     &           ( QUATRE*ZR(JVIT2+IM) - ZR(JVIT1+IM) )
            ZR(JDEP3+IM) = ZR(JDEP2+IM) + DT1*ZR(JVIT2+IM) + DT4*X2
            ZR(JVIT3+IM) = ( ZR(JDEP3+IM) - ZR(JDEP2+IM) ) / DT1
 32      CONTINUE
C
C     --- FORCES EXTERIEURES ---
         DO 20 IF = 0,NBMODE-1
            ZR(JFEX3+IF) = ZERO
 20      CONTINUE
         IF (NBEXCI.NE.0) THEN
           CALL MDFEX2 (TEMPS,NBMODE,NBEXCI,IDESCF,NOMFON,COEFM,LIAD,
     &                  INUMOR,ZR(JFEX3))
         ENDIF
C
C        --- CONTRIBUTION DES FORCES NON LINEAIRES ---
         CALL MDFNLI(NBMODE,ZR(JDEP3),ZR(JVIT3),ZR(JBID1),
     &               ZR(JFEX3),R8BID2,R8BID3,R8BID4,R8BID5,
     &               NBCHOC,LOGCHO,DPLMOD,PARCHO,NOECHO,ZR(JCHOR),
     &               NBREDE,DPLRED,PARRED,FONRED,ZR(JREDR),
     &               ZI(JREDI),NBREVI,DPLREV,FONREV,
     &               TEMPS,NOFDEP,NOFVIT,NOFACC,NBEXCI,PSIDEL,MONMOT)
C
         DO 34 IM = 0,NBMOD1
            IM1 = IM + 1
            G2 = (ZR(JFEX2+IM) / MASGEN(IM1)) - PULSA2(IM1)*ZR(JDEP2+IM)
            G3 = (ZR(JFEX3+IM) / MASGEN(IM1)) - PULSA2(IM1)*ZR(JDEP3+IM)
C
C              --- VITESSES GENERALISEES AU DEMI PAS ---
            X1 = QUATRE / ( QUATRE + DT*AMOGEN(IM1) )
            X2 = G2 + G3 - AMOGEN(IM1)*ZR(JVIT2+IM)
            ZR(JVIT3+IM) = X1 * ( ZR(JVIT2+IM) + DT2*X2 )
C
C           --- DEPLACEMENTS GENERALISES AU PAS ---
            X2 = G2 + DEUX*G3 - AMOGEN(IM1) *
     &           ( ZR(JVIT2+IM) + DEUX*ZR(JVIT3+IM) )
            ZR(JDEP4+IM) = ZR(JDEP2+IM) + DT*ZR(JVIT2+IM) + DT5*X2
            ZR(JVIT4+IM) = ( ZR(JDEP4+IM) - ZR(JDEP3+IM) ) / DT1
 34      CONTINUE
C
C        --- FORCES EXTERIEURES ---
         DO 35 IF = 0,NBMODE-1
            ZR(JFEX4+IF) = ZERO
 35      CONTINUE
         TEMPS = TEMPS + DT1
         IF (NBEXCI.NE.0) THEN
           CALL MDFEX2 (TEMPS,NBMODE,NBEXCI,IDESCF,NOMFON,COEFM,LIAD,
     &                  INUMOR,ZR(JFEX4))
         ENDIF
C        --- CONTRIBUTION DES FORCES NON LINEAIRES ---
         CALL MDFNLI(NBMODE,ZR(JDEP4),ZR(JVIT4),ZR(JBID1),
     &               ZR(JFEX4),R8BID2,R8BID3,R8BID4,R8BID5,
     &               NBCHOC,LOGCHO,DPLMOD,PARCHO,NOECHO,ZR(JCHOR),
     &               NBREDE,DPLRED,PARRED,FONRED,ZR(JREDR),
     &               ZI(JREDI),NBREVI,DPLREV,FONREV,
     &               TEMPS,NOFDEP,NOFVIT,NOFACC,NBEXCI,PSIDEL,MONMOT)
C
         DO 36 IM = 0,NBMOD1
            IM1 = IM + 1
            G2 = (ZR(JFEX2+IM) / MASGEN(IM1)) - PULSA2(IM1)*ZR(JDEP2+IM)
            G3 = (ZR(JFEX3+IM) / MASGEN(IM1)) - PULSA2(IM1)*ZR(JDEP3+IM)
            G4 = (ZR(JFEX4+IM) / MASGEN(IM1)) - PULSA2(IM1)*ZR(JDEP4+IM)
C
C           --- VITESSES GENERALISEES AU PAS ---
            X1 =  SIX / ( SIX + DT*AMOGEN(IM1) )
            X2 =  G4 + QUATRE*G3 + G2 - ( AMOGEN(IM1) *
     &            ( QUATRE*ZR(JVIT3+IM) + ZR(JVIT2+IM) ) )
            ZR(JVIT4+IM) = X1 * ( ZR(JVIT2+IM) + DT3*X2 )
C
C           --- ACCELERATIONS GENERALISEES AU PAS ---
            ZR(JACCE+IM) = G4 - AMOGEN(IM1)*ZR(JVIT4+IM)
 36      CONTINUE
C
C        --- ARCHIVAGE ---
         IARCHI = I
         IF (IPARCH(IARCHI) .EQ. 1) THEN
            ISTO1 = ISTO1 + 1
            TARCHI = TEMPS
            CALL MDARCH(ISTO1,IARCHI,TEMPS,DT,NBMODE,
     &                  ZR(JDEP4),ZR(JVIT4),ZR(JACCE),
     &                  ISTO2,NBCHOC,ZR(JCHOR),NBSCHO,
     &                  ISTO3,NBREDE,ZR(JREDR),ZI(JREDI),
     &                  DEPSTO,VITSTO,ACCSTO,
     &                  R8B,LPSTO,IORSTO,TEMSTO,
     &                  FCHOST,DCHOST,VCHOST,ICHOST,
     &                  ZR(JVINT), IREDST,DREDST )
         ENDIF
C
         DO 40 IM = 0,NBMOD1
            ZR(JDEP1+IM) = ZR(JDEP3+IM)
            ZR(JDEP2+IM) = ZR(JDEP4+IM)
            ZR(JVIT1+IM) = ZR(JVIT3+IM)
            ZR(JVIT2+IM) = ZR(JVIT4+IM)
            ZR(JFEX1+IM) = ZR(JFEX3+IM)
            ZR(JFEX2+IM) = ZR(JFEX4+IM)
 40      CONTINUE
C
C
C        --- TEST SI LE TEMPS RESTANT EST SUFFISANT POUR CONTINUER ---
C
         IF (I.EQ.1 .OR. MOD(I,N100).EQ.0) THEN
          CALL UTTCPU (1,'FIN',4,TPS1)
          IF (MAX(5.D0,N100*TPS1(4)).GT.0.90D0*TPS1(1)) THEN
           CALL MDSIZE (NOMRES,ISTO1,NBMODE,LPSTO,NBCHOC,NBREDE)
           IF (NOMRES.EQ.'&&OP0074') THEN
C          --- CAS D'UNE POURSUITE ---
              CALL GETVID('ETAT_INIT','RESU_GENE',1,1,1,TRAN,NDT)
              IF (NDT.NE.0) CALL RESU74(TRAN,NOMRES)
           ENDIF
           CALL UTDEXC (28, 'MDDEVO','ARRET PAR MANQUE DE TEMPS CPU')
           CALL UTIMPI ('S',' AU NUMERO D''ORDRE : ',1,I)
           CALL UTIMPR ('L',' DERNIER INSTANT ARCHIVE : ',1,TARCHI)
           CALL UTIMPI ('L',' NUMERO D''ORDRE CORRESPONDANT : ',1,ISTO1)
           CALL UTIMPR ('L',' TEMPS MOYEN PAR PAS DE TEMPS : ',1,
     &                  TPS1(4))
           CALL UTIMPR ('L',' TEMPS CPU RESTANT : ',1,TPS1(1))
           CALL UTFINM ()
           GOTO 9999
          ENDIF
         ENDIF
         TEMPS = TEMPS+DT1
 30   CONTINUE
C
 9999 CONTINUE
      CALL JEDETR('&&MDDEVO.DEPL')
      CALL JEDETR('&&MDDEVO.VITE')
      CALL JEDETR('&&MDDEVO.ACCE')
      CALL JEDETR('&&MDDEVO.TRA1')
      CALL JEDETR('&&MDDEVO.FEXT')
      IF (NBCHOC.NE.0) CALL JEDETR('&&MDDEVO.SCHOR')
      IF (NBREDE.NE.0) THEN
         CALL JEDETR('&&MDDEVO.SREDR')
         CALL JEDETR('&&MDDEVO.SREDI')
      ENDIF
      IF (IRET.NE.0)
     &   CALL U2MESS('F','ALGORITH5_24')
C
      CALL JEDEMA()
      END
