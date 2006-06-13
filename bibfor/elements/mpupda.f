      SUBROUTINE MPUPDA(ZERO,NORTH,MP1,MP2,ZEROF,ZEROG)
      IMPLICIT NONE
      CHARACTER*8  NOMRES(2), NOMPAR(2)
      CHARACTER*10 PHENOM
      CHARACTER*2  CODRET(2)      
      REAL*8       NORTH(3),  MP1(3),   MP2(3),  ZEROF,  ZEROG
      REAL*8       TMP(6),    ZERO,     NORM6,   R8B
      REAL*8       VALRES(4), VALPAR(4)
      INTEGER      I,  TEST, IMATE    
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 18/10/2004   AUTEUR LEBOUVIE F.LEBOUVIER 
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
C     BUT    :  - REACTUALISER LES MOMENTS LIMITES ELASTIQUES MP1 ET MP2
C                 AINSI QUE LES VARIABLES ZEROG ET ZEROF
C  
C IN    R  NORTH  : EFFORT NORMAL EXPRIME DANS LE REPERE D'ORTHOTROPIE
C
C INOUT R  MP1    : MOMENT LIMITE ELASTIQUE EN FLEXION POSITIVE
C       R  MP2    : MOMENT LIMITE ELASTIQUE EN FLEXION NEGATIVE
C
C-----------------------------------------------------------------------
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C     CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL,VECTEU,MATRIC,TEMPNO
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      TEST=1
      CALL JEVECH('PMATERC','L',IMATE)
C
C- RECUPERATION DES PARAMETRES DE LA LOI DE COMPORTEMENT GLRC
C
      CALL RCCOMA ( ZI(IMATE), 'GLRC' , PHENOM, CODRET)
C
      IF(PHENOM . NE . 'GLRC' ) THEN
        CALL UTMESS('F','DXGLRC','COMPORTEMENT NON TROUVE:'//PHENOM)
      ENDIF
C
      NOMRES(1)  = 'MEX1'
      NOMRES(2)  = 'MEX2'   
      CALL RCVALA(ZI(IMATE),' ',PHENOM,1,'NORM',NORTH(1),2,NOMRES,
     +                 VALRES,CODRET,'FM')
      MP1(1)   = VALRES(1)
      MP2(1)   = VALRES(2)
C                       
      NOMRES(1)  = 'MEY1'
      NOMRES(2)  = 'MEY2'
      CALL RCVALA(ZI(IMATE),' ',PHENOM,1,'NORM',NORTH(2),2,NOMRES,
     +                 VALRES,CODRET,'FM')      
      MP1(2)  = VALRES(1)
      MP2(2)  = VALRES(2)
C
C------- ON VERIFIE LE SIGNE DES MOMENTS LIMITES
C
      IF (TEST .GT. 0.D0) THEN
         IF (MP1(1)*MP2(1) .GE. 0.D0) THEN
            CALL UTMESS('F','MPUPDA','LE SIGNE DES MOMENTS LIMITES '// 
     &           'EST MAUVAIS, IL FAUT RESPECTER LA CONDITION: '// 
     &           'MP1X*MP2X < 0')
         ENDIF
C
         IF (MP1(1)*MP1(2) .LE. 0.D0) THEN
            CALL UTMESS('F','MPUPDA','LE SIGNE DES MOMENTS LIMITES '//
     &           'EST MAUVAIS, IL FAUT RESPECTER LA CONDITION: '//  
     &           'MP1X*MP1Y > 0')
         ENDIF
C
         IF (MP2(1)*MP2(2) .LE. 0.D0) THEN
            CALL UTMESS('F','MPUPDA','LE SIGNE DES MOMENTS LIMITES '//
     &           'EST MAUVAIS, IL FAUT RESPECTER LA CONDITION: '//
     &           'MP2X*MP2Y > 0')
         ENDIF
      ENDIF
C     
         DO 200 I=1,3
            TMP(I)  = MP1(I)
            TMP(I+3)= MP2(I)
 200     CONTINUE
C
         ZEROG=NORM6(TMP)
         ZEROF=ZERO*ZEROG**2
         ZEROG=ZERO*ZEROG
C
         END
