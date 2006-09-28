       SUBROUTINE NMGP2D(NNO, NPG, IPOIDS, IVF, IDFDE, GEOMI,TYPMOD,
     &                   OPTION, IMATE, COMPOR, LGPG, CRIT,
     &                   INSTM, INSTP,
     &                   TM, TP, TREF,
     &                   DEPLM, DDEPL,
     &                   ANGMAS,
     &                   SIGM, VIM, DFDIM,
     &                   DFDIP, SIGP, VIP, MATNS, VECTU, CODRET )

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C RESPONSABLE MABBAS M.ABBAS
C TOLE CRP_21

       IMPLICIT NONE
       INTEGER       NNO, NPG, IMATE, LGPG, CODRET,IPOIDS,IVF,IDFDE
       CHARACTER*8   TYPMOD(*)
       CHARACTER*16  OPTION, COMPOR(4)
       REAL*8        GEOMI(2,NNO), CRIT(3), INSTM, INSTP
       REAL*8        TM(NNO), TP(NNO), TREF
       REAL*8        DEPLM(2,NNO), DDEPL(2,NNO), SIGM(4,NPG)
       REAL*8        VIM(LGPG,NPG), DFDIM(NNO,2),DFDIP(NNO,2)
       REAL*8        SIGP(4,NPG), VIP(LGPG,NPG)
       REAL*8        MATNS(2,NNO,2,NNO), VECTU(2,NNO)
       REAL*8        ANGMAS(3)

C.......................................................................
C
C     BUT:  CALCUL  DES OPTIONS RIGI_MECA_TANG, RAPH_MECA ET FULL_MECA
C           EN GRANDES DEFORMATIONS 2D (D_PLAN ET AXI)
C.......................................................................
C IN  NNO     : NOMBRE DE NOEUDS DE L'ELEMENT
C IN  NPG     : NOMBRE DE POINTS DE GAUSS
C IN  POIDSG  : POIDS DES POINTS DE GAUSS
C IN  VFF     : VALEUR  DES FONCTIONS DE FORME
C IN  DFDE    : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
C IN  DFDK    : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
C IN  GEOMI   : COORDONNEES DES NOEUDS (CONFIGURATION INITIALE)
C IN  TYPMOD  : TYPE DE MODELISATION
C IN  OPTION  : OPTION DE CALCUL
C IN  IMATE   : MATERIAU CODE
C IN  COMPOR  : COMPORTEMENT
C IN  LGPG    : "LONGUEUR" DES VARIABLES INTERNES POUR 1 POINT DE GAUSS
C                CETTE LONGUEUR EST UN MAJORANT DU NBRE REEL DE VAR.INT.
C IN  CRIT    : CRITERES DE CONVERGENCE LOCAUX
C IN  INSTM   : VALEUR DE L'INSTANT T-
C IN  INSTP   : VALEUR DE L'INSTANT T+
C IN  TM      : TEMPERATURE AUX NOEUDS EN T-
C IN  TP      : TEMPERATURE AUX NOEUDS EN T+
C IN  TREF    : TEMPERATURE DE REFERENCE
C IN  DEPLM   : DEPLACEMENT EN T-
C IN  DDEPL   : INCREMENT DE DEPLACEMENT ENTRE T- ET T+
C IN  ANGMAS  : LES TROIS ANGLES DU MOT_CLEF MASSIF (AFFE_CARA_ELEM)
C IN  SIGM    : CONTRAINTES DE CAUCHY EN T-
C IN  VIM     : VARIABLES INTERNES EN T-
C OUT DFDIM   : DERIVEES DES FONCTIONS DE FORMES CONF T- (DERN PT GAUSS)
C OUT DFDIP   : DERIVEES DES FONCTIONS DE FORMES CONF T+ (DERN PT GAUSS)
C OUT SIGP    : CONTRAINTES DE CAUCHY (RAPH_MECA ET FULL_MECA)
C OUT VIP     : VARIABLES INTERNES    (RAPH_MECA ET FULL_MECA)
C OUT MATUU   : MATRICE DE RIGIDITE PROFIL (RIGI_MECA_TANG ET FULL_MECA)
C OUT VECTU   : FORCES INTERIEURES (RAPH_MECA ET FULL_MECA)
C OUT IRET    : CODE RETOUR DE L'INTEGRATION DE LA LDC
C               IRET=0 => PAS DE PROBLEME
C               IERT=1 => DJ<0 ET INTEGRATION IMPOSSIBLE
C.......................................................................
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER  ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

      LOGICAL GRAND, AXI, RESI, RIGI
      INTEGER KPG,N,A,M,B,G
      REAL*8  GEOMM(2,9), GEOMP(2,9), R8VIDE
      REAL*8  FM(3,3), DF(3,3), FBID(3,3), RM, RP, EPS(6), POIDS
      REAL*8  DSIDEP(6,3,3)
      REAL*8  SIGMP(4), SIGDF(2,9), DSIDF(2,2,2,9)
      REAL*8  MIAX1(2,9), MIAX2(2,9), MIAX3(9)
      REAL*8  TEMPM,TEMPP
      REAL*8  ELGEOM(10)
      INTEGER IND(3,3), COD(9)
      PARAMETER (GRAND = .TRUE.)
      DATA    IND / 1, 4, 5,
     &              4, 2, 6,
     &              5, 6, 3 /


