      SUBROUTINE MMACON(CHAR  ,NOMA)
C 
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 01/04/2008   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*8  NOMA
      CHARACTER*8  CHAR
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - LECTURE DONNEES)
C
C CREATION DES SDS SPECIFIQUES FORMULATION CONTINUE 
C      
C ----------------------------------------------------------------------
C
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  CHAR   : NOM UTILISATEUR DU CONCEPT DE CHARGE
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C  
      INTEGER ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      CFMMVD,ZMAES,ZCMCF,ZTABF
      INTEGER      NZOCO
      INTEGER      IZONE
      INTEGER      IMAE,NBMAE,POSMAE,ISUMAE,JDECME,NUMMAE,NTMAE     
      INTEGER      NTPC,NNINT,TYPINT
      CHARACTER*24 CONTMA,MAESCL,CARACF,NDIMCO,JEUSUR
      INTEGER      JMACO,JMAESC,JCMCF,JDIM,JUSU
      CHARACTER*24 TABFIN,PSURMA,PZONE,PSURNO,JEUCON
      INTEGER      JTABF,JSUMA,JZONE,JSUNO,JJEU                 
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C 
C --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
C
      CONTMA = CHAR(1:8)//'.CONTACT.MAILCO'
      MAESCL = CHAR(1:8)//'.CONTACT.MAESCL'
      TABFIN = CHAR(1:8)//'.CONTACT.TABFIN'
      PSURMA = CHAR(1:8)//'.CONTACT.PSUMACO'
      PSURNO = CHAR(1:8)//'.CONTACT.PSUNOCO'
      PZONE  = CHAR(1:8)//'.CONTACT.PZONECO'
      CARACF = CHAR(1:8)//'.CONTACT.CARACF'
      NDIMCO = CHAR(1:8)//'.CONTACT.NDIMCO'
      JEUCON = CHAR(1:8)//'.CONTACT.JEUCON'
      JEUSUR = CHAR(1:8)//'.CONTACT.JEUSUR'
      CALL JEVEUO(CONTMA,'L',JMACO)
      CALL JEVEUO(NDIMCO,'L',JDIM)
      CALL JEVEUO(PSURMA,'L',JSUMA)
      CALL JEVEUO(PSURNO,'L',JSUNO)
      CALL JEVEUO(PZONE ,'L',JZONE)
      CALL JEVEUO(CARACF,'L',JCMCF)
C
      ZMAES  = CFMMVD('ZMAES')
      ZCMCF  = CFMMVD('ZCMCF')
      ZTABF  = CFMMVD('ZTABF')          
C
      NZOCO  = ZI(JDIM+1)          
C      
C --- NOMBRE TOTAL DES MAILLES ESCLAVES DE CONTACT.
C
      NTMAE = 0
      DO 10 IZONE = 1,NZOCO
        ISUMAE = ZI(JZONE+IZONE-1) + 1
        NBMAE  = ZI(JSUMA+ISUMAE) - ZI(JSUMA+ISUMAE-1)
        NTMAE  = NTMAE + NBMAE
 10   CONTINUE       
C
C --- CREATION DU TABLEAU DES MAILLES ESCLAVES MAESC
C
      CALL WKVECT(MAESCL,'G V I',ZMAES*NTMAE+1,JMAESC)
C
C --- REMPLISSAGE DU TABLEAU DES MAILLES ESCLAVES MAESC
C
      NTMAE = 0
      DO 30 IZONE = 1,NZOCO  
        ISUMAE = ZI(JZONE+IZONE-1) + 1
        NBMAE  = ZI(JSUMA+ISUMAE) - ZI(JSUMA+ISUMAE-1)
        JDECME = ZI(JSUMA+ISUMAE-1)
        TYPINT = NINT(ZR(JCMCF+ZCMCF*(IZONE-1)+1))  
        DO 20 IMAE = 1,NBMAE
          POSMAE = JDECME + IMAE
          NUMMAE = ZI(JMACO-1+POSMAE)              
          CALL MMELIN(NOMA,NUMMAE,TYPINT,NNINT)            
          ZI(JMAESC+ZMAES*NTMAE+ZMAES*IMAE-2) = POSMAE
          ZI(JMAESC+ZMAES*NTMAE+ZMAES*IMAE-1) = IZONE
          ZI(JMAESC+ZMAES*NTMAE+ZMAES*IMAE)   = NNINT
 20     CONTINUE
        NTMAE = NTMAE + NBMAE
 30   CONTINUE
      ZI(JMAESC) = NTMAE 
C
C --- ON COMPTE LE NOMBRE DES POINTS ESCLAVES
C
      NTPC = 0
      DO 40 IMAE = 1,NTMAE
        NNINT  = ZI(JMAESC+3*(IMAE-1)+3)
        NTPC   = NTPC + NNINT
 40   CONTINUE
C
C --- CREATION DES TABLEAUX TABFIN JEUCON ET JEUSUR
C
      CALL WKVECT(TABFIN,'G V R',ZTABF*NTPC+1,JTABF)
      CALL WKVECT(JEUCON,'G V R',NTPC        ,JJEU)
      CALL WKVECT(JEUSUR,'G V R',NTPC        ,JUSU)
C      
      CALL JEDEMA()
      END
