      SUBROUTINE TSTJAC(NP1,N,TYPJ,KMOD,KMOD0)
      IMPLICIT NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 16/05/2000   AUTEUR KXBADNG T.KESTENS 
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
C-----------------------------------------------------------------------
C DESCRIPTION : TESTE LA VARIATION DE LA MATRICE DE RAIDEUR
C -----------
C               APPELANT : CALCMD
C
C-------------------   DECLARATION DES VARIABLES   ---------------------
C
C ARGUMENTS
C ---------
      INTEGER    NP1, N, TYPJ
      REAL*8     KMOD(NP1,*), KMOD0(NP1,*)
C
C VARIABLES LOCALES
C -----------------
      INTEGER    I, J
      REAL*8     SUP, SUP1, VAL, MAX, TOL
C
C FONCTIONS INTRINSEQUES
C ----------------------
C     INTRINSIC  ABS
C
C ROUTINES EXTERNES
C -----------------
C     EXTERNAL   UTMESS
C
C-------------------   DEBUT DU CODE EXECUTABLE    ---------------------
C
      TYPJ = 0
      SUP  = 0.0D0
      SUP1 = 0.0D0
      TOL  = 1.0D-03
      MAX  = 0.0D0
C
      DO 10 J = 1, N
         DO 11 I = 1, N
            SUP1 = ABS(KMOD0(I,J))
            IF ( SUP1.GT.SUP ) SUP = SUP1
  11     CONTINUE
  10  CONTINUE
C
C
      IF ( SUP.EQ.0.D0 ) THEN
         CALL UTMESS('I','TSTJAC','LE SUP DE KMOD0 EST NUL. '//
     &                            'ON PREND LE SUP DE KMOD.')
         DO 20 J = 1, N
            DO 21 I = 1, N
               SUP1 = ABS(KMOD(I,J))
               IF ( SUP1.GT.SUP ) SUP = SUP1
  21        CONTINUE
  20     CONTINUE
      ENDIF
C
C
      IF ( SUP.EQ.0.D0 )
     &   CALL UTMESS('F','TSTJAC','LE SUP DE KMOD EST NUL.')
C
C
      DO 30 J = 1, N
         DO 31 I = 1, N
            VAL = ABS(KMOD(I,J) - KMOD0(I,J)) / SUP
            IF ( VAL.GT.MAX ) MAX = VAL
  31     CONTINUE
  30  CONTINUE
C
      IF ( MAX.GE.TOL ) TYPJ = 1
C
C --- FIN DE TSTJAC.
      END
