      SUBROUTINE NMBARC (NDIM,IMATE,CRIT,SAT,BIOT,
     &                   TM,TP,DEPS,SBISM,VIM,
     &                   OPTION,SBISP,VIP,DSIDEP,P1,P2,DP1,DP2,
     &                   DSIDP1,SIPM,SIPP,RETCOM)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 23/05/2005   AUTEUR JOUMANA J.EL-GHARIB 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
C  TOLE CRP_20
C  TOLE CRP_21
      IMPLICIT NONE
      INTEGER            NDIM,IMATE,RETCOM
      CHARACTER*16      OPTION
      REAL*8             CRIT(*),TM,TP
      REAL*8             DEPS(6),DEUXMU,BIOT,SAT,P1,P2,DP1,DP2
      REAL*8             SBISM(6),VIM(5),SBISP(6),VIP(5),DSIDEP(6,6)
      REAL*8             DSIDP1(6)
      REAL*8             SIPM,SIPP
C ----------------------------------------------------------------------
C     REALISE LA LOI DE BARCELONE DES MILIEUX NON-SATURES
C     EN ELASTOPLASTICITE MECANIQUE ET HYDRIQUE UTILISABLE
C     SEULEMENT DANS UNE MODELISATION HHM ou THHM
C
C IN  NDIM    : DIMENSION DE L'ESPACE
C IN  IMATE   : ADRESSE DU MATERIAU CODE
C IN  CRIT    : CRITERES DE CONVERGENCE LOCAUX
C IN  TM      : TEMPERATURE A L'INSTANT PRECEDENT
C IN  TP      : TEMPERATURE A L'INSTANT DU CALCUL
C IN  DEPS    : INCREMENT DE DEFORMATION
C IN  SBISM   : CONTRAINTES DE BISHOP A L'INSTANT DU CALCUL PRECEDENT
C IN  PCRM    : VARIABLES INTERNES A L'INSTANT DU CALCUL PRECEDENT
C IN  OPTION  : OPTION DEMANDEE : RIGI_MECA_TANG , FULL_MECA , RAPH_MECA
C OUT SBISP   : CONTRAINTES DE BISHOP A L'INSTANT ACTUEL
C OUT VIP    : VARIABLES INTERNES A L'INSTANT ACTUEL
C OUT DSIDEP  : MATRICE CARREE (INUTILISE POUR RAPH_MECA)
C OUT DSIDP1  : MATRICE COLONNE (INUTILISE POUR RAPH_MECA)
C
C               ATTENTION LES TENSEURS ET MATRICES SONT RANGES DANS
C               L'ORDRE :  XX,YY,ZZ,SQRT(2)*XY,SQRT(2)*XZ,SQRT(2)*YZ
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      CHARACTER*32       JEXNUM , JEXNOM , JEXR8 , JEXATR
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      LOGICAL     CPLAN,PLASTI,IRET,LOGIC
      REAL*8      DEPSTH(6),VALRES(16),ALPHA
      REAL*8      LAMBDA,KAPA,PORO,PRESCR,M,PA,R,BETA,KC,PC0INI
      REAL*8      LAMBS,KAPAS,LAMBB,LAMBBM,ALPHAB,LAMP
      REAL*8      DEPSMO,SIGMMO,E,NU,E0,XK0,XK,XK0S,XKS,FONC1,FONC2
      REAL*8      SIELEQ,SIMOEL,H,A(6),AA(6),AP(6),AAP(6),SIEQM
      REAL*8      KRON(6),DEPSDV(6),SIGMDV(6),SIGPDV(6),TPLUS(6)
      REAL*8      SIGPMO,F1,F2,F3,F4,F5,F6,F,FP,COEF,PORO1,PORO2
      REAL*8      DEPPMO,DELTAP,DELTAS(6),SPARDS,HP,XC,XD,XHHC
      REAL*8      XLAM,XA,XU,XG,XH,XM,XE,XF,XV,XI,RAP
      REAL*8      CC(6,6),FV(6),FF(6)
      REAL*8      C(6,6),CT,XB,V0,V0EST,SEUIL,D(3,3),DD(3,3)
      REAL*8      SIGEL(6),XINF,XSUP,DET,TOL,FFI(6,6),EE(6,6)
      REAL*8      V(6,6),S(6,6),T(6,6),VV(6,6),SS(6,6),TT(6,6)
      REAL*8      NUL,DIFF,DIFF1
      REAL*8      SBARM(6),SBARP(6),PC0M(2),PC0P(2),PCRM(2),PCRP(2)
      REAL*8      P1M,P2M,PCRMP1,PAR,PCRPP
      REAL*8      PSP
      REAL*8      TRA,XGG,XZ,XDD,HH(6),XJ,XHH,CT1,KV(6)
      REAL*8      SSH(6),HHKV(6),VH(6,6),VHH(6,6),VVH(6,6)
      REAL*8      KKH(6),SSHH(6),BB,KCP1,KCP1M,KPMAX,KPMAXM,ZERO
      REAL*8      FXI1,FXI2,FXI3,FXI
      REAL*8      XINF0,XSUP0,XB0,SEUIL0,F0,FP0,FXI0,SIGNF0,SIGFI0
      REAL*8      SIEQP,XAU
      REAL*8      HHB(6,6),SES(6,6),HHBM(6,6),GG(6,6),SPS(6,6)
      REAL*8      D1G(6,6),ID2(6,6),DEVHYD(6,6),DEVHYM(6,6)
      REAL*8      D1GHHM(6,6)
      INTEGER     NDIMSI,SIGNF,SIGNFI
      INTEGER     I,K,L,ITER, MATR,IADZI,IAZK24,UMESS,IUNIFI
      CHARACTER*2 BL2, FB2, CODRET(16)
      CHARACTER*8 NOMRES(16)
      CHARACTER*8 NOMPAR(1),TYPE
      CHARACTER*24 NOMMA
      REAL*8       EPXMAX
      CHARACTER*8   NOMAIL
      REAL*8      VALPAM(1),R8MAEM
      DATA        KRON/1.D0,1.D0,1.D0,0.D0,0.D0,0.D0/
      DATA        TOL/1.D-10/NUL/0.D0/ZERO/0.D0/
C DEB ------------------------------------------------------------------
C
C     -- 1 INITIALISATIONS :
C     ----------------------
      NDIMSI = 2*NDIM
      LOGIC = .TRUE.
      EPXMAX=LOG(R8MAEM())
C
      BL2 = '  '
      FB2 = 'F '
C
      RETCOM = 0
C
C     -- 2 RECUPERATION DES CARACTERISTIQUES
C     ---------------------------------------
      NOMRES(1)='E'
      NOMRES(2)='NU'
      NOMRES(3)='ALPHA'
      NOMRES(4)='PORO'
      NOMRES(5)='LAMBDA'
      NOMRES(6)='KAPA'
      NOMRES(7)='M'
      NOMRES(8)='PRES_CRIT'
      NOMRES(9)='PA'
      NOMRES(10)='R'
      NOMRES(11)='BETA'
      NOMRES(12)='KC'
      NOMRES(13)='PC0_INIT'
      NOMRES(14)='KAPAS'
      NOMRES(15)='LAMBDAS'
      NOMRES(16)='ALPHAB'
C
      NOMPAR(1) = 'TEMP'
      VALPAM(1) = TM
