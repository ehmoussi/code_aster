      SUBROUTINE MMIMP2(IFM,NOMA,LIGRCF,JTABF)
C      
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 24/09/2007   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT     NONE
      INTEGER      IFM
      CHARACTER*19 LIGRCF       
      CHARACTER*8  NOMA
      INTEGER      JTABF
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - UTILITAIRE - IMPRESSIONS)
C
C AFFICHAGE POUR LES ELEMENTS DE CONTACT
C      
C ----------------------------------------------------------------------
C
C
C IN  IFM    : UNITE D'IMPRESSION DU MESSAGE
C IN  LIGRCF : LIGREL POUR LES ELEMENTS DE CONTACT
C IN  NOMA   : NOM DU MAILLAGE
C IN  JTABF  : POINTEUR VERS DEFICO(1:16)//'.CARACF'
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      CHARACTER*32 JEXNUM,JEXATR
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
      INTEGER      CFMMVD,ZTABF  
      INTEGER      JTYMAI,IACNX1,ILCNX1
      INTEGER      NBNOE,NBNOM,NUMAE,NUMAM,ITYMAE,ITYMAM,ITYCTC
      CHARACTER*8  K8BID,NTYMAE,NTYMAM,NTYCTC,NOMESC,NOMMAI
      INTEGER      NBEL,NNDEL,JAD,IEL    
       
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()     
C
      ZTABF = CFMMVD('ZTABF')
      CALL JEVEUO(NOMA//'.TYPMAIL','L',JTYMAI) 
      CALL JEVEUO(NOMA//'.CONNEX','L',IACNX1)
      CALL JEVEUO(JEXATR(NOMA//'.CONNEX','LONCUM'),'L',ILCNX1) 
C
C --- NOMBRE D'ELEMENTS DE CONTACT
C
      CALL JELIRA(LIGRCF//'.NEMA','NUTIOC',NBEL,K8BID)      
      WRITE(IFM,1000) NBEL

      DO 20 IEL= 1,NBEL
      
C       -- ACCES A L'ELEMENT DE CONTACT EN COURS
        CALL JEVEUO(JEXNUM(LIGRCF//'.NEMA',IEL),'L',JAD)
      
C       -- NOMBRE DE NOEUDS TOTAL DE L'ELEMENT DE CONTACT     
        CALL JELIRA(JEXNUM(LIGRCF//'.NEMA',IEL),'LONMAX',NNDEL,K8BID)

C       -- TYPE DE L'ELEMENT DE CONTACT
        ITYCTC = ZI(JAD+NNDEL-1)
        CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ITYCTC),NTYCTC)
     
C       -- IMPRESSION POUR ELEMENT DE CONTACT     
        WRITE(IFM,1050) IEL,NTYCTC,NNDEL-1

C       -- INFOS SUR MAILLE ESCLAVE     
        NUMAE  = NINT(ZR(JTABF+ZTABF*(IEL-1)+1))
        CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',NUMAE),NOMESC)        
        ITYMAE = ZI(JTYMAI-1+NUMAE)
        CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ITYMAE),NTYMAE)
        NBNOE  = ZI(ILCNX1+NUMAE) - ZI(ILCNX1-1+NUMAE) 

C       -- IMPRESSION POUR MAILLE ESCLAVE               
        WRITE(IFM,1060) NOMESC,NTYMAE,NBNOE

C       -- INFOS SUR MAILLE MAITRE 
        NUMAM  = NINT(ZR(JTABF+ZTABF*(IEL-1)+2))
        CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',NUMAM),NOMMAI)           
        ITYMAM = ZI(JTYMAI-1+NUMAM)
        CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ITYMAM),NTYMAM)        
        NBNOM  = ZI(ILCNX1+NUMAM) - ZI(ILCNX1-1+NUMAM) 

C       -- IMPRESSION POUR MAILLE MAITRE  
        WRITE(IFM,1070) NOMMAI,NTYMAM,NBNOM
           
   20 CONTINUE 
C
C --- FORMATS AFFICHAGE
C
 1000 FORMAT (' <CONTACT> CREATION DES ',I5,' ELEMENTS DE CONTACT')
 1050 FORMAT (' <CONTACT>     * L''ELEMENT DE CONTACT ',I5,
     &        ' EST DE TYPE ',A8,
     &        ' AVEC ',I5,' NOEUDS')
        
 1060 FORMAT (' <CONTACT>     ** EST CREE ENTRE LA MAILLE ESCLAVE ',A8,
     &        ' DE TYPE ',A8,
     &        ' AVEC ',I5,' NOEUDS')
 1070 FORMAT (' <CONTACT>     **             ET LA MAILLE MAITRE  ',A8,
     &        ' DE TYPE ',A8,
     &        ' AVEC ',I5,' NOEUDS')
C
 999  CONTINUE
      CALL JEDEMA()
C     
      END
