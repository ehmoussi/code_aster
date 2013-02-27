      SUBROUTINE  XPOAJD(ELREFP,INO,NNOP,LSN,LST,NINTER,
     &                  IAINC,TYPMA,CO,IGEOM,JDIRNO,NFISS,JFISNO,
     &                  HE,NDIME,NDIM,CMP,NBCMP,NFH,NFE,DDLC,IMA,JCONX1,
     &                  JCONX2,JCNSV1,JCNSV2,JCNSL2,NBNOC,INNTOT,
     &                  INN,NNN,CONTAC,LMECA)
      IMPLICIT NONE

      INCLUDE 'jeveux.h'
      INTEGER     INO,NNOP,IGEOM,NDIM,NDIME,DDLC,JDIRNO
      INTEGER     NBCMP,CMP(NBCMP),NFE,IMA,JCONX1,JCONX2,JCNSV1
      INTEGER     JCNSV2,JCNSL2,NBNOC,INNTOT,IAINC,CONTAC
      INTEGER     NFISS,JFISNO,HE(NFISS),NFH,INN,NNN,NINTER
      LOGICAL     LMECA 
      CHARACTER*8 ELREFP,TYPMA
      REAL*8      CO(3),LSN(NFISS),LST(NFISS)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 26/02/2013   AUTEUR CUVILLIE M.CUVILLIEZ 
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
C RESPONSABLE GENIAUT S.GENIAUT
C TOLE CRP_21 CRS_1404
C
C     BUT:  CALCUL DES DEPLACEMENTS AUX SOMMENTS DES SOUS-ELEMENTS
C           ET REPORT DES LAGRANGES SI CONTACT

C   IN
C     ELREFP : �L�MENT DE R�F�RENCE PARENT
C     INO   : NUM�RO DU NOEUD OU DU POINT D'INTERSECTION
C     NNOP   : NOMBRE DE NOEUDS DE L'ELEMENT PARENT
C     LSN    : LEVEL SETS NORMALES EN INO
C     LST    : LEVEL SET TANGENTE EN INO
C     NINTER : NOMBRE D'ARETES INTERSECT�S DE L'ELEMENT PARENT
C     IAINC  : ADRESSE DE TOPOFAC.AI DE L'ELEMENT PARENT
C     TYPMA  : TYPE DE LA MAILLE PARENTE
C     CO     : COORDONN�ES INITIALES DE INO
C     IGEOM  : COORDONN�ES DES NOEUDS DE L'�L�MENT PARENT
C     JDIRNO : ADRESSE DU TABLEAU DIRNO LOCAL
C     NFISS  : NOMBRE DE FISSURES "VUES" PAR L'�L�MENT PARENT
C     JFISNO : POINTEUR DE FISSNO DANS L'�L�MENT PARENT
C     HE     : VALEURS DE(S) FONCTION(S) HEAVISIDE SUR LE SOUS �L�MENT
C     NDIME  : DIMENSION TOPOLOGIQUE DE LA MAILLE PARENT
C     NDIM   : DIMENSION DU MAILLAGE
C     CMP    : POSITION DES DDLS DE DEPL X-FEM DANS LE CHAMP_NO DE DEPL1
C     NBCMP  : NOMBRE DE COMPOSANTES DU CHAMP_NO DE DEPL1
C     NFH    : NOMBRE DE FONCTIONS HEAVISIDE (PAR NOEUD)
C     NFE    : NOMBRE DE FONCTIONS SINGULI�RES D'ENRICHISSEMENT (1 A 4)
C     DDLC   : NOMBRE DE DDL DE CONTACT DE L'�L�MENT PARENT
C     IMA    : NUMERO DE MAILLE COURANTE PARENT
C     JCONX1 : ADRESSE DE LA CONNECTIVITE DU MAILLAGE SAIN
C              (CONNECTIVITE QUADRATIQUE SI LAGRANGES DE CONTACT
C              AUX ARETES)
C     JCONX2 : LONGUEUR CUMULEE DE LA CONNECTIVITE DU MAILLAGE SAIN
C              (CONNECTIVITE QUADRATIQUE SI LAGRANGES DE CONTACT
C              AUX ARETES)
C     JCNSV1 : ADRESSE DU CNSV DU CHAM_NO DE DEPLACEMENT 1
C     NBNOC  : NOMBRE DE NOEUDS CLASSIQUES DU MAILLAGE FISSURE
C     INN    : COMPTEUR LOCAL DU NOMBRE DE NOUVEAU NOEUDS CREES
C     NNN    : NOMBRE DE NOUVEAU NOEUDS A CREER SUR LA MAILLE PARENT
C     LMECA  : VRAI DANS LE CAS MECANIQUE (SINON CAS THERMIQUE)
C
C   OUT
C     JCNSV2 : ADRESSE DU CNSV DU CHAM_NO DE DEPLACEMENT 2
C     JCNSL2 : ADRESSE DU CNSL DU CHAM_NO DE DEPLACEMENT 2
C     INNTOT : COMPTEUR TOTAL DU NOMBRE DE NOUVEAU NOEUDS CREES
C      INN   : COMPTEUR LOCAL DU NOMBRE DE NOUVEAU NOEUDS CREES




      CHARACTER*8  ELREFC
      REAL*8       FF(NNOP),FFC(NNOP),FE(4),CRILSN,MINLSN,R8MAEM
      REAL*8       R,THETA,CHPRI(3),LAGRS(3),R8PREM
      INTEGER      I,J,IAD,IPOS,IG,INO2,NDIMC,IDECV2,IDECL2
      INTEGER      NNOL,NGL(8),IBID,IFISS,FISS
      INTEGER      LACT(8),NLACT
      LOGICAL      LPINT,LCONT
      PARAMETER    (CRILSN = 1.D-4)

