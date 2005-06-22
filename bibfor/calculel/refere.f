      SUBROUTINE REFERE(M,NO,DIME,TYPEMA,PREC,IMAX,IFORM,M0,IRET,F1)  

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 22/06/2005   AUTEUR REZETTE C.REZETTE 
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
C A_UTIL
C ----------------------------------------------------------------------
C          COORDONNEES D'UN POINT DANS LA MAILLE DE REFERENCE 
C ----------------------------------------------------------------------
C VARIABLES D'ENTREE
C REAL*8       M(DIME)    : POINT (X,Y,[Z])
C REAL*8       NO(DIME,*) : COORDONNEES DES NOEUDS DE LA MAILLE
C INTEGER      DIME       : DIMENSION DE L'ESPACE
C CHARACTER*8  TYPEMA     : TYPE DE LA MAILLE
C REAL*8       PREC       : PRECISION SUR LA POSITION DU POINT
C INTEGER      IMAX       : NOMBRE D'ITERATIONS MAXIMAL
C LOGICAL      IFORM      : .TRUE. : RECUPERE LES FONCTIONS DE
C                                    FORME EN CE POINT DANS F1
C VARIABLES DE SORTIE
C REAL*8       M0(*)      : COORDONNEES DE M SUR MAILLE DE REFERENCE
C                           (X0,Y0,[Z0])
C LOGICAL      IRET       : .TRUE. EN CAS DE SUCCES
C REAL*8       F1(*)      : FONCTIONS DE FORME EN CE POINT (W1,W2,...)
C ----------------------------------------------------------------------
      
      IMPLICIT NONE

C --- VARIABLES 
      CHARACTER*1 TRANS,KSTOP
      CHARACTER*8  TYPEMA
      INTEGER      NNO,DIME,I,J,IMAX,ISING
      REAL*8       M(*),NO(DIME,*),H,M0(*),F1(*),DET
      REAL*8       PREC,D,R,M1(3),F(3),F0(27),DF(3,3),DF0(3,27),DM(3)
      LOGICAL      IRET,IFORM

C --- METHODE DE NEWTON POUR RESOUDRE LE SYSTEME F(M0) = M

      I = 0
      IRET = .TRUE.

      IF (TYPEMA(1:4).EQ.'TRIA') THEN
        M1(1) = 0.33333333333D0
        M1(2) = 0.33333333333D0
      ELSEIF (TYPEMA(1:4).EQ.'QUAD') THEN
        M1(1) = 0.D0
        M1(2) = 0.D0
      ELSEIF (TYPEMA(1:5).EQ.'TETRA') THEN
        M1(1) = 0.33333333333D0
        M1(2) = 0.03333333333D0
        M1(3) = 0.03333333333D0
      ELSEIF (TYPEMA(1:5).EQ.'PENTA') THEN
        M1(1) = 0.33333333333D0
        M1(2) = 0.33333333333D0
        M1(3) = 0.D0
      ELSE
        M1(1) = 0.D0
        M1(2) = 0.D0
        M1(3) = 0.D0
      ENDIF

 10   CONTINUE

C ------ RESIDU ET NORME DU RESIDU

        CALL FORME0(M1,TYPEMA,F0,NNO)
        CALL MMPROD(NO,DIME,0,DIME,0,NNO,F0,NNO,0,0,1,F)

        I = I + 1
        R = 0.D0

        DO 20 J = 1, DIME
          D = M(J) - F(J)
          DM(J) = D
          D = ABS(D)
          IF (D .GT. R) R = D
 20     CONTINUE

C ----- TEST DE SORTIE

        IF (R .LT. PREC) GOTO 40
        IF (I .GT. IMAX) THEN
          IRET = .FALSE.
          GOTO 40
        ENDIF

C ----- MATRICE TANGENTE

        CALL FORME1(M1,TYPEMA,DF0,NNO,DIME)
        CALL MTPROD(NO,DIME,0,DIME,0,NNO,DF0,DIME,0,DIME,0,DF)

C ----- RESOLUTION
        TRANS=' '
        KSTOP='C'
        CALL MGAUSS(TRANS,KSTOP,DF,DM,DIME,DIME,1,DET,ISING)
        IF(ISING.EQ.0)IRET=.TRUE.

C ----- SI MATRICE NON INVERSIBLE, ECHEC

        IF (.NOT.IRET) GOTO 40

C ----- ACTUALISATION

        DO 30 J = 1, DIME
          M1(J) = M1(J) + DM(J)
 30     CONTINUE
  
        GOTO 10

 40   CONTINUE

C --- RECOPIE COORDONNEES DU POINT REFERENCE

      IF (IRET) CALL DCOPY(DIME,M1,1,M0,1)

C --- RECUPERATION DES FONCTIONS DE FORME

      IF (IFORM.AND.IRET) CALL DCOPY(NNO,F0,1,F1,1)

      END
