      SUBROUTINE NMVPGM (FAMI,KPG,KSP,NDIM,IMATE,COMPOR,CRIT,TYPMOD,
     &                   INSTAM,INSTAP,DEPS,SIGM,VIM,
     &                   OPTION,SIGP,VIP,DSIDEP,IRET)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 04/04/2011   AUTEUR PROIX J-M.PROIX 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_7 CRP_21 CRS_505 CRS_507
      IMPLICIT NONE
      INTEGER            NDIM,IMATE,IRET,KPG,KSP
      CHARACTER*(*)      FAMI
      CHARACTER*8        TYPMOD(*)
      CHARACTER*16       COMPOR(*),OPTION
      REAL*8             CRIT(4),INSTAM,INSTAP
      REAL*8             DEPS(6),DEFAM(6),DEFAP(6)
      REAL*8             SIGM(6),VIM(2),SIGP(6),VIP(2),DSIDEP(6,6)
C ----------------------------------------------------------------------
C     REALISE LA LOI DE VISCOPLASTICITE DE GATT - MONERIE
C  POUR LES ELEMENTS
C     ISOPARAMETRIQUES EN PETITES DEFORMATIONS
C
C
C
C IN  NDIM    : DIMENSION DE L'ESPACE
C IN  IMATE   : ADRESSE DU MATERIAU CODE
C IN  COMPOR  : COMPORTEMENT : RELCOM ET DEFORM
C IN  CRIT    : CRITERES DE CONVERGENCE LOCAUX
C IN  TYPMOD  : TYPE DE MODELISATION
C IN  INSTAM  : INSTANT DU CALCUL PRECEDENT
C IN  INSTAP  : INSTANT DU CALCUL
C IN  DEPS    : INCREMENT DE DEFORMATION
C IN  SIGM    : CONTRAINTES A L'INSTANT DU CALCUL PRECEDENT
C IN  VIM     : VARIABLES INTERNES A L'INSTANT DU CALCUL PRECEDENT
C IN  OPTION  : OPTION DEMANDEE : RIGI_MECA_TANG , FULL_MECA , RAPH_MECA
C IN  DEFAM   : DEFORMATIONS ANELASTIQUES A L'INSTANT PRECEDENT
C IN  DEFAP   : DEFORMATIONS ANELASTIQUES A L'INSTANT DU CALCUL
C OUT SIGP    : CONTRAINTES A L'INSTANT ACTUEL
C OUT VIP     : VARIABLES INTERNES A L'INSTANT ACTUEL
C OUT DSIDEP  : MATRICE CARREE
C OUT IRET    : CODE RETOUR DE LA RECHERCHE DE ZERO DE F(X)=0
C                   IRET=0 => PAS DE PROBLEME
C                   IRET=1 => ECHEC
C
C               ATTENTION LES TENSEURS ET MATRICES SONT RANGES DANS
C               L'ORDRE :  XX YY ZZ XY XZ YZ
C
C ----------------------------------------------------------------------
C
C     COMMON POUR LES PARAMETRES DES LOIS VISCOPLASTIQUES
      COMMON / NMPAVP / SIELEQ,DEUXMU,TROISK,DELTAT,TSCHEM,PREC,THETA,
     &                  NITER
      REAL*8            SIELEQ,DEUXMU,TROISK,DELTAT,TSCHEM,PREC,THETA,
     &                  NITER
C     COMMON POUR LES PARAMETRES DE LA LOI GATT-MONERIE
      COMMON / NMPAGM /AK1,AK2,XN1,XN2,EXPA1,EXPA2,EXPAB1,EXPAB2,A1,A2,
     &                 B1,B2,XW,XQ,XH,SIGE,SIGH,SIGH0,POROM,SGD
      REAL*8           AK1,AK2,XN1,XN2,EXPA1,EXPA2,EXPAB1,EXPAB2,A1,A2,
     &                 B1,B2,XW,XQ,XH,SIGE,SIGH,SIGH0,POROM,SGD
C
      REAL*8            DEPSTH(6),VALRES(5),EPSTHE
      REAL*8            DEPSDV(6),SIGDV(6),SIGEL(6),EPSMO,E,NU
      REAL*8            KRON(6),VALPAR(2),RAC2,T1,T2
      REAL*8            EM,NUM,TROIKM,DEUMUM,SIGMP(6),SIGMO
      REAL*8            DELTKL,DELTP2
      REAL*8            DEGRAN(6)
      REAL*8            VPAGM1
      EXTERNAL          VPAGM1
      INTEGER           IULMES,IUNIFI,K,L,IRET1,IRET2,IRET4,IBID
      INTEGER           NDIMSI
      REAL*8            A0,XAP,TM,TP
      REAL*8            FG,FDGDST,FDGDEV
      REAL*8            COEF1,COEF2,DELTEV
      CHARACTER*2       FB2, CODRET(5)
      CHARACTER*6       EPSA(6)
      CHARACTER*8       NOMRES(5),NOMPAR(2)
