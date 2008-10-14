      SUBROUTINE NMIHHT(MODELE,NUMEDD,MATE  ,COMPOR,CARELE,
     &                  LISCHA,CARCRI,COMREF,FONACT,SDDYNA,
     &                  SDSENS,DEFICO,RESOCO,RESOCU,VALMOI,
     &                  VALPLU,POUGD ,SDDISC,PARCON,SOLALG,
     &                  VEELEM,VEASSE)
C 
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/10/2008   AUTEUR ABBAS M.ABBAS 
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
C TOLE CRP_21
C
      IMPLICIT NONE
      LOGICAL       FONACT(*)
      CHARACTER*19  SDDYNA
      CHARACTER*19  LISCHA
      CHARACTER*24  MODELE,MATE,CARELE, NUMEDD
      CHARACTER*24  VALMOI(8),VALPLU(8),POUGD(8)
      CHARACTER*24  COMPOR,CARCRI,SDSENS,COMREF
      CHARACTER*19  SDDISC
      REAL*8        PARCON(8)
      CHARACTER*24  DEFICO,RESOCO,RESOCU
      CHARACTER*19  SOLALG(*),VEELEM(*),VEASSE(*) 
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C INITIALISATIONS SPECIFIQUES POUR SCHEMAS MULTIPAS EN POURSUITE
C
C ----------------------------------------------------------------------
C
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
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
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      INTEGER      IFM,NIV
      INTEGER      NOCC,IRET
      LOGICAL      EVONOL
      CHARACTER*24 K24BID,COMMOI,INSMOI 
C
C ----------------------------------------------------------------------
C
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> INITIALISATION MULTI-PAS'
      ENDIF
C      
      CALL GETVID('ETAT_INIT','EVOL_NOLI',1,1,1,K24BID,NOCC)
      EVONOL = NOCC .GT. 0
C
C --- DECOMPACTION DES VARIABLES CHAPEAUX
C      
      CALL DESAGG(VALMOI,K24BID,K24BID,K24BID,COMMOI,
     &            K24BID,K24BID,K24BID,K24BID)          
      IF (EVONOL) THEN
        CALL NMVCEX('INST',COMMOI,INSMOI)
        CALL EXISD('CHAMP_GD',INSMOI,IRET)
        IF ( IRET .NE. 0 ) THEN         
          CALL NMCHHT(MODELE,NUMEDD,MATE  ,COMPOR,CARELE,
     &                LISCHA,CARCRI,COMREF,FONACT,SDDYNA,
     &                SDSENS,DEFICO,RESOCO,RESOCU,VALMOI,
     &                VALPLU,POUGD ,SDDISC,PARCON,SOLALG,
     &                VEELEM,VEASSE)
        ENDIF
      ENDIF

      CALL JEDEMA()
      END
