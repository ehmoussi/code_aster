      SUBROUTINE TE0012(OPTION,NOMTE)
      IMPLICIT   NONE
C.......................................................................
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 16/12/2004   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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

C     BUT: CALCUL DES MATRICES DE MASSE ELEMENTAIRES EN MECANIQUE
C          ELEMENTS ISOPARAMETRIQUES 3D

C          OPTION : 'MASS_MECA'
C          OPTION : 'MASS_MECA_DIAG'
C          OPTION : 'M_GAMMA'
C          OPTION : 'ECIN_ELEM_DEPL'

C     ENTREES  ---> OPTION : OPTION DE CALCUL
C              ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................

C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
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
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------

      CHARACTER*2 CODRET

      CHARACTER*16 NOMTE,OPTION,PHENOM
      CHARACTER*8 ELREFE
      REAL*8 A(3,3,27,27),MATP(27,27),MATV(378)
      REAL*8 DFDX(27),DFDY(27),DFDZ(27),TPG,POIDS,RHO
      INTEGER IPOIDS,IVF,IDFDE,IGEOM,IMATE
      INTEGER JGANO,NNO,KP,I,J,K,IMATUU,ITEMPE,IACCE,IVECT
      INTEGER IJKL,IK,L,NDIM,NPG,NDDL,NVEC
      INTEGER IDIAG,NNOS
      INTEGER IVITE,IECIN,IFREQ
      REAL*8 TRACE,ALFA,WGT,MASVIT(27),DDOT
C.......................................................................

      CALL ELREF1(ELREFE)
      IF (ELREFE.EQ.'HE8') THEN
        CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)
      ELSE
        CALL ELREF4(' ','MASS',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)
      END IF
      NDDL = 3*NNO
      NVEC = NDDL* (NDDL+1)/2

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PTEMPER','L',ITEMPE)
      CALL RCCOMA(ZI(IMATE),'ELAS',PHENOM,CODRET)

      DO 50 K = 1,3
        DO 40 L = 1,3
          DO 30 I = 1,NNO
            DO 20 J = 1,I
              A(K,L,I,J) = 0.0D0
   20       CONTINUE
   30     CONTINUE
   40   CONTINUE
   50 CONTINUE

C    BOUCLE SUR LES POINTS DE GAUSS

      DO 90 KP = 1,NPG
        L = (KP-1)*NNO
        CALL DFDM3D ( NNO, KP, IPOIDS, IDFDE,
     &                ZR(IGEOM), DFDX, DFDY, DFDZ, POIDS )
        TPG = 0.0D0
        DO 60 I = 1,NNO
          TPG = TPG + ZR(ITEMPE+I-1)*ZR(IVF+L+I-1)
   60   CONTINUE
        CALL RCVALA(ZI(IMATE),' ',PHENOM,1,'TEMP',TPG,1,'RHO',RHO,
     &              CODRET,'FM')
        DO 80 I = 1,NNO
          DO 70 J = 1,I
            A(1,1,I,J) = A(1,1,I,J) + RHO*POIDS*ZR(IVF+L+I-1)*
     &                   ZR(IVF+L+J-1)
   70     CONTINUE
   80   CONTINUE
   90 CONTINUE

      DO 110 I = 1,NNO
        DO 100 J = 1,I
          A(2,2,I,J) = A(1,1,I,J)
          A(3,3,I,J) = A(1,1,I,J)
  100   CONTINUE
  110 CONTINUE

      IF (OPTION.EQ.'MASS_MECA') THEN

        CALL JEVECH('PMATUUR','E',IMATUU)

C PASSAGE DU STOCKAGE RECTANGULAIRE (A) AU STOCKAGE TRIANGULAIRE (ZR)

        DO 150 K = 1,3
          DO 140 L = 1,3
            DO 130 I = 1,NNO
              IK = ((3*I+K-4)* (3*I+K-3))/2
              DO 120 J = 1,I
                IJKL = IK + 3* (J-1) + L
                ZR(IMATUU+IJKL-1) = A(K,L,I,J)
  120         CONTINUE
  130       CONTINUE
  140     CONTINUE
  150   CONTINUE

      ELSE IF (OPTION.EQ.'MASS_MECA_DIAG') THEN

        CALL JEVECH('PMATUUR','E',IMATUU)

C-- CALCUL DE LA MASSE DE L'ELEMENT

        WGT = A(1,1,1,1)
        DO 170 I = 2,NNO
          DO 160 J = 1,I - 1
            WGT = WGT + 2*A(1,1,I,J)
  160     CONTINUE
          WGT = WGT + A(1,1,I,I)
  170   CONTINUE

C-- CALCUL DE LA TRACE EN TRANSLATION SUIVANT X

        TRACE = 0.D0
        DO 180 I = 1,NNO
          TRACE = TRACE + A(1,1,I,I)
  180   CONTINUE

C-- CALCUL DU FACTEUR DE DIAGONALISATION

        ALFA = WGT/TRACE

C PASSAGE DU STOCKAGE RECTANGULAIRE (A) AU STOCKAGE TRIANGULAIRE (ZR)

        K = 0
        DO 200 J = 1,NNO
          DO 190 I = 1,3
            K = K + 1
            IDIAG = K* (K+1)/2
            ZR(IMATUU+IDIAG-1) = A(I,I,J,J)*ALFA
  190     CONTINUE
  200   CONTINUE

      ELSE IF (OPTION.EQ.'M_GAMMA') THEN

        CALL JEVECH('PDEPLAR','L',IACCE)
        CALL JEVECH('PVECTUR','E',IVECT)
        DO 210 K = 1,NVEC
          MATV(K) = 0.0D0
  210   CONTINUE
        DO 250 K = 1,3
          DO 240 L = 1,3
            DO 230 I = 1,NNO
              IK = ((3*I+K-4)* (3*I+K-3))/2
              DO 220 J = 1,I
                IJKL = IK + 3* (J-1) + L
                MATV(IJKL) = A(K,L,I,J)
  220         CONTINUE
  230       CONTINUE
  240     CONTINUE
  250   CONTINUE
        CALL VECMA(MATV,NVEC,MATP,NDDL)
        CALL PMAVEC('ZERO',NDDL,MATP,ZR(IACCE),ZR(IVECT))

C OPTION ECIN_ELEM_DEPL : CALCUL DE L'ENERGIE CINETIQUE

      ELSE IF (OPTION.EQ.'ECIN_ELEM_DEPL') THEN

        CALL JEVECH('PDEPLAR','L',IVITE)
        CALL JEVECH('PENERCR','E',IECIN)
        CALL JEVECH('PFREQR','E',IFREQ)

        DO 260 K = 1,NVEC
          MATV(K) = 0.0D0
  260   CONTINUE
        DO 300 K = 1,3
          DO 290 L = 1,3
            DO 280 I = 1,NNO
              IK = ((3*I+K-4)* (3*I+K-3))/2
              DO 270 J = 1,I
                IJKL = IK + 3* (J-1) + L
                MATV(IJKL) = A(K,L,I,J)
  270         CONTINUE
  280       CONTINUE
  290     CONTINUE
  300   CONTINUE
        CALL VECMA(MATV,NVEC,MATP,NDDL)
        CALL PMAVEC('ZERO',NDDL,MATP,ZR(IVITE),MASVIT)

        ZR(IECIN) = .5D0*DDOT(NDDL,ZR(IVITE),1,MASVIT,1)*ZR(IFREQ)

      ELSE
        CALL UTMESS('F','TE0012','OPTION NON TRAITEE')
      END IF

      END
