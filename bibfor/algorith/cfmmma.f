      SUBROUTINE CFMMMA(DEFICO,RESOCO)
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 14/09/2010   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT NONE
      CHARACTER*24 DEFICO,RESOCO
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODES MAILLEES)
C
C CREATION SD DE RESOLUTION 
C      
C ----------------------------------------------------------------------
C     
C
C IN  DEFICO : SD POUR LA DEFINITION DE CONTACT
C IN  RESOCO : SD POUR LA RESOLUTION DE CONTACT
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
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
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      IFM,NIV
      INTEGER      CFDISI,NTPC,NTNOEC
      CHARACTER*24 APJEU,JEUSUP
      INTEGER      JAPJEU,JJSUP
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('CONTACT',IFM,NIV) 
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<CONTACT> ... CREATION DES SD POUR LES '//
     &                ' FORMULATIONS MAILLEES' 
      ENDIF
C
C --- INITIALISATIONS
C
      NTPC   = CFDISI(DEFICO,'NTPC'     )
      NTNOEC = CFDISI(DEFICO,'NTNOEC'   )  
C
C --- JEU TOTAL
C
      APJEU  = RESOCO(1:14)//'.APJEU'
      CALL WKVECT(APJEU ,'V V R',NTPC ,JAPJEU)
C
C --- JEU SUPPLEMENTAIRE (DIST_*)
C
      JEUSUP = RESOCO(1:14)//'.JSUPCO'
      CALL WKVECT(JEUSUP,'V V R',NTPC ,JJSUP )
C
C --- AFFICHAGE
C
      WRITE (IFM,*) '--- NOMBRE TOTAL DE NOEUDS ESCLAVES '//
     &              'POUR LE CONTACT : ',NTNOEC
C
      CALL JEDEMA()      
      END
