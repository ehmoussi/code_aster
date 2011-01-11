      SUBROUTINE NMORTH (FAMI,KPG,KSP,NDIM,PHENOM,TYPMOD,IMATE,
     &                   EPSM,DEPS,SIGM,OPTION,ANGMAS,SIGP,VIP,
     &                   DSIDEP)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 10/01/2011   AUTEUR PROIX J-M.PROIX 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT NONE
      CHARACTER*(*)    FAMI
      INTEGER          KPG,KSP,NDIM,IMATE
      REAL*8           EPSM(6),DEPS(6),SIGM(6),SIGP(6)
      REAL*8           ANGMAS(3),DSIDEP(6,6),P(3,3),VIP
      CHARACTER*16     OPTION,PHENOM
      CHARACTER*8      TYPMOD(*)
C TOLE CRP_21

C  IN    FAMI   : FAMILLE DE POINT DE GAUSS
C  IN    KPG    : NUMERO DU POINT DE GAUSS
C  IN    KSP    : NUMERO DU SOUS POINT DE GAUSS
C  IN    NDIM   : DIMENSION DU PROBLEME
C  IN    PHENOM : PHENOMENE (ELAS_ORTH OU ELAS_ISTR)
C  IN    TYPMOD : TYPE DE MODELISATION
C  IN    IMATE  : ADRESSE DU MATERIAU
C  IN    EPSM   : DEFORMATION A L INSTANT T-
C  IN    DESPS  : INCREMENT DE DEFORMATION
C  IN    SIGM   : CONTRAINTE A L INSTANT T-
C  IN    OPTION : OPTION A CALCULER
C  IN    ANGMAS : ANGLE DU REPERE LOCAL D ORTHOTROPIE
C  OUT   SIGP   : CONTRAINTE A L INSTANT T+
C  OUT   VIP    : VARIABLE INTERNE (NECESSAIRE
C                 CAR IL EN EXISTE FORCEMENT UNE)
C  OUT   DSIDEP : MATRICE DE RIGIDITE TANGENTE

C     VARIABLE LOCALE
      REAL*8 RBID,R8VIDE,REPERE(4),HOOKF(36),MKOOH(36),XYZGAU(3)
      REAL*8 VALPAR(3),VALRES(3),DEPLTH(6),DEPGTH(6),DEPSTR(6)
      REAL*8 DEPSME(6),RAC2,VEPST1(6),VEPST2(6),EPSM2(6)
      INTEGER IRET,NBSIGM,I,J
      CHARACTER*8 NOMPAR(2)
      CHARACTER*2 CODRET(3),K2BID
      LOGICAL     LTEATT,VRAI

      K2BID = '  '

      RAC2=SQRT(2.D0)
      NBSIGM=NDIM*2
      CALL R8INIR(36, 0.D0, DSIDEP, 1)

      IF ( OPTION.EQ.'FULL_MECA'.OR.OPTION.EQ.'RAPH_MECA') THEN
      DO 1 I=1,NBSIGM
        IF (I.LE.3) THEN
         DEPSTR(I)=DEPS(I)
       ELSE
         DEPSTR(I)=DEPS(I)*RAC2
       ENDIF
 1    CONTINUE
      ENDIF

      IF (ANGMAS(1).EQ.R8VIDE()) CALL U2MESS('F','ALGORITH8_20')

      REPERE(1)=1.D0
      REPERE(2)=ANGMAS(1)

      VRAI = .FALSE.
      IF (LTEATT(' ','DIM_TOPO_MAILLE','3')) THEN
        REPERE(3)=ANGMAS(2)
        REPERE(4)=ANGMAS(3)
        VRAI = .TRUE.
      ELSE IF (LTEATT(' ','C_PLAN','OUI')) THEN
        VRAI = .TRUE.
      ELSE IF (LTEATT(' ','D_PLAN','OUI')) THEN
        VRAI = .TRUE.
      ELSE IF (LTEATT(' ','AXIS','OUI'))   THEN
        VRAI = .TRUE.
      ENDIF

      IF(.NOT.VRAI) CALL U2MESS('F','ALGORITH8_22')

      DO 2 I=1,NBSIGM
        DEPGTH(I)=0.D0
2     CONTINUE

