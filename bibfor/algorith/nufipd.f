      SUBROUTINE NUFIPD(NDIM,NNO1,NNO2,NPG,IW,VFF1,VFF2,IDFF1,
     &                  VU,VP,GEOMI,TYPMOD,OPTION,MATE,COMPOR,
     &                  LGPG,CRIT,INSTM,INSTP,DDLM,DDLD,ANGMAS,SIGM,VIM,
     &                  SIGP,VIP,RESI,RIGI,MINI,VECT,MATR,CODRET)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 18/03/2013   AUTEUR SFAYOLLE S.FAYOLLE 
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
C TOLE CRP_21
C TOLE CRS_1404
C RESPONSABLE SFAYOLLE S.FAYOLLE
      IMPLICIT NONE

      LOGICAL      RESI,RIGI,MINI
      INTEGER      NDIM,NNO1,NNO2,NPG,IW,IDFF1,LGPG
      INTEGER      MATE
      INTEGER      VU(3,27),VP(27)
      INTEGER      CODRET
      REAL*8       VFF1(NNO1,NPG),VFF2(NNO2,NPG)
      REAL*8       INSTM,INSTP
      REAL*8       GEOMI(NDIM,NNO1),DDLM(*),DDLD(*),ANGMAS(*)
      REAL*8       SIGM(2*NDIM+1,NPG),SIGP(2*NDIM+1,NPG)
      REAL*8       VIM(LGPG,NPG),VIP(LGPG,NPG)
      REAL*8       VECT(*),MATR(*)
      REAL*8       CRIT(*)
      CHARACTER*8  TYPMOD(*)
      CHARACTER*16 COMPOR(*),OPTION
C-----------------------------------------------------------------------
C          CALCUL DES FORCES INTERNES POUR LES ELEMENTS
C          INCOMPRESSIBLES POUR LES PETITES DEFORMATIONS
C          3D/D_PLAN/AXIS
C          ROUTINE APPELEE PAR TE0596
C-----------------------------------------------------------------------
C IN  RESI    : CALCUL DES FORCES INTERNES
C IN  RIGI    : CALCUL DE LA MATRICE DE RIGIDITE
C IN  MINI    : STABILISATION BULLE - MINI ELEMENT
C IN  NDIM    : DIMENSION DE L'ESPACE
C IN  NNO1    : NOMBRE DE NOEUDS DE L'ELEMENT LIES AUX DEPLACEMENTS
C IN  NNO2    : NOMBRE DE NOEUDS DE L'ELEMENT LIES A LA PRESSION
C IN  NPG     : NOMBRE DE POINTS DE GAUSS
C IN  IW      : POIDS DES POINTS DE GAUSS
C IN  VFF1    : VALEUR  DES FONCTIONS DE FORME LIES AUX DEPLACEMENTS
C IN  VFF2    : VALEUR  DES FONCTIONS DE FORME LIES A LA PRESSION
C IN  IDFF1   : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
C IN  VU      : TABLEAU DES INDICES DES DDL DE DEPLACEMENTS
C IN  VP      : TABLEAU DES INDICES DES DDL DE PRESSION
C IN  GEOMI   : COORDONEES DES NOEUDS
C IN  TYPMOD  : TYPE DE MODELISATION
C IN  OPTION  : OPTION DE CALCUL
C IN  MATE    : MATERIAU CODE
C IN  COMPOR  : COMPORTEMENT
C IN  LGPG    : "LONGUEUR" DES VARIABLES INTERNES POUR 1 POINT DE GAUSS
C               CETTE LONGUEUR EST UN MAJORANT DU NBRE REEL DE VAR. INT.
C IN  CRIT    : CRITERES DE CONVERGENCE LOCAUX
C IN  INSTM   : INSTANT PRECEDENT
C IN  INSTP   : INSTANT DE CALCUL
C IN  DDLM    : DEGRES DE LIBERTE A L'INSTANT PRECEDENT
C IN  DDLD    : INCREMENT DES DEGRES DE LIBERTE
C IN  ANGMAS  : LES TROIS ANGLES DU MOT_CLEF MASSIF (AFFE_CARA_ELEM)
C IN  SIGM    : CONTRAINTES A L'INSTANT PRECEDENT
C IN  VIM     : VARIABLES INTERNES A L'INSTANT PRECEDENT
C OUT SIGP    : CONTRAINTES DE CAUCHY (RAPH_MECA ET FULL_MECA)
C OUT VIP     : VARIABLES INTERNES    (RAPH_MECA ET FULL_MECA)
C OUT VECT    : FORCES INTERNES
C OUT MATR    : MATRICE DE RIGIDITE (RIGI_MECA_TANG ET FULL_MECA)
C OUT CODRET  : CODE RETOUR
C-----------------------------------------------------------------------

      LOGICAL      AXI,GRAND
      INTEGER      G,NDDL
      INTEGER      IA,NA,SA,IB,NB,SB,JA,JB
      INTEGER      OS,KK
      INTEGER      VUIANA,VPSA
      INTEGER      COD(27)
      REAL*8       RAC2
      REAL*8       DEPLM(3*27),DEPLD(3*27)
      REAL*8       R,W,DFF1(NNO1,NDIM)
      REAL*8       PRESM(27),PRESD(27)
      REAL*8       PM,PD
      REAL*8       FM(3,3),EPSM(6),DEPS(6)
      REAL*8       SIGMA(6),SIGMAM(6),SIGTR
      REAL*8       DSIDEP(6,6)
      REAL*8       DEF(2*NDIM,NNO1,NDIM),DEFTR(NNO1,NDIM),DDIVU,DIVUM
      REAL*8       DDEV(6,6),DEVD(6,6),DDDEV(6,6)
      REAL*8       T1,T2
      REAL*8       IDEV(6,6)
      REAL*8       DDOT,TAMPON(10),RBID
      REAL*8       ALPHA,TREPST
      REAL*8       DSBDEP(2*NDIM,2*NDIM),KBB(NDIM,NDIM),KBP(NDIM,NNO2)
      REAL*8       KCE(NNO2,NNO2),RCE(NNO2)

      PARAMETER    (GRAND = .FALSE.)
      DATA         IDEV / 2.D0,-1.D0,-1.D0, 0.D0, 0.D0, 0.D0,
     &                   -1.D0, 2.D0,-1.D0, 0.D0, 0.D0, 0.D0,
     &                   -1.D0,-1.D0, 2.D0, 0.D0, 0.D0, 0.D0,
     &                    0.D0, 0.D0, 0.D0, 3.D0, 0.D0, 0.D0,
     &                    0.D0, 0.D0, 0.D0, 0.D0, 3.D0, 0.D0,
     &                    0.D0, 0.D0, 0.D0, 0.D0, 0.D0, 3.D0/