C     ------------------------------------------------------------------
      CALL JEMARQ()

C --- LPINT EST VRAI SI LE NOEUD DU MAILLAGE X-FEM EST SUR LA FISSURE
C --- SI LA MAILLE PARENTE POSSEDE DES DDLS DE CONTACT, ON CALCULERA
C --- ALORS LES LAGRANGES DE CONTACT FROTTEMENT POUR CE NOEUDS
C --- ATTENTION, IL SERA VRAI SEULEMENT SI ON EST DU COT� ESCAVE.
      IF (INO.LT.1000) THEN
        LPINT = .FALSE.
        DO 10 IFISS = 1,NFISS
          IF (LSN(IFISS).EQ.0.D0) LPINT = .TRUE.
 10     CONTINUE
      ELSEIF (INO.GT.1000.AND.INO.LT.2000) THEN
        LPINT = .TRUE.
      ELSEIF (INO.GT.2000) THEN
        LPINT = .FALSE.
        DO 20 IFISS = 1,NFISS
          IF (ABS(LSN(IFISS)).LT.CRILSN) LPINT = .TRUE.
 20     CONTINUE
      ENDIF

      IF (LPINT) THEN
        MINLSN = R8MAEM()
        DO 50 IFISS = 1, NFISS
C     ON DETECTE LA FISSURE CORESPONDANTE AU POINT D'INTERSECTION
          IF (ABS(LSN(IFISS)).LT.MINLSN) THEN
            MINLSN = ABS(LSN(IFISS))
            FISS = IFISS
          ENDIF
 50     CONTINUE
        IF (HE(FISS).EQ.1) THEN
          LPINT = .FALSE.
        ENDIF
      ENDIF
      IF (DDLC.GT.0) CALL ASSERT(LMECA)
      LCONT = (DDLC.GT.0).AND.(NDIME.EQ.NDIM)
     &       .AND.(NINTER.GT.0).AND.(NFISS.EQ.1)
C
      INN = INN + 1
      INNTOT = INNTOT + 1
      CALL ASSERT(INN.LE.NNN)

      ZI(JDIRNO-1+(2+NFISS)*(INN-1)+1) = INO
      ZI(JDIRNO-1+(2+NFISS)*(INN-1)+2) = NBNOC + INNTOT
      DO 30 IFISS = 1,NFISS
        ZI(JDIRNO-1+(2+NFISS)*(INN-1)+2+IFISS) = HE(IFISS)
 30   CONTINUE

C     FF : FONCTIONS DE FORMES AU NOEUD SOMMET OU D'INTERSECTION
      CALL XPOFFO(NDIM,NDIME,ELREFP,NNOP,IGEOM,CO,FF)

C     RQ : "NDIMC" CORRESPOND AU NOMBRE DE COMPOSANTE VECTORIELLE DU 
C     CHAMP PRIMAL (DEPL EN MECA -> NDIM CMP / TEMP EN THERMIQUE
C     SOIT 1 CMP)
      IF (LMECA) THEN
        NDIMC = NDIM
      ELSE
        NDIMC = 1
      END IF
      CALL VECINI(NDIMC,0.D0,CHPRI)

      IF (NFE.NE.0) THEN
C       FE : FONCTIONS D'ENRICHISSEMENT
        R = SQRT(LSN(1)**2+LST(1)**2)
        IF (R.GT.R8PREM()) THEN
C         LE POINT N'EST PAS SUR LE FOND DE FISSURE
          THETA = HE(1)*ABS(ATAN2(LSN(1),LST(1)))
        ELSE