C RMS
      REAL*8            GRAIN,TK,XR,XQ1,XQ2,DPORO,PORO,
     &                  XM1,XM2,XE01,XE02,FDEVPKK,GRAIN0
C DEB ------------------------------------------------------------------
      DATA              KRON/1.D0,1.D0,1.D0,0.D0,0.D0,0.D0/
      DATA EPSA   / 'EPSAXX','EPSAYY','EPSAZZ','EPSAXY','EPSAXZ',
     &              'EPSAYZ'/
C
      CALL VERIFT(FAMI,KPG,KSP,'T',IMATE,'ELAS',1,EPSTHE,IRET)
      CALL RCVARC(' ','TEMP','-',FAMI,KPG,KSP,TM,IRET1)
      CALL RCVARC(' ','TEMP','+',FAMI,KPG,KSP,TP,IRET2)
      THETA = CRIT(4)
      IF ((IRET1+IRET2).EQ.0) THEN
        TSCHEM = TM*(1.D0-THETA)+TP*THETA
      ELSE
        TSCHEM = 0.D0
      ENDIF
      T1 = ABS(THETA-0.5D0)
      T2 = ABS(THETA-1.D0)
      PREC = 0.01D0
      IF ((T1.GT.PREC).AND.(T2.GT.PREC))  THEN
         CALL U2MESS('F','ALGORITH6_55')
      ENDIF
C
      IF (TYPMOD(1).EQ.'C_PLAN') THEN
        IULMES = IUNIFI('MESSAGE')
        WRITE (IULMES,*) 'COMPORTEMENT ',COMPOR(1)(1:10),' NON PROGRAMME
     & POUR DES ELEMENTS DE CONTRAINTES PLANES'
        CALL U2MESS('F','ALGORITH6_92')
        GO TO 299
      ENDIF
      FB2 = 'F '
      DO 90 K = 1,6
        DEGRAN(K) = 0.D0
  90  CONTINUE
      RAC2 = SQRT(2.D0)
      DELTAT = INSTAP - INSTAM

      CALL MATINI(6,6,0.D0,DSIDEP)

      IF(NDIM.EQ.2) THEN
        NDIMSI=4
      ELSE
        NDIMSI=6
      ENDIF

C VARIABLE DE COMMANDE ANELASTIQUE
      DO 20 K=1,NDIMSI
        CALL RCVARC(' ',EPSA(K),'-',FAMI,KPG,KSP,DEFAM(K),IRET4)
        IF (IRET4.EQ.1) DEFAM(K)=0.D0

        CALL RCVARC(' ',EPSA(K),'+',FAMI,KPG,KSP,DEFAP(K),IRET4)
        IF (IRET4.EQ.1) DEFAP(K)=0.D0
 20   CONTINUE

C
C MISE AU FORMAT DES TERMES NON DIAGONAUX
C
      DO 105 K=4,NDIMSI
        DEFAM(K) = DEFAM(K)*RAC2
        DEFAP(K) = DEFAP(K)*RAC2
 105  CONTINUE
C
      NOMPAR(1)='INST'
      VALPAR(1)=INSTAM
      NOMRES(1)='E'
      NOMRES(2)='NU'
      CALL RCVALB(FAMI,KPG,KSP,'-',IMATE,' ','ELAS',1,NOMPAR,VALPAR,2,
     &              NOMRES,VALRES,CODRET, FB2 )
      EM     = VALRES(1)
      NUM    = VALRES(2)
      DEUMUM = EM/(1.D0+NUM)
      TROIKM = EM/(1.D0-2.D0*NUM)
      VALPAR(1)=INSTAP
      CALL RCVALB(FAMI,KPG,KSP,'+',IMATE,' ','ELAS',1,NOMPAR,VALPAR,2,
     &              NOMRES,VALRES,CODRET, FB2 )
      E      = VALRES(1)
      NU     = VALRES(2)
      DEUXMU = E/(1.D0+NU)
      TROISK = E/(1.D0-2.D0*NU)
C
C ---- PARAMETRES LOI VISCOPLASTIQUE GATT - MONERIE -------
C
      NOMRES(1) = 'D_GRAIN'
      NOMRES(2) = 'PORO_INIT'
      NOMRES(3) = 'EPSI_01'
      NOMRES(4) = 'EPSI_02'
      CALL RCVALB(FAMI,KPG,KSP,'+',IMATE,' ','GATT_MONERIE',1,
     &            NOMPAR,VALPAR,4,NOMRES,VALRES,CODRET, FB2 )
      GRAIN  = VALRES(1)
      POROM   = VIM(2)
      IF (POROM.EQ.0.D0) THEN
        POROM = VALRES(2)
        IF ((VIM(1).NE.0.D0).OR.(VALRES(2).EQ.0.D0)) THEN
          CALL U2MESS('F','ALGORITH8_86')
        ENDIF
      ENDIF
