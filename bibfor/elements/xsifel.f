      SUBROUTINE XSIFEL(ELREFP,NDIM,COORSE,IGEOM,JHEAVT,ISE,NFH,
     &                 DDLC,DDLM,NFE,RHO,BASLOC,NNOP,IDEPL,
     &                 LSN,LST,IDECPG,IGTHET,FNO,NFISS,JFISNO)

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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE GENIAUT S.GENIAUT
C TOLE CRP_20 CRS_1404
C TOLE CRP_21

      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*8   ELREFP
      INTEGER       IGEOM,NDIM,NFH,DDLC,DDLM,NFE,NNOP,IDECPG,IDEPL
      INTEGER       NFISS,JFISNO,JHEAVT,ISE
      REAL*8        FNO(NDIM*NNOP),COORSE(*)
      REAL*8        BASLOC(3*NDIM*NNOP),LSN(NNOP),LST(NNOP),RHO


C    - FONCTION REALISEE:  CALCUL DU TAUX DE RESTITUTION D'ENERGIE
C                          ET DES FACTEURS D'INTENSITE DE CONTRAINTES
C                          PAR LA METHODE ENERGETIQUE G-THETA
C                          POUR LES ELEMENTS X-FEM
C
C IN  ELREFP  : �L�MENT DE R�F�RENCE PARENT
C IN  NDIM    : DIMENSION DE L'ESPACE
C IN  COORSE  : COORDONN�ES DES SOMMETS DU SOUS-�L�MENT
C IN  IGEOM   : COORDONN�ES DES NOEUDS DE L'�L�MENT PARENT
C IN  NFH     : NOMBRE DE FONCTIONS HEAVYSIDE
C IN  NFISS   : NOMBRE DE FISSURES "VUES" PAR L'�L�MENT
C IN  JFISNO  : CONNECTIVITE DES FISSURES ET DES DDL HEAVISIDES
C IN  DDLC    : NOMBRE DE DDL DE CONTACT (PAR NOEUD)
C IN  NFE     : NOMBRE DE FONCTIONS SINGULI�RES D'ENRICHISSEMENT
C IN  BASLOC  : BASE LOCALE AU FOND DE FISSURE AUX NOEUDS
C IN  NNOP    : NOMBRE DE NOEUDS DE L'ELEMENT PARENT
C IN  NPG     : NOMBRE DE POINTS DE GAUSS DU SOUS-�L�MENT
C IN  DEPL    : D�PLACEMENTS
C IN  LSN     : VALEUR DE LA LEVEL SET NORMALE AUX NOEUDS PARENTS
C IN  LST     : VALEUR DE LA LEVEL SET TANGENTE AUX NOEUDS PARENTS
C IN  IDECPG  : POSITION DANS LA FAMILLE 'XFEM' DU 1ER POINT DE GAUSS
C               DU SOUS ELEMENT COURRANT (EN FAIT 1ER POINT : IDECPG+1)
C IN  FNO     : FORCES VOLUMIQUES AUX NOEUDS DE L'ELEMENT PARENT
C IN  RHO     : MASSE VOLUMIQUE
C OUT IGTHET  : G, K1, K2, K3


      INTEGER  ITHET,IMATE,ICOMP,ICOUR,IGTHET,JTAB(2),NCOMP
      INTEGER  IPOIDS,JCOOPG,IVF,IDFDE,JDFD2,JGANO
      INTEGER  I,J,K,KPG,N,INO,IRET,CPT,IG,IPG,IN
      INTEGER  NDIMB,NNO,NNOS,NPGBIS,DDLD,DDLS
      INTEGER  FISNO(NNOP,NFISS),IFISS
      REAL*8   G,K1,K2,K3,COEFK,COEFF3,VALRES(3),R8PREM,ALPHA,HE(NFISS)
      REAL*8   DEVRES(3),E,NU,LAMBDA,MU,KA,C1,C2,C3,XG(NDIM),FE(4),K3A
      REAL*8   DGDGL(4,3),XE(NDIM),FF(NNOP),DFDI(NNOP,NDIM),F(3,3)
      REAL*8   EPS(6),E1(3),E2(3),NORME,E3(3),P(3,3)
      REAL*8   INVP(3,3),RG,TG,RBID1(4)
      REAL*8   DGDPO(4,2),DGDLO(4,3),COURB(3,3,3),DU1DM(3,3),DU2DM(3,3)
      REAL*8   DU3DM(3,3),GRAD(NDIM,NDIM),DUDM(3,3),POIDS,RBID2(4),RBID
      REAL*8   DTDM(3,3),TZERO(3),DZERO(3,4),LSNG,LSTG,TH,RBID3(4)
      REAL*8   DUDME(3,4),DTDME(3,4),DU1DME(3,4),DU2DME(3,4),DU3DME(3,4)
      REAL*8   U1L(3),U2L(3),U3L(3),U1(3),U2(3),U3(3), UR, R
      REAL*8   DEPLA(3),THETA(3),TGUDM(3),TPN(27),TREF,TEMPG
      REAL*8   TTRGU,TTRGV,DFDM(3,4),CS,COEF,PULS
      INTEGER  ICODRE(3)
      CHARACTER*8  NOMRES(3),ELRESE(6),FAMI(6)
      LOGICAL  LCOUR,GRDEPL,LTEATT, AXI
      INTEGER       IRESE,NNOPS,IBID
      LOGICAL       ISELLI
      INTEGER       DDLN,NNON,INDENN,MXSTAC
      PARAMETER      (MXSTAC=1000)

      DATA     NOMRES /'E','NU','ALPHA'/
      DATA     ELRESE /'SE2','TR3','TE4','SE3','TR6','TE4'/
      DATA     FAMI   /'BID','XINT','XINT','BID','XINT','XINT'/

      CALL JEMARQ()
