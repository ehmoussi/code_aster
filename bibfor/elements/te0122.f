      SUBROUTINE TE0122(OPTION,NOMTE)
      IMPLICIT   NONE
      CHARACTER*16 OPTION,NOMTE

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 18/05/2004   AUTEUR CIBHHLV L.VIVAN 
C ======================================================================
C COPYRIGHT (C) 1991 - 2003  EDF R&D                  WWW.CODE-ASTER.ORG
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
C......................................................................
C     FONCTION REALISEE:  CALCUL DES CHAMELEM AUX NOEUDS A PARTIR DES
C     VALEURS AUX POINTS DE GAUSS ( SIEF_ELNO_ELGA VARI_ELNO_ELGA )
C     ELEMENTS 2D DE JOINTS

C IN  OPTION : OPTION DE CALCUL
C IN  NOMTE  : NOM DU TYPE ELEMENT
C ......................................................................

C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

      INTEGER ICHG,ICHN,ICOM,JTAB(7),NCMP,N,C,IBID,I,IN,IG
C     ------------------------------------------------------------------

      IF (OPTION.EQ.'SIEF_ELNO_ELGA') THEN
      
        CALL JEVECH('PCONTRR' ,'L',ICHG)
        CALL JEVECH('PSIEFNOR','E',ICHN)
        NCMP = 2

      ELSE IF (OPTION.EQ.'VARI_ELNO_ELGA') THEN
      
        CALL JEVECH('PCOMPOR','L',ICOM)
        CALL JEVECH('PVARIGR','L',ICHG)
        CALL JEVECH('PVARINR','E',ICHN)
        CALL TECACH('OOO','PVARINR',7,JTAB,IBID)
        NCMP = MAX(JTAB(6),1)*JTAB(7)
        
      END IF
      
C    EXTRAPOLATION AUX NOEUDS

      DO 10 I = 1,NCMP
        IG = ICHG-1+I
        IN = ICHN-1+I
        ZR(IN)        = ZR(IG) + (ZR(IG+NCMP)-ZR(IG))*(1-SQRT(3.D0))/2
        ZR(IN+3*NCMP) = ZR(IG) + (ZR(IG+NCMP)-ZR(IG))*(1-SQRT(3.D0))/2
        ZR(IN+NCMP)   = ZR(IG) + (ZR(IG+NCMP)-ZR(IG))*(1+SQRT(3.D0))/2
        ZR(IN+2*NCMP) = ZR(IG) + (ZR(IG+NCMP)-ZR(IG))*(1+SQRT(3.D0))/2
   10 CONTINUE                
        
      END
