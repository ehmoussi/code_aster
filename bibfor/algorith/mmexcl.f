      SUBROUTINE MMEXCL(DEFICO,NOMA,IZONE,POSMA,NBN,
     &                  NPEX,INI1,INI2,INI3)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 11/09/2007   AUTEUR KHAM M.KHAM 
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
C
      IMPLICIT NONE
      CHARACTER*24 DEFICO
      CHARACTER*8  NOMA
      INTEGER      POSMA,IZONE,NBN,NPEX,INI1,INI2,INI3
C
C ----------------------------------------------------------------------
C ROUTINE APPELLEE PAR : MAPPAR
C ----------------------------------------------------------------------
C
C DIT SI UNE MAILLE ESCLAVE CONTIENT UN NOEUD EXCLUS PAR SANS_NOEUD OU
C SANS_GROUP_NO
C
C IN  DEFICO : SD POUR LA DEFINITION DE CONTACT
C IN  NOMA   : NOM DU MAILLAGE
C IN  IZONE  : NUMERO DE LA ZONE DE CONTACT
C IN  POSMA  : NUMERO DE LA MAILLE ESCLAVE
C IN  NBN    : NOMBRE DE POINTS DE CONTACT DE LA MAILLE ESCLAVE
C               /!\  DEPEND DE LA MAILLE ET DU SCHEMA INTEGRATION
C OUT NPEX   : NOMBRE DE NOEUDS A EXCLURE SUR LA MAILLE
C OUT INI1   : NUMERO DU PREMIER NOEUD A EXCLURE
C OUT INI2   : NUMERO DU DEUXIEME NOEUD A EXCLURE
C OUT INI3   : NUMERO DU TROISIEME NOEUD A EXCLURE
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
      CHARACTER*24 NOMACO,PNOMA,CONTNO,FROTNO,PFROT,COTAMA
      INTEGER      JNOMA,JPONO,JNOCO,JSANS,JPSANS,JMACO
      INTEGER      INI,SUPPOK,POSNOE,NUMNOE,NSANS,NUMSAN,K,NUMA
      INTEGER      IBID
      REAL*8       R8BID
      CHARACTER*24 K24BID,K24BLA
      DATA         K24BLA /' '/
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C      
      NOMACO = DEFICO(1:16) // '.NOMACO'
      PNOMA  = DEFICO(1:16) // '.PNOMACO'
      CONTNO = DEFICO(1:16) // '.NOEUCO'
      FROTNO = DEFICO(1:16) // '.SANOFR'
      PFROT  = DEFICO(1:16) // '.PSANOFR' 
      COTAMA = DEFICO(1:16) // '.MAILCO'           
      CALL JEVEUO(NOMACO,'L',JNOMA)
      CALL JEVEUO(PNOMA ,'L',JPONO)
      CALL JEVEUO(CONTNO,'L',JNOCO)
      CALL JEVEUO(FROTNO,'L',JSANS)
      CALL JEVEUO(PFROT ,'L',JPSANS) 
      CALL JEVEUO(COTAMA,'L',JMACO)           
C
C --- ON TESTE SI LA MAILLE CONTIENT UN NOEUD INTERDIT DANS
C --- SANS_GROUP_NO_FR OU SANS_NOEUD_FR
C
      DO 50 INI = 1,NBN
        SUPPOK = 0
        POSNOE = ZI(JNOMA+ZI(JPONO+POSMA-1)+INI-1)
        NUMNOE = ZI(JNOCO+POSNOE-1)
        NSANS  = ZI(JPSANS+IZONE) - ZI(JPSANS+IZONE-1)
        DO 30 K = 1,NSANS
          NUMSAN = ZI(JSANS+ZI(JPSANS+IZONE-1)+K-1)
          IF (NUMNOE .EQ. NUMSAN) THEN
            SUPPOK = 1
            GOTO 40
          END IF
 30     CONTINUE 
 40     CONTINUE 
        IF (SUPPOK .EQ. 1) THEN
          NPEX = NPEX + 1
          IF (NPEX .EQ. 1) THEN
           INI1 = INI
          ELSEIF (NPEX .EQ. 2) THEN
           INI2 = INI
          ELSE
           INI3 = INI
          END IF
        END IF
 50   CONTINUE
 
      IF (NPEX.GT.3) THEN
        NUMA  = ZI(JMACO+POSMA-1)
        CALL MMERRO(DEFICO,K24BLA,NOMA,'MMEXCL','F','TROP_NDS',
     &              NUMA,IBID,IBID,IBID,R8BID,K24BID) 
      ENDIF
C
      CALL JEDEMA()      
      END