C
      XE01   = VALRES(3)
      XE02   = VALRES(4)
C
      XN1 = 1.D0
      XN2 = 8.0D0
      XM1 = -2.0D0
      XM2 = 2.0D0
      XQ1 = 377.0D3
      XQ2 = 462.0D3
      TK = TSCHEM + 273.D0
C --- CONSTANTE DES GAZS PARFAITS (J/(K*MOL))
      XR = 8.31D0
C     POTENTIELS DE DISSIPATIONS
C     CONTRAINTES EN MPA, SIG0I = 1 MPA -> XE01*(1.D6**XNI)
C     (ASSURE LA COHERENCE POUR PSII ET SES DERIVEES)
      AK1=XE01*(1.D6**XN1)*(GRAIN**XM1)*EXP(-XQ1/(XR*TK))
      GRAIN0 = 15.0D-6
      AK2=XE02*(1.D6**XN2)*2.D0*(GRAIN0**XM2)*(1.D0-COS(GRAIN/GRAIN0))
     &    *EXP(-XQ2/(XR*TK))
C     PREMIER POTENTIEL
      EXPA1 = 1.D0/XN1
      EXPAB1= 2.D0*XN1/(XN1+1.D0)
      A1    = (POROM**(2.D0/(XN1+1)))
     &           *(XN1*(1.D0 - POROM**EXPA1))**(-1.D0*EXPAB1)
      B1    = (1.D0+((2.D0/3.D0)*POROM))/((1.D0-POROM)**EXPAB1)
C     SECOND POTENTIEL
      EXPA2 = 1.D0/XN2
      EXPAB2= 2.D0*XN2/(XN2+1.D0)
      A2    = (POROM**(2.D0/(XN2+1)))
     &           *(XN2*(1.D0 - POROM**EXPA2))**(-1.D0*EXPAB2)
      B2    = (1.D0+((2.D0/3.D0)*POROM))/((1.D0-POROM)**EXPAB2)
C     FCT COUPLAGE
C     CONTRAINTES EN MPA -> REFORMULATION W*SIGI**Q -> W*(SIGI/SIG0)**Q
C     SIG0 = 1 MPA, W -> W*(1.D6**XQ)
C     (ASSURE LA COHERENCE POUR THETA ET SES DERIVEES)
      XQ = -0.189D0
      XW = 47350.4D0*(1.D6**XQ)
      XH = 600.D0
C --- FIN PARAMETRES LOI VISCOPLASTIQUE GATT - MONERIE -----
C
      EPSMO = 0.D0
      DO 110 K=1,3
        DEPSTH(K)   = DEPS(K)
     &                -EPSTHE
     &                -(DEFAP(K)-DEFAM(K))
        DEPSTH(K) = DEPSTH(K) - DEGRAN(K)
        DEPSTH(K)   = DEPSTH(K) * THETA
        IF ((K.EQ.1).OR.(NDIMSI.EQ.6)) THEN
          DEPSTH(K+3) = DEPS(K+3)-(DEFAP(K+3)-DEFAM(K+3))
          DEPSTH(K+3) = DEPSTH(K+3) - DEGRAN(K+3)
          DEPSTH(K+3) = DEPSTH(K+3) * THETA
        ENDIF
        EPSMO = EPSMO + DEPSTH(K)
 110  CONTINUE
C
      EPSMO = EPSMO/3.D0
      DO 115 K=1,NDIMSI
        DEPSDV(K)   = DEPSTH(K) - EPSMO * KRON(K)
 115  CONTINUE
C
      SIGMO = 0.D0
      DO 113 K =1,3
        SIGMO = SIGMO + SIGM(K)
 113  CONTINUE
      SIGMO = SIGMO /3.D0
C
      DO 114 K=1,NDIMSI
        SIGMP(K)=(THETA*DEUXMU+(1.D0-THETA)*DEUMUM)
     &      /DEUMUM*(SIGM(K)-SIGMO*KRON(K))+
     &      (THETA*TROISK+(1.D0-THETA)*TROIKM)/TROIKM*SIGMO*KRON(K)
114   CONTINUE
      SIGMO = 0.D0
      DO 116 K =1,3
        SIGMO = SIGMO + SIGMP(K)
116   CONTINUE
      SIGMO = SIGMO /3.D0
      SIELEQ = 0.D0
      DO 117 K = 1,NDIMSI
        SIGDV(K) = SIGMP(K) - SIGMO * KRON(K)
        SIGEL(K) = SIGDV(K) + DEUXMU * DEPSDV(K)
        SIELEQ   = SIELEQ   + SIGEL(K)**2
 117  CONTINUE
      SIELEQ       = SQRT(1.5D0*SIELEQ)
