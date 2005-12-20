      SUBROUTINE OP0086(IER)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF SOUSTRUC  DATE 05/10/2004   AUTEUR REZETTE C.REZETTE 
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
      IMPLICIT REAL*8 (A-H,O-Z)
C     COMMANDE:  MACR_ELEM_STAT
C
C ---------------- COMMUNS NORMALISES  JEVEUX  -------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*8 NOMU
      CHARACTER*16 KBI1,KBI2
      LOGICAL LOK
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32,JEXNUM,JEXNOM
      CHARACTER*80 ZK80
C
C
      CALL JEMARQ()
      CALL INFMAJ()
C
      CALL GETRES(NOMU,KBI1,KBI2)
C
C     -- VERIFICATION DE L'APPEL DE LA COMMANDE :
C
C     --TRAITEMENT DES MOTS CLEFS 'DEFINITION' ET 'EXTERIEUR'
      CALL GETFAC('DEFINITION',NOCC)
      IF (NOCC.EQ.1) THEN
         CALL JEEXIN(NOMU//'.REFM',IRET)
         IF (IRET.GT.0) THEN
            CALL UTMESS('F','OP0086','MOT-CLEF "DEFINITION" INTERDIT :'
     +                 //'LE MACR_ELEM: '//NOMU//' EST DEJA DEFINI.')
         ELSE
            CALL SSDEGE(NOMU)
         END IF
      END IF
C
C     --TRAITEMENT DU MOT CLEF 'RIGI_MECA'
      CALL GETFAC('RIGI_MECA',NOCC)
      IF (NOCC.EQ.1) THEN
         CALL JEEXIN(NOMU//'.REFM',IRET)
         IF (IRET.EQ.0) THEN
            CALL UTMESS('F','OP0086','MOT-CLEF "RIGI_MECA" INTERDIT :'
     +                 //'IL EST DEJA CALCULE.')
         END IF
         CALL JEVEUO(NOMU//'.REFM','L',IAREFM)
         IF (ZK8(IAREFM-1+6).EQ.'OUI_RIGI') THEN
            CALL UTMESS('F','OP0086','MOT-CLEF "RIGI_MECA" INTERDIT :'
     +                 //'LE RESULTAT : '//NOMU//' EXISTE DEJA.')
         ELSE
            CALL SSRIGE(NOMU)
         END IF
      END IF
C
C     --TRAITEMENT DU MOT CLEF 'MASS_MECA':
      CALL GETFAC('MASS_MECA',NOCC)
      IF (NOCC.EQ.1) THEN
         CALL JEEXIN(NOMU//'.REFM',IRET)
         IF (IRET.EQ.0) THEN
            CALL UTMESS('F','OP0086','MOT-CLEF "MASS_MECA" INTERDIT :'
     +           //'IL FAUT AVOIR FAIT "DEFINITION" ET "RIGI_MECA".')
         END IF
         CALL JEVEUO(NOMU//'.REFM','L',IAREFM)
         IF (ZK8(IAREFM-1+6).NE.'OUI_RIGI') THEN
            CALL UTMESS('F','OP0086','MOT-CLEF "MASS_MECA" INTERDIT :'
     +           //'IL FAUT AVOIR FAIT "DEFINITION" ET "RIGI_MECA".')
         END IF
         IF (ZK8(IAREFM-1+7).EQ.'OUI_MASS') THEN
            CALL UTMESS('F','OP0086','MOT-CLEF "MASS_MECA" INTERDIT :'
     +                 //'IL EST DEJA CALCULE.')
         ELSE
            CALL SSMAGE(NOMU,'MASS_MECA')
         END IF
      END IF
C
C     --TRAITEMENT DU MOT CLEF 'CAS_CHARGE'
      CALL GETFAC('CAS_CHARGE',NOCC)
      IF (NOCC.GT.0) THEN
         CALL JEEXIN(NOMU//'.REFM',IRET)
         IF (IRET.EQ.0) THEN
            CALL UTMESS('F','OP0086','MOT-CLEF "CAS_CHARGE" INTERDIT :'
     +           //'IL FAUT AVOIR FAIT "DEFINITION" ET "RIGI_MECA".')
         END IF
         CALL JEVEUO(NOMU//'.REFM','L',IAREFM)
         IF (ZK8(IAREFM-1+6).NE.'OUI_RIGI') THEN
            CALL UTMESS('F','OP0086','MOT-CLEF "CAS_CHARGE" INTERDIT :'
     +           //'IL FAUT AVOIR FAIT "DEFINITION" ET "RIGI_MECA".')
         END IF
         CALL SSCHGE(NOMU)
      END IF
C
C
      CALL JEDEMA()
      END