C     VERIF QUE LES TABLEAUX LOCAUX DYNAMIQUES NE SONT PAS TROP GRANDS
C     (VOIR CRS 1404)

      CALL ASSERT(NNOP.LE.MXSTAC)
      CALL ASSERT((3*NDIM*NNOP).LE.MXSTAC)

      GRDEPL=.FALSE.

C     ATTENTION, DEPL ET VECTU SONT ICI DIMENSIONN�S DE TELLE SORTE
C     QU'ILS NE PRENNENT PAS EN COMPTE LES DDL SUR LES NOEUDS MILIEU

C     NOMBRE DE DDL DE DEPLACEMENT � CHAQUE NOEUD SOMMET
      DDLD=NDIM*(1+NFH+NFE)

C     NOMBRE DE DDL TOTAL (DEPL+CONTACT) � CHAQUE NOEUD SOMMET
      DDLS=DDLD+DDLC

C     NOMBRE DE COMPOSANTES DE PHEAVTO (DANS LE CATALOGUE)
      CALL TECACH('OOO','PHEAVTO','L',2,JTAB,IRET)
      NCOMP = JTAB(2)

C     ELEMENT DE REFERENCE PARENT : RECUP DE NNOPS
      CALL ELREF4(' ','RIGI',IBID,IBID,NNOPS,IBID,IBID,IBID,IBID,IBID)

      AXI = LTEATT(' ','AXIS','OUI')

      IF (.NOT.ISELLI(ELREFP).AND. NDIM.LE.2) THEN
        IRESE=3
      ELSE
        IRESE=0
      ENDIF

      CALL JEVECH('PTHETAR','L',ITHET)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PCOMPOR','L',ICOMP)

C     V�RIFICATION DU CADRE TH�ORIQUE DU CALCUL
      IF (ZK16(ICOMP-1+1).NE.'ELAS'.OR.
     &    ZK16(ICOMP-1+3).NE.'PETIT') CALL U2MESS('F','RUPTURE1_24')

C     SOUS-ELEMENT DE REFERENCE
      CALL ELREF5(ELRESE(NDIM+IRESE),FAMI(NDIM+IRESE),NDIMB,NNO,NNOS,
     &            NPGBIS,IPOIDS,JCOOPG,IVF,IDFDE,JDFD2,JGANO)
      CALL ASSERT(NDIM.EQ.NDIMB)

C     TEMPERATURE DE REF
      CALL RCVARC(' ','TEMP','REF','RIGI',1,1,TREF,IRET)
      IF (IRET.NE.0) TREF = 0.D0

C     TEMPERATURE AUX NOEUDS PARENT
      DO 30 INO = 1,NNOP
        CALL RCVARC(' ','TEMP','+','NOEU',INO,1,TPN(INO),IRET)
        IF (IRET.NE.0) TPN(INO) = 0.D0
 30   CONTINUE

