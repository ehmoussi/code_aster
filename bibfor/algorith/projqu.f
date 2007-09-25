      SUBROUTINE PROJQU(MATYP ,NDIM  ,PROJ  ,MOYEN ,
     &                  ENORM ,MNORM ,TOLEIN,TOLEOU,
     &                  COORDA,COORDB,COORDC,COORDD,
     &                  COORDP,COORDM,LAMBDA,DEBORD,
     &                  ITRIA ,NOEUD ,ARETE ,DIAG)
C
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 24/09/2007   AUTEUR ABBAS M.ABBAS 
C TOLE CRP_21
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*4 MATYP
      INTEGER     NDIM
      REAL*8      COORDA(3)
      REAL*8      COORDB(3)
      REAL*8      COORDC(3)
      REAL*8      COORDD(3)
      REAL*8      COORDP(3)
      INTEGER     PROJ
      INTEGER     MOYEN
      REAL*8      TOLEIN
      REAL*8      TOLEOU
      REAL*8      ENORM(3),MNORM(3)
      REAL*8      COORDM(3),LAMBDA(3)
      REAL*8      DEBORD
      INTEGER     ARETE(4),NOEUD(4),DIAG(2) 
      INTEGER     ITRIA     
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODES DISCRETES - APPARIEMENT - MAIT/ESCL - QUA)
C
C PROJECTION D'UN NOEUD ESCLAVE SUR UN QUADRANGLE
C ON DECOUPE EN QUATRE TRIANGLES
C
C ----------------------------------------------------------------------
C
C
C IN  MATYP  : TYPE DE MAILLE (QUAD4 , QUAD8 , QUAD9 )
C IN  NDIM   : DIMENSION DU PB
C IN  COORDA : COORDONNEES DU SOMMET A DU QUADRANGLE
C IN  COORDB : COORDONNEES DU SOMMET B DU QUADRANGLE
C IN  COORDC : COORDONNEES DU SOMMET C DU QUADRANGLE
C IN  COORDD : COORDONNEES DU SOMMET D DU QUADRANGLE
C IN  COORDP : COORDONNEES DU NOEUD ESCLAVE P
C IN  PROJ   : PROJECTION LINEAIRE (1) OU QUADRATIQUE (2) SUR LA MAILLE
C              OU PAS DE NOUVELLE PROJECTION (0)
C IN  MOYEN  : NORMALES D'APPARIEMENT
C               0 MAIT
C               1 MAIT_ESCL
C IN  TOLEIN : TOLERANCE <IN> POUR LA PROJECTION GEOMETRIQUE
C               ( SUR ARETE OU NOEUD )
C IN  TOLEOU : TOLERANCE POUR DETECTION PROJECTION EN DEHORS
C              MAILLE MAITRE
C IN  ENORM  : NORMALE AU NOEUD ESCLAVE
C OUT MNORM  : NORMALE A LA MAILLE MAITRE
C OUT COORDM : COORDONNEES DE LA "PROJECTION" M
C OUT LAMBDA : COORDONNEES PARAMETRIQUES DE LA "PROJECTION" M APRES
C                RABATTEMENT DANS LA MAILLE SI ON DEPASSE
C OUT DEBORD : PROJECTION HORS DE LA MAILLE
C              >0 : PROJECTION HORS DE LA MAILLE
C              <0 : PROJECTION SUR LA MAILLE
C OUT ARETE  : DETECTION DE PROJECTION SUR ARETE
C                 (1: SUR L'ARETE, 0: NON)
C               ARETE(1)   : SEGMENT AB
C               ARETE(2)   : SEGMENT BC
C               ARETE(3)   : SEGMENT CD
C               ARETE(3)   : SEGMENT DA
C OUT NOEUD  : DETECTION DE PROJECTION SUR NOEUD 
C                 (1: SUR LE NOEUD, 0: NON)
C               NOEUD(1)   : NOEUD A
C               NOEUD(2)   : NOEUD B
C               NOEUD(3)   : NOEUD C
C               NOEUD(4)   : NOEUD D
C OUT DIAG   : DETECTION DE PROJECTION SUR DIAGONALE
C                 (1: SUR LA DIAG, 0: NON)
C               DIAG(1)    : SEGMENT AC
C               DIAG(2)    : SEGMENT BD
C OUT ITRIA  : TRIANGLE LE PLUS PROCHE DU NOEUD ESCLAVE
C               TRIANGLE(1): A,B,C
C               TRIANGLE(2): A,C,D
C               TRIANGLE(3): A,B,D
C               TRIANGLE(4): B,C,D
C
C ----------------------------------------------------------------------
C
      INTEGER      K
      REAL*8       DDOT,KSI1,KSI2,KSI3
      REAL*8       AM(3),AB(3),BC(3),AD(3),DC(3)
      REAL*8       LAB,LBC,LAD,LDC
      REAL*8       DEBOR(4)
      REAL*8       COORM1(3),COORM2(3),COORM3(3),COORM4(3)
      REAL*8       LAMBD1(3),LAMBD2(3),LAMBD3(3),LAMBD4(3)
      REAL*8       COORD1(3),COORD2(3),COORD3(3)
      REAL*8       OUTSID(2)
      INTEGER      ARETT1(3),ARETT2(3),ARETT3(3),ARETT4(3)
      INTEGER      NOEUT1(3),NOEUT2(3),NOEUT3(3),NOEUT4(3)
      INTEGER      OUTTRI(4)
      REAL*8       JEUPMJ(4)
C
C ----------------------------------------------------------------------
C
C
C --- VERIFICATION TYPE PROJECTION
C
      IF (PROJ.EQ.2) THEN
        CALL U2MESS('F','CONTACT_14')
      END IF  
C
C --- INITIALISATIONS
C
      DEBORD    = -1.D0
      OUTSID(1) = -1.D0
      OUTSID(2) = -1.D0
      DO 1 K = 1,4
        OUTTRI(K) = 0
   1  CONTINUE 
      ITRIA      = 0    
C
C --- PROJECTION SUR LES 4 TRIANGLES
C
      CALL PROJTT(PROJ  ,MOYEN ,ENORM ,TOLEIN,
     &            COORDA,COORDB,COORDC,COORDP,COORM1,
     &            JEUPMJ(1),LAMBD1,ARETT1,NOEUT1,DEBOR(1))
C
      CALL PROJTT(PROJ  ,MOYEN ,ENORM ,TOLEIN,
     &            COORDA,COORDC,COORDD,COORDP,COORM2,
     &            JEUPMJ(2),LAMBD2,ARETT2,NOEUT2,DEBOR(2))     
C
      CALL PROJTT(PROJ  ,MOYEN ,ENORM ,TOLEIN,
     &            COORDA,COORDB,COORDD,COORDP,COORM3,
     &            JEUPMJ(3),LAMBD3,ARETT3,NOEUT3,DEBOR(3)) 
C
      CALL PROJTT(PROJ  ,MOYEN ,ENORM ,TOLEIN,
     &            COORDB,COORDC,COORDD,COORDP,COORM4,
     &            JEUPMJ(4),LAMBD4,ARETT4,NOEUT4,DEBOR(4))   
C
C --- DEBORDE-T-ON DE LA MAILLE SUR LES TRIANGLES ?
C
      DO 4 K = 1,4
        IF (DEBOR(K).GT.0.D0) THEN
          IF (TOLEOU.GT.0.D0) THEN
            IF (DEBOR(K).GT.TOLEOU) THEN
              OUTTRI(K) = 1
            ENDIF
          ENDIF
        ENDIF
4     CONTINUE   
C
C --- SE PROJETE-T-ON SUR LES PSEUDO-DIAGONALES ?
C
      CALL PROJQD(ARETT1,ARETT2,ARETT3,ARETT4,DIAG)  
C
C --- CHOIX DU TRIANGLE
C
      CALL PROJQC(DIAG,JEUPMJ,ITRIA)
C
C --- SI ON PROJETTE "EN DEHORS" DU TRIANGLE
C --- ET SI ON NE PROJETTE PAS SUR LA DIAGONALE -> TEST DE DEBORDEMENT
C
      IF (OUTTRI(ITRIA).EQ.1) THEN
        IF ((ITRIA.EQ.1).OR.(ITRIA.EQ.2)) THEN
          IF (DIAG(1).EQ.0) THEN
            OUTSID(1) = DEBOR(ITRIA)
            OUTSID(2) = DEBOR(ITRIA)
          ELSE
            OUTSID(1) = -1.D0
            OUTSID(2) = -1.D0
          ENDIF
        ELSE
          IF (DIAG(2).EQ.0) THEN
            OUTSID(1) = DEBOR(ITRIA)
            OUTSID(2) = DEBOR(ITRIA)
          ELSE
            OUTSID(1) = -1.D0
            OUTSID(2) = -1.D0
          ENDIF
        ENDIF
      ELSE
        OUTSID(1) = -1.D0
        OUTSID(2) = -1.D0
      ENDIF   
C
C --- CHOIX DES COORDONNEES CARTESIENNES DE M ("PROJECTION" DE P)
C
      IF (ITRIA.EQ.1) THEN
        COORDM(1) = COORM1(1)
        COORDM(2) = COORM1(2)
        COORDM(3) = COORM1(3)
      ELSE IF (ITRIA.EQ.2) THEN
        COORDM(1) = COORM2(1)
        COORDM(2) = COORM2(2)
        COORDM(3) = COORM2(3)
      ELSE IF (ITRIA.EQ.3) THEN
        COORDM(1) = COORM3(1)
        COORDM(2) = COORM3(2)
        COORDM(3) = COORM3(3)
      ELSE IF (ITRIA.EQ.4) THEN
        COORDM(1) = COORM4(1)
        COORDM(2) = COORM4(2)
        COORDM(3) = COORM4(3)
      ELSE
        CALL ASSERT(.FALSE.) 
      ENDIF      
C
C --- CALCUL DES COORDONNEES PARAMETRIQUES KSI1, KSI2 ET KSI3 DE M 
C --- DANS ABCD
C
      IF ((MATYP.EQ.'QUA4').OR.(PROJ.EQ.1)) THEN
        IF (ITRIA.EQ.1) THEN
          KSI1 = LAMBD1(1)
          KSI2 = LAMBD1(2)
          KSI3 = LAMBD1(3)
        ELSE IF (ITRIA.EQ.2) THEN
          KSI1 = LAMBD2(1)
          KSI2 = LAMBD2(2)
          KSI3 = LAMBD2(3)
        ELSE IF (ITRIA.EQ.3) THEN
          KSI1 = LAMBD3(1)
          KSI2 = LAMBD3(2)
          KSI3 = LAMBD3(3)
        ELSE IF (ITRIA.EQ.4) THEN
          KSI1 = LAMBD4(1)
          KSI2 = LAMBD4(2)
          KSI3 = LAMBD4(3)
        ELSE
          CALL ASSERT(.FALSE.) 
        ENDIF      
      ELSE IF ((MATYP.EQ.'QUA8').AND.(PROJ.EQ.2)) THEN
        DO 100 K = 1, NDIM
          AM(K) = COORDM(K) - COORDA(K)
          AB(K) = COORDB(K) - COORDA(K)
          BC(K) = COORDC(K) - COORDB(K)
          DC(K) = COORDC(K) - COORDD(K)
          AD(K) = COORDD(K) - COORDA(K)          
 100    CONTINUE    
        LAB  = DDOT(NDIM,AB,1,AB,1)
        LBC  = DDOT(NDIM,BC,1,BC,1)
        LDC  = DDOT(NDIM,DC,1,DC,1)
        LAD  = DDOT(NDIM,AD,1,AD,1) 
        KSI3 = 0.D0   
        IF (ITRIA.EQ.1) THEN
          KSI1 = DDOT(NDIM,AM,1,AB,1) 
          KSI1 = KSI1 / LAB
          KSI2 = DDOT(NDIM,AM,1,BC,1)
          KSI2 = KSI2 / LBC
        ELSE IF (ITRIA.EQ.2) THEN
          KSI1 = DDOT(NDIM,AM,1,DC,1)     
          KSI1 = KSI1 / LDC
          KSI2 = DDOT(NDIM,AM,1,AD,1)
          KSI2 = KSI2 / LAD
        ELSE IF (ITRIA.EQ.3) THEN
          KSI1 = DDOT(NDIM,AM,1,AB,1)
          KSI1 = KSI1 / LAB
          KSI2 = DDOT(NDIM,AM,1,AD,1)
          KSI2 = KSI2 / LAD
        ELSE IF (ITRIA.EQ.4) THEN
          KSI1 = DDOT(NDIM,AM,1,DC,1)
          KSI1 = KSI1 / LDC
          KSI2 = DDOT(NDIM,AM,1,BC,1)
          KSI2 = KSI2 / LBC
        ELSE
          CALL ASSERT(.FALSE.)           
        ENDIF
C      
C --- RABATTEMENT DE LA PROJECTION SUR LA MAILLE (ARETE)
C
        IF (KSI1.LT.0.0D0) THEN
          OUTSID(1) = ABS(KSI1)
          KSI1 = 0.0D0
        ENDIF
        IF (KSI1.GT.1.0D0) THEN
          OUTSID(1) = 1-KSI1
          KSI1 = 1.0D0
        ENDIF
        IF (KSI2.LT.0.0D0) THEN
          OUTSID(2) = ABS(KSI2)
          KSI2 = 0.0D0
        ENDIF
        IF (KSI2.GT.1.0D0) THEN
          OUTSID(2) = 1-KSI2
          KSI2 = 1.0D0
        ENDIF      
      ENDIF
C
C --- SAUVEGARDE DES COORDONNEES PARAMETRIQUES
C 
      LAMBDA(1) = KSI1
      LAMBDA(2) = KSI2
      LAMBDA(3) = KSI3                
C
C --- PROJECTION HORS DE LA MAILLE ?
C --- SI OUI: DEBORD EST LA VALEUR DE DEBORDEMENT
C
      IF ((OUTSID(1).GT.0.D0).OR.(OUTSID(2).GT.0.D0)) THEN
        DEBORD = MAX(OUTSID(1),OUTSID(2))
      ENDIF
C      
C --- VERIFICATIONS DES PROJECTIONS SUR ARETES ET NOEUDS
C
       CALL PRDIQU(ITRIA,
     &             ARETT1,NOEUT1,ARETT2,NOEUT2,
     &             ARETT3,NOEUT3,ARETT4,NOEUT4,
     &             ARETE ,NOEUD)     
C
C --- RECUPERATION DE LA BONNE NORMALE MAITRE SUIVANT TRIANGLE ACTIF
C
      IF (ITRIA.EQ.1) THEN
        CALL DCOPY(3,COORDA,1,COORD1,1)
        CALL DCOPY(3,COORDB,1,COORD2,1)
        CALL DCOPY(3,COORDC,1,COORD3,1)       
      ELSE IF (ITRIA.EQ.2) THEN
        CALL DCOPY(3,COORDA,1,COORD1,1)
        CALL DCOPY(3,COORDC,1,COORD2,1)
        CALL DCOPY(3,COORDD,1,COORD3,1) 
      ELSE IF (ITRIA.EQ.3) THEN
        CALL DCOPY(3,COORDA,1,COORD1,1)
        CALL DCOPY(3,COORDB,1,COORD2,1)
        CALL DCOPY(3,COORDD,1,COORD3,1) 
      ELSE IF (ITRIA.EQ.4) THEN
        CALL DCOPY(3,COORDB,1,COORD1,1)
        CALL DCOPY(3,COORDC,1,COORD2,1)
        CALL DCOPY(3,COORDD,1,COORD3,1) 
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF  

      
      CALL CFNOTR(COORD1,COORD2,COORD3,MNORM )    
     
      END
