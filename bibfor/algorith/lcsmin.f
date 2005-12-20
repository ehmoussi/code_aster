      SUBROUTINE LCSMIN(YOUNG,NU,ALPHA,TEMP,TREF)

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

      REAL*8   YOUNG,NU,ALPHA,TEMP,TREF
C ----------------------------------------------------------------------
C        INTEGRATION DES LOIS EN GRANDES DEFORMATIONS SIMO-MIEHE
C                            INITIALISATION
C ----------------------------------------------------------------------
C IN  YOUNG  MODULE DE YOUNG
C IN  NU     COEFFICIENT DE POISSON
C IN  ALPHA  COEFFICIENT DE DILATATION THERMIQUE
C IN  TEMP   TEMPERATURE (DEBUT DU PAS SI RIGI_MECA_*, FIN DE PAS SINON)
C IN  TREF   TEMPERATURE DE REFERENCE
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


      RAC2 = SQRT(2.D0)

C    AFFECTATION DU RACINE DE 2 EN REPRESENTATION VECTORIELLE
      RC(1) = 1.D0
      RC(2) = 1.D0
      RC(3) = 1.D0
      RC(4) = RAC2
      RC(5) = RAC2
      RC(6) = RAC2

C    TENSEUR DU SECOND ORDRE IDENTITE (REPRESENTATION VECTORIELLE)
      KR(1) = 1.D0
      KR(2) = 1.D0
      KR(3) = 1.D0
      KR(4) = 0.D0
      KR(5) = 0.D0
      KR(6) = 0.D0

C    MANIPULATION DES INDICES : IJ -> I
      IND1(1) = 1
      IND1(2) = 2
      IND1(3) = 3
      IND1(4) = 2
      IND1(5) = 3
      IND1(6) = 3

C    MANIPULATION DES INDICES : IJ -> J
      IND2(1) = 1
      IND2(2) = 2
      IND2(3) = 3
      IND2(4) = 1
      IND2(5) = 1
      IND2(6) = 2

C    PARAMETRES MATERIAUX
      LAMBDA = YOUNG*NU/(1+NU)/(1-2*NU)
      DEUXMU = YOUNG/(1+NU)
      MU     = DEUXMU/2
      TROISK = YOUNG/(1-2*NU)
      UNK    = TROISK/3

C    CONTRAINTE THERMIQUE
      COTHER = TROISK*ALPHA*(TEMP-TREF)

      END