C     FONCTION HEAVYSIDE CSTE SUR LE SS-�LT ET PAR FISSURE

      DO 70 IFISS = 1,NFISS
        HE(IFISS) = ZI(JHEAVT-1+NCOMP*(IFISS-1)+ISE)
  70  CONTINUE

C     RECUPERATION DE LA CONNECTIVIT� FISSURE - DDL HEAVISIDES
C     ATTENTION !!! FISNO PEUT ETRE SURDIMENTIONN�
      IF (NFISS.EQ.1) THEN
        DO 40 INO = 1, NNOP
          FISNO(INO,1) = 1
  40    CONTINUE
      ELSE
        DO 50 IG = 1, NFH
C    ON REMPLIT JUSQU'A NFH <= NFISS
          DO 60 INO = 1, NNOP
            FISNO(INO,IG) = ZI(JFISNO-1+(INO-1)*NFH+IG)
  60      CONTINUE
  50    CONTINUE
      ENDIF

C     ------------------------------------------------------------------
C     BOUCLE SUR LES POINTS DE GAUSS DU SOUS-T�TRA
C     ------------------------------------------------------------------

      DO 10 KPG=1,NPGBIS

C       INITIALISATIONS
        CALL VECINI(9,0.D0,DTDM)
        CALL VECINI(9,0.D0,DU1DM)
        CALL VECINI(9,0.D0,DU2DM)
        CALL VECINI(9,0.D0,DU3DM)

C       RECUPERATION DES DONNEES MATERIAUX
        IPG = IDECPG + KPG
        CALL RCVAD2 ('XFEM',IPG,1,'+',ZI(IMATE),'ELAS',
     &               3,NOMRES,VALRES,DEVRES,ICODRE)
        IF (ICODRE(3).NE.0) THEN
          VALRES(3)= 0.D0
          DEVRES(3)= 0.D0
        ENDIF
        E     = VALRES(1)
        NU    = VALRES(2)
        ALPHA = VALRES(3)
        K3A   = ALPHA * E / (1.D0-2.D0*NU)

        IF ( NDIM.EQ.3.OR.
     &       (NDIM.EQ.2.AND.LTEATT(' ','D_PLAN','OUI')).OR.
     &        AXI) THEN

          LAMBDA = NU*E/((1.D0+NU)*(1.D0-2.D0*NU))
          MU = E/(2.D0*(1.D0+NU))
          KA = 3.D0-4.D0*NU
          COEFK = E/(1.D0-NU*NU)
          COEFF3=2.D0 * MU
          C1 = LAMBDA + 2.D0 * MU
          C2 = LAMBDA
          C3 = MU
          TH = 1.D0

        ELSEIF (NDIM.EQ.2.AND.LTEATT(' ','C_PLAN','OUI')) THEN

          KA = (3.D0-NU)/(1.D0+NU)
          MU  = E/(2.D0*(1.D0+NU))
          COEFK = E
          COEFF3 = MU
          C1 = E/(1.D0-NU*NU)
          C2 = NU*C1
          C3 = MU
          TH = (1.D0-2.D0*NU)/(1.D0-NU)

        ENDIF

C       COORDONN�ES DU PT DE GAUSS DANS LE REP�RE R�EL : XG
        CALL VECINI(NDIM,0.D0,XG)
        DO 101 I=1,NDIM
          DO 102 N=1,NNO
            XG(I) = XG(I) + ZR(IVF-1+NNO*(KPG-1)+N)
     &                                * COORSE(NDIM*(N-1)+I)
 102      CONTINUE
 101    CONTINUE

C       CALCUL DES FF
        CALL REEREF(ELREFP,AXI, NNOP,NNOPS,ZR(IGEOM),XG,IDEPL,GRDEPL,
     &              NDIM,HE,RBID, RBID,
     &              FISNO,NFISS,NFH,NFE,DDLS,DDLM,FE,DGDGL,'NON',
     &              XE,FF,DFDI,F,EPS,GRAD)

C       POUR CALCULER LE JACOBIEN DE LA TRANSFO SS-ELT -> SS-ELT REF
C       ON ENVOIE DFDM3D/DFDM2D AVEC LES COORD DU SS-ELT
        IF (NDIM.EQ.3) CALL DFDM3D(NNO,KPG,IPOIDS,IDFDE,COORSE,
     &                                      RBID1,RBID2,RBID3,POIDS)
        IF (NDIM.EQ.2) CALL DFDM2D(NNO,KPG,IPOIDS,IDFDE,COORSE,
     &                                      RBID1,RBID2,POIDS)