C-----------------------------------------------------------------------

C - INITIALISATION
      AXI  = TYPMOD(1).EQ.'AXIS'
      NDDL = NNO1*NDIM + NNO2
      RAC2  = SQRT(2.D0)

C - EXTRACTION DES CHAMPS
      DO 10 NA = 1,NNO1
        DO 11 IA = 1,NDIM
          DEPLM(IA+NDIM*(NA-1)) = DDLM(VU(IA,NA))
          DEPLD(IA+NDIM*(NA-1)) = DDLD(VU(IA,NA))
 11     CONTINUE
 10   CONTINUE

      DO 30 SA = 1,NNO2
        PRESM(SA) = DDLM(VP(SA))
        PRESD(SA) = DDLD(VP(SA))
 30   CONTINUE
      IF (RESI) CALL R8INIR(NDDL,0.D0,VECT,1)
      IF (RIGI) CALL R8INIR(NDDL*(NDDL+1)/2,0.D0,MATR,1)

      CALL R8INIR(36,0.D0,DSIDEP,1)

C - CALCUL POUR CHAQUE POINT DE GAUSS
      DO 1000 G = 1,NPG

C - CALCUL DES DEFORMATIONS
        CALL R8INIR(6,0.D0,EPSM,1)
        CALL R8INIR(6,0.D0,DEPS,1)
        CALL DFDMIP(NDIM,NNO1,AXI,GEOMI,G,IW,VFF1(1,G),IDFF1,R,W,DFF1)
        CALL NMEPSI(NDIM,NNO1,AXI,GRAND,VFF1(1,G),R,DFF1,DEPLM,FM,EPSM)
        CALL NMEPSI(NDIM,NNO1,AXI,GRAND,VFF1(1,G),R,DFF1,DEPLD,FM,DEPS)

C - CALCUL DE LA PRESSION
        PM = DDOT(NNO2,VFF2(1,G),1,PRESM,1)
        PD = DDOT(NNO2,VFF2(1,G),1,PRESD,1)

