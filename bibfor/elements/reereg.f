      SUBROUTINE REEREG(STOP,ELREFP,NNOP,COOR,XG,NDIM,XE,IRET)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 16/11/2009   AUTEUR REZETTE C.REZETTE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
      IMPLICIT NONE
      CHARACTER*1  STOP
      CHARACTER*8  ELREFP
      INTEGER      NNOP,NDIM
      REAL*8       COOR(NDIM*NNOP)
      REAL*8       XG(NDIM)
      REAL*8       XE(NDIM)
      INTEGER      IRET
C
C ----------------------------------------------------------------------
C
C TROUVER LES COORDONNEES DANS L'ELEMENT DE REFERENCE D'UN
C POINT DONNE DANS L'ESPACE REEL PAR LA METHODE DE NEWTON
C
C ----------------------------------------------------------------------
C
C
C IN  STOP   : /'S' : ON S'ARRETE EN ERREUR <F> EN CAS D'ECHEC
C              /'C' : ON CONTINUE EN CAS D'ECHEC (IRET=1)
C IN  ELREFP : TYPE DE L'ELEMENT
C IN  NNOP   : NOMBRE DE NOEUDS DE L'ELEMENT
C IN  COOR   : COORDONNEES DS ESPACE REEL DES NOEUDS DE L'ELEMENT
C IN  XG     : COORDONNEES DU POINT DANS L'ESPACE REEL
C IN  NDIM   : DIMENSION DE L'ESPACE
C OUT XE     : COORDONNEES DU POINT DANS L'ESPACE PARA DE L'ELEMENT
C OUT IRET   : 0 : ON A CONVERGE
C            : 1 : ON N'A PAS CONVERGE
C
C ----------------------------------------------------------------------
C
      INTEGER     NBNOMX,ITERMX
      REAL*8      TOLER
      PARAMETER   (NBNOMX = 27 , TOLER = 1.D-8 , ITERMX = 50)
C
      REAL*8      ZERO
      INTEGER     ITER,I,K,IDIM,INO,IPB
      INTEGER     NNO,NDERIV
      REAL*8      ETMP(3),ERR,DDOT
      REAL*8      POINT(NDIM),XENEW(NDIM),INVJAC(3,3)
      REAL*8      DFF(3,NBNOMX)
      REAL*8      FF(NNOP)
C
C ----------------------------------------------------------------------
C

C
C --- INITIALISATIONS
C
      ZERO  = 0.D0
      ITER  = 0
      IRET  = 0
      CALL VECINI(NDIM,ZERO,XE)
C
 100  CONTINUE
      ITER=ITER+1
C
C --- VALEURS DES FONCTIONS DE FORME EN XE: FF
C
      CALL ELRFVF(ELREFP,XE,NBNOMX,FF,NNO)
      CALL ASSERT(NNO.EQ.NNOP)
C
C --- DERIVEES PREMIERES DES FONCTIONS DE FORME EN XE: DFF
C
      CALL ELRFDF(ELREFP,XE,NDIM*NBNOMX,DFF,NNO,NDERIV)
      CALL ASSERT(NDERIV.EQ.NDIM)
C
C --- CALCUL DES COORDONNEES DU POINT: POINT
C
      CALL VECINI(NDIM,ZERO,POINT)
      DO 200 IDIM=1,NDIM
        DO 210 INO=1,NNO
          POINT(IDIM) = POINT(IDIM)+FF(INO)*COOR(NDIM*(INO-1)+IDIM)
 210    CONTINUE
 200  CONTINUE
C
C --- CALCUL DE L'INVERSE DE LA JACOBIENNE EN XE: INVJAC
C
      CALL INVJAX(STOP,NNO   ,NDIM  ,DFF   ,COOR  ,INVJAC,IPB)
      IF (IPB.EQ.1) THEN
        IF (STOP.EQ.'S') THEN
          CALL U2MESS('F','ALGORITH5_19')
        ELSEIF (STOP.EQ.'C') THEN
          IRET=1
          GOTO 999
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
      ENDIF

C --- UPDATE XE
C
      DO 220 I=1,NDIM
        XENEW(I)=XE(I)
        DO 230 K=1,NDIM
          XENEW(I) = XENEW(I)-INVJAC(I,K)*(POINT(K)-XG(K))
 230    CONTINUE
 220  CONTINUE
C
C --- CALCUL DE L'ERREUR: ERR
C
      DO 240 I = 1,NDIM
        ETMP(I) = XENEW(I) - XE(I)
 240  CONTINUE
      ERR = DDOT(NDIM,ETMP,1,ETMP,1)
C
C --- NOUVELLE VALEUR DE XE
C
      CALL LCEQVN(NDIM,XENEW,XE)
C
C --- TEST DE FIN DE BOUCLE
C
      IF (ERR.LE.TOLER) THEN
        GOTO 999
      ELSEIF (ITER.LT.ITERMX) THEN
        GOTO 100
      ELSE
        IF (STOP.EQ.'S') THEN
          CALL U2MESS('F','ELEMENTS2_58')
        ELSE
          CALL ASSERT(STOP.EQ.'C')
          IRET=1
        ENDIF
      ENDIF

 999  CONTINUE
C
      END
