      SUBROUTINE ARLTEN(NPGS  ,POIJCS,
     &                  NDML1   ,FCPIG1    ,
     &                  NDML2   ,FCPIG2    ,
     &                  MCPLN)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 13/10/2009   AUTEUR CAO B.CAO 
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
C RESPONSABLE MEUNIER S.MEUNIER
C
      IMPLICIT    NONE
      INTEGER     NPGS
      REAL*8      POIJCS(NPGS)
      INTEGER     NDML1,NDML2
      REAL*8      FCPIG1(NPGS*NDML1),FCPIG2(NPGS*NDML2)
      REAL*8      MCPLN(NDML1,NDML2)
C
C ----------------------------------------------------------------------
C
C CALCUL DES MATRICES DE COUPLAGE ARLEQUIN
C OPTION ARLQ_MATR
C
C
C CALCUL DES INTEGRALES DE COUPLAGE ENTRE MAILLE 1 ET MAILLE 2
C
C TERME CONSTANT (N1)T.N2  (INTEGRALE SUR S)
C
C ----------------------------------------------------------------------
C
C
C IN  NPGS   : NOMBRE DE POINTS DE GAUSS DE LA MAILLE S
C IN  POIJCS : PRODUIT POIDS DE GAUSS*JACOBIEN  DE LA MAILLE S
C IN  NDML1  : NOMBRE DE NOEUDS DE LA MAILLE 1
C IN  FCPIG1 : FCT. FORME DE MAILLE 1 AU POINT DE GAUSS KPGS
C               DE LA MAILLE S
C IN  NDML2  : NOMBRE DE NOEUDS DE LA MAILLE 2
C IN  FCPIG2 : FCT. FORME DE MAILLE 2 AU POINT DE GAUSS KPGS
C               DE LA MAILLE S
C OUT MCPLN  : MATRICE DES TERMES DE COUPLAGE (N1)T.N2
C              MATRICE RECTANGULAIRE (NDML1xNDML2)
C
C NB: SI MAILLE 1 == MAILLE 2 ALORS MCPLN EQUIVALENTE A UNE MATRICE
C     MASSE DE DENSITE 1 (ET DONC MATRICE CARREE)
C
C ----------------------------------------------------------------------
C
      REAL*8  POIDS
      INTEGER KPGS,IAUX,JAUX
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- CALCUL DES TERMES DE COUPLAGE
C
      POIDS = POIJCS(1)
      DO 10 JAUX = 1,NDML2
        DO 20 IAUX = 1,NDML1
          MCPLN(IAUX,JAUX) = POIDS*FCPIG1(IAUX)*FCPIG2(JAUX)
 20     CONTINUE
 10   CONTINUE

      DO 30 KPGS = 2,NPGS
        POIDS = POIJCS(KPGS)
        DO 40 JAUX = 1,NDML2
          DO 50 IAUX = 1,NDML1
            MCPLN(IAUX,JAUX) = MCPLN(IAUX,JAUX)
     &            + POIDS*FCPIG1(NDML1*(KPGS-1)
     &            + IAUX)*FCPIG2(NDML2*(KPGS-1)+JAUX)
 50       CONTINUE
 40     CONTINUE
 30   CONTINUE
C
      CALL JEDEMA()
      END