C
         CALL RCVALA(IMATE,' ','ELAS',1,NOMPAR,VALPAM,1,
     +                 NOMRES(1),VALRES(1),CODRET(1), FB2 )
         E  = VALRES(1)
         CALL RCVALA(IMATE,' ','ELAS',1,NOMPAR,VALPAM,1,
     +                 NOMRES(2),VALRES(2),CODRET(2), FB2 )
         NU = VALRES(2)
         CALL RCVALA(IMATE,' ','ELAS',1,NOMPAR,VALPAM,1,
     +                 NOMRES(3),VALRES(3),CODRET(3), BL2 )
         IF ( CODRET(3) .NE. 'OK' ) VALRES(3) = 0.D0
         ALPHA = VALRES(3)
         CALL RCVALA(IMATE,' ','CAM_CLAY ',1,NOMPAR,VALPAM,1,
     +                 NOMRES(4),VALRES(4),CODRET(4), FB2 )
         PORO = VALRES(4)
         PORO1 = PORO
         CALL RCVALA(IMATE,' ','CAM_CLAY ',1,NOMPAR,VALPAM,1,
     +                 NOMRES(5),VALRES(5),CODRET(5), FB2 )
         LAMBDA = VALRES(5)
         CALL RCVALA(IMATE,' ','CAM_CLAY ',1,NOMPAR,VALPAM,1,
     +                 NOMRES(6),VALRES(6),CODRET(6), FB2 )
         KAPA = VALRES(6)
         CALL RCVALA(IMATE,' ','CAM_CLAY ',1,NOMPAR,VALPAM,1,
     +                 NOMRES(7),VALRES(7),CODRET(7), FB2 )
         M     = VALRES(7)
         CALL RCVALA(IMATE,' ','CAM_CLAY ',1,NOMPAR,VALPAM,1,
     +                 NOMRES(8),VALRES(8),CODRET(8), FB2 )
         PRESCR = VALRES(8)
         CALL RCVALA(IMATE,' ','CAM_CLAY ',1,NOMPAR,VALPAM,1,
     +                 NOMRES(9),VALRES(9),CODRET(9), FB2 )
         PA = VALRES(9)
         CALL RCVALA(IMATE,' ','BARCELONE',1,NOMPAR,VALPAM,1,
     +                 NOMRES(10),VALRES(10),CODRET(10), FB2 )
         R = VALRES(10)
         CALL RCVALA(IMATE,' ','BARCELONE',1,NOMPAR,VALPAM,1,
     +                 NOMRES(11),VALRES(11),CODRET(11), FB2 )
         BETA = VALRES(11)
         CALL RCVALA(IMATE,' ','BARCELONE',1,NOMPAR,VALPAM,1,
     +                 NOMRES(12),VALRES(12),CODRET(12), FB2 )
         KC = VALRES(12)
         CALL RCVALA(IMATE,' ','BARCELONE',1,NOMPAR,VALPAM,1,
     +                 NOMRES(13),VALRES(13),CODRET(13), FB2 )
         PC0INI = VALRES(13)
         CALL RCVALA(IMATE,' ','BARCELONE',1,NOMPAR,VALPAM,1,
     +                 NOMRES(14),VALRES(14),CODRET(14), FB2 )
         KAPAS = VALRES(14)
         CALL RCVALA(IMATE,' ','BARCELONE',1,NOMPAR,VALPAM,1,
     +                 NOMRES(15),VALRES(15),CODRET(15), FB2 )
         LAMBS = VALRES(15)
         CALL RCVALA(IMATE,' ','BARCELONE',1,NOMPAR,VALPAM,1,
     +                 NOMRES(16),VALRES(16),CODRET(16), BL2 )
         IF ( CODRET(16) .NE. 'OK' ) THEN
         VALRES(16) = M*(M-9.D0)*(M-3.D0)/9.D0/(6.D0-M)
     &                *(1.D0/(1.D0-KAPA/LAMBDA))
         ALPHAB = VALRES(16)
         ELSE
         ALPHAB = VALRES(16)
         ENDIF
         CALL RCVALA(IMATE,' ','THM_INIT',1,NOMPAR,VALPAM,1,
     +                 NOMRES(4),VALRES(4),CODRET(4), FB2 )
         PORO = VALRES(4)
         PORO2 = PORO
         DIFF = PORO1-PORO2
         IF (ABS(DIFF) .GT. TOL) THEN
           CALL UTMESS('F','NMCCAM','CAM_CLAY : LA POROSITE '
     &   //'DONNEE DANS CAM_CLAY DOIT ETRE LA MEME QUE DANS THM_INIT')
         ELSE
         PORO=PORO1
         ENDIF
         DEUXMU = E/(1.D0+NU)
         E0=PORO/(1.D0-PORO)
C--- CALCUL DES COEFFICIENTS K ET K0 DE LA COURBE HYDROSTATIQUE
C--- MECANIQUE
         XK0 = (1.D0+E0)/KAPA
C    CALCUL DE LAMBDA COMME DANS LE PAPIER D'ALONSO
         LAMBB = LAMBDA*((1.D0-R)*EXP(-BETA*P1)+R)
         XK= (1.D0+E0)/(LAMBB-KAPA)
C    DERIVEE DE LAMBB PAR RAPPORT A P1
         LAMP = -BETA*LAMBDA*((1.D0-R)*EXP(-BETA*P1))
C--- CALCUL DES COEFFICIENTS KS ET K0S DE LA COURBE HYDROSTATIQUE
C--- HYDRIQUE
         XK0S = (1.D0+E0)/KAPAS
         XKS= (1.D0+E0)/(LAMBS-KAPAS)
C--- ACTUALISATION DE SIP
         SIPP=SIPM+BIOT*SAT*DP1-BIOT*DP2
C
C     -- 3 CALCUL DE DEPSMO ET DEPSDV :
C     --------------------------------
      COEF = ALPHA*TP - ALPHA*TM
      DEPSMO = 0.D0 
      DO 110 K=1,NDIMSI
        DEPSTH(K) = DEPS(K)
 110  CONTINUE
      DO 111 K=1,3
        DEPSTH(K) = DEPSTH(K) - COEF
        DEPSMO = DEPSMO + DEPSTH(K)
 111  CONTINUE 
      DEPSMO = -DEPSMO
      DO 112 K=1,NDIMSI
        DEPSDV(K)   = DEPSTH(K) + DEPSMO/3.D0 * KRON(K)
 112  CONTINUE
C     -- 4 CALCUL DES CONTRAINTES DE BARCELONE A PARTIR DES 
C     ------------------------------------------------------
C     CONTRAINTES DE BISHOP
C     ---------------------
      P2M=P2-DP2
      P1M=P1-DP1

      DO 113 K=1,NDIMSI
        SBARM(K)   = SBISM(K) + (SIPM+P2M)*KRON(K)
 113  CONTINUE
C     -- 5 CALCUL DE SIGMMO, SIGMDV, SIGEL,SIMOEL,SIELEQ, SIEQM :
C     -------------------------------------------------------------
      SIGMMO = 0.D0
      DO 116 K =1,3
        SIGMMO = SIGMMO + SBARM(K)
 116  CONTINUE
      SIGMMO = -SIGMMO/3.D0
      IF (SIGMMO.LE.(-0.99D0*KC*P1)) THEN 
           CALL UTMESS('F','NMBARC','BARCELONE : IL FAUT QUE '
     &     //'LA CONTRAINTE HYDROSTATIQUE SOIT SUPERIEURE A LA ' 
     &     //' PRESSION DE COHESION -KC*PC ')
      ENDIF        
      SIELEQ = 0.D0
      SIEQM = 0.D0
      DO 117 K = 1,NDIMSI
        SIGMDV(K) = SBARM(K) + SIGMMO * KRON(K)
        SIEQM = SIEQM + SIGMDV(K)**2
        SIGEL(K)  = SIGMDV(K) + DEUXMU * DEPSDV(K)
        SIELEQ     = SIELEQ + SIGEL(K)**2
 117  CONTINUE
      SIELEQ     = SQRT(1.5D0*SIELEQ)
      SIEQM    = SQRT(1.5D0*SIEQM)

         IF ((-XK0*DEPSMO).GT.EPXMAX) THEN
           UMESS  = IUNIFI('MESSAGE')
           CALL TECAEL(IADZI,IAZK24)
           NOMAIL = ZK24(IAZK24-1+3) (1:8)
           WRITE (UMESS,9001) 'NMBARC_2','EXP EXPLOSE A LA MAILLE: ',
     &                                                           NOMAIL
           RETCOM = 1
           GO TO 8000
         ENDIF
         IF ((-BETA*P1M).GT.EPXMAX) THEN
           UMESS  = IUNIFI('MESSAGE')
           CALL TECAEL(IADZI,IAZK24)
           NOMAIL = ZK24(IAZK24-1+3) (1:8)
           WRITE (UMESS,9001) 'NMBARC_3','EXP EXPLOSE A LA MAILLE: ',
     &                                                           NOMAIL
           RETCOM = 1
           GO TO 8000
         ENDIF

C
      SIMOEL    = SIGMMO*EXP(XK0*DEPSMO)/((P1+PA)/(P1M+PA))**(XK0/XK0S)
C
         KCP1 = KC*P1
         KPMAX = MAX (KCP1 , ZERO)
C    CALCUL DE LAMBDA COMME DANS LE PAPIER D'ALONSO
         LAMBBM = LAMBDA*((1.D0-R)*EXP(-BETA*P1M)+R)
C     -- 6 DEFINITION DES VARIABLES INTERNES
C     ------------------------------------
      PCRM(1) = VIM(1)
      PCRM(2) = VIM(2)
      PC0M(1) = VIM(3)
      PC0M(2) = VIM(4)
C
      IF (PCRM(1).EQ.0.D0)  THEN
      PCRMP1 = (PA/2.D0)*
     &       (2*PRESCR/PA)**((LAMBDA-KAPA)/(LAMBB-KAPA))
      ELSE
      PCRMP1=(PA/2.D0)*
     &       (2*PCRM(1)/PA)**((LAMBBM-KAPA)/(LAMBB-KAPA))
      ENDIF
      IF (PC0M(1).EQ.0.D0)  PC0M(1) = PC0INI 

C     -- 7 CALCUL DU CRITERE MECANIQUE:
C     ----------------------
      FONC1 = SIELEQ**2+M*M*(SIMOEL+KPMAX)*(SIMOEL-2.D0*PCRMP1)
C
C     --  CALCUL DU CRITERE HYDRIQUE:
C     ----------------------
      FONC2 = P1-PC0M(1)
C
C     -- 8  TEST DE PLASTIFICATION ET CALCUL DE PCRP SIGP, SIGPDV :
C     ------------------------------------------------------------
      IF ( OPTION(1:9) .EQ. 'RAPH_MECA' .OR.
     &     OPTION(1:9) .EQ. 'FULL_MECA'     ) THEN
C     -- CAS ELASTIQUE
        IF ((FONC1.LE.0.D0).AND.(FONC2.LE.0.D0)) THEN
           PCRP(1) = PCRMP1
           PCRP(2) = 0.D0
           PC0P(1) = PC0M(1)
           PC0P(2) = 0.D0
           PSP = 0.D0
C
            DO 118 K=1,NDIMSI
C     -- REACTUALISATION DES CONTRAINTES
              SIGPMO = SIMOEL             
              SIGPDV(K) = SIGEL(K)
              SBARP(K)  = SIGEL(K)-SIMOEL*KRON(K)
C     -- CALCUL DES CONTRAINTES DE BISHOP
              SBISP(K) = SBARP(K)-(SIPP+P2)*KRON(K)
 118  CONTINUE
        ELSE
C     -- PLASTIFICATION : CALCUL DE LA DEFORMATION 
C     -- VOLUMIQUE PLASTIQUE : DEPPMO 
C     -- CRITERE HYDRIQUE EST ATTEINT
       IF (FONC2.GT.0) THEN
       PC0P(2) = 1.D0
       PC0P(1) = P1
C 
       DEPPMO = 1/XKS*LOG((PC0P(1)+PA)/(PC0M(1)+PA))
       PSP = DEPPMO
         IF ((-XK0*DEPPMO).GT.EPXMAX) THEN
           UMESS  = IUNIFI('MESSAGE')
           CALL TECAEL(IADZI,IAZK24)
           NOMAIL = ZK24(IAZK24-1+3) (1:8)
           WRITE (UMESS,9001) 'NMBARC_4','EXP EXPLOSE A LA MAILLE: ',
     &                                                           NOMAIL
           RETCOM = 1
           GO TO 8000
         ENDIF
         
         IF ((XK*DEPPMO).GT.EPXMAX) THEN
           UMESS  = IUNIFI('MESSAGE')
           CALL TECAEL(IADZI,IAZK24)
           NOMAIL = ZK24(IAZK24-1+3) (1:8)
           WRITE (UMESS,9001) 'NMBARC_5','EXP EXPLOSE A LA MAILLE: ',
     &                                                           NOMAIL
           RETCOM = 1
           GO TO 8000
         ENDIF
         
       SIGPMO = SIMOEL*EXP(-XK0*DEPPMO)
       PCRP(1) = PCRMP1*EXP(XK*DEPPMO)
 
       DO 114 K = 1,NDIMSI
       SIGPDV(K) = SIGEL(K)
       SBARP(K) = SIGPDV(K)-SIGPMO*KRON(K)
       SBISP(K) = SBARP(K)-(SIPP+P2)*KRON(K)
 114  CONTINUE
       F1 = SIMOEL*EXP(-XK0*DEPPMO)
       F2 = SIMOEL*EXP(-XK0*DEPPMO)-2.D0*PCRMP1
       F3 = 2.D0*SIMOEL*EXP(-XK0*DEPPMO)-2.D0*PCRMP1+KPMAX
       F = SIELEQ**2/(1.D0+6.D0*DEUXMU*DEPPMO*ALPHAB/2.D0/M/M/F3)**2
     &    +M**2*(F1+KPMAX)*F2
         IF (F.GT.0) THEN 
         PCRP(2) = 1
         ELSE
         PCRP(2) = 0
         ENDIF
       ELSE
C     -- CRITERE MECANIQUE EST ETTEINT
         IF (FONC1.GT.0) THEN
         PCRP(2) = 1.D0
         PC0P(2) = 0.D0 
C     -- VALEURS DES BORNES INITIALES 
         XINF = 0.D0

C     -- NEWTON POUR CALCULER LA BORNE SUP

       XINF0 = -1.D0
       XSUP0 = 1.D0
       XB0 = XINF0
       SEUIL0 = PCRMP1-(KC*P1)/2.D0
       
         IF ((-XK0*XB0).GT.EPXMAX) THEN
           UMESS  = IUNIFI('MESSAGE')
           CALL TECAEL(IADZI,IAZK24)
           NOMAIL = ZK24(IAZK24-1+3) (1:8)
           WRITE (UMESS,9001) 'NMBARC_6','EXP EXPLOSE A LA MAILLE: ',
     &                                                           NOMAIL
           RETCOM = 1
           GO TO 8000
         ENDIF
         
         IF ((XK*XB0).GT.EPXMAX) THEN
           UMESS  = IUNIFI('MESSAGE')
           CALL TECAEL(IADZI,IAZK24)
           NOMAIL = ZK24(IAZK24-1+3) (1:8)
           WRITE (UMESS,9001) 'NMBARC_7','EXP EXPLOSE A LA MAILLE: ',
     &                                                           NOMAIL
           RETCOM = 1
           GO TO 8000
         ENDIF
       
       
       F0 = SIMOEL*EXP(-XK0*XB0)-PCRMP1*EXP(XK*XB0)+(KC*P1)/2.D0
       FP0 = -XK0*SIMOEL*EXP(-XK0*XB0)-XK*PCRMP1*EXP(XK*XB0)

       DO 210 ITER = 1, NINT(CRIT(1))
C     --CRITERE DE CONVERGENCE
       
       IF ((ABS(F0/SEUIL0)) . LE. CRIT(3))   GOTO 101         

C     --CONSTRUCTION DU NOUVEL ITERE    
       XB0 = XB0-F0/FP0

         IF ((-XK0*XB0).GT.EPXMAX) THEN
           UMESS  = IUNIFI('MESSAGE')
           CALL TECAEL(IADZI,IAZK24)
           NOMAIL = ZK24(IAZK24-1+3) (1:8)
           WRITE (UMESS,9001) 'NMBARC_8','EXP EXPLOSE A LA MAILLE: ',
     &                                                           NOMAIL
           RETCOM = 1
           GO TO 8000
         ENDIF

         IF ((XK*XB0).GT.EPXMAX) THEN
           UMESS  = IUNIFI('MESSAGE')
           CALL TECAEL(IADZI,IAZK24)
           NOMAIL = ZK24(IAZK24-1+3) (1:8)
           WRITE (UMESS,9001) 'NMBARC_9','EXP EXPLOSE A LA MAILLE: ',
     &                                                           NOMAIL
           RETCOM = 1
           GO TO 8000
         ENDIF
       
C     -- DICHOTOMIE       
       IF (XB0.LE.XINF0 .OR. XB0.GE.XSUP0)  V0 = (XINF0+XSUP0)/2

       F0 = SIMOEL*EXP(-XK0*XB0)-PCRMP1*EXP(XK*XB0)+(KC*P1)/2.D0
       FP0 = -XK0*SIMOEL*EXP(-XK0*XB0)-XK*PCRMP1*EXP(XK*XB0)
       IF (F0.GT.ZERO) SIGNF0 =  1
       IF (F0.LT.ZERO) SIGNF0 = -1

         IF ((-XK0*XINF0).GT.EPXMAX) THEN
           UMESS  = IUNIFI('MESSAGE')
           CALL TECAEL(IADZI,IAZK24)
           NOMAIL = ZK24(IAZK24-1+3) (1:8)
           WRITE (UMESS,9001) 'NMBARC_10','EXP EXPLOSE A LA MAILLE: ',
     &                                                           NOMAIL
           RETCOM = 1
           GO TO 8000
         ENDIF

         IF ((XK*XINF0).GT.EPXMAX) THEN
           UMESS  = IUNIFI('MESSAGE')
           CALL TECAEL(IADZI,IAZK24)
           NOMAIL = ZK24(IAZK24-1+3) (1:8)
           WRITE (UMESS,9001) 'NMBARC_11','EXP EXPLOSE A LA MAILLE: ',
     &                                                           NOMAIL
           RETCOM = 1
           GO TO 8000
         ENDIF

       FXI0 = SIMOEL*EXP(-XK0*XINF0)-PCRMP1*EXP(XK*XINF0)+(KC*P1)/2.D0
       
       IF (FXI0.GT.ZERO) SIGFI0 =  1
       IF (FXI0.LT.ZERO) SIGFI0 = -1

       IF ((SIGNF0*SIGFI0).LT.ZERO) XSUP0 = XB0
       IF ((SIGNF0*SIGFI0).GT.ZERO) XINF0 = XB0

 210  CONTINUE
      CALL UTMESS('F','BARCELONE','ITER_INTE_MAXI INSUFFISANT '
     &     // 'LORS DU CALCUL DE LA BORNE'      )
 101  CONTINUE       
       XB = XB0
       XSUP = XB
       
C     --RESOLUTION AVEC LA METHODE DE NEWTON ENTRE LES BORNES
       V0 = XINF
       SEUIL = M**2*(PCRMP1+KC*P1/2)**2
         
         IF ((-XK0*V0).GT.EPXMAX) THEN
           UMESS  = IUNIFI('MESSAGE')
           CALL TECAEL(IADZI,IAZK24)
           NOMAIL = ZK24(IAZK24-1+3) (1:8)
           WRITE (UMESS,9001) 'NMBARC_12','EXP EXPLOSE A LA MAILLE:',
     &                                                           NOMAIL
           RETCOM = 1
           GO TO 8000
         ENDIF

         IF ((XK*V0).GT.EPXMAX) THEN
           UMESS  = IUNIFI('MESSAGE')
           CALL TECAEL(IADZI,IAZK24)
           NOMAIL = ZK24(IAZK24-1+3) (1:8)
           WRITE (UMESS,9001) 'NMBARC_13','EXP EXPLOSE A LA MAILLE:',
     &                                                           NOMAIL
           RETCOM = 1
           GO TO 8000
         ENDIF
       
         IF ((-2.D0*XK0*V0).GT.EPXMAX) THEN
           UMESS  = IUNIFI('MESSAGE')
           CALL TECAEL(IADZI,IAZK24)
           NOMAIL = ZK24(IAZK24-1+3) (1:8)
           WRITE (UMESS,9001) 'NMBARC_14','EXP EXPLOSE A LA MAILLE: ',
     &                                                           NOMAIL
           RETCOM = 1
           GO TO 8000
         ENDIF

         IF (((XK-XK0)*V0).GT.EPXMAX) THEN
           UMESS  = IUNIFI('MESSAGE')
           CALL TECAEL(IADZI,IAZK24)
           NOMAIL = ZK24(IAZK24-1+3) (1:8)
           WRITE (UMESS,9001) 'NMBARC_15','EXP EXPLOSE A LA MAILLE: ',
     &                                                           NOMAIL
           RETCOM = 1
           GO TO 8000
         ENDIF
       
       F1 = SIMOEL*EXP(-XK0*V0)
       F2 = SIMOEL*EXP(-XK0*V0)-2.D0*PCRMP1*EXP(XK*V0)
       F3 = 2.D0*SIMOEL*EXP(-XK0*V0)-2.D0*PCRMP1*EXP(XK*V0)+KPMAX
       F = SIELEQ**2+M**2*(1.D0+6.D0*DEUXMU*V0*ALPHAB/2.D0/M/M/F3)**2
     &      *(F1+KPMAX)*F2

       F4 = (1.D0+6.D0*DEUXMU*V0*ALPHAB/2.D0/M/M/F3)
       F5 = -2.D0*XK0*SIMOEL**2*EXP(-2.D0*XK0*V0)+
     &         2.D0*SIMOEL*PCRMP1*EXP((XK-XK0)*V0)*(XK0-XK)
     &   -KPMAX*(XK0*SIMOEL*EXP(-XK0*V0)+2.D0*XK*PCRMP1*EXP(XK*V0))
       F6 = 2.D0*SIMOEL*(1.D0+V0*XK0)*EXP(-XK0*V0)+
     &        2.D0*PCRMP1*(-1.D0+V0*XK)*EXP(XK*V0)+
     &        KPMAX
       FP = M**2*F4**2*F5+6.D0*DEUXMU*ALPHAB*F4*(F1+KPMAX)*F2*(F6/F3/F3)
       
C          
       DO 200 ITER = 1, NINT(CRIT(1))
C     --CRITERE DE CONVERGENCE
       IF ((ABS(F)/SEUIL) . LE. CRIT(3))   GOTO 100         

C     --CONSTRUCTION DU NOUVEL ITERE    
       V0 = V0-F/FP
       IF (XSUP.GT.ZERO) THEN
       IF (V0.LE.XINF .OR. V0.GE.XSUP)  V0 = (XINF+XSUP)/2
       ELSE
       IF (V0.LE.XSUP .OR. V0.GE.XINF)  V0 = (XINF+XSUP)/2
       ENDIF       

         IF ((-XK0*V0).GT.EPXMAX) THEN
           UMESS  = IUNIFI('MESSAGE')
           CALL TECAEL(IADZI,IAZK24)
           NOMAIL = ZK24(IAZK24-1+3) (1:8)
           WRITE (UMESS,9001) 'NMBARC_16','EXP EXPLOSE A LA MAILLE:',
     &                                                           NOMAIL
           RETCOM = 1
           GO TO 8000
         ENDIF

         IF ((XK*V0).GT.EPXMAX) THEN
           UMESS  = IUNIFI('MESSAGE')
           CALL TECAEL(IADZI,IAZK24)
           NOMAIL = ZK24(IAZK24-1+3) (1:8)
           WRITE (UMESS,9001) 'NMBARC_17','EXP EXPLOSE A LA MAILLE: ',
     &                                                           NOMAIL
           RETCOM = 1
           GO TO 8000
         ENDIF
       
         IF ((-2.D0*XK0*V0).GT.EPXMAX) THEN
           UMESS  = IUNIFI('MESSAGE')
           CALL TECAEL(IADZI,IAZK24)
           NOMAIL = ZK24(IAZK24-1+3) (1:8)
           WRITE (UMESS,9001) 'NMBARC_18','EXP EXPLOSE A LA MAILLE: ',
     &                                                           NOMAIL
           RETCOM = 1
           GO TO 8000
         ENDIF
       
         IF ((-XK0*XINF).GT.EPXMAX) THEN
           UMESS  = IUNIFI('MESSAGE')
           CALL TECAEL(IADZI,IAZK24)
           NOMAIL = ZK24(IAZK24-1+3) (1:8)
           WRITE (UMESS,9001) 'NMBARC_19','EXP EXPLOSE A LA MAILLE: ',
     &                                                           NOMAIL
           RETCOM = 1
           GO TO 8000
         ENDIF

         IF ((XK*XINF).GT.EPXMAX) THEN
           UMESS  = IUNIFI('MESSAGE')
           CALL TECAEL(IADZI,IAZK24)
           NOMAIL = ZK24(IAZK24-1+3) (1:8)
           WRITE (UMESS,9001) 'NMBARC_20','EXP EXPLOSE A LA MAILLE: ',
     &                                                           NOMAIL
           RETCOM = 1
           GO TO 8000
         ENDIF

C     --CALCUL DE LA FONCTION EN V0 ET DE SA DERIVEE
       F1 = SIMOEL*EXP(-XK0*V0)
       F2 = SIMOEL*EXP(-XK0*V0)-2.D0*PCRMP1*EXP(XK*V0)
       F3 = 2.D0*SIMOEL*EXP(-XK0*V0)-2.D0*PCRMP1*EXP(XK*V0)+KPMAX
       F = SIELEQ**2+M**2*(1.D0+6.D0*DEUXMU*V0*ALPHAB/2.D0/M/M/F3)**2
     &      *(F1+KPMAX)*F2
       IF (F.GT.ZERO) SIGNF =  1
       IF (F.LT.ZERO) SIGNF = -1
       F4 = (1.D0+6.D0*DEUXMU*V0*ALPHAB/2.D0/M/M/F3)
       F5 = -2.D0*XK0*SIMOEL**2*EXP(-2.D0*XK0*V0)+
     &         2.D0*SIMOEL*PCRMP1*EXP((XK-XK0)*V0)*(XK0-XK)
     &   -KPMAX*(XK0*SIMOEL*EXP(-XK0*V0)+2.D0*XK*PCRMP1*EXP(XK*V0))
       F6 = 2.D0*SIMOEL*(1.D0+V0*XK0)*EXP(-XK0*V0)+
     &        2.D0*PCRMP1*(-1.D0+V0*XK)*EXP(XK*V0)+
     &        KPMAX
       FP = M**2*F4**2*F5+6.D0*DEUXMU*ALPHAB*F4*(F1+KPMAX)*F2*(F6/F3/F3)
         
         
       FXI1 = SIMOEL*EXP(-XK0*XINF)
       FXI2 = SIMOEL*EXP(-XK0*XINF)-2.D0*PCRMP1*EXP(XK*XINF)
       FXI3 = 2.D0*SIMOEL*EXP(-XK0*XINF)-2.D0*PCRMP1*EXP(XK*XINF)+KPMAX
       FXI = SIELEQ**2+M**2*
     &      (1.D0+6.D0*DEUXMU*XINF*ALPHAB/2.D0/M/M/FXI3)**2
     &      *(FXI1+KPMAX)*FXI2       
       IF (FXI.GT.ZERO) SIGNFI =  1
       IF (FXI.LT.ZERO) SIGNFI = -1

       IF ((SIGNF*SIGNFI).LT.ZERO) XSUP = V0
       IF ((SIGNF*SIGNFI).GT.ZERO) XINF = V0

 
 200  CONTINUE
      CALL UTMESS('F','BARCELONE','ITER_INTE_MAXI INSUFFISANT')
 100  CONTINUE       
      DEPPMO=V0
C
         IF ((XK*DEPPMO).GT.EPXMAX) THEN
           UMESS  = IUNIFI('MESSAGE')
           CALL TECAEL(IADZI,IAZK24)
           NOMAIL = ZK24(IAZK24-1+3) (1:8)
           WRITE (UMESS,9001) 'NMBARC_21','EXP EXPLOSE A LA MAILLE: ',
     &                                                           NOMAIL
           RETCOM = 1
           GO TO 8000
         ENDIF

         IF ((XKS*DEPPMO).GT.EPXMAX) THEN
           UMESS  = IUNIFI('MESSAGE')
           CALL TECAEL(IADZI,IAZK24)
           NOMAIL = ZK24(IAZK24-1+3) (1:8)
           WRITE (UMESS,9001) 'NMBARC_22','EXP EXPLOSE A LA MAILLE: ',
     &                                                           NOMAIL
           RETCOM = 1
           GO TO 8000
         ENDIF

         IF ((XK0*(DEPSMO-DEPPMO)).GT.EPXMAX) THEN
           UMESS  = IUNIFI('MESSAGE')
           CALL TECAEL(IADZI,IAZK24)
           NOMAIL = ZK24(IAZK24-1+3) (1:8)
           WRITE (UMESS,9001) 'NMBARC_23','EXP EXPLOSE A LA MAILLE: ',
     &                                                           NOMAIL
           RETCOM = 1
           GO TO 8000
         ENDIF

C     -- REACTUALISATION DE LA VARIABLE INTERNE MECANIQUE PCR
        PCRP(1) = PCRMP1*EXP(XK*DEPPMO)
C     -- CALCUL DE LA DERIVEE DE PCRP PAR RAPPORT A P1
        PCRPP = -LOG(2.D0*PRESCR/PA)*
     &          ((LAMBDA-KAPA)/(LAMBB-KAPA)**2)*LAMP*PCRP(1) 
C     -- REACTUALISATION DU SEUIL HYDRIQUE
        PC0P(1) = (PC0M(1)+PA)*EXP(XKS*DEPPMO)-PA
C
        PSP = DEPPMO
C
C     -- REACTUALISATION DES CONTRAINTES NETTES DE BARCELONE
        SIGPMO = SIGMMO*EXP(XK0*(DEPSMO-DEPPMO))/
     &   ((P1+PA)/(P1M+PA))**(XK0/XK0S)
       CALL R8INIR(6,0.D0,SIGPDV,1)        
         DO 119 K=1,NDIMSI
           SIGPDV(K) = SIGEL(K)/(1.D0+(6.D0*DEUXMU/2.D0*ALPHAB*
     &         DEPPMO)/(M*M*(2.D0*SIGPMO-2.D0*PCRP(1)+KPMAX)))
           SBARP(K) = SIGPDV(K)-SIGPMO*KRON(K)
C     -- CALCUL DES CONTRAINTES DE BISHOP
           SBISP(K) = SBARP(K)-(SIPP+P2)*KRON(K)
 119  CONTINUE 
C 
      ENDIF
      ENDIF
      ENDIF        
      VIP(1) = PCRP(1)
      VIP(2) = PCRP(2)
      VIP(3) = PC0P(1)
      VIP(4) = PC0P(2)
      VIP(5) = PSP
      ENDIF
C
C     -- 9 CALCUL DE L'OPERATEUR TANGENT :
C     --------------------------------
      IF ( OPTION(1:14) .EQ. 'RIGI_MECA_TANG'.OR.
     &     OPTION(1:9)  .EQ. 'FULL_MECA'         ) THEN     
C
       IF ( OPTION(1:14) .EQ. 'RIGI_MECA_TANG' ) THEN
           IF ((PCRM(2).EQ.0.D0).AND.(PC0M(2).EQ.0.D0)) THEN
            MATR = 0
           ELSE IF ((PCRM(2).EQ.1.D0).AND.(PC0M(2).EQ.0.D0)) THEN
            MATR = 1
           ELSE IF ((PCRM(2).EQ.0.D0).AND.(PC0M(2).EQ.1.D0)) THEN
            MATR =11
           ENDIF
       END IF
       IF ( OPTION(1:9) .EQ. 'FULL_MECA' ) THEN
           IF ((PCRP(2).EQ.1.D0).AND.(PC0P(2).EQ.0.D0)) THEN
            MATR = 2
           ELSE IF ((PCRP(2).EQ.0.D0).AND.(PC0P(2).EQ.1.D0)) THEN
            MATR = 21
           ELSE IF ((PCRP(2).EQ.0.D0).AND.(PC0P(2).EQ.0.D0)) THEN
            MATR = 0
           ENDIF
       END IF

C     --9.0 INITIALISATION DE L'OPERATEUR TANGENT
C     ---------------------------------------
         DO 125 K=1,6
         DO 126 L=1,6
            DSIDEP(K,L) = 0.D0
            DSIDP1(K) = 0.D0
 126  CONTINUE
 125  CONTINUE
C 
C     -- 9.1 CALCUL DE DSIDEP(6,6)-ELASTIQUE: 
C     ---------------------------------------
        IF (MATR .EQ. 0) THEN
          DO 127 K=1,3
            DO 128 L=1,3
              DSIDEP(K,L) = XK0*SIMOEL-DEUXMU/3.D0
 128  CONTINUE
 127  CONTINUE
            DO 129 K=1,NDIMSI
               DSIDEP(K,K) = DSIDEP(K,K)+DEUXMU
 129  CONTINUE
C 
C     -- 9.2 CALCUL DE DSIDP1(6) ELASTIQUE: 
C     ---------------------------------------
          DO 139 K=1,NDIMSI
            DSIDP1(K) = (XK0/XK0S*SIMOEL/(P1+PA)-SAT*BIOT)*KRON(K)
 139  CONTINUE      
        END IF
C     -- 9.3 CALCUL DE DSIDEP(6,6) CRITERE MECANIQUE ATTEINT 
C     ------------------------------------------------------
C     -EN VITESSE : 
C     ------------
      IF (MATR.EQ.1) THEN
C 
C     -- 9.3.1 CALCUL DU MODULE ELASTOPLASTIQUE H
        H = M**4*(2.D0*SIGMMO-2.D0*PCRMP1+KPMAX)*
     &  (XK0*SIGMMO*(2.D0*SIGMMO-2.D0*PCRMP1+KPMAX)+2.D0*XK*PCRMP1*
     &    (SIGMMO+KPMAX))+6.D0*DEUXMU*SIEQM**2*ALPHAB

C     -- 9.3.2 CALCUL D'UN TERME INTERMEDIAIRE      
          DO 160 K=1,NDIMSI
             A(K) = 0.D0
 160  CONTINUE
          DO 130 K=1,3
             A(K) = -XK0*M*M*SIGMMO*(2.D0*SIGMMO-2.D0*PCRMP1+KPMAX)
     &               *KRON(K)+3.D0*DEUXMU*SIGMDV(K)
             AP(K) = -XK0*M*M*SIGMMO*(2.D0*SIGMMO-2.D0*PCRMP1+KPMAX)
     &               *KRON(K)+3.D0*DEUXMU*SIGMDV(K)*ALPHAB
 130  CONTINUE
       CALL R8INIR(3,0.D0,AA,1)
          DO 131 K=4,NDIMSI
             AA(K) = 3.D0*DEUXMU*SIGMDV(K)
             AAP(K) = 3.D0*DEUXMU*SIGMDV(K)*ALPHAB
 131  CONTINUE
C
C     -- 9.3.3 CALCUL DES TERMES DE DSIDEP 
       CALL R8INIR(NDIMSI*NDIMSI,0.D0,DSIDEP,1)
          DO 132 K=1,3
           DO 133 L=1,3
             DSIDEP(K,L)=XK0*SIGMMO-DEUXMU/3.D0 - 
     &                  1.D0/2.D0/H*(A(K)*AP(L)+A(L)*AP(K))
 133  CONTINUE
 132  CONTINUE
          DO 134 K=1,3
          DO 135 L=4,NDIMSI
             DSIDEP(K,L) = -1.D0/2.D0*(A(K)*AAP(L)+AP(K)*AA(L))
             DSIDEP(K,L) = DSIDEP(K,L)/H
             DSIDEP(L,K) = DSIDEP(K,L)
 135  CONTINUE
 134  CONTINUE
          DO 136 K=4,NDIMSI
          DO 137 L=4,NDIMSI
             DSIDEP(K,L) = -1.D0/2.D0*(AA(K)*AAP(L)+AA(L)*AAP(K))
             DSIDEP(K,L) = DSIDEP(K,L)/H
 137  CONTINUE
 136  CONTINUE  
           DO 138 K=1,NDIMSI     
           DSIDEP(K,K) = DEUXMU + DSIDEP(K,K)
 138  CONTINUE
C     -- 9.4 CALCUL DE DSIDP1(6) CRITERE MECANIQUE ATTEINT- 
C     -----------------------------------------------------
C     EN VITESSE : 
C     -----------
      TRA = -3.D0*XK0*M*M*SIGMMO*(2.D0*SIGMMO-2.D0*PCRMP1+KPMAX)
      PAR = (KC*(2.D0*PCRMP1-SIGMMO)-2.D0*PCRMP1*
     &                  (SIGMMO+KPMAX)*LOG(2.D0*PRESCR/PA)*
     &                  ((LAMBDA-KAPA)/(LAMBB-KAPA)**2)*LAMP)
          DO 161 K=1,3
            DSIDP1(K) = -AP(K)*TRA/3.D0/H/XK0S/(P1+PA)
     &                  +M*M*PAR/H*AP(K)
     &                  +XK0*SIGMMO/XK0S/(P1+PA)
     &                  -BIOT*SAT
 161  CONTINUE            
          DO 166 K=4,NDIMSI
            DSIDP1(K)=-DEUXMU*TRA*SIGMDV(K)*ALPHAB/H/XK0S/(P1+PA)
     &                   +3.D0*DEUXMU*SIGMDV(K)*ALPHAB*M*M*PAR/H
 166  CONTINUE            
        ENDIF
C     -- 9.5 CALCUL DE DSIDEP(6,6)CRITERE HYDRIQUE ATTEINT-EN VITESSE: 
C     ---------------------------------------------------------------
      IF (MATR.EQ.11) THEN
          DO 162 K=1,3
            DO 163 L=1,3
              DSIDEP(K,L) = XK0*SIGMMO-DEUXMU/3.D0
 163  CONTINUE
 162  CONTINUE
            DO 164 K=1,NDIMSI
               DSIDEP(K,K) = DSIDEP(K,K)+DEUXMU
 164  CONTINUE
C     -- 9.6 CALCUL DE DSIDP1(6) CRITERE HYDRIQUE ATTEINT-EN VITESSE: 
C     --------------------------------------------------------------
          DO 165 K=1,NDIMSI
            DSIDP1(K) = (XK0*SIGMMO/(P1+PA)*(1.D0/XKS+1.D0/XK0S)
     &                    -SAT*BIOT)*KRON(K)
 165  CONTINUE            
        ENDIF
C        
C     -- 9.7 CALCUL DE DSIDEP(6,6)-MATRICE COHERENTE CRITERE MECANIQUE 
C      ATTEINT: MATRICE QUI RELIE LES CONTRAINTES AUX DEFORMATIONS
C     -----------------------------------------------------------------
        IF (MATR.EQ.2) THEN
      SIEQP = 0.0D0
      DO 3000 K=1,NDIMSI
           SIEQP = SIEQP + SIGPDV(K)**2
 3000  CONTINUE
       SIEQP = SQRT(1.5D0*SIEQP)
        DIFF1 = ABS((SIGPMO-PCRP(1)+KPMAX/2)/(PCRP(1)-KPMAX/2))
        IF (DIFF1.LT.CRIT(3)) THEN
C
C     -- 9.7.0.1 OPERATEUR TANGENT COHERENT AU POINT CRITIQUE
C     -- TRAITEMENT DE LA PARTIE DEVIATORIQUE
C     -- CALCUL DE Q+
C     -- CALCUL DU TENSEUR HHB QUI MULTIMPLIE LA DEFORMATION
       CALL R8INIR(6*6,0.D0,SES,1)
       DO 1000 K=1,NDIMSI
         DO 1001 L = 1,NDIMSI
          SES(K,L) = 1.D0/2.D0*(SIGPDV(K)*SIGEL(L)+SIGEL(K)*SIGPDV(L))
 1001 CONTINUE 
 1000 CONTINUE 
       CALL R8INIR(6*6,0.D0,HHB,1) 
       DO 3001 K=1,NDIMSI
       DO 3002 L=1,NDIMSI
            HHB(K,L) = -DEUXMU*3.D0*SES(K,L)/2.D0/SIELEQ/SIEQP/ALPHAB
 3002  CONTINUE
 3001  CONTINUE
       DO 3003 K=1,NDIMSI
            HHB(K,K) = DEUXMU+HHB(K,K)
 3003  CONTINUE 
         IF (NDIM.EQ.2) THEN
           HHB(5,5) = 1.D0
           HHB(6,6) = 1.D0
         ENDIF
C     -- INVERSE DE HHB
        CALL R8INIR(6*6,0.D0,HHBM,1)  
           DO 3004 K=1,6
               HHBM(K,K)=1.D0
 3004  CONTINUE 
        CALL MGAUSS(HHB,HHBM,6,6,6,NUL,LOGIC) 
C     -- CALCUL DU TENSEUR GG QUI MULTIMPLIE LA CONTRAINTE
       CALL R8INIR(6*6,0.D0,SPS,1)
       DO 1002 K=1,NDIMSI
         DO 1003 L = 1,NDIMSI
          SPS(K,L) = SIGPDV(K)*SIGPDV(L)
 1003 CONTINUE 
 1002 CONTINUE 
       CALL R8INIR(6*6,0.D0,GG,1) 
       DO 3005 K=1,NDIMSI
       DO 3006 L=1,NDIMSI
            GG(K,L) = -3.D0*SIELEQ*SPS(K,L)/2.D0/SIEQP**3/ALPHAB
 3006  CONTINUE
 3005  CONTINUE
       DO 3007 K=1,NDIMSI
            GG(K,K) = SIELEQ/SIEQP/ALPHAB+(1.D0-1.D0/ALPHAB)+GG(K,K)
 3007  CONTINUE 
C     --  MATRICE DE PROJECTION SUR L'ESPACE DES CONTRAINTES
C     -- DEVIATORIQUES
       CALL R8INIR(6*6,0.D0,V,1)    
       DO 3015 K = 1,3
       DO 3016 L = 1,3
         V(K,L) = -1.D0/3.D0
         V(L,K) = V(K,L)
 3016  CONTINUE
 3015  CONTINUE
      DO 3017 K= 1,NDIMSI
         V(K,K) = V(K,K) + 1.D0
 3017  CONTINUE
C     --  PRODUIT DE LA MATRICE DE PROJECTION SUR L'ESPACE 
C     --  DES CONTRAINTES DEVIATORIQUES PAR GG
       CALL R8INIR(6*6,0.D0,D1G,1)
       CALL PROMAT(V,6,NDIMSI,NDIMSI,GG,6,NDIMSI,NDIMSI,D1G)
C     -- PRODUIT DU RESULTAT PAR L'INVERSE DE HHB
       CALL R8INIR(6*6,0.D0,D1GHHM,1)
       CALL PROMAT(D1G,6,NDIMSI,NDIMSI,HHBM,6,NDIMSI,NDIMSI,D1GHHM)
C
C     -- 9.7.0.2 TRAITEMENT DE LA PARTIE HYDROSTATIQUE
C     --  PRODUIT DE LA MATRICE DE PROJECTION SUR L'ESPACE 
C     --  DES CONTRAINTES HYDROSTATIQUES PAR LA MATRICE IDENTITE
C     --  D'ORDRE 2
       CALL R8INIR(6*6,0.D0,ID2,1)
       DO 3008 K=1,3
       DO 3009 L=1,3
            ID2(K,L) = -1.D0/3.D0/XK0/SIGPMO
 3009  CONTINUE 
 3008  CONTINUE 
C     -- SOMME DES TERMES DEVIATORIQUE ET HYDROSTATIQUE
       CALL R8INIR(6*6,0.D0,DEVHYD,1)
       DO 3010 K=1,NDIMSI
       DO 3011 L=1,NDIMSI
            DEVHYD(K,L) = D1GHHM(K,L)/DEUXMU + ID2(K,L)
 3011  CONTINUE 
 3010  CONTINUE 
         IF (NDIM.EQ.2) THEN
           DEVHYD(5,5) = 1.D0
           DEVHYD(6,6) = 1.D0
         ENDIF
C     -- INVERSE DE LA SOMME DES TERMES DEVIATORIQUE ET HYDROSTATIQUE
        CALL R8INIR(6*6,0.D0,DEVHYM,1)  
           DO 3012 K=1,6
               DEVHYM(K,K)=1.D0
 3012  CONTINUE 
        CALL MGAUSS(DEVHYD,DEVHYM,6,6,6,NUL,LOGIC) 
C     -- TERMES DE L'OPERATEUR TANGENT QUI RELIENT LA CONTRAINTE
C     -- A LA DEFORMATION       
       CALL R8INIR(6*6,0.D0,DSIDEP,1)
       DO 3013 K=1,6
       DO 3014 L=1,6
            DSIDEP(K,L) = DEVHYM(K,L)
 3014  CONTINUE 
 3013  CONTINUE             
C     -- 9.7.0.3 CALCUL DE DSIDP1(6) COHERENT AU POINT CRITIQUE: 
C    -- MATRICE QUI RELIE LES CONTRAINTES A LA SUCCION
       CALL R8INIR(6*6,0.D0,DSIDP1,1)
       DO 3018 K=1,NDIMSI
            DSIDP1(K) = -KRON(K)/XK0S/(P1+PA)-BIOT*SAT*KRON(K)
 3018   CONTINUE 
                    
        ELSE
C        
C      -- 9.7.1 OPERATEUR TANGENT COHERENT DANS LE CAS GENERAL
C      -- CALCUL DES INCREMENTS DE P ET DE S
        DELTAP = SIGPMO - SIGMMO
       CALL R8INIR(6,0.D0,DELTAS,1)
           DO 140 K=1,NDIMSI
              DELTAS(K)=SIGPDV(K)-SIGMDV(K)
 140  CONTINUE
C           
C     -- 9.7.2 CALCUL DE VECTEURS INTERMEDIAIRES 
        SPARDS = 0.D0
           DO 141 K = 1,NDIMSI
               SPARDS = SPARDS+DELTAS(K)*SIGPDV(K)
 141  CONTINUE
       CALL R8INIR(6,0.D0,TPLUS,1)
           DO 142 K = 1, NDIMSI
               TPLUS(K) = SIGPDV(K) + DELTAS(K)
 142  CONTINUE              
C
C      9.7.3-- TERMES NECESSAIRES A LA PARTIE DEVIATORIQUE 
        HP = 2.D0*M**4*XK*(SIGPMO+KPMAX)*PCRP(1)*
     &                   (2.D0*SIGPMO-2.D0*PCRP(1)+KPMAX)
C
        XC = 9.D0*SPARDS*ALPHAB/HP
        XD = 3.D0*M*M*(2.D0*SIGPMO-2.D0*PCRP(1)+KPMAX)*DELTAP*ALPHAB/HP
        XGG = -3.D0*M**2/HP*KC*(2.D0*PCRP(1)-SIGPMO)*DP1*ALPHAB
        XHHC = -6.D0*ALPHAB/HP*M*M*(SIGPMO+KPMAX)*PCRPP*DP1
        XV = 3.D0*SPARDS + M**2*(2.D0*SIGPMO-2.D0*PCRP(1)+KPMAX)*DELTAP-
     &    M**2*(KC*(2.D0*PCRP(1)-SIGPMO)+2.D0*(SIGPMO+KPMAX)*PCRPP)*DP1
        XLAM = XV/HP
        XA = (XLAM*XK*M**4*(SIGPMO+KPMAX)*
     &       (2.D0*SIGPMO-4.D0*PCRP(1)+KPMAX)+
     &       M**2*DELTAP+M**2*KC*DP1)*M**2*
     &       (2.D0*SIGPMO-2.D0*PCRP(1)+KPMAX)/
     &       (M**2*XLAM+(1.D0/2.D0/XK/PCRP(1)))
        XI = M**2*(2.D0*SIGPMO-2.D0*PCRP(1)+KPMAX)-M**4*XLAM*
     &      (2.D0*SIGPMO-2.D0*PCRP(1)+KPMAX)/
     &      ((1.D0/2.D0/XK/PCRP(1))+M**2*XLAM)
        RAP = XI/(HP+XA)
C
C     9.7.4-- CALCUL DE LA MATRICE CC-SYMETRISATION DE TPLUS.I
C
       CALL R8INIR(6*6,0.D0,CC,1)
          DO 172 K=1,3
          DO 173 L=1,3
              CC(K,L)=(TPLUS(K)+TPLUS(L))/2.D0
 173  CONTINUE
 172  CONTINUE
          DO 174 K=1,3
          DO 175 L=4,NDIMSI
              CC(K,L)=TPLUS(L)/2.D0
              CC(L,K)=CC(K,L)
 175  CONTINUE
 174  CONTINUE
                  
C     9.7.5-- CALCUL DES TERMES D'UNE MATRICE INTERMEDIAIRE C
C
       CALL R8INIR(6*6,0.D0,C,1)
          DO 170 K=1,NDIMSI
          DO 171 L=1,NDIMSI
             C(K,L) = 9.D0*ALPHAB/2.D0/(HP+XA)*(SIGPDV(K)*TPLUS(L)+
     &                                         TPLUS(K)*SIGPDV(L))
 171  CONTINUE
 170  CONTINUE
           DO 149 K=1,NDIMSI
               C(K,K) = C(K,K)+1.D0/DEUXMU+XC+XD+XGG+XHHC
 149  CONTINUE
C 
C     9.7.6-- ASSEMBLAGE DES TERMES POUR LA PARTIE DEVIATORIQUE
       CALL R8INIR(6*6,0.D0,EE,1)
           DO 180 K=1,NDIMSI
           DO 181 L=1,NDIMSI
               EE(K,L) = C(K,L) - RAP*CC(K,L)
  181   CONTINUE
  180   CONTINUE
C            
C      9.7.7-- TERMES NECESSAIRES A LA PARTIE HYDROSTATIQUE             
        XU = 2.D0*M**2*XK*PCRP(1)
        XG = XLAM*XU/(1.D0+XLAM*XU)
        XH = XU*(2.D0*SIGPMO-2.D0*PCRP(1)+KPMAX)/2.D0/(1.D0+XLAM*XU)
        XM = 2.D0*SIGPMO**2-4.D0*SIGPMO*PCRP(1)-4.D0*PCRP(1)*KPMAX
     &      +3.D0*SIGPMO*KPMAX+(KPMAX)**2
        XE = 1.D0+XH*2.D0*M**2*(DELTAP+KPMAX)/HP+XH*2.D0*XK*M**4*
     &      XM*XV/HP/HP
        XF = M**2*(2.D0*SIGPMO-2.D0*PCRP(1)+
     &         KPMAX+KC*(1.D0-2.D0*XG)*DP1+2.D0*DELTAP
     &        -2.D0*XG*DELTAP-2.D0*PCRPP*DP1)/HP
     &        -2.D0*XK*M**4*XV/HP/HP*
     &        ((4.D0*SIGPMO-2.D0*PCRP(1)+3.D0*KPMAX)*PCRP(1)+XG*XM)
        CT = (1.D0+M**2*XK0*SIGPMO*(2.D0*XLAM-2.D0*XG*XLAM-2.D0*
     &       XLAM*XF*XH/XE+XF/XE*(2.D0*SIGPMO-2.D0*PCRP(1)+KPMAX)))
     &       /(XK0*SIGPMO)

C     9.7.8--  VECTEUR INTERMEDIAIRE
       CALL R8INIR(6,0.D0,FV,1)
       DO 190 K=1,NDIMSI
           FV(K)=3.D0*XF/XE*SIGPDV(K)-CT*KRON(K)/3.D0
 190  CONTINUE
C     9.7.9-- SYMMETRISATION DEFV ET SA PROJECTION SUR L'ESPACE
C     -- DES CONTRAINTES HYDROSTATIQUES
       CALL R8INIR(6*6,0.D0,FFI,1)
        DO 195 K=1,3
        DO 196 L=1,3
             FFI(K,L) = -(1.D0/3.D0)*(FV(K)+FV(L))/2.D0
 196  CONTINUE
 195  CONTINUE
        DO 197 K=1,3
        DO 198 L=4,NDIMSI
             FFI(K,L) = -(1.D0/3.D0)*FV(L)/2.D0
             FFI(L,K) = FFI(K,L)
 198  CONTINUE
 197  CONTINUE
C     9.7.10--  MATRICE DE PROJECTION SUR L'ESPACE DES CONTRAINTES
C     -- DEVIATORIQUES
       CALL R8INIR(6*6,0.D0,V,1)    
       DO 185 K = 1,3
       DO 186 L = 1,3
         V(K,L) = -1.D0/3.D0
         V(L,K) = V(K,L)
 186  CONTINUE
 185  CONTINUE
      DO 187 K= 1,NDIMSI
         V(K,K) = V(K,K) + 1.D0
 187  CONTINUE
C     9.7.11-- PROJECTION DE EE SUR L'ESPACE DES CONTRAINTES
C     -- DEVIATORIQUES 
       CALL R8INIR(6*6,0.D0,S,1)
       CALL PROMAT(EE,6,NDIMSI,NDIMSI,V,6,NDIMSI,NDIMSI,S)
C       
C     9.7.12-- COMBINAISON DES DEUX PARTIES DEVIATORIQUE ET 
C     -- HYDROSTATIQUE
       CALL R8INIR(6*6,0.D0,T,1)
        DO 204 K = 1,NDIMSI
        DO 205 L = 1,NDIMSI
           T(K,L) =  S(K,L)+ FFI(K,L)
 205  CONTINUE
 204  CONTINUE
         IF (NDIM.EQ.2) THEN
           T(5,5) = 1.D0
           T(6,6) = 1.D0
         ENDIF
C     9.7.13-- INVERSE DE LA MATRICE T
       CALL R8INIR(6*6,0.D0,VV,1)
           DO 108 K=1,6
               VV(K,K)=1.D0
 108  CONTINUE 
       CALL MGAUSS(T,VV,6,6,6,NUL,LOGIC)
C     --  9.7.14 CALCUL DES TERMES DSIDEP L'OPERATEUR TANGENT
       CALL R8INIR(6*6,0.D0,DSIDEP,1)
        DO 106 K = 1,6
        DO 107 L = 1,6
        DSIDEP(K,L) = VV(K,L)
 107  CONTINUE
 106  CONTINUE  
C     -- 9.8 CALCUL DE DSIDP1(6) COHERENT CRITERE MECANIQUE ATTEINT: 
C    -- MATRICE QUI RELIE LES CONTRAINTES A LA SUCCION
C     -----------------------------------------------------------
C     9.8.1 TERMES NECESSAIRES A LA PARTIE DEVIATORIQUE
       XZ = M*M*XLAM*(XK*KC*XLAM*M*M*XM/(1.D0/XU+XLAM)+
     &               2.D0*XK*KC*PCRP(1)*M*M*
     &               (3.D0*SIGPMO-2.D0*PCRP(1)+2.D0*KPMAX))+
     &     (M**4*KC*DELTAP*XLAM+M*M*KC*KC*XLAM*DP1)/(1.D0/XU+XLAM)+
     &     M*M*KC*(2*PCRP(1)-SIGPMO-DELTAP)+
     &     2.D0*M*M*PCRPP*(SIGPMO+KPMAX+KC*DP1)
       XDD = -KC*(XLAM*M*M)**2/(M**2*XLAM+1.D0/(2.D0*XK*PCRP(1)))+
     &      M*M*XLAM*KC
C     9.8.2 VECTEUR INTERMEDIAIRE MULTIPLIE DP1 EN DEVIATORIQUE
       CALL R8INIR(6,0.D0,HH,1)
       DO 300 K = 1, NDIMSI
       HH(K) = 3.D0*XZ/(HP+XA)*SIGPDV(K)-
     &       XI*XZ/3.D0/(HP+XA)*KRON(K) +
     &       XDD/3.D0*KRON(K) +
     &       KRON(K)/3.D0/XK0S/(P1+PA)
 300   CONTINUE
C     9.8.3 TERMES NECESSAIRES A LA PARTIE HYDROSTATIQUE
        XJ = XU*XLAM*KC/2.D0/(1.D0+XU*XLAM) 
        XHH = M*M/HP*(-2.D0*XJ*DELTAP-2.D0*XJ*KC*DP1+KC*DELTAP
     &               -2.D0*KC*PCRP(1)+KC*SIGPMO
     &               -2.D0*PCRPP*(SIGPMO+KPMAX+KC*DP1))-
     &       2.D0*XK*XV*M**4/HP/HP*(XJ*XM+KC*PCRP(1)*
     &              (3.D0*SIGPMO-2.D0*PCRP(1)+2.D0*KPMAX))
        CT1 = XK0*SIGPMO*M**2*(
     &       XHH/XE*(2.D0*SIGPMO-2.D0*PCRP(1)+KPMAX) +
     &       KC*XLAM-2.D0*XH*XHH/XE*XLAM-2.D0*XJ*XLAM) +
     &       XK0/XK0S*SIGPMO/(P1+PA)
C     9.8.4 VECTEUR INTERMEDIAIRE MULTIPLIE DP1 EN HYDROSTATIQUE
         CALL R8INIR(6,0.D0,KV,1)
         DO 310 K=1,NDIMSI
          KV(K) = 3.D0*XHH/XE*SIGPDV(K)-CT1*KRON(K)/3.D0
 310   CONTINUE
C     9.8.5 MULTIPLICATION DE VV par H(K)-KV(K)
         CALL R8INIR(6,0.D0,HHKV,1)
         DO 320 K=1,NDIMSI
          HHKV(K) = HH(K) - KV(K)
 320   CONTINUE
       CALL R8INIR(6,0.D0,SSH,1)
       CALL PROMAT(VV,6,NDIMSI,NDIMSI,HHKV,6,NDIMSI,1,SSH)       
C     9.8.6 LES TERMES DE L'OPERATEUR TANGENT COHERENT DSIDP1(6)     
       CALL R8INIR(6,0.D0,DSIDP1,1)
       DO 330 K=1,NDIMSI
            DSIDP1(K) = SSH(K)-BIOT*SAT*KRON(K) 
 330   CONTINUE 
       ENDIF
       ENDIF
C     --9.9 CALCUL DE DSIDEP(6,6) CRITERE HYDRIQUE ATTEINT
C     MATRICE QUI RELIE LES CONTRAINTES AUX DEFORMATIONS
C     ----------------------------------------------------
       IF (MATR.EQ.21) THEN
C     9.9.1 -- MATRICE QUI RELIE LES CONTRAINTES AUX DEFORMATIONS
       CALL R8INIR(6*6,0.D0,VH,1)    
       DO 340 K = 1,3
       DO 345 L = 1,3
         VH(K,L) = -1.D0/3.D0+DEUXMU/9.D0/XK0/SIGPMO
         VH(L,K) = VH(K,L)
 345  CONTINUE
 340  CONTINUE
      DO 350 K= 1,NDIMSI
         VH(K,K) = VH(K,K)+1.D0
 350  CONTINUE
       CALL R8INIR(6*6,0.D0,VHH,1)     
        DO 355 K=1,NDIMSI
        DO 360 L=1,NDIMSI
             VHH(K,L) = 1.D0/DEUXMU*VH(K,L)
 360  CONTINUE
 355  CONTINUE
         IF (NDIM.EQ.2) THEN
           VHH(5,5) = 1.D0
           VHH(6,6) = 1.D0
         ENDIF
C     9.9.2-- INVERSE DE LA MATRICE VHH
       CALL R8INIR(6*6,0.D0,VVH,1)
           DO 390 K=1,6
               VVH(K,K)=1.D0
 390  CONTINUE 
       CALL MGAUSS(VHH,VVH,6,6,6,NUL,LOGIC)
C     9.9.3--  LES TERMES DSIDEP L'OPERATEUR TANGENT
       CALL R8INIR(6*6,0.D0,DSIDEP,1)
        DO 395 K = 1,6
        DO 400 L = 1,6
        DSIDEP(K,L) = VVH(K,L)
 400  CONTINUE
 395  CONTINUE         
C     --9.10 CALCUL DE DSIDP1(6) CRITERE HYDRIQUE ATTEINT 
C    -- MATRICE QUI RELIE LES CONTRAINTES A LA SUCCION
C     LES TERMES DE L'OPERATEUR TANGENT COHERENT DSIDP1(6)
C    ------------------------------------------------------
       CALL R8INIR(6,0.D0,KKH,1)
       DO 402 K= 1,3
       KKH(K) = 1.D0
 402   CONTINUE
       DO 403 K= 4,NDIMSI
       KKH(K) = 0.D0
 403   CONTINUE
       CALL R8INIR(6,0.D0,SSHH,1)
       CALL PROMAT(VVH,6,NDIMSI,NDIMSI,KKH,6,NDIMSI,1,SSHH)
       BB = 1.D0/3.D0*(1.D0/XK0S/(P1+PA)+1.D0/XKS/(P1+PA))     
       DO 410 K=1,NDIMSI
            DSIDP1(K) = SSHH(K)*BB-BIOT*SAT*KRON(K)
 410   CONTINUE                    
       ENDIF           
      ENDIF
C ======================================================================
 8000 CONTINUE
C =====================================================================
 9001 FORMAT (A10,2X,A40,2X,A8)
C    FIN ---------------------------------------------------------
      END