C - INITIALISATION ET VERIFICATIONS
      IF (NNO.GT.9) CALL U2MESS('F','ALGORITH7_99')
      IF (TYPMOD(1).EQ.'C_PLAN') CALL U2MESS('F','ALGORITH8_1')
      AXI  = TYPMOD(1).EQ.'AXIS'
      RESI = OPTION(1:4).EQ.'RAPH' .OR. OPTION(1:4).EQ.'FULL'
      RIGI = OPTION(1:4).EQ.'RIGI' .OR. OPTION(1:4).EQ.'FULL'
      DO 5 N = 1,NNO
        DO 6 A = 1,2
          GEOMM(A,N) = GEOMI(A,N) + DEPLM(A,N)
          GEOMP(A,N) = GEOMI(A,N) + DEPLM(A,N) + DDEPL(A,N)
 6      CONTINUE
 5    CONTINUE
      IF (RESI) CALL R8INIR(2*NNO,     0.D0, VECTU, 1)
      IF (RIGI) CALL R8INIR(4*NNO*NNO, 0.D0, MATNS, 1)
      CALL R8INIR(10,0.D0,ELGEOM,1)

C - INITIALISATION CODES RETOURS
      DO 7 KPG=1,NPG
         COD(KPG)=0
 7    CONTINUE

C - CALCUL POUR CHAQUE POINT DE GAUSS
      DO 10 KPG=1,NPG

C - CALCUL DE LA TEMPERATURE AU POINT DE GAUSS
        TEMPM = 0.D0
        TEMPP = 0.D0
        DO 15 N=1,NNO
          TEMPM = TEMPM + TM(N)*ZR(IVF+N+(KPG-1)*NNO-1)
          TEMPP = TEMPP + TP(N)*ZR(IVF+N+(KPG-1)*NNO-1)
 15     CONTINUE


C - CALCUL DES ELEMENTS GEOMETRIQUES
C     CALCUL DE F EN T-  =>  FM
        CALL NMGEOM(2,NNO,AXI,GRAND,GEOMI,KPG,IPOIDS,
     &              IVF,IDFDE,DEPLM,POIDS,DFDIM,
     &              FM,EPS,RM)

C     CALCUL DE F POUR DT  =>  DF, RM  ET DFDIM
        CALL NMGEOM(2,NNO,AXI,GRAND,GEOMM,KPG,IPOIDS,
     &              IVF,IDFDE,DDEPL,POIDS,DFDIM,
     &              DF,EPS,RM)

C     CALCUL DE DFDIP, RP ET POIDS EN T+
        CALL NMGEOM(2,NNO,AXI,GRAND,GEOMP,KPG,IPOIDS,
     &              IVF,IDFDE,DEPLM,POIDS,DFDIP,
     &              FBID,EPS,RP)

C -   APPEL A LA LOI DE COMPORTEMENT
       CALL NMCOMP('RIGI',KPG,1,2,TYPMOD,IMATE,COMPOR,CRIT,
     &             INSTM,INSTP,
     &             TEMPM,TEMPP,TREF,
     &             FM,DF,
     &             SIGM(1,KPG),VIM(1,KPG),
     &             OPTION,ANGMAS,ELGEOM,
     &             SIGP(1,KPG),VIP(1,KPG),DSIDEP,COD(KPG))

       IF(COD(KPG).EQ.1) THEN
         GOTO 10
       ENDIF


