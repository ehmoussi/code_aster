      SUBROUTINE TSTVEC(PERM,IAD,NLONG,TYPE,SOMMI,SOMMR,NBIGN)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 12/09/2006   AUTEUR VABHHTS J.PELLET 
C TOLE CRP_4
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
C TOLE CRP_18 CRS_508
      IMPLICIT NONE

C BUT : RECUPERER 2 NOMBRES RESUMANT UN VECTEUR JEVEUX

C IN: PERM  K3 : /OUI/NON
C           NON : ON FAIT LA SOMME BETE DES ELEMENTS DU VECTEUR
C                 => UNE PERMUTATION DU VECTEUR NE SE VOIT PAS !
C           OUI : ON FAIT UNE "SOMME" QUI DONNE UN RESULTAT
C                 DEPENDANT UN PEU DE L'ORDRE DES ELEMENTS DU VECTEUR
C IN: IAD   I  : ADRESSE DU VECTEUR
C IN: NLONG  I  : LONGUEUR DU VECTEUR
C IN: TYPE  K3 : TYPE DES ELEMENTS DU VECTEUR :
C                   I/L/R/C/K8/K16/K24/K32/K80

C OUT: SOMMI   I      : SOMME(V(I)) QUELQUE SOIT LE TYPE DE V
C OUT: SOMMR   R      : SOMME(V(I)) SI V EST DE TYPE "R/C"
C OUT: NBIGN   I      : NOMBRE DE VALEURS IGNOREES DANS SOMMR :
C                       (UNDEF OU TRES GRAND )


      CHARACTER*3 TYPE
      REAL*8 SOMMR
      INTEGER SOMMI,NBIGN
C --------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*32 JEXNUM,JEXNOM,JEXATR
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24,K24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C --------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------
      LOGICAL L
      CHARACTER*(*) PERM
      CHARACTER*8 K8
      REAL*8 X
      INTEGER IAD,I,IX,C1,NLONG,ICO,K,TSTK2I,IISNAN
      INTEGER*8 SOMMI2 ,I8

      EQUIVALENCE (X,IX)
      EQUIVALENCE (L,IX)
      EQUIVALENCE (K8,IX)


      IF (PERM.EQ.'NON') THEN
         C1=0
      ELSE
         C1=1
      END IF


C     -- CALCUL DE SOMMR :
C     --------------------
      SOMMR = 0.D0
      ICO=0
      NBIGN=0
      IF (TYPE.EQ.'R') THEN
        DO 10,K = 1,NLONG
          X = ZR(IAD-1+K)
          IF (IISNAN(X).EQ.0) THEN
            IF (ABS(X).LT.1.D300) THEN
               ICO=ICO+1
               SOMMR = SOMMR + (C1*MOD(K,3)+1)*X
            END IF
          END IF
   10   CONTINUE
        NBIGN=NLONG-ICO
      END IF
      IF (TYPE.EQ.'C') THEN
        DO 20,K = 1,NLONG
          X = DBLE(ZC(IAD-1+K))
          IF (IISNAN(X).EQ.0) THEN
            IF (ABS(X).LT.1.D300) THEN
               ICO=ICO+1
               SOMMR = SOMMR + (C1*MOD(K,3)+1)*X
            END IF
          END IF
          X = DIMAG(ZC(IAD-1+K))
          IF (IISNAN(X).EQ.0) THEN
            IF (ABS(X).LT.1.D300)  THEN
               ICO=ICO+1
               SOMMR = SOMMR + (C1*MOD(K,3)+1)*X
            END IF
          END IF
   20   CONTINUE
        NBIGN=2*NLONG-ICO
      END IF


C     -- CALCUL DE SOMMI :
C     --------------------
      SOMMI2 = 0
      IF (TYPE.EQ.'I') THEN
        DO 30,K = 1,NLONG
          I8= ZI(IAD-1+K)
          SOMMI2 = SOMMI2 + (C1*MOD(K,3)+1)*I8
   30   CONTINUE
      ELSE IF (TYPE.EQ.'L') THEN
        DO 40,K = 1,NLONG
          L = ZL(IAD-1+K)
          IF (L) SOMMI2 = SOMMI2 + (C1*MOD(K,3)+1)
   40   CONTINUE
      ELSE IF (TYPE.EQ.'R') THEN
        SOMMI2=0
   50   CONTINUE
      ELSE IF (TYPE.EQ.'C') THEN
        SOMMI2=0
   60   CONTINUE
      ELSE IF (TYPE.EQ.'K8') THEN
        DO 70,K = 1,NLONG
          SOMMI2 = SOMMI2 + (C1*MOD(K,3)+1)*TSTK2I(8,ZK8(IAD-1+K))
   70   CONTINUE
      ELSE IF (TYPE.EQ.'K16') THEN
        DO 80,K = 1,NLONG
          SOMMI2 = SOMMI2 + (C1*MOD(K,3)+1)*TSTK2I(16,ZK16(IAD-1+K))
   80   CONTINUE
      ELSE IF (TYPE.EQ.'K24') THEN
        DO 90,K = 1,NLONG
          SOMMI2 = SOMMI2 + (C1*MOD(K,3)+1)*TSTK2I(24,ZK24(IAD-1+K))
   90   CONTINUE
      ELSE IF (TYPE.EQ.'K32') THEN
        DO 100,K = 1,NLONG
          SOMMI2 = SOMMI2 + (C1*MOD(K,3)+1)*TSTK2I(32,ZK32(IAD-1+K))
  100   CONTINUE
      ELSE IF (TYPE.EQ.'K80') THEN
        DO 110,K = 1,NLONG
          SOMMI2 = SOMMI2 + (C1*MOD(K,3)+1)*TSTK2I(80,ZK80(IAD-1+K))
  110   CONTINUE
      END IF

C     -- ON TRONQUE SOMMI2 (9 DERNIERS CHIFFRES) POUR AVOIR
C        LE MEME RESULTAT SUR LES PLATEFORMES I4 ET I8 :
      WRITE(K24,'(I24)') SOMMI2
      READ(K24(16:24),'(I9)') SOMMI


      END
