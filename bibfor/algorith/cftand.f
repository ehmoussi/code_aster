      SUBROUTINE CFTAND(DEFICO,IZONE,TANGDF,DTANG)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 24/09/2007   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT   NONE
      INTEGER      IZONE
      CHARACTER*24 DEFICO
      INTEGER      TANGDF
      REAL*8       DTANG(3)
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODES DISCRETES - APPARIEMENT)
C
C RETOURNE LA TANGENTE SUR UNE ZONE DE CONTACT
C SI ELLE EST DEFINIE PAR VECT_Y, VECT_ORIE_POU OU RIEN
C
C ----------------------------------------------------------------------
C
C
C IN  DEFICO : SD DE DEFINITION DU CONTACT (ISSUE D'AFFE_CHAR_MECA)
C IN  IZONE  : ZONE DE CONTACT
C OUT TANGDF : INDICATEUR DE PRESENCE QUE LE REPERE LOCAL EST DEFINI
C              PAR L'UTILISATEUR VIA VECT_Y/VECT_ORIE_POU
C               0 NON DEFINI
C               1 TANGENTE DEFINIE
C OUT DTANG  : VECTEUR TANGENT DEFINI PAR L'UTILISATEUR
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
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
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      REAL*8       ZERO
      PARAMETER  ( ZERO   =  0.0D0  )       
      INTEGER      CFMMVD,CFDISI,ZTGDE,ZPOUD
      CHARACTER*24 TANDEF,TANPOU
      INTEGER      JTGDEF,JPOUDI
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      DTANG(1) = ZERO
      DTANG(2) = ZERO
      DTANG(3) = ZERO 
C
C --- LECTURE DES SD POUR LE CONTACT POTENTIEL
C
      TANDEF = DEFICO(1:16)//'.TANDEF'
      TANPOU = DEFICO(1:16)//'.TANPOU'
C
      ZTGDE  = CFMMVD('ZTGDE')
      ZPOUD  = CFMMVD('ZPOUD')                
C
C --- TANGENTES
C
      IF (CFDISI(DEFICO,'TANG_DEF',IZONE).EQ.0) THEN
        TANGDF = 0
      ELSE
        TANGDF = 1
      ENDIF
      
      IF (CFDISI(DEFICO,'TANG_DEF',IZONE).EQ.1) THEN
        CALL JEVEUO(TANDEF,'L',JTGDEF)
        DTANG(1) = ZR(JTGDEF+ZTGDE*(IZONE-1))
        DTANG(2) = ZR(JTGDEF+ZTGDE*(IZONE-1)+1)
        DTANG(3) = ZR(JTGDEF+ZTGDE*(IZONE-1)+2)
      ELSE IF (CFDISI(DEFICO,'TANG_DEF',IZONE).EQ.2) THEN
        CALL JEVEUO(TANPOU,'L',JPOUDI)
        DTANG(1) = ZR(JPOUDI+ZPOUD*(IZONE-1))
        DTANG(2) = ZR(JPOUDI+ZPOUD*(IZONE-1)+1)
        DTANG(3) = ZR(JPOUDI+ZPOUD*(IZONE-1)+2)
      ELSE 
        DTANG(1) = 0.D0
        DTANG(2) = 0.D0
        DTANG(3) = 0.D0 
      END IF
C
      CALL JEDEMA()      
C
      END
