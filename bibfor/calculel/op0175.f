      SUBROUTINE OP0175()
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 11/10/2010   AUTEUR PELLET J.PELLET 
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
C ======================================================================
C     COMMANDE :  CALC_FERRAILLAGE
C ----------------------------------------------------------------------
      IMPLICIT NONE
C   ----- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER        ZI
      COMMON /IVARJE/ZI(1)
      REAL*8         ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16     ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL        ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8    ZK8
      CHARACTER*16          ZK16
      CHARACTER*24                  ZK24
      CHARACTER*32                          ZK32
      CHARACTER*80                                  ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     ----- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      INTEGER      IFM,NIV,N0,NUORD,NCHAR,IBID,IERD,JORDR
      INTEGER      IRET,IRANG,IEXCIT,JPARA,IE,NBORDR,I,NUORDR
      CHARACTER*4  CTYP
      CHARACTER*8  RESU,MODELE,CARA,CHMAT,K8B
      CHARACTER*16 NOMCMD,CONCEP,CRIT
      CHARACTER*19 CHFER1,CHFER2, CHEFGE, RESU19,EXCIT
      REAL*8 RBID,PREC
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
C

      CALL INFMAJ()
      CALL INFNIV(IFM,NIV)

      CALL GETVID(' ','RESULTAT',1,1,1,RESU,N0)
      RESU19=RESU

C     -- CHOIX DES INSTANTS DE CALCUL :
C     ---------------------------------
      CALL GETVR8(' ','PRECISION',0,1,1,PREC,IE)
      CALL GETVTX(' ','CRITERE'  ,0,1,1,CRIT,IE)
      CALL RSUTNU(RESU19,' ',0,'&&OP0175.NUME_ORDRE',NBORDR,PREC,
     &            CRIT,IRET)
      CALL ASSERT(IRET.EQ.0)
      CALL ASSERT(NBORDR.GT.0)
      CALL JEVEUO('&&OP0175.NUME_ORDRE','L',JORDR)


C     -- ON PREND LE MODELE POUR LE 1ER INSTANT :
C     --------------------------------------------
      NUORD = ZI(JORDR-1+1)

      CALL RSADPA(RESU,'L',1,'MODELE',NUORD,0,JPARA,K8B)
      MODELE=ZK8(JPARA)
      CALL ASSERT(MODELE.NE.' ')
      CALL RSADPA(RESU,'L',1,'CARAELEM',NUORD,0,JPARA,K8B)
      CARA=ZK8(JPARA)
      CALL ASSERT(CARA.NE.' ')



C     -- 1. ON CREE LE CHAMP DE DONNEES (CHFER1) :
C     ---------------------------------------------
      CHFER1='&&OP0175.CHFER1'
      CALL W175AF(MODELE,CHFER1)
      IF (NIV.GT.1) CALL IMPRSD('CHAMP',CHFER1,6,'CHFER1=')



C     -- 2. ON APPELLE L'OPTION CALC_FERRAILLAGE :
C     -------------------------------------------
      DO 20,I = 1,NBORDR
        NUORDR = ZI(JORDR+I-1)
        CALL RSEXCH(RESU19,'EFGE_ELNO_DEPL',NUORDR,CHEFGE,IRET)
        CALL ASSERT(IRET.EQ.0)

        CALL RSEXCH(RESU19,'FERRAILLAGE',NUORDR,CHFER2,IRET)

        CALL W175CA(MODELE,CARA,CHFER1,CHEFGE,CHFER2)

        IF (NIV.GT.1) CALL IMPRSD('CHAMP',CHFER2,6,'CHFER2=')
        CALL RSNOCH(RESU19,'FERRAILLAGE',NUORDR,' ')
 20   CONTINUE

 9999 CONTINUE

      CALL JEDEMA()
      END
