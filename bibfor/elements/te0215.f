      SUBROUTINE TE0215 ( OPTION , NOMTE )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 11/01/2011   AUTEUR SFAYOLLE S.FAYOLLE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE SFAYOLLE S.FAYOLLE
      IMPLICIT NONE
      CHARACTER*16        OPTION , NOMTE

C ----------------------------------------------------------------------
C FONCTION REALISEE:  CALCUL DE L'OPTION FORC_NODA POUR LES ELEMENTS
C                     INCOMPRESSIBLES A 2 CHAMPS (EN 2D ET AXI)
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................

C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

      LOGICAL AXI, LTEATT

      INTEGER I,N,KK, ICOMPO,IDFDE2,JGANO,NDIM,NNOS,NPG2
      INTEGER NNO1,NNO2,NPG1,IPOIDS,IVF1,IVF2,IDFDE1,J
      INTEGER ICONT,IGEOM,IVECTU,IDEPLM,IBID,IMATE

      REAL*8  DFDI(18), FINTU(2,9), FINTA(1,4)
      REAL*8  DEPLM(2,9),GONFLM(1,4)

      CHARACTER*8  ELREFE,ELREF2,ALIAS8
C--------------------------------------------------------------------

      IF(OPTION(1:9) .NE. 'FORC_NODA') CALL ASSERT(.FALSE.)

C - INITIALISATION
      AXI  = LTEATT(' ','AXIS','OUI')

C -  CARACTERISTIQUES GEOMETRIQUES DE L'ELEMENT DE REFERENCE
      CALL ELREF1(ELREFE)

      CALL TEATTR(' ','S','ALIAS8',ALIAS8,IBID)

      IF (ALIAS8(6:7).EQ.'TR') THEN
        ELREF2 = 'TR3'
      ELSEIF (ALIAS8(6:7).EQ. 'QU'  ) THEN
        ELREF2 = 'QU4'
      ELSE
        CALL U2MESK('F','DVP_4',1,NOMTE(7:10))
      ENDIF

      CALL ELREF4(ELREFE,'RIGI',NDIM,NNO1,NNOS,NPG1,IPOIDS,IVF1,
     &                                              IDFDE1,JGANO)
      CALL ELREF4(ELREF2,'RIGI',NDIM,NNO2,NNOS,NPG2,IPOIDS,IVF2,
     &                                              IDFDE2,JGANO)

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PCONTMR','L',ICONT)
      CALL JEVECH('PDEPLMR','L',IDEPLM)
      CALL JEVECH('PVECTUR','E',IVECTU)
      CALL JEVECH('PCOMPOR','L',ICOMPO)

C - REMISE EN FORME DES DONNEES
      KK = 0
      DO 10 N = 1, NNO1
        DO 20 I = 1,3
          IF (I.LE.2) THEN
            DEPLM(I,N) = ZR(IDEPLM+KK)
            KK = KK + 1
          END IF
          IF (I.GE.3 .AND. N.LE.NNO2) THEN
            GONFLM(I-2,N) = ZR(IDEPLM+KK)
            KK = KK + 1
          END IF
 20     CONTINUE
 10   CONTINUE


C - CALCUL DES FORCES INTERIEURES
      IF (ZK16(ICOMPO+2) (1:6).EQ.'PETIT ') THEN
        IF ( ALIAS8(6:8).EQ.'TR3') THEN
          CALL NIFN2B(NNO1, NNO2,NPG1,IPOIDS,IVF1,IVF2,IDFDE1,
     &                DFDI,ZR(IGEOM),AXI,ZR(ICONT),ZI(IMATE),
     &                ZK16(ICOMPO),DEPLM,GONFLM,FINTU , FINTA )
        ELSE
          CALL NIFN2C(NNO1, NNO2,NPG1,IPOIDS,IVF1,IVF2,IDFDE1,
     &                DFDI,ZR(IGEOM),AXI,ZR(ICONT),ZI(IMATE),
     &                ZK16(ICOMPO),DEPLM,GONFLM,FINTU , FINTA )
        END IF
      ELSE IF (ZK16(ICOMPO+2) (1:10).EQ.'SIMO_MIEHE') THEN
        CALL U2MESS('F','ELEMENTS5_9')
      ELSE
        CALL U2MESK('F','ELEMENTS3_16',1,ZK16(ICOMPO+2))
      END IF

C - STOCKAGE DES FORCES INTERIEURES
      KK = 0
      DO 30 N = 1, NNO1
        DO 40 I = 1,3
          IF (I.LE.2) THEN
            ZR(IVECTU+KK) = FINTU(I,N)
            KK = KK + 1
          END IF
          IF (I.GE.3 .AND. N.LE.NNO2) THEN
            ZR(IVECTU+KK) = FINTA(I-2,N)
            KK = KK + 1
          END IF
 40     CONTINUE
 30   CONTINUE

      END
