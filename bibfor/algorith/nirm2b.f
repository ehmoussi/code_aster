      SUBROUTINE  NIRM2B (NNO1, NNO2, NPG1, IPOIDS, IVF1, IVF2, IDFDE1,
     &                    GEOM, TYPMOD, IMATE, KUU , KUA , KAA)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 11/01/2011   AUTEUR SFAYOLLE S.FAYOLLE 
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
C RESPONSABLE SFAYOLLE S.FAYOLLE
C TOLE CRS_1404
      IMPLICIT NONE

      INTEGER NNO1, NNO2, NPG1, IMATE
      INTEGER IPOIDS, IVF1, IVF2, IDFDE1

      REAL*8 GEOM(2,NNO1), GONFVD(1,NNO2), DGONVD(1,NNO2)
      REAL*8 KUU(2,9,2,9), KUA(2,9,1,4), KAA(1,4,1,4)

      CHARACTER*8   TYPMOD(*)

C......................................................................
C     BUT:  CALCUL  DES OPTIONS RIGI_MECA_TANG, RAPH_MECA ET FULL_MECA
C           EN HYPO-ELASTICITE AVEC LE MINI-ELEMENT
C......................................................................
C IN  NNO1    : NOMBRE DE NOEUDS DE L'ELEMENT LIES AUX DEPLACEMENTS
C IN  NNO2    : NOMBRE DE NOEUDS DE L'ELEMENT LIES A LA PRESSION
C IN  NPG1    : NOMBRE DE POINTS DE GAUSS
C IN  POIDSG  : POIDS DES POINTS DE GAUSS
C IN  VFF1    : VALEUR  DES FONCTIONS DE FORME LIES AUX DEPLACEMENTS
C IN  VFF2    : VALEUR  DES FONCTIONS DE FORME LIES A LA PRESSION
C                  ET AU GONFLEMENT
C IN  DFDE1   : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
C IN  DFDK1   : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
C IN  GEOM    : COORDONEES DES NOEUDS
C IN  TYPMOD  : TYPE DE MODELISATION
C IN  OPTION  : OPTION DE CALCUL
C IN  IMATE   : MATERIAU CODE
C IN  COMPOR  : COMPORTEMENT
C IN  LGPG    : "LONGUEUR" DES VARIABLES INTERNES POUR 1 POINT DE GAUSS
C               CETTE LONGUEUR EST UN MAJORANT DU NBRE REEL DE VAR. INT.
C IN  CRIT    : CRITERES DE CONVERGENCE LOCAUX
C IN  INSTAM  : INSTANT PRECEDENT
C IN  INSTAP  : INSTANT DE CALCUL
C IN  TM      : TEMPERATURE AUX NOEUDS A L'INSTANT PRECEDENT
C IN  TP      : TEMPERATURE AUX NOEUDS A L'INSTANT DE CALCUL
C IN  TREF    : TEMPERATURE DE REFERENCE
C IN  DEPLM   : DEPLACEMENT A L'INSTANT PRECEDENT
C IN  DDEPL   : INCREMENT DE DEPLACEMENT
C IN  ANGMAS  : LES TROIS ANGLES DU MOT_CLEF MASSIF (AFFE_CARA_ELEM)
C IN  GONFLM  : P ET G  A L'INSTANT PRECEDENT
C IN  DGONFL  : INCREMENT POUR P ET G
C IN  SIGM    : CONTRAINTES A L'INSTANT PRECEDENT
C IN  VIM     : VARIABLES INTERNES A L'INSTANT PRECEDENT
C OUT DFDI    : DERIVEE DES FONCTIONS DE FORME  AU DERNIER PT DE GAUSS
C OUT SIGP    : CONTRAINTES DE CAUCHY (RAPH_MECA ET FULL_MECA)
C OUT VIP     : VARIABLES INTERNES    (RAPH_MECA ET FULL_MECA)
C OUT FINTU   : FORCES INTERNES
C OUT FINTA   : FORCES INTERNES LIEES AUX MULTIPLICATEURS
C OUT KUU     : MATRICE DE RIGIDITE (RIGI_MECA_TANG ET FULL_MECA)
C OUT KUA     : MATRICE DE RIGIDITE TERMES CROISES U - PG
C                                       (RIGI_MECA_TANG ET FULL_MECA)
C OUT KAA     : MATRICE DE RIGIDITE TERME PG (RIGI_MECA_TANG, FULL_MECA)
C......................................................................
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER  ZI
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

      LOGICAL AXI, LTEATT

      INTEGER KPG, N, KL, PQ, I, J, M, NBSIGM, NBSIG

      REAL*8 F(3,3), R, DEF(4,NNO1,2), DEFD(4,9,2), DEFTR(9,2)
      REAL*8 TMP, DSBDEP(6,6), B(4,81)
      REAL*8 POIDS, VFF2, VFFN, VFFM, ALPHA
      REAL*8 RCE(1,3), KBB(2,2), KBP(2,3), KCE(3,3)
      DATA   F/1,0,0,0,1,0,0,0,1/

