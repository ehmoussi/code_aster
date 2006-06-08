      SUBROUTINE INSCU ( STRN , SEQ , EPEQ , IPL , TANG )
        IMPLICIT REAL*8 (A-H,O-Z)
C       -----------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 27/03/2002   AUTEUR VABHHTS J.PELLET 
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
C       -----------------------------------------------------------
C    NADAI_B :  BETON FISSURE
C               CALCUL DE LA CONTRAINTE EQUIVALENTE EN COMPRESSION
C               DU MODULE TANGENT ET DE L INDICATEUR DE PLASTICITE
C ENTREES :
C            STRN  : DEFORMATION A T+DT
C
C SORTIES :  SEQ  : CONTRAINTE UNIAXIALE A T+DT EN VALEUR ABSOLUE
C            EPEQ : DEFORMATION EQUIVALENTE A T+DT = ABS(STRN)
C            TANG : MODULE TANGENT
C            IPL  : INDICATEUR DE PLASTICITE
C       -----------------------------------------------------------
      INTEGER  IPL
      REAL*8   STRN , SEQ , EPEQ , TANG
      COMMON /DBETO/ POU1(4),RB,ALPHA,EX,PXY,EMAX,EPSUT,FTC,FLIM,
     1   EPO,EPO1,POU2(6),ICU,IPOU1(9)
C------------------------------------------------------------------
      EPEQ = ABS(STRN)
      IF(EPEQ.GT.EMAX) THEN
       SEQ = 0.D0
       IPL = 2
       TANG = 0.D0
       GOTO 10
      ENDIF
C
      IPL = 0
      EPO2=EPO1
      EPSU=EMAX
      TU=RB
      B3=EX/TU-2.D0/EPO2
      C3=1.D0/EPO2/EPO2
C
      IF(EPEQ.LT.EPO2) THEN
        DIN3=1.D0+B3*EPEQ+C3*EPEQ*EPEQ
        SEQ=EX*EPEQ/DIN3
        TANG=EX*(1.D0-C3*EPEQ*EPEQ)/DIN3/DIN3
      ELSE
        SEQ=TU*(EPSU-EPEQ)/(EPSU-EPO2)
        TANG=-TU/(EPSU-EPO2)
        IPL=1
      ENDIF
C
   10 CONTINUE
      IF(SEQ .LT.  1.D-8)  SEQ=0.D0
      IF(EPEQ .LT. 1.D-10) EPEQ=0.D0
      END
