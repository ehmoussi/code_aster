      SUBROUTINE RECHME(NOMA  ,IZONE ,NEWGEO,DEFICO,RESOCO,
     &                  IESCL0,NFESCL)
C     
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 24/09/2007   AUTEUR ABBAS M.ABBAS 
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
      IMPLICIT     NONE
      INTEGER      IZONE
      CHARACTER*8  NOMA
      CHARACTER*24 NEWGEO
      CHARACTER*24 DEFICO
      CHARACTER*24 RESOCO
      INTEGER      IESCL0 
      INTEGER      NFESCL        
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODES DISCRETES - APPARIEMENT - MAIT/ESCL)
C
C RECHERCHE POUR CHAQUE NOEUD ESCLAVE LA MAILLE MAITRE LA PLUS 
C PROCHE ET REALISE L'APPARIEMENT (ECRITURE DE LA RELATION CINEMATIQUE)
C
C ----------------------------------------------------------------------
C
C
C APPARIEMENT MAITRE/ESCLAVE (NOEUD/MAILLE):
C  - RECHERCHE NOEUD MAITRE LE PLUS PROCHE DE NOEUD ESCLAVE
C  - RECHERCHE MAILLE MAITRE ATTACHEE AU NOEUD MAITRE  LE PLUS PROCHE 
C     DE NOEUD ESCLAVE
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  IZONE  : NUMERO DE LA ZONE DE CONTACT
C IN  NEWGEO : GEOMETRIE ACTUALISEE EN TENANT COMPTE DU CHAMP DE
C              DEPLACEMENTS COURANT
C IN  DEFICO : SD DE DEFINITION DU CONTACT (ISSUE D'AFFE_CHAR_MECA)
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C IN  IESCL0 : INDICE DU PREMIER NOEUD ESCLAVE A EXAMINER
C OUT NFESCL : NOMBRE DE NOEUDS ESCLAVES DE LA ZONE
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      IFM,NIV  
      CHARACTER*8  K8BID
      REAL*8       R8BID
      INTEGER      VALI(2)      
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()      
      CALL INFDBG('CONTACT',IFM,NIV) 
C   
C --- AFFICHAGE
C 
      VALI(1) = IZONE
      CALL CFIMPD(IFM   ,NIV  ,'RECHME',1, 
     &            VALI  ,R8BID,K8BID)            
C
C --- RECHERCHE DU NOEUD MAITRE LE PLUS PROCHE
C
      CALL RECHMN(NOMA  ,NEWGEO,DEFICO,RESOCO,IZONE,
     &            IESCL0)
C
C --- RECHERCHE DE LA MAILLE MAITRE LA PLUS PROCHE
C
      CALL CHMANO(NOMA  ,IZONE ,NEWGEO,DEFICO,RESOCO,
     &            IESCL0,NFESCL)    
C     
      CALL JEDEMA ()
      END
