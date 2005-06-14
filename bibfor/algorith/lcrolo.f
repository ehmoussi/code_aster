      SUBROUTINE LCROLO (NDIM,MATE,OPTION,CARCRI,TM,TP,TREF,
     &                    FM,DF,VIM,VIP,SIGP,DSIGDF,IRET)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 10/05/2005   AUTEUR GJBHHEL E.LORENTZ 
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
C RESPONSABLE ADBHHVV V.CANO

      IMPLICIT NONE
      INTEGER            MATE,IRET,NDIM
      CHARACTER*16       OPTION
      REAL*8             CARCRI(3)
      REAL*8             TM,TP,TREF
      REAL*8             FM(3,3),DF(3,3),VIM(9)
      REAL*8             VIP(9),SIGP(6),DSIGDF(6,3,3)

C......................................................................
C       INTEGRATION DE LA LOI DE ROUSSELIER LOCAL
C   EN GRANDES DEFORMATIONS DE TYPE NOUVELLE FORMULATION DE SIMO-MIEHE
C......................................................................
C IN  MATE    : ADRESSE DU MATERIAU CODE
C IN  OPTION  : OPTION DE CALCUL
C IN  CARCRI  : PARAM7TRES POUR L INTEGRATION DE LA LOI DE COMMPORTEMENT
C                CARCRI(1) = NOMBRE D ITERATIONS
C                CARCRI(3) = PRECISION SUR LA CONVERGENCE
C IN  TM      : TEMPERATURE A L'INSTANT PRECEDENT
C IN  TP      : TEMPERATURE A L'INSTANT DU CALCUL
C IN  TREF    : TEMPERATURE DE REFERENCE
C IN  FM      : GRADIENT DE LA TRANSFORMATION A L INSTANT PRECEDENT
C IN  DF      : INCREMENT DU GRADIENT DE LA TRANSFORMATION
C IN  VIM     : VARIABLES INTERNES A L INSTANT DU CALCUL PRECEDENT
C         VIM(1)   = P (DEFORMATION PLASTIQUE CUMULEE)
C         VIM(2)   = POROSITE
C         VIM(3:8) = DEFORMATION ELASTIQUE EULERIENNE EE = (ID-BE)/2)
C         VIM(9)   = INDICATEUR DE PLASTICITE
C                  = 0 SOLUTION ELASTIQUE
C                  = 1 SOLUTION PLASTIQUE
C                  = 2 SOLUTION PLASTIQUE SINGULIERE
C OUT VIP     : VARIABLES INTERNES A L'INSTANT ACTUEL
C OUT SIGP    : CONTRAINTE A L INSTANT ACTUEL
C OUT DSIGDF  : DERIVEE DE SIGMA PAR RAPPORT A DF
C OUT IRET    : CODE RETOUR SUR L INTEGRATION DE LA LDC
C               SI LA FONCTION FONC = D*POROM*EXP(-K*TRETR/SIG1)
C               EST TROP GRANDE OU TROP PETITE ON REDECOUPE GLOBALEMENT
C               LE PAS DE TEMPS
C
C          ATTENTION SIGP ET DSIGDF SONT RANGES DANS
C          L'ORDRE :  XX,YY,ZZ,XY,XZ,YZ (SANS RACINE DE 2)
C ----------------------------------------------------------------------
C  COMMON SIMO - MIEHE

      INTEGER IND1(6),IND2(6)
      REAL*8  KR(6),RAC2,RC(6)
      REAL*8  LAMBDA,MU,DEUXMU,UNK,TROISK,COTHER
      REAL*8  JM,DJ,JP,DJDF(3,3)
      REAL*8  BEM(6),ETR(6),DVETR(6),EQETR,TRETR,DETRDF(6,3,3)
      REAL*8  SIGMA(6),DSIGDE(6,6),DSIGDJ(6)
      COMMON /LCSMC/
     &          IND1,IND2,KR,RAC2,RC,
     &          LAMBDA,MU,DEUXMU,UNK,TROISK,COTHER,
     &          JM,DJ,JP,DJDF,
     &          BEM,ETR,DVETR,EQETR,TRETR,DETRDF,
     &          SIGMA,DSIGDE,DSIGDJ