C       --------------------------------------
C       1) COORDONN�ES POLAIRES ET BASE LOCALE
C       --------------------------------------

C       BASE LOCALE ET LEVEL SETS AU POINT DE GAUSS
        CALL VECINI(3,0.D0,E1)
        CALL VECINI(3,0.D0,E2)
        LSNG=0.D0
        LSTG=0.D0
        DO 100 INO=1,NNOP
          LSNG = LSNG + LSN(INO) * FF(INO)
          LSTG = LSTG + LST(INO) * FF(INO)
          DO 110 I=1,NDIM
            E1(I) = E1(I) + BASLOC(3*NDIM*(INO-1)+I+NDIM)   * FF(INO)
            E2(I) = E2(I) + BASLOC(3*NDIM*(INO-1)+I+2*NDIM) * FF(INO)
 110      CONTINUE
 100    CONTINUE
C
C -     CALCUL DE LA DISTANCE A L'AXE (AXISYMETRIQUE)
C       ET DU DEPL. RADIAL
        IF (AXI) THEN
          R  = 0.D0
          UR = 0.D0
          DO 1000 INO=1,NNOP
            R  = R  + FF(INO)*ZR(IGEOM-1+2*(INO-1)+1)
            UR = UR + FF(INO)*ZR(IDEPL-1+DDLS*(INO-1)+1)
            DO 1001 IG=1,NFH
              UR = UR + FF(INO)
     &                   *ZR(IDEPL-1+DDLS*(INO-1)+NDIM*IG+1)
     &                   *HE(FISNO(INO,IG))
 1001       CONTINUE
            DO 1002 IG=1,NFE
                UR = UR + FF(INO)
     &                   *ZR(IDEPL-1+DDLS*(INO-1)+NDIM*(NFH+IG)+1)
     &                   *FE(IG)
 1002       CONTINUE

1000      CONTINUE

        IF (AXI) THEN
          POIDS= POIDS * R
        ENDIF
C Si R n�gative, on s'arrete

          CALL ASSERT(R.GT.0D0)
        ENDIF

C       NORMALISATION DE LA BASE
        CALL NORMEV(E1,NORME)
        CALL NORMEV(E2,NORME)
        CALL PROVEC(E1,E2,E3)

C       CALCUL DE LA MATRICE DE PASSAGE P TQ 'GLOBAL' = P * 'LOCAL'
        CALL VECINI(9,0.D0,P)
        DO 120 I=1,NDIM
          P(I,1)=E1(I)
          P(I,2)=E2(I)
          P(I,3)=E3(I)
 120    CONTINUE

C       CALCUL DE L'INVERSE DE LA MATRICE DE PASSAGE : INV=TRANSPOSE(P)
        DO 130 I=1,3
          DO 131 J=1,3
            INVP(I,J)=P(J,I)
 131      CONTINUE
 130    CONTINUE

C       COORDONN�ES POLAIRES DU POINT
        RG=SQRT(LSNG**2+LSTG**2)

        IF (RG.GT.R8PREM()) THEN
C         LE POINT N'EST PAS SUR LE FOND DE FISSURE
          TG = HE(1) * ABS(ATAN2(LSNG,LSTG))
          IRET=1
        ELSE
C         LE POINT EST SUR LE FOND DE FISSURE :
C         L'ANGLE N'EST PAS D�FINI, ON LE MET � Z�RO
C         ON NE FERA PAS LE CALCUL DES D�RIV�ES
          TG=0.D0
          IRET=0
        ENDIF
C       ON A PAS PU CALCULER LES DERIVEES DES FONCTIONS SINGULIERES
C       CAR ON SE TROUVE SUR LE FOND DE FISSURE
        CALL ASSERT(IRET.NE.0)

C       ---------------------------------------------
C       2) CALCUL DU DEPLACEMENT ET DE SA DERIVEE (DUDM)
C       ---------------------------------------------

C       FONCTIONS D'ENRICHISSEMENT
        CALL XDEFFE(RG,TG,FE)

        CALL VECINI(NDIM,0.D0,DEPLA)

