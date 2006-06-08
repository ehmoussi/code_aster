      SUBROUTINE NMMABU(NDIM,NNO,AXI,GRAND,DFDI,B)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 10/05/2005   AUTEUR GJBHHEL E.LORENTZ 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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

      IMPLICIT NONE

      LOGICAL GRAND, AXI
      INTEGER NDIM,NNO
      REAL*8  DFDI(NNO,NDIM),B(6,3,NNO)

C ----------------------------------------------------------------------
C                     CALCUL DE LA MATRICE B :  DEPS = B.DU
C
C IN  NDIM    : DIMENSION DE L'ESPACE
C IN  NNO     : NOMBRE DE NOEUDS
C IN  AXI     : .TRUE. SI AXISYMETRIQUE
C IN  GRAND   : .TRUE. SI GRANDES DEFORMATIONS
C IN  DFDI    : DERIVEE DES FONCTIONS DE FORME (POINT DE GAUSS COURANT)
C OUT B       : MATRICE B : B(6,3,NNP)
C ----------------------------------------------------------------------

      INTEGER N
      REAL*8  R2
C ----------------------------------------------------------------------


      IF (GRAND) CALL UTMESS('F','NMMATB_1','DVP : NON IMPLANTE')
      IF (AXI)   CALL UTMESS('F','NMMATB_2','DVP : NON IMPLANTE')

      CALL R8INIR(18*NNO,0.D0,B,1)
      R2 = SQRT(2.D0)/2.D0

      IF (NDIM.EQ.2) THEN
        DO 10 N = 1,NNO
          B(1,1,N) = DFDI(N,1)
          B(2,2,N) = DFDI(N,2)
          B(4,1,N) = R2*DFDI(N,2)
          B(4,2,N) = R2*DFDI(N,1)
 10     CONTINUE

      ELSE IF (NDIM.EQ.3) THEN
        DO 20 N = 1,NNO
          B(1,1,N) = DFDI(N,1)
          B(2,2,N) = DFDI(N,2)
          B(3,3,N) = DFDI(N,3)
          B(4,1,N) = R2*DFDI(N,2)
          B(4,2,N) = R2*DFDI(N,1)
          B(5,1,N) = R2*DFDI(N,3)
          B(5,3,N) = R2*DFDI(N,1)
          B(6,2,N) = R2*DFDI(N,3)
          B(6,3,N) = R2*DFDI(N,2)
 20     CONTINUE

      ELSE
        CALL UTMESS('F','NMMATB_3','DVP : NON COHERENT')
      END IF

      END