C ----------------------------------------------------------------------
C  COMMON LOI DE COMPORTEMENT ROUSSELIER

      INTEGER ITEMAX, JPROLP, JVALEP, NBVALP
      REAL*8  PREC,YOUNG,NU,ALPHA,SIGY,SIG1,ROUSD,F0,FCR,ACCE
      REAL*8  PM,RPM,FONC,FCD,DFCDDJ
      COMMON /LCROU/ PREC,YOUNG,NU,ALPHA,SIGY,SIG1,ROUSD,F0,FCR,ACCE,
     &               PM,RPM,FONC,FCD,DFCDDJ,
     &               ITEMAX, JPROLP, JVALEP, NBVALP
C ----------------------------------------------------------------------
      LOGICAL RESI,RIGI,ELAS
      INTEGER IJ,INDICE
      REAL*8  INFINI,PETIT
      REAL*8  POROM,PORO,TEMP,EM(6),EP(6)
      REAL*8  Y,YM,X,SEUIL,DSEUIL,S,DP
      REAL*8  LCROY1, LCROY2, LCROYI, R8GAEM, R8PREM
C ----------------------------------------------------------------------

      INTEGER K,L

C 1 - INITIALISATION

C    DONNEES DE CONTROLE DE L'ALGORITHME
      INFINI = R8GAEM()
      PETIT  = R8PREM()
      ITEMAX = NINT(CARCRI(1))
      PREC   = CARCRI(3)
      RESI   = OPTION(1:4).EQ.'RAPH' .OR. OPTION(1:4).EQ.'FULL'
      RIGI   = OPTION(1:4).EQ.'RIGI' .OR. OPTION(1:4).EQ.'FULL'
      ELAS   = OPTION(11:14).EQ.'ELAS'

C    LECTURE DES VARIABLES INTERNES
      PM     = VIM(1)
      POROM  = VIM(2)
      CALL DCOPY(6,VIM(3),1,EM,1)

C    INITIALISATION SPECIFIQUE A RIGI_MECA_*
      IF (RESI) THEN
        TEMP   = TP
      ELSE
        TEMP   = TM
        DP     = 0.D0
        INDICE = VIM(9)
        CALL DCOPY(6,EM,1,EP,1)
      END IF

C    CARACTERISTIQUES MATERIAU
      CALL LCROMA(MATE, TEMP)

C    INITIALISATION DE L'OBJET COMMUN A SIMO-MIEHE
      CALL LCSMIN(YOUNG,NU,ALPHA,TEMP,TREF)



C 2 - CALCUL DES ELEMENTS CINEMATIQUES

      CALL LCSMCI(FM,DF,EM)



C 3 - CALCUL DE LA POROSITE ET TESTS ASSOCIES

      POROM  = MAX(F0,POROM)
      PORO   = POROM
      FCD    = ROUSD*PORO
      DFCDDJ = 0.D0

C ON ACTIVERA CETTE FONCTIONNALITÉ ULTERIEUREMENT
C QUAND ON CORRIGERA LA DIRECTION D'ECOULEMENT
C EN ATTENDANT : LE MODELE RESTE A POROSITE EXPLICITE
C
C C    POROSITE FONCTION DE J
C       PORO = 1 - (1-F0)/JP
C       IF (PORO .GT. F0) THEN
C         DFCDDJ = ROUSD*(1-F0)/JP**2
C       ELSE
C         PORO   = F0
C         DFCDDJ = 0
C       END IF
C       FCD = ROUSD*PORO


      IF ((UNK*ABS(TRETR)/SIG1).GE.500.D0) THEN
        IRET = 1
        GOTO 9999
      ENDIF
      FONC=ROUSD*PORO*EXP(-UNK*TRETR/SIG1)*EXP(-COTHER/SIG1)
      IF ((FONC.GE.INFINI).OR.(FONC.LE.PETIT)) THEN
        IRET = 1
        GOTO 9999
      ENDIF



C 4 - INTEGRATION DE LA LOI DE COMPORTEMENT
C     PAR METHODE DE NEWTON AVEC BORNES CONTROLEES ET DICHOTOMIE
C  RESOLUTION DES EQATIONS:
C  - SI SEUIL(0)<0 => LA SOLUTION EST ELASTIQUE SINON
C  - SI S(0)>0     => LA SOLUTION EST PLASTIQUE ET REGULIERE
C                     ON RESOUD SEUIL(Y)=0
C  - SI S(0)<0     => ON RESOUD S(YS)=0
C                     YS EST SOLUTION SINGULIERE SI DP>2*EQ(DVE-DVETR)/3
C  - SINON ON RESOUD SEUIL(Y)=0 POUR Y>YS
C  AVEC  SEUIL(Y)= 2*MU*EQETR-S(Y)-3*MU*DP(Y)
C        Y       = K*X/SIG1
C        X       = TRE-TRETR
C        DP      = (Y*SIG1/K)*EXP(Y)/FONC
C        S(Y)    = -SIG1*FONC*EXP(-Y)+R(PM+DP)


      IF(RESI) THEN