C       CALCUL DE L'APPROXIMATION DU DEPLACEMENT
        DO 200 IN=1,NNOP
          IF (IN.LE.NNOPS) THEN
            NNON=0
            DDLN=DDLS
          ELSEIF (IN.GT.NNOPS) THEN
            NNON=NNOPS
            DDLN=DDLM
          ENDIF
          INDENN = DDLS*NNON+DDLN*(IN-NNON-1)

          CPT=0
C         DDLS CLASSIQUES
          DO 201 I=1,NDIM
            CPT=CPT+1
             DEPLA(I) = DEPLA(I) +  FF(IN) *
     &                    ZR(IDEPL-1+INDENN+CPT)
 201      CONTINUE
C         DDLS HEAVISIDE
          DO 202 IG=1,NFH
            DO 203 I=1,NDIM
            CPT=CPT+1
            DEPLA(I) = DEPLA(I) + HE(FISNO(IN,IG)) * FF(IN) *
     &                   ZR(IDEPL-1+INDENN+CPT)
 203        CONTINUE
 202      CONTINUE
C         DDL ENRICHIS EN FOND DE FISSURE
          DO 204 IG=1,NFE
            DO 205 I=1,NDIM
              CPT=CPT+1
              DEPLA(I) = DEPLA(I) + FE(IG) * FF(IN) *
     &                     ZR(IDEPL-1+INDENN+CPT)
 205        CONTINUE
 204      CONTINUE
 200    CONTINUE

C       D�RIV�ES DES FONCTIONS D'ENRICHISSEMENT DANS LA BASE POLAIRE
        CALL XDERFE(RG,TG,DGDPO)

C       D�RIV�ES DES FONCTIONS D'ENRICHISSEMENT DANS LA BASE LOCALE
        DO 210 I=1,4
          DGDLO(I,1)=DGDPO(I,1)*COS(TG)-DGDPO(I,2)*SIN(TG)/RG
          DGDLO(I,2)=DGDPO(I,1)*SIN(TG)+DGDPO(I,2)*COS(TG)/RG
          DGDLO(I,3)=0.D0
 210    CONTINUE

C       D�RIV�ES DES FONCTIONS D'ENRICHISSEMENT DANS LA BASE GLOBALE
        DO 220 I=1,4
          DO 221 J=1,3
            DGDGL(I,J)=0.D0
            DO 222 K=1,3
              DGDGL(I,J)=DGDGL(I,J)+DGDLO(I,K)*INVP(K,J)
 222        CONTINUE
 221      CONTINUE
 220    CONTINUE

C       CALCUL DU GRAD DE U AU POINT DE GAUSS

C
        CALL REEREF(ELREFP,AXI,NNOP,NNOPS,ZR(IGEOM),XG,IDEPL,GRDEPL,
     &              NDIM,HE,R, UR,
     &              FISNO,NFISS,NFH,NFE,DDLS,DDLM,FE,DGDGL,'OUI',
     &              XE,FF,DFDI,F,EPS,GRAD)

C       ON RECOPIE GRAD DANS DUDM (CAR PB DE DIMENSIONNEMENT SI 2D)
        DO 230 I=1,NDIM
          DO 231 J=1,NDIM
            DUDM(I,J)=GRAD(I,J)
 231      CONTINUE
 230    CONTINUE

C       ------------------------------------------------
C       3) CALCUL DU CHAMP THETA ET DE SA DERIVEE (DTDM)
C       ------------------------------------------------
C
        DO 300 I=1,NDIM

          THETA(I)=0.D0
          DO 301 INO=1,NNOP
            THETA(I) = THETA(I) +  FF(INO) * ZR(ITHET-1+NDIM*(INO-1)+I)
 301      CONTINUE

          DO 310 J=1,NDIM
             DO 311 INO=1,NNOP
               DTDM(I,J) = DTDM(I,J) + ZR(ITHET-1+NDIM*(INO-1)+I)
     &                               * DFDI(INO,J)
 311        CONTINUE
 310      CONTINUE
 300    CONTINUE

