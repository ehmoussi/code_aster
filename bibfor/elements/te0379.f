      SUBROUTINE TE0379 ( OPTION , NOMTE )
      IMPLICIT NONE
      INCLUDE 'jeveux.h'

      CHARACTER*16        OPTION  , NOMTE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 15/01/2013   AUTEUR DELMAS J.DELMAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
C ......................................................................
C    - FONCTION REALISEE: EXTENSION DU CHAM_ELEM ERREUR AUX NOEUDS
C                         OPTIONS : 'ERME_ELNO'  ET 'ERTH_ELNO'
C             (POUR PERMETTRE D'UTILISER POST_RELEVE_T)
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE
C ......................................................................
C
C
C
C
      INTEGER    NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO,NBCMP
      INTEGER    I,J,ITAB(3),IERR,IERRN,IRET
C
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)
C
      CALL TECACH ('OOO','PERREUR','L',3,ITAB,IRET)
      CALL JEVECH('PERRENO','E',IERRN)
      IERR=ITAB(1)
      NBCMP=ITAB(2)
C
      DO 10 I = 1 , NNO
        DO 20 J = 1 , NBCMP
          ZR(IERRN+NBCMP*(I-1)+J-1) = ZR(IERR-1+J)
   20   CONTINUE
   10 CONTINUE
C
      END
