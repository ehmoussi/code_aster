      SUBROUTINE PROAX0( UI, VI, CSTA, CSTB, A1, B1, U0, V0, RPAX )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 10/01/2005   AUTEUR F1BHHAJ J.ANGLES 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE F1BHHAJ J.ANGLES
      IMPLICIT      NONE
      REAL*8        UI, VI, CSTA, CSTB, A1, B1, U0, V0, RPAX
C ----------------------------------------------------------------------
C BUT: PROJETER SUR L'AXE 2 LES POINTS REPRESANTANT LE
C      CISAILLEMENT TAU DANS LE PLAN u, v.
C ----------------------------------------------------------------------
C ARGUMENTS:
C UI        IN   R  : COMPOSANTES u DU VECTEUR TAU (CISAILLEMENT),
C                     POUR LE VECTEUR NORMAL COURANT.
C VI        IN   R  : COMPOSANTES v DU VECTEUR TAU (CISAILLEMENT),
C                     POUR LE VECTEUR NORMAL COURANT.
C CSTA      IN   R  : CONSTANTE A POUR LE VECTEUR NORMAL COURANT.
C CSTB      IN   R  : CONSTANTE B POUR LE VECTEUR NORMAL COURANT.
C A1        IN   R  : CONSTANTE A1 POUR LE VECTEUR NORMAL COURANT.
C B1        IN   R  : CONSTANTE B1 POUR LE VECTEUR NORMAL COURANT.
C U0        IN   R  : VALEUR CENTRALE DES u, POUR LE VECTEUR NORMAL 
C                     COURANT.
C V0        IN   R  : VALEUR CENTRALE DES v, POUR LE VECTEUR NORMAL
C                     COURANT.
C RPAX      OUT  R  : VALEUR DE L'AMPLITUDE DU POINT PROJETE SUR L'AXE
C                     CHOISI, POUR LE VECTEUR NORMAL COURANT.
C
C-----------------------------------------------------------------------
C---- COMMUNS NORMALISES  JEVEUX
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32,JEXNOM,JEXNUM,JEXATR
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     ------------------------------------------------------------------
      REAL*8       UIP, VIP, A3, B3
      REAL*8       UP, VP, VAL
C-----------------------------------------------------------------------
C234567                                                              012

      CALL JEMARQ()

      RPAX = 0.0D0

      UIP = UI + 1.0D0
      VIP = VI - (CSTA/CSTB)*(UIP-UI)

      A3 = (VIP-VI)/(UIP-UI)
      B3 = (UIP*VI - UI*VIP)/(UIP-UI)

      UP = (B3-B1)/(A1-A3)
      VP = (A1*B3 - A3*B1)/(A1-A3)
      VAL = SQRT((UP-U0)**2 + (VP-V0)**2)

      IF ( UP .LT. U0 ) THEN
         VAL = -VAL
      ENDIF
      RPAX = VAL

      CALL JEDEMA()
      END
