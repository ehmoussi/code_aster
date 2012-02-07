      SUBROUTINE  PJ3DA1(INO2,GEOM2,I,GEOM1,TETR4,
     &              COBAR2,OK)
      IMPLICIT NONE
      REAL*8  COBAR2(4),GEOM1(*),GEOM2(*),EPSI
      INTEGER I,TETR4(*),INO2
      LOGICAL OK
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 07/02/2012   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     BUT :
C       DETERMINER SI LE TETR4 I CONTIENT LE NOEUD INO2
C       SI OUI :
C       DETERMINER LES COORDONNEES BARYCENTRIQUES DE INO2 DANS CE TETR4
C
C  IN   INO2       I  : NUMERO DU NOEUD DE M2 CHERCHE
C  IN   GEOM2(*)   R  : COORDONNEES DES NOEUDS DU MAILLAGE M2
C  IN   GEOM1(*)   R  : COORDONNEES DES NOEUDS DU MAILLAGE M1
C  IN   I          I  : NUMERO DU TETR4 CANDIDAT
C  IN   TETR4(*)   I  : OBJET '&&PJXXCO.TETR4'
C  OUT  COBAR2(4)  R  : COORDONNEES BARYCENTRIQUES DE INO2 DANS I
C  OUT  OK         L  : .TRUE. : INO2 APPARTIENT AU TETR4 I


C ----------------------------------------------------------------------
      INTEGER PERM(4),LINO(4),K,P
      REAL*8 P1(3),P2(3),P3(3),P4(3),PP(3),N(3),V12(3),V13(3),V14(3)
      REAL*8 VOL,VOLP,V1P(3)
      DATA PERM/2,3,4,1/
C DEB ------------------------------------------------------------------
      PP(1)=GEOM2(3*(INO2-1)+1)
      PP(2)=GEOM2(3*(INO2-1)+2)
      PP(3)=GEOM2(3*(INO2-1)+3)

      LINO(1)=4
      LINO(2)=1
      LINO(3)=2
      LINO(4)=3

      DO 10, P=1,4
C       -- ON PERMUTE LES 4 NOEUDS DU TETRAEDRE :
        DO 11, K=1,4
          LINO(K)=PERM(LINO(K))
11      CONTINUE

        DO 1, K=1,3
          P1(K)= GEOM1(3*(TETR4(1+6*(I-1)+LINO(1))-1)+K)
          P2(K)= GEOM1(3*(TETR4(1+6*(I-1)+LINO(2))-1)+K)
          P3(K)= GEOM1(3*(TETR4(1+6*(I-1)+LINO(3))-1)+K)
          P4(K)= GEOM1(3*(TETR4(1+6*(I-1)+LINO(4))-1)+K)
1       CONTINUE

        DO 2, K=1,3
          V12(K)= P2(K)-P1(K)
          V13(K)= P3(K)-P1(K)
          V14(K)= P4(K)-P1(K)
          V1P(K)= PP(K)-P1(K)
2       CONTINUE

        N(1)=   V12(2)*V13(3)-V12(3)*V13(2)
        N(2)=   V12(3)*V13(1)-V12(1)*V13(3)
        N(3)=   V12(1)*V13(2)-V12(2)*V13(1)

        VOL =N(1)*V14(1)+N(2)*V14(2)+N(3)*V14(3)
        IF (VOL.EQ.0.D0) THEN
           OK=.FALSE.
           GO TO 9999
        END IF
        VOLP=N(1)*V1P(1)+N(2)*V1P(2)+N(3)*V1P(3)
        COBAR2(LINO(4))=VOLP/VOL
10    CONTINUE


      OK =.TRUE.

C     -- TOLERANCE EPSI POUR EVITER DES DIFFERENCES ENTRE
C        LES VERSIONS DEBUG ET NODEBUG
      EPSI=1.D-10
      DO 30,K=1,4
        IF ((COBAR2(K).LT.-EPSI).OR.(COBAR2(K).GT.1.D0+EPSI)) OK=.FALSE.
30    CONTINUE

9999  CONTINUE
      END