C       --------------------------------------------------
C       4) CALCUL DU CHAMP DE TEMPERATURE ET DE SA DERIVEE
C       --------------------------------------------------
C
C       TEMPERATURE AU POINT DE GAUSS
        CALL RCVARC(' ','TEMP','+','XFEM',IPG,1,TEMPG,IRET)
        IF (IRET.NE.0) TEMPG=0.D0
        TTRGU = TEMPG - TREF
        TTRGV = 0.D0

        DO 400 I=1,NDIM
          TGUDM(I)=0.D0
           DO 401 INO=1,NNOP
             TGUDM(I) = TGUDM(I) + DFDI(INO,I) * TPN(INO)
 401      CONTINUE
 400    CONTINUE

C       ------------------------------------------------
C       5) CALCUL DES CHAMPS AUXILIAIRES ET DE LEURS DERIVEES
C       -----------------------------------------------------

        IF (NDIM.EQ.2) THEN
C         NON PRISE EN COMPTE DE LA COURBURE
          LCOUR=.FALSE.
        ELSEIF (NDIM.EQ.3) THEN
C         PRISE EN COMPTE DE LA COURBURE
          LCOUR=.TRUE.
C         RECUPERATION DU TENSEUR DE COURBURE
          CALL JEVECH('PCOURB','L',ICOUR)
          DO 500 I=1,NDIM
            DO 501 J=1,NDIM
              COURB(I,1,J)=ZR(ICOUR-1+NDIM*(I-1)+J)
              COURB(I,2,J)=ZR(ICOUR-1+NDIM*(I+3-1)+J)
              COURB(I,3,J)=ZR(ICOUR-1+NDIM*(I+6-1)+J)
 501        CONTINUE
 500      CONTINUE
        ENDIF

        CALL CHAUXI(NDIM,MU,KA,RG,TG,INVP,LCOUR,COURB,
     &              DU1DM,DU2DM,DU3DM,U1L,U2L,U3L)

C       CHAMPS SINGULIERS DANS LA BASE GLOBALE
        CALL VECINI(NDIM,0.D0,U1)
        CALL VECINI(NDIM,0.D0,U2)
        CALL VECINI(NDIM,0.D0,U3)
        DO 510 I=1,NDIM
          DO 511 J=1,NDIM
            U1(I) = U1(I) + P(I,J) * U1L(J)
            U2(I) = U2(I) + P(I,J) * U2L(J)
            IF (NDIM.EQ.3) U3(I) = U3(I) + P(I,J) * U3L(J)
 511      CONTINUE
 510    CONTINUE


C       -----------------------------------------------------------
C       6) CALCUL DES FORCES VOLUMIQUES ET DE LEURS DERIVEES (DFDM)
C       -----------------------------------------------------------

        CALL VECINI(12,0.D0,DFDM)
        DO 600 INO=1,NNOP
          DO 610 J=1,NDIM
            DO 620 K=1,NDIM
              DFDM(J,K) = DFDM(J,K) + FNO(NDIM*(INO-1)+J)*DFDI(INO,K)
620         CONTINUE
C           VALEUR DE LA FORCE DANS LA QUATRIEME COLONNE :
            DFDM(J,4) = DFDM(J,4) +
     &                  FNO(NDIM*(INO-1)+J)*FF(INO)
610       CONTINUE
600     CONTINUE
C
        IF (AXI) THEN
            DFDM(3,3)= DFDM(1,4)/R
        ENDIF
C
C       ---------------------------------------------
C       7) CALCUL DE G, K1, K2, K3 AU POINT DE GAUSS
C       --------------------------------------------

        CALL VECINI(3,0.D0,TZERO)
        CALL VECINI(12,0.D0,DZERO)

C       POUR L'APPEL A GIL3D/GBIL2D, ON STOCKE LES CHAMPS
C       EN DERNIERE COLONNE DES MATRICES DES DERIVEES DES CHAMPS
C       ON ETEND LES MATRICES :
C       EX : DUDM DE DIM (3,3) -> DUDME DE DIM (3,4)
        CALL VECINI(12,0.D0,DUDME)
        CALL VECINI(12,0.D0,DTDME)
        CALL VECINI(12,0.D0,DU1DME)
        CALL VECINI(12,0.D0,DU2DME)
        CALL VECINI(12,0.D0,DU3DME)
        DO 700 I=1,NDIM
          DO 701 J=1,NDIM
            DUDME(I,J) = DUDM(I,J)
            DTDME(I,J) = DTDM(I,J)
            DU1DME(I,J) = DU1DM(I,J)
            DU2DME(I,J) = DU2DM(I,J)
            DU3DME(I,J) = DU3DM(I,J)
 701      CONTINUE
          DUDME(I,4) = DEPLA(I)
          DTDME(I,4) = THETA(I)
          DU1DME(I,4) = U1(I)
          DU2DME(I,4) = U2(I)
          DU3DME(I,4) = U3(I)
 700    CONTINUE
