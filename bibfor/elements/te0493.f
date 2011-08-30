      SUBROUTINE TE0493(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 29/08/2011   AUTEUR GRANET S.GRANET 
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
C ======================================================================
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*16 OPTION,NOMTE
C ......................................................................

C     BUT: CALCUL DU FLUX HYDRAULIQUE NORMAL
C          SUR DES ELEMENTS DE BORD DE 3D (FACE8 ET FACE6)
C          OPTION : 'FLHN_ELGA'

C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................

      REAL*8 NX,NY,NZ,FLX,FLY,FLZ,FLUN,S,T,U,JAC
      REAL*8 SX(4,4),SY(4,4),SZ(4,4)
      INTEGER NNO,KP,NPG,IPOIDS,IVF,IDFDX,IDFDY,IGEOM
      INTEGER IFLUX,IVECTU,K,I,IAD
      INTEGER IDEC,JDEC,KDEC
      CHARACTER*24 VALKM(3)
      LOGICAL TRIA

C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

      TRIA = .FALSE.
C  CALCUL DU NBRE DE CMP CALCULEES DU FLUX
      IF(NOMTE.EQ.'HM_FACE8'.OR.NOMTE.EQ.'THM_FACE8'.OR.
     &   NOMTE.EQ.'H_FACE8'  ) THEN
         NBFLUX=1
      ELSEIF(NOMTE.EQ.'HM_FACE6'.OR.NOMTE.EQ.'THM_FACE6'.OR.
     & NOMTE.EQ.'H_FACE6') THEN
         NBFLUX=1
         TRIA = .TRUE.
      ELSEIF(NOMTE.EQ.'THV_FACE8') THEN
         NBFLUX=2
      ELSEIF(NOMTE.EQ.'THV_FACE6') THEN
         NBFLUX=2
         TRIA = .TRUE.
      ELSEIF(NOMTE.EQ.'HHM_FACE8'.OR.NOMTE.EQ.'THH_FACE8'
     &.OR.NOMTE.EQ.'THHM_FACE8'.OR.NOMTE.EQ.'HH_FACE8') THEN
         NBFLUX=3
      ELSEIF(NOMTE.EQ.'HHM_FACE6'.OR.NOMTE.EQ.'THH_FACE6'
     &.OR.NOMTE.EQ.'THHM_FACE6'.OR.NOMTE.EQ.'HH_FACE6') THEN
         NBFLUX=3
         TRIA = .TRUE.
      ELSEIF(NOMTE.EQ.'HH2M_FACE8'.OR.NOMTE.EQ.'THH2_FACE8'
     &.OR.NOMTE.EQ.'THH2M_FACE8'.OR.NOMTE.EQ.'HH2_FACE8') THEN
         NBFLUX=4
      ELSEIF(NOMTE.EQ.'HH2M_FACE6'.OR.NOMTE.EQ.'THH2_FACE6'
     &.OR.NOMTE.EQ.'THH2M_FACE6'.OR.NOMTE.EQ.'HH2_FACE6') THEN
         NBFLUX=4
         TRIA = .TRUE.
      ELSE
         VALKM(1)=OPTION
         VALKM(2)=NOMTE
         VALKM(3)='TE0493'
         CALL U2MESK('F','CALCULEL7_2',3,VALKM)
      ENDIF
C
      IF(TRIA) THEN
        CALL ELREF4('TR3','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDX,
     &               JGANO)
      ELSE
        CALL ELREF4('QU4','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDX,
     &               JGANO)
      ENDIF
      IDFDY=IDFDX+1
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PCONTR','L',IFLUX)
      CALL JEVECH('PFLHN','E',IVECTU)
C
C --- CALCUL DES PRODUITS VECTORIELS OMI X OMJ ---
C
      DO 20 INO = 1,NNO
         I = IGEOM + 3*(INO-1) -1
         DO 22 JNO = 1,NNO
            J = IGEOM + 3*(JNO-1) -1
            SX(INO,JNO) = ZR(I+2) * ZR(J+3) - ZR(I+3) * ZR(J+2)
            SY(INO,JNO) = ZR(I+3) * ZR(J+1) - ZR(I+1) * ZR(J+3)
            SZ(INO,JNO) = ZR(I+1) * ZR(J+2) - ZR(I+2) * ZR(J+1)
 22      CONTINUE
 20   CONTINUE
C
C    BOUCLE SUR LES CMP
      DO 100 IFL = 1,NBFLUX

C    BOUCLE SUR LES POINTS DE GAUSS
        DO 40 KP = 1,NPG
          K = (KP-1)*NNO
C CALCUL DES FLUX AU POINT DE GAUSS KP A PARTIR DES FLUX AUX NOEUDS
          S = 0.D0
          T = 0.D0
          U = 0.D0
          DO 10 I = 1,NNO
            IAD = IFLUX+3*(IFL-1)+3*NBFLUX*(I-1)
            S = S + ZR(IAD  )*ZR(IVF+K+I-1)
            T = T + ZR(IAD+1)*ZR(IVF+K+I-1)
            U = U + ZR(IAD+2)*ZR(IVF+K+I-1)
   10     CONTINUE
          FLX = S
          FLY = T
          FLZ = U
C --- CALCUL DE LA NORMALE AU POINT DE GAUSS KP ---
          NX = 0.0D0
          NY = 0.0D0
          NZ = 0.0D0
          KDEC = (KP-1)*NNO*NDIM
          DO 102 I=1,NNO
            IDEC = (I-1)*NDIM
            DO 102 J=1,NNO
              JDEC = (J-1)*NDIM
              NX = NX + ZR(IDFDX+KDEC+IDEC)*ZR(IDFDY+KDEC+JDEC)*SX(I,J)
              NY = NY + ZR(IDFDX+KDEC+IDEC)*ZR(IDFDY+KDEC+JDEC)*SY(I,J)
              NZ = NZ + ZR(IDFDX+KDEC+IDEC)*ZR(IDFDY+KDEC+JDEC)*SZ(I,J)
 102        CONTINUE
          JAC = SQRT(NX*NX+NY*NY+NZ*NZ)
          FLUN = (NX*FLX + NY*FLY + NZ*FLZ)/JAC
          ZR(IVECTU+NBFLUX*(KP-1)+IFL-1) = FLUN
   40   CONTINUE
100   CONTINUE
C
      END