C         LE POINT EST SUR LE FOND DE FISSURE :
C         L'ANGLE N'EST PAS D�FINI, ON LE MET � Z�RO
          THETA=0.D0
        ENDIF

        CALL XDEFFE(R,THETA,FE)
      ENDIF

C     CALCUL DE L'APPROXIMATION DU CHAMP PRIMAL "CHPRI" (DEPLACEMENT 
C     EN MECA / TEMPERATURE EN THERMIQUE)
      DO 100 J=1,NNOP

C       ADRESSE DE LA 1ERE CMP DU CHAMP PRIMAL DU NOEUD INO
        IAD=JCNSV1-1+NBCMP*(ZI(JCONX1-1+ZI(JCONX2+IMA-1)+J-1)-1)

        IPOS=0

C       DDLS CLASSIQUES
        DO 110 I=1,NDIMC
          IPOS=IPOS+1
          CHPRI(I) = CHPRI(I) +  FF(J) * ZR(IAD+CMP(IPOS))
 110    CONTINUE

C       DDLS HEAVISIDE
        DO 120 IG=1,NFH
          DO 130 I=1,NDIMC
            IPOS=IPOS+1
            CHPRI(I) = CHPRI(I) + HE(ZI(JFISNO-1+(J-1)*NFH+IG))
     &                 * FF(J) *  ZR(IAD+CMP(IPOS))
 130      CONTINUE
 120    CONTINUE

C       DDL ENRICHIS EN FOND DE FISSURE
        DO 140 IG=1,NFE
          DO 150 I=1,NDIMC
            IPOS=IPOS+1
            CHPRI(I) = CHPRI(I) + FE(IG) * FF(J) * ZR(IAD+CMP(IPOS))
 150      CONTINUE
 140    CONTINUE

 100  CONTINUE

C     CALCUL DES LAGRANGES DE CONTACT FROTTEMENT
C     SEULEMENT POUR LES POINTS D'INTERSECTION

      CALL VECINI(NDIM,0.D0,LAGRS)
      IF (LPINT.AND.LCONT) THEN

C       NOEUD(S) GLOBAUX PORTANT LE(S) LAMBDA(S)
        CALL XLACTI(TYPMA,NINTER,IAINC,LACT,NLACT)
        CALL ASSERT(NLACT.GT.0)
        IF (CONTAC.EQ.1) THEN
          NNOL = NNOP
        ELSEIF (CONTAC.EQ.3) THEN
C --- FONCTIONS DE FORMES LINEAIRES POUR LE P2P1
          CALL ELELIN(CONTAC,ELREFP,ELREFC,IBID,NNOL)
          CALL XPOFFO(NDIM,NDIME,ELREFC,NNOL,IGEOM,CO,FF)
        ENDIF
C --- FONCTIONS DE FORMES MODIFI�ES
        CALL XMOFFC(LACT,NLACT,NNOL,FF,FFC)
        DO 200 J=1,NNOL
          NGL(J)=ZI(JCONX1-1+ZI(JCONX2+IMA-1)+J-1)
 200    CONTINUE
C
        DO 310 I=1,DDLC
C --- CALCUL AVEC LES FF DE CONTACT FFC, LIN�AIRES ET MODIFI�ES
           DO 330 J=1,NNOL
             LAGRS(I)=LAGRS(I)+ZR(JCNSV1-1+NBCMP*(NGL(J)-1)
     &               +CMP((1+NFH+NFE)*NDIM+I))*FFC(J)
 330       CONTINUE
 310    CONTINUE
      ENDIF

 999  CONTINUE

C       ECRITURE DANS LE .VALE2 POUR LE NOEUD INO2
      INO2 = NBNOC + INNTOT
      IF (LMECA) THEN
C       POUR LA MECA
        IDECV2 = JCNSV2-1+2*NDIMC*(INO2-1)
        IDECL2 = JCNSL2-1+2*NDIMC*(INO2-1)
      ELSE
C       POUR LA THERMIQUE
        IDECV2 = JCNSV2-1+NDIMC*(INO2-1)
        IDECL2 = JCNSL2-1+NDIMC*(INO2-1)
      END IF 
      DO 400 I=1,NDIMC
        ZR(IDECV2+I)=CHPRI(I)      
        ZL(IDECL2+I)=.TRUE.   
        IF (LPINT.AND.LCONT) THEN
C         POUR LES LAGRANGES DE CONTACT EN MECA
          ZR(IDECV2+NDIMC+I)=LAGRS(I)
          ZL(IDECL2+NDIMC+I)=.TRUE.
        ENDIF
 400  CONTINUE

      CALL JEDEMA()

      END