C - CALCUL DES ELEMENTS GEOMETRIQUES
        DIVUM = EPSM(1) + EPSM(2) + EPSM(3)
        DDIVU = DEPS(1) + DEPS(2) + DEPS(3)

C - CALCUL DE LA MATRICE B EPS_ij=B_ijkl U_kl
C - DEF (XX,YY,ZZ,2/RAC(2)XY,2/RAC(2)XZ,2/RAC(2)YZ)
        IF (NDIM.EQ.2) THEN
          DO 35 NA=1,NNO1
            DO 45 IA=1,NDIM
             DEF(1,NA,IA)= FM(IA,1)*DFF1(NA,1)
             DEF(2,NA,IA)= FM(IA,2)*DFF1(NA,2)
             DEF(3,NA,IA)= 0.D0
             DEF(4,NA,IA)=(FM(IA,1)*DFF1(NA,2)+FM(IA,2)*DFF1(NA,1))/RAC2
 45         CONTINUE
 35       CONTINUE

C - TERME DE CORRECTION (3,3) AXI QUI PORTE EN FAIT SUR LE DDL 1
          IF (AXI) THEN
            DO 47 NA=1,NNO1
              DEF(3,NA,1) = FM(3,3)*VFF1(NA,G)/R
 47         CONTINUE
          END IF
        ELSE
          DO 36 NA=1,NNO1
            DO 46 IA=1,NDIM
             DEF(1,NA,IA)= FM(IA,1)*DFF1(NA,1)
             DEF(2,NA,IA)= FM(IA,2)*DFF1(NA,2)
             DEF(3,NA,IA)= FM(IA,3)*DFF1(NA,3)
             DEF(4,NA,IA)=(FM(IA,1)*DFF1(NA,2)+FM(IA,2)*DFF1(NA,1))/RAC2
             DEF(5,NA,IA)=(FM(IA,1)*DFF1(NA,3)+FM(IA,3)*DFF1(NA,1))/RAC2
             DEF(6,NA,IA)=(FM(IA,2)*DFF1(NA,3)+FM(IA,3)*DFF1(NA,2))/RAC2
 46         CONTINUE
 36       CONTINUE
        ENDIF

C - CALCUL DE TRACE(B)
        DO 50 NA = 1,NNO1
          DO 49 IA = 1,NDIM
            DEFTR(NA,IA) =  DEF(1,NA,IA) + DEF(2,NA,IA) + DEF(3,NA,IA)
 49       CONTINUE
 50     CONTINUE

C - CONTRAINTE EN T- POUR LA LOI DE COMPORTEMENT
        DO 62 IA = 1,3
          SIGMAM(IA) = SIGM(IA,G) + SIGM(2*NDIM+1,G)
 62     CONTINUE
        DO 65 IA = 4,2*NDIM
          SIGMAM(IA) = SIGM(IA,G)*RAC2
 65     CONTINUE

C - APPEL A LA LOI DE COMPORTEMENT
        CALL NMCOMP('RIGI',G,1,NDIM,TYPMOD,MATE,COMPOR,CRIT,INSTM,INSTP,
     &            6,EPSM,DEPS,6,SIGMAM,VIM(1,G),OPTION,ANGMAS,10,TAMPON,
     &              SIGMA,VIP(1,G),36,DSIDEP,1,RBID,COD(G))

        IF (COD(G).EQ.1) THEN
          CODRET = 1
          IF (.NOT. RESI) CALL U2MESS('F','ALGORITH14_75')
          GOTO 9999
        ENDIF

C - CALCUL DE LA MATRICE D'ELASTICITE BULLE
        CALL TANBUL(OPTION,NDIM,G,MATE,COMPOR,RESI,MINI,ALPHA,DSBDEP,
     &              TREPST)

C - CALCUL DE LA MATRICE DE CONDENSATION STATIQUE
        IF (MINI) THEN
          CALL CALKBB(NNO1,NDIM,W,DEF,DSBDEP,KBB)
          CALL CALKBP(NNO2,NDIM,W,DFF1,KBP)
          CALL CALKCE(NNO1,NDIM,KBP,KBB,PRESM,PRESD,KCE,RCE)
        ELSE
          CALL R8INIR(NNO2,0.D0,RCE,1)
          CALL R8INIR(NNO2*NNO2,0.D0,KCE,1)
        ENDIF

C - CALCUL DE LA FORCE INTERIEURE ET DES CONTRAINTES DE CAUCHY
        IF (RESI) THEN
