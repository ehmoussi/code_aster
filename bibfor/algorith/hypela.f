      SUBROUTINE HYPELA(NDIM,TYPMOD,IMATE,COMPOR,CRIT,
     &                  TEMP,EPS,
     &                  SIG,DSIDEP,CODRET)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 14/02/2006   AUTEUR MABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 2005 UCBL LYON1 - T. BARANGER     WWW.CODE-ASTER.ORG
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
      IMPLICIT NONE
      INTEGER      NDIM
      CHARACTER*8  TYPMOD(*)      
      INTEGER      IMATE
      CHARACTER*16 COMPOR(*)
      REAL*8       CRIT(3)
      REAL*8       TEMP
      REAL*8       EPS(6)
      REAL*8       SIG(6)
      REAL*8       DSIDEP(6,6)    
      INTEGER      CODRET     
C
C-----------------------------------------------------------------------
C
C     LOI DE COMPORTEMENT HYPERELASTIQUE
C     REALISE LA LOI DE SIGNORINI HYPERELASTICITE
C         C10 (I1-3) + C01 (I2-3)+ C20 (I1-3)^2 + K/2(J-1)�
C     POUR LES ELEMENTS ISOPARAMETRIQUES 3D, CP, et DP
C
C IN  NDIM    : DIMENSION DE L'ESPACE
C IN  TYPMOD  : TYPE DE MODELISATION
C IN  IMATE   : NATURE DU MATERIAU
C IN  COMPOR  : COMPORTEMENT  (1) = TYPE DE RELATION COMPORTEMENT
C                             (2) = NB VARIABLES INTERNES / PG
C                             (3) = HYPOTHESE SUR LES DEFORMATIONS
C                             (4) = COMP_ELAS (OU COMP_INCR)
C IN  CRIT    : CRITERES DE CONVERGENCE LOCAUX
C                             (1) = NB ITERATIONS MAXI A CONVERGENCE
C                                   (ITER_INTE_MAXI == ITECREL)
C                             (2) = TYPE DE JACOBIEN A T+DT
C                                   (TYPE_MATR_COMP == MACOMP)
C                                   0 = EN VITESSE     >SYMETRIQUE
C                                   1 = EN INCREMENTAL >NON-SYMETRIQUE
C                             (3) = VALEUR TOLERANCE DE CONVERGENCE
C                                    (RESI_INTE_RELA == RESCREL)
C IN  TEMP    : TEMPERATURE.
C IN  EPS     : DEFORMATION (SI C_PLAN EPS(3) EST EN FAIT CALCULE)
C OUT SIG     : CONTRAINTES
C OUT DSIDEP  : MATRICE TANGENTE
C OUT CODRET  : CODE RETOUR CONVERGENCE COMPORTEMENT
C-----------------------------------------------------------------------
C    
      INTEGER     I,J,L,M
      REAL*8      C11,C22,C12,C33,C13,C23,CV(6,6),CISO(6,6)
      REAL*8      C10,C01,C20,K,SISO(6),SV(6)
C 
C-----------------------------------------------------------------------
C      
C      
C --- INITIALISATION DE LA RIGIDITE TANGENTE
C
      DO 2 M=1,2*NDIM
        DO 3 L=1,2*NDIM
          DSIDEP(M,L) = 0.D0
 3      CONTINUE
 2    CONTINUE      
C
C --- LECTURE DES CARACTERISTIQUES ELASTIQUES
C       
      IF ((COMPOR(1)(1:10).EQ. 'ELAS_HYPER')) THEN
        CALL HYPMAT(IMATE,TEMP,
     &              C10,C01,C20,K)
      ELSE
        CALL UTMESS('F','HYPELA','NO MATERIAL DATA FOR HYPERELASTIC')
      ENDIF 
C
C --- A PRIORI ON A CONVERGE
C
      CODRET = 0 
C
C --- CALCUL CONTRAINTES ET MATRICE TANGENTE
C 
      IF (TYPMOD(1) .EQ. '3D'.OR.TYPMOD(1) .EQ. '3D_SI') THEN
C --- CALCUL DES ELONGATIONS      
        C11 = 2.D0*EPS(1)+1.D0
        C12 = 2.D0*EPS(4)
        C22 = 2.D0*EPS(2)+1.D0
        C33 = 2.D0*EPS(3)+1.D0
        C13 = 2.D0*EPS(5)
        C23 = 2.D0*EPS(6)
C --- CALCUL DES CONTRAINTES (ISOTROPIQUES PUIS VOLUMIQUES)     
        CALL HYP3CI(C11,C22,C33,C12,C13,C23,
     &              C10,C01,C20,
     &              SISO)
        CALL HYP3CV(C11,C22,C33,C12,C13,C23,
     &              K,
     &              SV)
C --- CALCUL DE LA MATRICE TANGENTE (ISOTROPIQUE PUIS VOLUMIQUE)
        CALL HYP3DI(C11,C22,C33,C12,C13,C23,
     &              C10,C01,C20,
     &              CISO)
        CALL HYP3DV(C11,C22,C33,C12,C13,C23,
     &              K,
     &              CV)
C --- ASSEMBLAGE VOLUMIQUE/ISOTROPIQUE  
        DO 40 I=1,6
          SIG(I)=SISO(I)+SV(I)
          DO 30 J=1,6
            DSIDEP(I,J) = CISO(I,J)+CV(I,J)
 30       CONTINUE
 40     CONTINUE
      ELSE IF (TYPMOD(1)(1:6) .EQ. 'C_PLAN') THEN
C --- CALCUL DES ELONGATIONS       
        C11 = 2.D0*EPS(1)+1.D0
        C12 = 2.D0*EPS(4)
        C22 = 2*EPS(2)+1.D0
        C33 = 1.D0
C --- CALCUL DES CONTRAINTES    
        CALL HYPCPC(C11,C22,C33,C12,
     &              K,C10,C01,C20,INT(CRIT(1)),CRIT(3),
     &              SIG,CODRET)
C --- CALCUL DE LA MATRICE TANGENTE     
        CALL HYPCPD(C11,C22,C33,C12,
     &              K,C10,C01,C20,
     &              DSIDEP)
        DO 130 K=1,2*NDIM
          IF (K.EQ.3) GOTO 130
          DO 140 L=1,2*NDIM
            IF (L.EQ.3) GO TO 140
              DSIDEP(K,L )= DSIDEP(K,L) -
     &                    1.D0/DSIDEP(3,3)*DSIDEP(K,3)*DSIDEP(3,L)
 140      CONTINUE
 130    CONTINUE        
      ELSE IF (TYPMOD(1)(1:6).EQ.'D_PLAN') THEN
C --- CALCUL DES ELONGATIONS      
        C11 = 2.D0*EPS(1)+1.D0
        C12 = 2.D0*EPS(4)
        C22 = 2.D0*EPS(2)+1.D0
C --- CALCUL DES CONTRAINTES    
        CALL HYPDPC(C11,C22,C12,
     &              K,C10,C01,C20,
     &              SIG)
C --- CALCUL DE LA MATRICE TANGENTE             
        CALL HYPDPD(C11,C22,C12,
     &              K,C10,C01,C20,
     &              DSIDEP)
      ELSE      
        CALL UTMESS('F','HYPELA',
     &              'MODEL NOT SUPPORTED FOR HYPERELASTIC MATERIAL')
      ENDIF
      
      
      END