C
        IF (AXI) THEN
            DUDME(3,3) = DUDME(1,4)/R
            DTDME(3,3) = DTDME(1,4)/R
            DU1DME(3,3) = DU1DME(1,4)/R
            DU2DME(3,3) = DU2DME(1,4)/R
            DU3DME(3,3) = DU3DME(1,4)/R
        ENDIF
C
        IF (NDIM.EQ.3) THEN

          CALL GBIL3D(DUDME,DUDME,DTDME,DFDM,DFDM,TGUDM,TGUDM,
     &                TTRGU,TTRGU,POIDS,C1,C2,C3,K3A,0.D0,0.D0,G)
          ZR(IGTHET )= ZR(IGTHET) + G

          CALL GBIL3D(DUDME,DU1DME,DTDME,DFDM,DZERO,TGUDM,TZERO,
     &                TTRGU,TTRGV,POIDS,C1,C2,C3,K3A,0.D0,0.D0,K1)
          ZR(IGTHET+4 )= ZR(IGTHET+4) + K1 * COEFK
          ZR(IGTHET+1 )= ZR(IGTHET+1) + K1 * SQRT(COEFK)

          CALL GBIL3D(DUDME,DU2DME,DTDME,DFDM,DZERO,TGUDM,TZERO,
     &                TTRGU,TTRGV,POIDS,C1,C2,C3,K3A,0.D0,0.D0,K2)
          ZR(IGTHET+5) = ZR(IGTHET+5) + K2 * COEFK
          ZR(IGTHET+2) = ZR(IGTHET+2) + K2 * SQRT(COEFK)

          CALL GBIL3D(DUDME,DU3DME,DTDME,DFDM,DZERO,TGUDM,TZERO,
     &                TTRGU,TTRGV,POIDS,C1,C2,C3,K3A,0.D0,0.D0,K3)
          ZR(IGTHET+6) = ZR(IGTHET+6) + K3 * COEFF3
          ZR(IGTHET+3) = ZR(IGTHET+3) + K3 * SQRT(COEFF3)

        ELSEIF(NDIM.EQ.2)THEN

          PULS = 0.D0

C         POUR G, COEF = 2
          COEF = 2.D0
          CS = 1.D0
          CALL GBILIN('XFEM',IPG,ZI(IMATE),DUDME,DUDME,DTDME,DFDM,
     &              TGUDM,POIDS,C1,C2,C3,CS,TH,COEF,RHO,PULS,AXI,G)

C         POUR K1, COEF = 1
          COEF = 1.D0
          CS = 0.5D0
          CALL GBILIN('XFEM',IPG,ZI(IMATE),DUDME,DU1DME,DTDME,DFDM,
     &              TGUDM,POIDS,C1,C2,C3,CS,TH,COEF,RHO,PULS,AXI,K1)
          K1 = K1*COEFK

C         POUR K2, COEF = 1
          COEF = 1.D0
          CS = 0.5D0
          CALL GBILIN('XFEM',IPG,ZI(IMATE),DUDME,DU2DME,DTDME,DFDM,
     &              TGUDM,POIDS,C1,C2,C3,CS,TH,COEF,RHO,PULS,AXI,K2)
          K2 = K2*COEFK
          IF (E3(3).LT.0) K2=-K2

          ZR(IGTHET)   = ZR(IGTHET)   + G
          ZR(IGTHET+1) = ZR(IGTHET+1) + K1/SQRT(COEFK)
          ZR(IGTHET+2) = ZR(IGTHET+2) + K2/SQRT(COEFK)
          ZR(IGTHET+3) = ZR(IGTHET+3) + K1
          ZR(IGTHET+4) = ZR(IGTHET+4) + K2

        ENDIF

 10   CONTINUE

C     ------------------------------------------------------------------
C     FIN DE LA BOUCLE SUR LES POINTS DE GAUSS DU SOUS-T�TRA
C     ------------------------------------------------------------------

      CALL JEDEMA()
      END