C
C----RESOLUTION CHAINEE DES DEUX EQUATIONS SCALAIRES----
C----VPAGM1 = FD, VPAGM2 = F (VOIR R5.03.08)
C
      PREC = CRIT(3)
      NITER = NINT(CRIT(1))
C---PAS D ECOULEMENT
      SIGH0 = SIGMO + TROISK*EPSMO
      IF ((SIELEQ.LE.PREC).AND.(ABS(SIGH0).LE.PREC)) THEN
         PORO = POROM
         SIGE = 0.D0
C---ECOULEMENT
      ELSE
         SGD = 1.D0
         A0 =  VPAGM1(0.D0)
         XAP = ABS(POROM-A0)
         IF (A0.GT.0.D0) THEN
C            WRITE(*,*) 'A0>0, DF EXPLICITE', XAP, POROM, A0
            SGD = -1.D0
            A0 = A0*SGD
            CALL ZEROF2(VPAGM1,A0,XAP,1.D20,INT(NITER),PORO,IRET,IBID)
            IF(IRET.EQ.1) GOTO 9999
         ELSE
            IF (XAP.GE.1.D0) THEN
               XAP = POROM + (1.D0-POROM)/2.D0
            ENDIF
            CALL ZEROF2(VPAGM1,A0,XAP,PREC,INT(NITER),PORO,IRET,IBID)
            IF(IRET.EQ.1) GOTO 9999
         ENDIF
      ENDIF
      DPORO = PORO - POROM
      SIGH = SIGH0 - (TROISK/3.D0)*DPORO/(1.D0-POROM-DPORO)
      CALL GGPGMO(SIGE,SIGH,
     &        THETA,DEUXMU,FG,FDEVPKK,FDGDST,FDGDEV,TSCHEM)
      EPSMO = EPSMO - FDEVPKK*DELTAT
C
C-----------------------------------------
      IF (SIGE.NE.0.D0) THEN
        COEF1 = 1.D0/(1.D0+1.5D0*DEUXMU*DELTAT*FG/SIGE)
      ELSE
        COEF1 = 1.D0/(1.D0+1.5D0*DEUXMU*DELTAT*FDGDST)
      ENDIF
C
      IF ( OPTION(1:9) .EQ. 'RAPH_MECA' .OR.
     &     OPTION(1:9) .EQ. 'FULL_MECA' ) THEN
        DELTP2 = 0.D0
        DO 160 K = 1,NDIMSI
          SIGDV(K) = SIGEL(K) * COEF1
          SIGP(K)  = SIGDV(K) + (SIGMO + TROISK*EPSMO)*KRON(K)
          SIGP(K)  = (SIGP(K) - SIGM(K))/THETA + SIGM(K)
          DELTEV   = (SIGEL(K)-SIGDV(K))/(DEUXMU*THETA)
          DELTP2   = DELTP2   + DELTEV**2
 160    CONTINUE
        VIP(1) = VIM(1) + SQRT(2.D0*DELTP2/3.D0)
        VIP(2) = POROM + DPORO/THETA
      ENDIF
C
      IF  ( OPTION(1:9) .EQ. 'FULL_MECA'.OR.
     &      OPTION(1:14) .EQ. 'RIGI_MECA_TANG' ) THEN
       IF (SIGE.NE.0.D0) THEN
        COEF2=SIELEQ*(1.D0 - DELTAT*FDGDEV)
        COEF2=COEF2/(1.D0+1.5D0*DEUXMU*DELTAT*FDGDST)
        COEF2=COEF2 - SIGE
        COEF2=COEF2*1.5D0/(SIELEQ**3)
       ELSE
        COEF2 = 0.D0
       ENDIF
       DO 135 K=1,NDIMSI
         DO 135 L=1,NDIMSI
           DELTKL = 0.D0
           IF (K.EQ.L) DELTKL = 1.D0
           DSIDEP(K,L) = COEF1*(DELTKL-KRON(K)*KRON(L)/3.D0)
           DSIDEP(K,L) = DEUXMU*(DSIDEP(K,L)+COEF2*SIGEL(K)*SIGEL(L))
           DSIDEP(K,L) = DSIDEP(K,L) + TROISK*KRON(K)*KRON(L)/3.D0
 135   CONTINUE
      ENDIF
C
C MISE AU FORMAT DES TERMES NON DIAGONAUX
C
      DO 200 K=4,NDIMSI
         DEFAM(K) = DEFAM(K)/RAC2
         DEFAP(K) = DEFAP(K)/RAC2
 200  CONTINUE
C
 299  CONTINUE
C
9999  CONTINUE
C
C FIN ------------------------------------------------------------------
      END
