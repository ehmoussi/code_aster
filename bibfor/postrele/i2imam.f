      SUBROUTINE I2IMAM (CONEC,TYPE,LSTMAI,NBMLST,CHEMIN,PTCHM,NBCHM,
     +                   MAIL1,MAIL2)
      IMPLICIT REAL*8 (A-H,O-Z)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF POSTRELE  DATE 21/02/96   AUTEUR VABHHTS J.PELLET 
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
C
C*********************************************************************
C
C     REPERAGE D' UN ENSEMBLE DE MAILLES LINEIQUES DANS UN
C     MAILLAGE 2D
C
C       CONEC  (IN)  : TABLE DE CONNECTIVITE DU MAILLAGE
C
C       TYPE   (IN)  : TABLE DES TYPE DE MAILLES
C
C       LSTMAI (IN)  : ENSEMBLE DE MAILLES A TRAITE
C
C       NBMLST (IN)  : NBR DE MAILLES DE L' ENSEMBLE A TRAITE
C
C       CHEMIN (OUT) : TABLE DE STRUCTURE DES CHEMINS TROUVES
C
C       PTCHM  (OUT) : TABLE D' ACCES A CHEMIN PAR NUMERO DE CHEMIN
C
C       NBCHM  (OUT) : NBR DE CHEMINS TROUVES
C
C       MAIL1  (OUT) : TABLE DES PREMIERES MAILLES SURFACIQUES
C                      CONTENANT UN ELEMENT DE L' ENSEMBLE
C
C       MAIL2  (OUT) : TABLE DES SECONDES MAILLES SURFACIQUES
C                      CONTENANT UN ELEMENT DE L' ENSEMBLE
C
C*********************************************************************
C
        CHARACTER*24 CONEC,TYPE
        INTEGER      LSTMAI(*),NBMLST,CHEMIN(*),PTCHM(*),NBCHM
        INTEGER      MAIL1(*),MAIL2(*)
C
C
C------------COMMUNS NORMALISES JEVEUX-------------------------------
C
      INTEGER              ZI
      COMMON      /IVARJE/ ZI(1)
      REAL*8               ZR
      COMMON      /RVARJE/ ZR(1)
      COMPLEX*16           ZC
      COMMON      /CVARJE/ ZC(1)
      LOGICAL              ZL
      COMMON      /LVARJE/ ZL(1)
      CHARACTER*8          ZK8
      CHARACTER*16         ZK16
      CHARACTER*24         ZK24
      CHARACTER*32         ZK32
      CHARACTER*80         ZK80
      COMMON      /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
        INTEGER      AV1,AV2,I
C
      CALL JEMARQ()
        I   = 0
        AV1 = 0
        AV2 = 0
C
        CALL JECREO ('&INTVOISIN1','V V I')
        CALL JEECRA ('&INTVOISIN1','LONMAX',NBMLST,' ')
        CALL JEVEUO ('&INTVOISIN1','E',AV1)
C
        CALL JECREO ('&INTVOISIN2','V V I')
        CALL JEECRA ('&INTVOISIN2','LONMAX',NBMLST,' ')
        CALL JEVEUO ('&INTVOISIN2','E',AV2)
C
        DO 10, I = 1, NBMLST, 1
C
           ZI(AV1 + I-1) = 0
           ZI(AV2 + I-1) = 0
C
10      CONTINUE
C
        CALL I2VOIS (CONEC,TYPE,LSTMAI,NBMLST,ZI(AV1),ZI(AV2))
        CALL I2TGRM (ZI(AV1),ZI(AV2),NBMLST,CHEMIN,PTCHM,NBCHM)
        CALL I2REPR (CONEC,TYPE,LSTMAI,CHEMIN,PTCHM,NBCHM,MAIL1,MAIL2)
C
        CALL JEDETR ('&INTVOISIN1')
        CALL JEDETR ('&INTVOISIN2')
C
      CALL JEDEMA()
      END