C 4.1 - EXAMEN DE LA SOLUTION ELASTIQUE (Y=0)
C       LCROFG = CALCUL DU SEUIL ET DE SA DERIVEE
C                IN : Y - OUT : DP,S,SEUIL,DSEUIL

        Y = 0
        CALL LCROFG (Y, DP, S, SEUIL, DSEUIL)
        IF (SEUIL.LE.0.D0) THEN
          INDICE=0
          GOTO 600
        ENDIF


C 4.2 - RESOLUTION SEUIL(Y)=0 QUAND S(0)>0
C       CALCUL DE Y PUIS DU DP CORRESPONDANT

        IF (S .GT. 0) THEN
          Y = LCROY1()
          CALL LCROFG (Y, DP, S, SEUIL, DSEUIL)
          INDICE = 1
          GOTO 600
        END IF


C 4.3 - EXAMEN DE LA SOLUTION SINGULIERE ( S(0)<0 )
C 4.3.1 - RESOLUTION S(Y)=0
C         CALCUL DE Y PUIS DU DP CORRESPONDANT

        Y = LCROYI()
        CALL LCROFG (Y, DP, S, SEUIL, DSEUIL)


C 4.3.2 - CONDITION POUR SOLUTION SINGULIERE

        IF ( 2*EQETR/3.D0-DP .LE. 0 ) THEN
          INDICE=2
          GOTO 600
        END IF
        YM = Y


C 4.4 - RESOLUTION SEUIL(Y)=0 QUAND S(0)<0 : ON A S(YM)=0
C       CALCUL DE Y PUIS DU DP CORRESPONDANT

        Y = LCROY2(YM)
        CALL LCROFG (Y, DP, S, SEUIL, DSEUIL)
        INDICE=1

 600    CONTINUE
        X = SIG1*Y/UNK


C 4.5 - CALCUL DE LA DEFORMATION ELASTIQUE

        IF (INDICE.EQ.0) THEN
          CALL DCOPY(6,ETR,1,EP,1)
        ELSE
          DO 55 IJ = 1,6
            EP(IJ) = (X+TRETR)/3.D0*KR(IJ)
 55       CONTINUE
          IF (INDICE.EQ.1 .AND. EQETR.GT.PETIT) THEN
            DO 60 IJ=1,6
              EP(IJ) = EP(IJ) + DVETR(IJ)*(1.D0-3.D0*DP/(2.D0*EQETR))
 60         CONTINUE
          END IF
        END IF

C FIN DE LA RESOLUTION



C 5 - STOCKAGE DES VARIABLES INTERNES EN T+

        VIP(1) = PM+DP
        VIP(2) = 1.D0-(1.D0-PORO)*EXP(-X)
        IF (VIP(2).GE.FCR) THEN
          VIP(2) = 1.D0-(1.D0-PORO)*EXP(-ACCE*X)
        ENDIF
        CALL DCOPY(6,EP,1,VIP(3),1)
        VIP(9) = INDICE



C 6 - CALCUL ET STOCKAGE DES CONTRAINTES

        CALL LCSMCO(EP)
        DO 100 IJ = 1,2*NDIM
          SIGP(IJ) = SIGMA(IJ)/RC(IJ)
 100    CONTINUE


      ENDIF



C 8 - CALCUL DE LA MATRICE TANGENTE

      IF(RIGI) THEN

C      SI ON FORCE A UTILISER LA MATRICE DE DECHARGE
        IF (ELAS) INDICE = 0

C      A TERME, ON POURRA S'APPUYER SUR SIGM ET INITIALISER SM AU DEBUT
        IF (.NOT. RESI) CALL LCSMCO(EP)

C      GRANDEURS DERIVEES COMMUNES A SIMO-MIEHE
        CALL LCSMTG(DF,EP)

C      DERIVATIONS SPECIFIQUES A LA LOI DE ROUSSELIER
        CALL LCROTG (INDICE,DP,EP,DSIGDF)

C      STOCKAGE SANS LE RACINE DE 2
        DO 200 IJ = 4,6
          CALL DSCAL(9,1/RAC2,DSIGDF(IJ,1,1),6)
 200    CONTINUE

      ENDIF



 9999 CONTINUE
      END
