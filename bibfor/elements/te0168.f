      SUBROUTINE TE0168(OPTION,NOMTE)
      IMPLICIT   NONE
      CHARACTER*16 OPTION,NOMTE
C ......................................................................
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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

C    - FONCTION REALISEE:  CALCUL MATRICE DE MASSE MECABLE
C                          OPTION : 'MASS_MECA'

C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................

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

      CHARACTER*2 CODRET
      REAL*8 A,RHO,BILINE,COEF,JACOBI,EN(3,2),R8B
      REAL*8 MATP(6,6),MATV(21)
      INTEGER NNO,NPG,K,KP,I,II,JJ,KI,KY,NDDL,NVEC,IMATUU,LSECT
      INTEGER IPOIDS,IVF,IYTY,IGEOM,IMATE,IACCE,IVECT
      INTEGER NDIM,NNOS,JGANO,IDFDK
C ......................................................................


      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDK,JGANO)
      CALL JEVETE('&INEL.CABPOU.YTY','L',IYTY)
      NDDL = 3*NNO
      NVEC = NDDL* (NDDL+1)/2

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)

      CALL RCVALA(ZI(IMATE),' ','ELAS',0,' ',R8B,1,'RHO',RHO,
     &             CODRET,'FM')
      CALL JEVECH('PCACABL','L',LSECT)
      A = ZR(LSECT)

      K = 0
      DO 20 KP = 1,NPG
        DO 10 I = 1,NNO
          K = K + 1
          EN(I,KP) = ZR(IVF-1+K)
   10   CONTINUE
   20 CONTINUE

      DO 30 K = 1,NVEC
        MATV(K) = 0.0D0
   30 CONTINUE

      DO 70 KP = 1,NPG
        KY = (KP-1)*NDDL*NDDL
        JACOBI = SQRT(BILINE(NDDL,ZR(IGEOM),ZR(IYTY+KY),ZR(IGEOM)))
        COEF = RHO*A*JACOBI*ZR(IPOIDS-1+KP)
        K = 0
        DO 60 II = 1,NNO
          DO 50 KI = 1,3
            K = K + KI - 3
            DO 40 JJ = 1,II
              K = K + 3
              MATV(K) = MATV(K) + COEF*EN(II,KP)*EN(JJ,KP)
   40       CONTINUE
   50     CONTINUE
   60   CONTINUE
   70 CONTINUE

      IF (OPTION.EQ.'MASS_MECA') THEN

        CALL JEVECH('PMATUUR','E',IMATUU)

        DO 80 I = 1,NVEC
          ZR(IMATUU+I-1) = MATV(I)
   80   CONTINUE

      ELSE IF (OPTION.EQ.'M_GAMMA') THEN

        CALL JEVECH('PDEPLAR','L',IACCE)
        CALL JEVECH('PVECTUR','E',IVECT)

        CALL VECMA(MATV,NVEC,MATP,NDDL)
        CALL PMAVEC('ZERO',NDDL,MATP,ZR(IACCE),ZR(IVECT))

      ELSE
        CALL U2MESS('F','ELEMENTS2_67')
      END IF

      END
