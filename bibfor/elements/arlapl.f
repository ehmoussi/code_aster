      SUBROUTINE ARLAPL(NDIM  ,NNS ,NN1   ,NN2 ,LCARA ,LINCLU,NOMTE,
     &                  JCOORS,NPGS,IPOIDS,IVFS,IDFDES              )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 08/06/2009   AUTEUR DELMAS J.DELMAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2009  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT     NONE
      INTEGER      NDIM,NNS,NN1,NN2
      REAL*8       LCARA
      CHARACTER*6  LINCLU
      CHARACTER*16 NOMTE
      INTEGER      JCOORS
      INTEGER      NPGS,IPOIDS,IVFS,IDFDES
C
C ----------------------------------------------------------------------
C
C CALCUL DES MATRICES DE COUPLAGE ARLEQUIN
C OPTION ARLQ_MATR
C
C CREATION DES 2 MATRICES DE COUPLAGE POUR LES ELEMENTS ISOPARAMETRIQUES
C 2D, 3D
C
C
C ----------------------------------------------------------------------
C
C IN  NDIM   : DIMENSION DU PROBLEME
C IN  NNS    : NOMBRE DE NOEUDS DE LA MAILLE SUPPORT
C IN  NN1    : NOMBRE DE NOEUDS DE LA MAILLE 1
C IN  NN2    : NOMBRE DE NOEUDS DE LA MAILLE 2
C IN  LCARA  : LONGUEUR CARACTERISTIQUE POUR TERME DE COUPLAGE (PONDERA
C              TION DES TERMES DE COUPLAGE)
C IN  LINCLU : TYPE D'INCLUSION
C IN  NOMTE  : NOM DU TYPE_ELEMENT MAILLE SUPPORT S
C IN  JCOORS : POINTEUR VERS COORD. NOEUDS DE LA MAILLE SUPPORT S
C IN  NPGS   : NOMBRE DE POINTS DE GAUSS DE LA MAILLE SUPPORT S
C IN  IPOIDS : POINTEUR VERS POIDS DE GAUSS DE LA MAILLE SUPPORT S
C IN  IVFS   : POINTEUR VERS FONCTIONS DE FORME DE LA MAILLE SUPPORT S
C IN  IDFDES : POINTEUR VERS DER. FONCTIONS DE FORME DE LA MAILLE S
C
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      INTEGER      JREFE1,JREFE2,JCOOR1,JCOOR2
      REAL*8       MCPLN1(NN1,NN1)
      REAL*8       MCPLN2(NN1,NN2)
      REAL*8       MCPLB1(NDIM*NN1,NDIM*NN1)
      REAL*8       MCPLB2(NDIM*NN1,NDIM*NN2)
      REAL*8       MCPLC1(NDIM*NN1,NDIM*NN1)
      REAL*8       MCPLC2(NDIM*NN1,NDIM*NN2)
      CHARACTER*8  ELRF1,ELRF2
      INTEGER      I,J,IJKL1,IJKL2,IMATU1,IMATU2
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- ACCES INFOS MAILLES COUPLEES
C
      CALL JEVECH('PREFE1K','L',JREFE1)
      ELRF1 = ZK8(JREFE1)
      CALL JEVECH('PCOOR1R','L',JCOOR1)
C
      CALL JEVECH('PREFE2K','L',JREFE2)
      ELRF2 = ZK8(JREFE2)
      CALL JEVECH('PCOOR2R','L',JCOOR2)
C
C --- CALCUL DES TERMES COMPOSANT LES MATRICES DE COUPLAGE
C
      CALL ARLTEM(LINCLU,NDIM  ,NOMTE ,
     &            NNS   ,JCOORS,
     &            NPGS , IVFS  ,IDFDES,IPOIDS,
     &            ELRF1, NN1   ,JCOOR1,
     &            ELRF2, NN2   ,JCOOR2,
     &            MCPLN1,MCPLN2,MCPLB1,MCPLB2)
C
C --- ASSEMBLAGE DE LA MATRICE DE MASSE
C
      CALL ARLTEC(NN1   ,NN1   ,NDIM  ,LCARA ,
     &            MCPLN1,MCPLB1,MCPLC1)
C
C --- ASSEMBLAGE DE LA MATRICE MORTAR
C
      CALL ARLTEC(NN1   ,NN2   ,NDIM  ,LCARA ,
     &            MCPLN2,MCPLB2,MCPLC2)
C
C --- RECOPIE DES TERMES DE LA MATRICE DE MASSE  ET DE LA MATRICE MORTAR
C
      CALL JEVECH('PMATUN1','E',IMATU1)
      CALL JEVECH('PMATUN2','E',IMATU2)
      IJKL1 = 0
      IJKL2 = 0
      DO 140 I = 1,NDIM*NN1
C
        DO 130 J = 1,NDIM*NN1
          IJKL1 = IJKL1 + 1
          ZR(IMATU1-1+IJKL1) = MCPLC1(I,J)
 130    CONTINUE
C
        DO 150 J = 1,NDIM*NN2
          IJKL2 = IJKL2 + 1
          ZR(IMATU2-1+IJKL2) = MCPLC2(I,J)
 150    CONTINUE
C
 140  CONTINUE
C
C --- MENAGE
C
      CALL JEDEMA()
C
      END