C - CONTRAINTES A L'EQUILIBRE
          SIGTR = SIGMA(1) + SIGMA(2) + SIGMA(3)
          DO 130 IA = 1,3
            SIGMA(IA) = SIGMA(IA) - SIGTR/3.D0 + (PM+PD)
 130      CONTINUE

C - VECTEUR FINT:U
          DO 300 NA = 1,NNO1
            DO 310 IA = 1,NDIM
              KK = VU(IA,NA)
              T1 = DDOT(2*NDIM, SIGMA,1, DEF(1,NA,IA),1)
              VECT(KK) = VECT(KK) + W*T1
 310        CONTINUE
 300      CONTINUE

C - VECTEUR FINT:P
          T2 = (DIVUM+DDIVU-(PM+PD)*ALPHA-TREPST)
          DO 370 SA = 1,NNO2
            KK = VP(SA)
            T1 = VFF2(SA,G)*T2
            VECT(KK) = VECT(KK) + W*T1 - RCE(SA)
 370      CONTINUE

C - STOCKAGE DES CONTRAINTES
          DO 190 IA=1,3
            SIGP(IA,G) = SIGMA(IA)
 190      CONTINUE
           DO 195 IA=4,2*NDIM
            SIGP(IA,G) = SIGMA(IA)/RAC2
 195      CONTINUE
          SIGP(2*NDIM+1,G) = SIGTR/3.D0 - PM - PD
        END IF

C - MATRICE TANGENTE
        IF (RIGI) THEN

          CALL PMAT(6,IDEV/3.D0,DSIDEP,DEVD)
          CALL PMAT(6,DSIDEP,IDEV/3.D0,DDEV)
          CALL PMAT(6,DEVD,IDEV/3.D0,DDDEV)

C - MATRICE SYMETRIQUE
C - TERME K:UX
          DO 400 NA = 1,NNO1
            DO 410 IA = 1,NDIM
              VUIANA = VU(IA,NA)
              OS = (VUIANA-1)*VUIANA/2

C - TERME K:UU      KUU(NDIM,NNO1,NDIM,NNO1)
              DO 420 NB = 1,NNO1
                DO 430 IB = 1,NDIM
                  IF(VU(IB,NB).LE.VUIANA)THEN
                  KK = OS+VU(IB,NB)
                  T1 = 0.D0
                  DO 440 JA = 1,2*NDIM
                    DO 450 JB = 1,2*NDIM
                      T1 = T1 + DEF(JA,NA,IA)*DDDEV(JA,JB)*DEF(JB,NB,IB)
 450                CONTINUE
 440              CONTINUE
                  MATR(KK) = MATR(KK) + W*T1
                  ENDIF
 430            CONTINUE
 420          CONTINUE

C - TERME K:UP      KUP(NDIM,NNO1,NNO2)
              DO 490 SB = 1, NNO2
                IF(VP(SB).LT.VUIANA)THEN
                KK = OS + VP(SB)
                T1 = DEFTR(NA,IA)*VFF2(SB,G)
                MATR(KK) = MATR(KK) + W*T1
                ENDIF
 490          CONTINUE
 410        CONTINUE
 400      CONTINUE

C - TERME K:PX
          DO 600 SA = 1,NNO2
            VPSA = VP(SA)
            OS = (VPSA-1)*VPSA/2

C - TERME K:PU      KPU(NDIM,NNO2,NNO1)
            DO 610 NB = 1,NNO1
              DO 620 IB = 1,NDIM
                IF(VU(IB,NB).LT.VPSA)THEN
                KK = OS + VU(IB,NB)
                T1 = VFF2(SA,G)*DEFTR(NB,IB)
                MATR(KK) = MATR(KK) + W*T1
                ENDIF
 620          CONTINUE
 610        CONTINUE

C - TERME K:PP      KPP(NNO2,NNO2)
            DO 640 SB = 1,NNO2
              IF(VP(SB).LE.VPSA)THEN
              KK = OS + VP(SB)
              T1 = - VFF2(SA,G)*VFF2(SB,G)*ALPHA
              MATR(KK) = MATR(KK) + W*T1 - KCE(SA,SB)
              ENDIF
 640        CONTINUE
 600      CONTINUE
        END IF
 1000 CONTINUE

C - SYNTHESE DES CODES RETOURS
      CALL CODERE(COD,NPG,CODRET)

 9999 CONTINUE
      END
