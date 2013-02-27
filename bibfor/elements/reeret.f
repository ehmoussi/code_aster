      SUBROUTINE REERET(ELREFP,AXI,NNOP,GEOM,XG,NDIM,DERIV,XE,FF,DFDI)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 26/02/2013   AUTEUR CUVILLIE M.CUVILLIEZ 
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
C RESPONSABLE CUVILLIEZ
C.......................................................................
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*3  DERIV
      CHARACTER*8  ELREFP
      INTEGER      NNOP,NDIM,IDEPL
      REAL*8       XG(NDIM)
      REAL*8       XE(NDIM),FF(NNOP),DFDI(NNOP,NDIM)
      REAL*8       GEOM(*)
      LOGICAL      AXI
C
C ----------------------------------------------------------------------
C
C ELEMENTS XFEM THERMIQUES LINEAIRES:
C
C TROUVER LES COORDONNEES DANS L'ELEMENT DE REFERENCE D'UN
C POINT DONNE DANS L'ELEMENT REEL PAR LA METHODE NEWTON
C ET CALCUL DES FONCTIONS DE FORMES ET DE LEURS DERIVEES
C
C ----------------------------------------------------------------------
C
C
C IN  ELREFP : TYPE DE L'ELEMENT DE REF PARENT
C IN   AXI   : INDIQUER POUR MODEL AXIS
C IN  NNOP   : NOMBRE DE NOEUDS DE L'ELT DE R�F PARENT
C   L'ORDRE DES DDLS DOIT ETRE 'DC' 'H1' 'E1' 'E2' 'E3' 'E4' 'LAGC'
C IN  GEOM   : COORDONNEES DES NOEUDS
C IN  XG     : COORDONNES DU POINT DANS L'ELEMENT REEL
C IN  NDIM   : DIMENSION DE L'ESPACE
C IN  DERIV  : CALCUL DES QUANTIT�S CIN�MATIQUES
C               'NON' : ON S'ARRETE APRES LE CALCUL DES FF
C               'OUI' : ON CALCULE AUSSI LES DERIVEES DES FF
C OUT XE     : COORDONN�ES DU POINT DANS L'�L�MENT DE R�F PARENT
C OUT FF     : FONCTIONS DE FORMES EN XE
C OUT DFDI   : D�RIV�ES DES FONCTIONS DE FORMES EN XE
C
      INTEGER     NBNOMX
      PARAMETER   (NBNOMX = 27)
C
      REAL*8      ZERO
      INTEGER     I,J,K,N,P,IG,CPT
      INTEGER     NNO,NDERIV,IRET,NN
      REAL*8      INVJAC(3,3)
      REAL*8      DFF(3,NBNOMX)
      REAL*8      KRON(3,3),TMP,EPSTAB(3,3)
      LOGICAL     LDEC,ISELLI
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()

C --- INITIALISATIONS
C
      CALL ASSERT(ISELLI(ELREFP))
      CALL ASSERT(DERIV.EQ.'NON'.OR.DERIV.EQ.'OUI')
      ZERO = 0.D0
C
C --- RECHERCHE DE XE PAR NEWTON-RAPHSON
C
      CALL REEREG('S',ELREFP,NNOP,GEOM,XG,NDIM,XE,IRET)
C
C --- VALEURS DES FONCTIONS DE FORME EN XE: FF
C
      CALL ELRFVF(ELREFP,XE,NBNOMX,FF,NNO)

C --- DERIVEES PREMIERES DES FONCTIONS DE FORME EN XE: DFF
C
      CALL ELRFDF(ELREFP,XE,NDIM*NBNOMX,DFF,NNO,NDERIV)
C
C --- CALCUL DE L'INVERSE DE LA JACOBIENNE EN XE: INVJAC
C
      CALL INVJAX('S',NNO   ,NDIM  ,NDERIV,DFF,GEOM,INVJAC,IRET)
C
      IF (DERIV.EQ.'NON') GOTO 9999
C
C --- DERIVEES DES FONCTIONS DE FORMES CLASSIQUES EN XE : DFDI
C
      CALL MATINI(NNOP,NDIM,ZERO,DFDI)
      DO 310 I=1,NDIM
        DO 300 N=1,NNO
          DO 311 K=1,NDIM
            DFDI(N,I)= DFDI(N,I) + INVJAC(K,I)*DFF(K,N)
 311      CONTINUE
 300    CONTINUE
 310  CONTINUE
C
 9999 CONTINUE
C
      CALL JEDEMA()
C
      END
