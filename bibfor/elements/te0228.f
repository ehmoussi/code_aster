      SUBROUTINE TE0228(OPTION,NOMTE)
      IMPLICIT   NONE
      CHARACTER*16 OPTION,NOMTE
C ......................................................................
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 23/08/2011   AUTEUR DELMAS J.DELMAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C .  - FONCTION REALISEE:  CALCUL  DEFORMATIONS GENERALISEES AUX NOEUDS
C .                        COQUE 1D
C .
C .                        OPTIONS : 'DEGE_ELNO  '
C .                        ELEMENT: MECXSE3,METCSE3,METDSE3
C .
C .  - ARGUMENTS:
C .      DONNEES:      OPTION       -->  OPTION DE CALCUL
C .                    NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................
C --------- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------
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
C --------- FIN  DECLARATIONS NORMALISEES JEVEUX -----------------------

      INTEGER I,K,KP,IGEOM,IDEPL,IDEFOR,NNO,NNOS,JGANO,NDIM,NPG
      INTEGER IVF,IDFDK,IPOIDS
      CHARACTER*8 ELREFE
      REAL*8 DFDX(3),DEGEPG(24)
      REAL*8 COSA,SINA,COUR,R,ZERO,JAC
      REAL*8 EPS(5),E11,E22,K11,K22


      CALL ELREF1(ELREFE)
      ZERO = 0.0D0


      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDK,JGANO)

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PDEPLAR','L',IDEPL)
      CALL JEVECH('PDEFOGR','E',IDEFOR)

      DO 30 KP = 1,NPG
        K = (KP-1)*NNO
        CALL DFDM1D(NNO,ZR(IPOIDS+KP-1),ZR(IDFDK+K),ZR(IGEOM),DFDX,COUR,
     &              JAC,COSA,SINA)
        DO 10 I = 1,5
          EPS(I) = ZERO
   10   CONTINUE
        R = ZERO
        DO 20 I = 1,NNO
          EPS(1) = EPS(1) + DFDX(I)*ZR(IDEPL+3*I-3)
          EPS(2) = EPS(2) + DFDX(I)*ZR(IDEPL+3*I-2)
          EPS(3) = EPS(3) + DFDX(I)*ZR(IDEPL+3*I-1)
          EPS(4) = EPS(4) + ZR(IVF+K+I-1)*ZR(IDEPL+3*I-3)
          EPS(5) = EPS(5) + ZR(IVF+K+I-1)*ZR(IDEPL+3*I-1)
          R = R + ZR(IVF+K+I-1)*ZR(IGEOM+2* (I-1))
   20   CONTINUE
        E11 = EPS(2)*COSA - EPS(1)*SINA
        K11 = EPS(3)
        IF (NOMTE.EQ.'MECXSE3') THEN
          E22 = EPS(4)/R
          K22 = -EPS(5)*SINA/R
        ELSE
          E22 = ZERO
          K22 = ZERO
        END IF

        DEGEPG(6* (KP-1)+1) = E11
        DEGEPG(6* (KP-1)+2) = E22
        DEGEPG(6* (KP-1)+3) = ZERO
        DEGEPG(6* (KP-1)+4) = K11
        DEGEPG(6* (KP-1)+5) = K22
        DEGEPG(6* (KP-1)+6) = ZERO
   30 CONTINUE


C     -- PASSAGE GAUSS -> NOEUDS :
      CALL PPGAN2(JGANO,1,6,DEGEPG,ZR(IDEFOR))

      END