C-----------------------------------------------------------------------
C - INITIALISATION
      CALL R8INIR(324, 0.D0, KUU, 1)
      CALL R8INIR(72, 0.D0, KUA, 1)
      CALL R8INIR(16, 0.D0, KAA, 1)
      CALL R8INIR(NNO2, 0.D0, GONFVD, 1)
      CALL R8INIR(NNO2, 0.D0, DGONVD, 1)

      AXI   = TYPMOD(1) .EQ. 'AXIS'

      NBSIG = NBSIGM()

C - CALCUL POUR CHAQUE POINT DE GAUSS
      DO 800 KPG = 1,NPG1

C - CALCUL DES ELEMENTS GEOMETRIQUES
C - CALCUL DE DFDI,F,EPS,R(EN AXI) ET POIDS
        CALL BMATMC(KPG,NBSIG,GEOM,IPOIDS,IVF1,IDFDE1,
     +                  NNO1, 0.D0, POIDS, B)

        DO 10 I = 1, 4
          DO 20 J = 1, NNO1
            DO 30 N = 1, 2
              DEF(I,J,N) = B(I,(J-1)*2+N)
  30        CONTINUE
  20      CONTINUE
  10    CONTINUE

C - CALCUL DE LA TRACE ET DEVIATEUR DE B
        DO 70 N = 1,NNO1
          DO 65 I = 1,2
            DEFTR(N,I) =  DEF(1,N,I) + DEF(2,N,I) + DEF(3,N,I)
            DO 60 KL = 1,3
              DEFD(KL,N,I) = DEF(KL,N,I) - DEFTR(N,I)/3.D0
 60         CONTINUE
            DEFD(4,N,I) = DEF(4,N,I)
 65       CONTINUE
 70     CONTINUE

C - APPEL A LA LOI DE COMPORTEMENT
C - CALCUL DE LA MATRICE D'ELASTICITE BULLE
        CALL TANBUL(2, KPG, IMATE, 'ELAS            ', ALPHA, DSBDEP)

C - CALCUL DE LA MATRICE DE CONDENSATION STATIQUE
        IF ( LTEATT(' ','AXIS','OUI') ) THEN
          R = 0.0D0
          DO 75 I=1,NNO1
            R = R + GEOM(1,I)*ZR(IVF1+KPG+I-1)
 75       CONTINUE
        ENDIF

        CALL CALKBB(NNO1, 2, AXI, R, KPG, GEOM, IVF1, F, IPOIDS, IDFDE1,
     &              DSBDEP, KBB)
        CALL CALKBP(NNO2, 2, AXI, R, KPG, GEOM, IVF2, IPOIDS, IDFDE1,
     &              KBP)
        CALL CALKCE(NNO1, 2, KBP, KBB, GONFVD, DGONVD, KCE, RCE)

C - CALCUL DE LA MATRICE DE RIGIDITE
C - TERME K_UU
          DO 105 N=1,NNO1
            DO 104 I=1,2
              DO 103 M=1,NNO1
                DO 102 J=1,2
                  TMP = 0.D0
                  DO 101 KL = 1,4
                    DO 100 PQ = 1,4
                      TMP=TMP+DEFD(KL,N,I)*DSBDEP(KL,PQ)*DEFD(PQ,M,J)
 100                CONTINUE
 101              CONTINUE
                  KUU(I,N,J,M) = KUU(I,N,J,M) + POIDS*TMP
 102            CONTINUE
 103          CONTINUE
 104        CONTINUE
 105      CONTINUE

C - TERME K_UP
          DO 112 N = 1, NNO1
            DO 111 I = 1,2
              DO 110 M = 1, NNO2
                VFF2 = ZR(IVF2-1+M+(KPG-1)*NNO2)
                TMP = DEFTR(N,I)*VFF2
                KUA(I,N,1,M) = KUA(I,N,1,M) + POIDS*TMP
 110          CONTINUE
 111        CONTINUE
 112      CONTINUE

C - TERME K_PP
          DO 145 N = 1,NNO2
            VFFN = ZR(IVF2-1+N+(KPG-1)*NNO2)
            DO 140 M = 1,NNO2
              VFFM = ZR(IVF2-1+M+(KPG-1)*NNO2)
              TMP = VFFN * VFFM*ALPHA
              KAA(1,N,1,M) = KAA(1,N,1,M) - POIDS*TMP - KCE(N,M)
 140        CONTINUE
 145      CONTINUE
 800  CONTINUE
      END