C     APPEL A DMATMC POUR RECUPERER LA MATRICE TANGENTE
      IF ( OPTION.EQ.'RIGI_MECA_TANG') THEN
         CALL DMATMC(FAMI,K2BID,IMATE,RBID,'-',KPG,KSP,REPERE,
     &               XYZGAU,NBSIGM,HOOKF,.FALSE.)
      ELSE
         CALL D1MAMC(FAMI,IMATE,RBID,'-',KPG,KSP,REPERE,
     &               XYZGAU,NBSIGM,MKOOH)
         CALL DMATMC(FAMI,K2BID,IMATE,RBID,'+',KPG,KSP,REPERE,
     &               XYZGAU,NBSIGM,HOOKF,.FALSE.)
      ENDIF

      IF ( OPTION.EQ.'RIGI_MECA_TANG'.OR.
     &     OPTION.EQ.'FULL_MECA') THEN
        DO 10 I=1,NBSIGM
          DO 20 J=1,NBSIGM
            DSIDEP(I,J)=HOOKF(NBSIGM*(J-1)+I)
 20       CONTINUE
 10     CONTINUE
      ENDIF

      IF ( OPTION.EQ.'FULL_MECA'.OR.OPTION.EQ.'RAPH_MECA') THEN


        IF (PHENOM.EQ.'ELAS_ORTH') THEN

          CALL VERIFT(FAMI,KPG,KSP,'T',IMATE,'ELAS_ORTH',3,
     &                VALRES,IRET)
          DEPLTH(1) = VALRES(1)
          DEPLTH(2) = VALRES(2)
          DEPLTH(3) = VALRES(3)


        ELSE IF (PHENOM.EQ.'ELAS_ISTR') THEN

C RECUPERATION DES PARAMETRES MATERIAUX A L INSTANT -

          CALL VERIFT(FAMI,KPG,KSP,'T',IMATE,'ELAS_ORTH',2,
     &                VALRES,IRET)
          DEPLTH(1) = VALRES(1)
          DEPLTH(2) = VALRES(1)
          DEPLTH(3) = VALRES(2)

        ENDIF

C INCREMENT DE DEFORMATIONS D ORIGINE THERMIQUE DANS LE REPERE LOCAL

        DEPLTH(4)=0.D0
        DEPLTH(5)=0.D0
        DEPLTH(6)=0.D0

C RECUPERATION DE LA MATRICE DE PASSAGE
        CALL MATROT(ANGMAS,P)

C PASSAGE DU TENSEUR DES DEFORMATIONS THERMIQUES DANS LE REPERE GLOBAL

        VEPST1(1)=DEPLTH(1)
        VEPST1(2)=DEPLTH(4)
        VEPST1(3)=DEPLTH(2)
        VEPST1(4)=DEPLTH(5)
        VEPST1(5)=DEPLTH(6)
        VEPST1(6)=DEPLTH(3)
        CALL UTPSLG(1,3,P,VEPST1,VEPST2)

        DEPGTH(1)=VEPST2(1)
        DEPGTH(2)=VEPST2(3)
        DEPGTH(3)=VEPST2(6)
        DEPGTH(4)=VEPST2(2)
        DEPGTH(5)=VEPST2(4)
        DEPGTH(6)=VEPST2(5)
C CALCUL DES DEFORMATIONS MECANIQUES
C ATTENTION LES TERMES EXTRA DIAGONAUX DE DEFORMATIONS THERMIQUES
C DOIVENT ETRE MULTIPLIES PAR DEUX POUR ETRE CONFORME AVEC
C LA MATRICE DE RIGIDITE ISSU DE DMATMC (ET DONC AVEC DEPSTR AUSSI)

        DO 30 I=1,NBSIGM
          IF (I.LE.3) THEN
            DEPSME(I)=DEPSTR(I)-DEPGTH(I)
          ELSE
            DEPSME(I)=DEPSTR(I)-2.D0*DEPGTH(I)
          ENDIF
 30     CONTINUE

C CONTRAINTE A L ETAT +
        DO 55 I=4,NBSIGM
           SIGM(I)=SIGM(I)/RAC2
 55     CONTINUE
C MODIFICATIOn DE SIGM POUR PRENDRE EN COMPTE LA VARIATION DE 
C COEF ELASTIQUES AVEC LA TEMPERATURE

        DO 40 I=1,NBSIGM
          EPSM2(I)=0.D0
          DO 50 J=1,NBSIGM
            EPSM2(I)=EPSM2(I)+MKOOH(NBSIGM*(J-1)+I)*SIGM(J)
 50       CONTINUE
 40     CONTINUE
 
        DO 60 I=1,NBSIGM
           SIGP(I)=0.D0
           DO 70 J=1,NBSIGM
            SIGP(I)=SIGP(I)+HOOKF(NBSIGM*(J-1)+I)*(DEPSME(J)+EPSM2(J))
 70       CONTINUE
 60     CONTINUE

C PAS DE VARIABLE INTERNE POUR CE COMPORTEMENT
        VIP=0.D0

C REMISE AU FORMAT ASTER DES VALEURS EXTRA DIAGONALES
        DO 80 I=4,NBSIGM
         SIGP(I)=SIGP(I)*RAC2
80      CONTINUE
      ENDIF

      IF ( OPTION.EQ.'RIGI_MECA_TANG'.OR.
     &     OPTION.EQ.'FULL_MECA') THEN
           DO 67 I=1,6
           DO 67 J=4,6
             DSIDEP(I,J) = DSIDEP(I,J)*SQRT(2.D0)
 67        CONTINUE
           DO 68 I=4,6
           DO 68 J=1,6
             DSIDEP(I,J) = DSIDEP(I,J)*SQRT(2.D0)
 68        CONTINUE
      ENDIF

      END
