      SUBROUTINE VLGGL (NNO,NBRDDL,PGL,V,CODE,P,VTEMP)
      IMPLICIT REAL*8 (A-H,O-Z)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C PASSAGE D'UN VECTEUR V DU REPERE GLOBAL AU REPERE LOCAL
C OU INVERSEMENT. ON AGIT UNIQUEMENT SUR LES DDL DE POUTRE,
C LES DDL DE COQUE RESTENT INCHANGES.
C
      INTEGER            I,J,L,NNO,NBRDDL,M
CJMP      PARAMETER          (NBRDDL=63)
      REAL*8             V(NBRDDL),P(NBRDDL,NBRDDL),PGL(3,3)
      REAL*8             VTEMP(NBRDDL)
      CHARACTER*2        CODE
C  ENTREE :NNO  = NBRE DE NOEUDS
C          PGL  = MATRICE DE PASSAGE
C          CODE = GL POUR UN PASSAGE GLOBAL -> LOCAL
C                 LG POUR UN PASSAGE LOCAL  -> GLOBAL
C ENTREE-SORTIE : V
C
C  INITIALISATION A L'IDENTITE DE LA MATRICE DE PASSAGE P
C
      DO 10, I=1, NBRDDL
         DO 20 J=1, NBRDDL
         IF ( I.EQ.J ) THEN
             P(I,J)=1.D0
         ELSE
             P(I,J)=0.D0
         ENDIF
20       CONTINUE
10    CONTINUE
C
C  REMPLISSAGE DES DE BLOC DE LA MATRICE P CORRESPONDANT AUX DDL
C  DE POUTRE (UX, UY, UZ, TETAX, TETAY, ET TETAZ) PAR LA MATRICE
C  DE PASSAGE (3*3) PGL.
C
      DO 30, L=1,NNO
         M=(L-1)*NBRDDL/NNO
         DO 40, I=1,3
            DO 50, J=1,3
            P(M+I,M+J)=PGL(I,J)
            P(M+3+I,M+3+J)=PGL(I,J)
50          CONTINUE
40       CONTINUE
30    CONTINUE
C
C INITIALISATION A ZERO DU VECTEUR VTEMP
C
      DO 60, I=1,NBRDDL
            VTEMP(I) = 0.D0
60    CONTINUE
C
C  CAS D'UN PASSAGE LOCAL -> GLOBAL
C
      IF(CODE.EQ.'LG') THEN
C
C CALCUL DE VTEMP = PRODUIT (TRANSPOSEE P) * V
C
      DO 70, I=1,NBRDDL
         DO 90, L=1,NBRDDL
            VTEMP(I)=VTEMP(I)+P(L,I)*V(L)
90       CONTINUE
70    CONTINUE
C
      ELSEIF(CODE.EQ.'GL') THEN
C
C CALCUL DE VTEMP = P * V
C
      DO 100, I=1,NBRDDL
         DO 110, L=1,NBRDDL
            VTEMP(I)=VTEMP(I)+P(I,L)*V(L)
110      CONTINUE
100    CONTINUE
C
      ELSE
         CALL U2MESK('F','ELEMENTS4_58',1,CODE)
      ENDIF
C
C STOCKAGE DE VTEMP DANS V
C
      DO 120, I=1,NBRDDL
            V(I) = VTEMP(I)
120   CONTINUE
C
C
9999  CONTINUE
      END