C - CALCUL DE LA MATRICE DE RIGIDITE
        IF (RESI) THEN
            SIGMP(1) = SIGP(1,KPG)
            SIGMP(2) = SIGP(2,KPG)
            SIGMP(3) = SIGP(3,KPG)
            SIGMP(4) = SIGP(4,KPG)
        ELSE
            SIGMP(1) = SIGM(1,KPG)
            SIGMP(2) = SIGM(2,KPG)
            SIGMP(3) = SIGM(3,KPG)
            SIGMP(4) = SIGM(4,KPG)
        END IF

        DO 500 N = 1,NNO
          DO 510 A = 1,2
            SIGDF(A,N) = SIGMP(IND(A,1))*DFDIP(N,1)
     &                 + SIGMP(IND(A,2))*DFDIP(N,2)
 510      CONTINUE
 500    CONTINUE

        IF (RIGI) THEN
          DO 600 A = 1,2
            DO 610 N = 1,NNO
              DO 620 B = 1,2
                DO 630 G = 1,2
                  DSIDF(A,B,G,N) = DSIDEP(IND(A,1),B,G)*DFDIP(N,1)
     &                           + DSIDEP(IND(A,2),B,G)*DFDIP(N,2)
 630            CONTINUE
 620          CONTINUE
 610        CONTINUE
 600      CONTINUE
          DO 130 N = 1,NNO
            DO 131 M = 1,NNO
              DO 132 A = 1,2
                DO 133 B = 1,2
                  MATNS(A,N,B,M) = MATNS(A,N,B,M) + POIDS * (
     &                 DFDIP(N,A) * SIGDF(B,M) - DFDIP(M,A) * SIGDF(B,N)
     &               + DFDIM(N,1) * DSIDF(B,A,1,M)
     &               + DFDIM(N,2) * DSIDF(B,A,2,M) )
 133            CONTINUE
 132          CONTINUE
 131        CONTINUE
 130      CONTINUE

C        TERMES COMPLEMENTAIRES EN AXISYMETRIQUE
          IF (AXI) THEN
            DO 700 N = 1,NNO
              DO 710 A = 1,2
                MIAX1(A,N) = (  SIGMP(3)     *DFDIP(N,A)
     &                        + DSIDEP(3,A,1)*DFDIM(N,1)
     &                        + DSIDEP(3,A,2)*DFDIM(N,2)) / RP
 710          CONTINUE
 700        CONTINUE
            DO 720 N = 1,NNO
              DO 730 A = 1,2
                MIAX2(A,N) = (  SIGMP(IND(A,1))*DFDIP(N,1)
     &                        + SIGMP(IND(A,2))*DFDIP(N,2) )/RP
     &                     + (  DSIDEP(IND(A,1),3,3)*DFDIP(N,1)
     &                       +  DSIDEP(IND(A,2),3,3)*DFDIP(N,2) ) /RM
 730          CONTINUE
 720        CONTINUE
            DO 740 N = 1,NNO
              MIAX3(N) = DSIDEP(3,3,3)*ZR(IVF+N+(KPG-1)*NNO-1)/(RM*RP)
 740        CONTINUE
            DO 800 M = 1,NNO
              DO 810 N = 1,NNO
                DO 820 A = 1,2
                  MATNS(A,N,1,M) = MATNS(A,N,1,M)
     &                        + POIDS*MIAX1(A,N)*ZR(IVF+M+(KPG-1)*NNO-1)
 820            CONTINUE
 810          CONTINUE
              DO 830 N = 1,NNO
                DO 840 A = 1,2
                  MATNS(1,M,A,N) = MATNS(1,M,A,N)
     &                        + POIDS*MIAX2(A,N)*ZR(IVF+M+(KPG-1)*NNO-1)
 840            CONTINUE
 830          CONTINUE
              DO 850 N = 1,NNO
                MATNS(1,M,1,N) = MATNS(1,M,1,N)
     &                      + POIDS * MIAX3(N) *ZR(IVF+M+(KPG-1)*NNO-1)
 850          CONTINUE
 800        CONTINUE
          END IF
        ENDIF


C - CALCUL DE LA FORCE INTERIEURE
        IF(RESI) THEN
          DO 180 N=1,NNO
            DO 181 A=1,2
              VECTU(A,N) = VECTU(A,N) + POIDS * SIGDF(A,N)
 181        CONTINUE
 180      CONTINUE

C        TERMES COMPLEMENTAIRES EN AXISYMETRIQUE
          IF (AXI) THEN
            DO 190 N = 1,NNO
              VECTU(1,N)=VECTU(1,N)+POIDS*SIGMP(3)
     &                   * ZR(IVF+N+(KPG-1)*NNO-1)/RP
 190        CONTINUE
          ENDIF
        ENDIF

 10   CONTINUE

C - SYNTHESE DES CODES RETOURS
      CALL CODERE(COD,NPG,CODRET)
      END
