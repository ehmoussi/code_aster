      SUBROUTINE NMEPSB(NDIM,NNO,AXI,VFF,DFDI,DEPLG,EPSB,GEPS)

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

      LOGICAL AXI
      INTEGER NDIM,NNO
      REAL*8  VFF(NNO),DFDI(NNO,NDIM),DEPLG(*)
      REAL*8  EPSB(6),GEPS(6,3)

C ----------------------------------------------------------------------
C       CALCUL DES DEFORMATIONS REGULARISEES ET LEURS GRADIENTS
C
C IN  NDIM    : DIMENSION DE L'ESPACE
C IN  NNO     : NOMBRE DE NOEUDS (FAMILLE E-BARRE)
C IN  AXI     : .TRUE. SI AXISYMETRIQUE
C IN  VFF     : VALEURS DES FONCTIONS DE FORME (POINT DE GAUSS COURANT)
C IN  DFDI    : DERIVEE DES FONCTIONS DE FORME (POINT DE GAUSS COURANT)
C IN  DEPLG   : DEPLACEMENT GENERALISE (U ET E-BARRE)
C OUT EPSB    : DEFORMATIONS REGULARISEES EPSB(6)
C OUT GEPS    : GRADIENT DES DEFORMATIONS REGULARISEES GEPS(6,3)
C ----------------------------------------------------------------------

      INTEGER KL,I,NDIMSI,NDL
      REAL*8  DDOT
C ----------------------------------------------------------------------



      NDIMSI = 2*NDIM
      NDL    = NDIM+NDIMSI

      CALL R8INIR(6 ,0.D0,EPSB,1)
      CALL R8INIR(18,0.D0,GEPS,1)
      DO 10 KL = 1,NDIMSI
        EPSB(KL)=DDOT(NNO,DEPLG(KL+NDIM),NDL,VFF,1)
        DO 20 I = 1,NDIM
          GEPS(KL,I) = DDOT(NNO,DEPLG(KL+NDIM),NDL,DFDI(1,I),1)
 20     CONTINUE
 10   CONTINUE

      IF (AXI) CALL UTMESS('F','NMEPSB_1','DVP : NON IMPLANTE')
      END
