      SUBROUTINE MMRESI(ALIAS ,NNO   ,NDIM  ,COORMA,COORPT,
     &                  KSI1  ,KSI2  ,VALEUR)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 05/03/2013   AUTEUR DESOZA T.DESOZA 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.         
C ======================================================================
C RESPONSABLE ABBAS M.ABBAS
      IMPLICIT NONE
      CHARACTER*8  ALIAS
      INTEGER      NNO   ,NDIM
      REAL*8       COORMA(27),COORPT(3)
      REAL*8       KSI1      ,KSI2
      REAL*8       VALEUR
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (TOUTES METHODES - APPARIEMENT)
C
C ALGORITHME DE NEWTON POUR CALCULER LA PROJECTION D'UN POINT SUR UNE
C MAILLE : RECHERCHE LINEAIRE AVEC REBROUSSEMENT
C
C EVALUATION DE LA FONCTION DE RECHERCHE LINEAIRE
C                                     __
C ==> FONCTION G(ALPHA)  ==  1/2 * || \/D(KSI+ALPHA*DKSI) ||^2
C
C
C ----------------------------------------------------------------------
C
C IN  ALIAS  : TYPE DE MAILLE
C IN  NNO    : NOMBRE DE NOEUD SUR LA MAILLE
C IN  NDIM   : DIMENSION DE LA MAILLE (2 OU 3)
C IN  COORMA : COORDONNEES DES NOEUDS DE LA MAILLE
C IN  COORPT : COORDONNEES DU NOEUD A PROJETER SUR LA MAILLE
C IN  KSI1   : PREMIERE COORDONNEE PARAMETRIQUE DU POINT PROJETE
C IN  KSI2   : SECONDE COORDONNEE PARAMETRIQUE DU POINT PROJETE
C OUT VALEUR : VALEUR DE LA FONCTION DE RECHERCHE LINEAIRE
C
C ----------------------------------------------------------------------
C
      REAL*8       FF(9),DFF(2,9),DDFF(3,9)
      INTEGER      INO,IDIM
      REAL*8       VEC1(3),TAU1(3),TAU2(3)
      REAL*8       RESIDU(2)
      REAL*8       ZERO
      PARAMETER   (ZERO=0.D0)
C
C ----------------------------------------------------------------------
C
C --- INITIALISATIONS
C
      DO 10 IDIM  = 1,3
        VEC1(IDIM)  = ZERO
        TAU1(IDIM)  = ZERO
        TAU2(IDIM)  = ZERO
 10   CONTINUE
      RESIDU(1)   = ZERO
      RESIDU(2)   = ZERO
C
C --- CALCUL DES FONCTIONS DE FORME ET DE LEUR DERIVEES EN UN POINT
C --- DANS LA MAILLE
C
      CALL MMFONF(NDIM  ,NNO   ,ALIAS  ,KSI1   ,KSI2  ,
     &            FF    ,DFF   ,DDFF   )
C
C --- CALCUL DU VECTEUR POSITION DU POINT COURANT SUR LA MAILLE
C
      DO 40 IDIM = 1,NDIM
        DO 30 INO = 1,NNO
          VEC1(IDIM)  = COORMA(3*(INO-1)+IDIM)*FF(INO) + VEC1(IDIM)
 30     CONTINUE
 40   CONTINUE
C
C --- CALCUL DES TANGENTES
C
      CALL MMTANG(NDIM  ,NNO   ,COORMA,DFF   ,
     &            TAU1  ,TAU2)
C
C --- CALCUL DE LA QUANTITE A MINIMISER
C
      DO 35 IDIM = 1,NDIM
        VEC1(IDIM) = COORPT(IDIM) - VEC1(IDIM)
 35   CONTINUE
C
C --- CALCUL DU RESIDU
C
      RESIDU(1) = VEC1(1)*TAU1(1) + VEC1(2)*TAU1(2) +
     &            VEC1(3)*TAU1(3)
      IF (NDIM.EQ.3) THEN
        RESIDU(2) = VEC1(1)*TAU2(1) + VEC1(2)*TAU2(2) +
     &              VEC1(3)*TAU2(3)
      ENDIF
C
C --- VALEUR DE G
C
      VALEUR = 0.5D0 * (RESIDU(1)**2+RESIDU(2)**2)
C
      END
