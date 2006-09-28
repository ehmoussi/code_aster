      SUBROUTINE DXSIGT(NOMTE,XYZL,PGL,IC,INIV,TSUP,TINF,TMOY,SIGT)
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
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*16 NOMTE
      REAL*8 XYZL(3,1),PGL(3,1)
      REAL*8 TSUP(1),TINF(1),TMOY(1)
      REAL*8 SIGT(1)
      LOGICAL GRILLE
C     ------------------------------------------------------------------
C --- CONTRAINTES PLANES D'ORIGINE THERMIQUE AUX NOEUDS
C --- POUR LES ELEMENTS COQUES A FACETTES PLANES :
C --- DST, DKT, DSQ, DKQ, Q4G DUS :
C ---  .A UN CHAMP DE TEMPERATURES MOYEN ET
C ---  .A UN GRADIENT DE TEMPERATURES DANS L'EPAISSEUR DE LA COQUE
C --- DANS LE CAS ELASTIQUE ISOTROPE HOMOGENE
C     ------------------------------------------------------------------
C     IN  NOMTE        : NOM DU TYPE D'ELEMENT
C     IN  XYZL(3,NNO)  : COORDONNEES DES CONNECTIVITES DE L'ELEMENT
C                        DANS LE REPERE LOCAL DE L'ELEMENT
C     IN  PGL(3,3)     : MATRICE DE PASSAGE DU REPERE GLOBAL AU REPERE
C                        LOCAL
C     IN  IC           : NUMERO DE LA COUCHE
C     IN  INIV         : NIVEAU DANS LA COUCHE (-1:INF 0:MOY 1:SUP)
C     IN  TSUP(4)      : TEMPERATURES AUX NOEUDS DU PLAN SUPERIEUR
C                        DE LA COQUE
C     IN  TINF(4)      : TEMPERATURES AUX NOEUDS DU PLAN INFERIEUR
C                        DE LA COQUE
C     IN  TMOY(4)      : TEMPERATURES AUX NOEUDS DU PLAN MOYEN
C                        DE LA COQUE
C     OUT SIGT(1)      : CONTRAINTES PLANES D'ORIGINE THERMIQUE
C                        AUX NOEUDS (AU NOMBRE DE 3 OU 4)
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
      CHARACTER*2 CODRET(56)
      CHARACTER*8 NOMAIL
      CHARACTER*10 PHENOM
      REAL*8 DF(3,3),DM(3,3),DMF(3,3)
      REAL*8 N(4),T2EV(4),T2VE(4),T1VE(9),CARAT3(21),CARAQ4(25)
      REAL*8 ORDI,EPI,EPAIS
      INTEGER MULTIC,IAZK24,IADZI
C     ------------------------------------------------------------------

C --- INITIALISATIONS :
C     -----------------
      CALL R8INIR(24,0.D0,SIGT,1)

      GRILLE = .FALSE.
      IF (NOMTE(1:8).EQ.'MEGRDKT ')  GRILLE = .TRUE.

      IF (NOMTE(1:8).EQ.'MEDKTR3 ' .OR. NOMTE(1:8).EQ.'MEDSTR3 ' .OR.
     &    NOMTE(1:8).EQ.'MEGRDKT'  .OR.
     &    NOMTE(1:8).EQ.'MEDKTG3 ' ) THEN

         NNO = 3
         CALL GTRIA3(XYZL,CARAT3)
      ELSE IF (NOMTE(1:8).EQ.'MEDKQU4 ' .OR.
     &         NOMTE(1:8).EQ.'MEDSQU4 ' .OR.
     &         NOMTE(1:8).EQ.'MEQ4QU4 ' .OR.
     &         NOMTE(1:8).EQ.'MEDKQG4 ') THEN
         NNO = 4
         CALL GQUAD4(XYZL,CARAQ4)
      ELSE
         CALL U2MESK('F','ELEMENTS_14',1,NOMTE(1:8))
      END IF

      CALL JEVECH('PMATERC','L',JMATE)
      CALL RCCOMA(ZI(JMATE),'ELAS',PHENOM,CODRET)

      IF ((PHENOM.EQ.'ELAS') .OR. (PHENOM.EQ.'ELAS_COQMU')) THEN
          IF ((PHENOM.EQ.'ELAS').AND.(IC.GT.1)) THEN
           CALL TECAEL(IADZI,IAZK24)
           NOMAIL = ZK24(IAZK24-1+3)(1:8)
           CALL UTDEBM ('F','DMATEL','NUMERO DE')
           CALL UTIMPI ( 'S', ' COUCHE ', 1, ICOU )
           CALL UTIMPK ( 'S', ' TROP GRAND PAR RAPPORT AU NOMBRE '//
     &               'DE COUCHES AUTORISE POUR LA MAILLE ', 1, NOMAIL )
           CALL UTFINM ()
          ENDIF

C --- RECUPERATION DE LA TEMPERATURE DE REFERENCE ET
C --- DE L'EPAISSEUR DE LA COQUE
C     --------------------------

        CALL JEVECH('PCACOQU','L',JCARA)
        CALL JEVECH('PTEREF' ,'L',JTREF)
        EPAIS = ZR(JCARA)
        TREF  = ZR(JTREF)

C --- CALCUL DES MATRICES DE HOOKE DE FLEXION, MEMBRANE,
C --- MEMBRANE-FLEXION, CISAILLEMENT, CISAILLEMENT INVERSE
C     ----------------------------------------------------

        CALL DMATHL(ORDI,EPI,EPAIS,DF,DM,DMF,NNO,PGL,MULTIC,IC,
     &              INDITH,GRILLE,T2EV,T2VE,T1VE)
        IF (INDITH.EQ.-1) GO TO 20

C --- BOUCLE SUR LES NOEUDS
C     ---------------------
        DO 10 INO = 1,NNO

C  --      LES COEFFICIENTS SUIVANTS RESULTENT DE L'HYPOTHESE SELON
C  --      LAQUELLE LA TEMPERATURE EST PARABOLIQUE DANS L'EPAISSEUR.
C  --      LES COEFFICIENTS THERMOELASTIQUES PROVIENNENT DES
C  --      MATRICES QUI SONT LES RESULTATS DE LA ROUTINE DXMATH.
C          ----------------------------------------
          COE1 = (TSUP(INO)+TINF(INO)+4.D0*TMOY(INO))/6.D0 - TREF
          COE2 = (TSUP(INO)-TINF(INO))* (ORDI+DBLE(INIV)*EPI/2.D0)/EPAIS

          SIGT(1+6* (INO-1)) = ((DM(1,1)+DM(1,2))/EPI)* (COE1+COE2)
          SIGT(2+6* (INO-1)) = ((DM(2,1)+DM(2,2))/EPI)* (COE1+COE2)
          SIGT(4+6* (INO-1)) = ((DM(3,1)+DM(3,2))/EPI)* (COE1+COE2)
   10   CONTINUE

      ELSE

C --- CAS ELAS_COQUE

        CALL U2MESK('A','ELEMENTS_51',1,PHENOM(1:10))
      END IF

   20 CONTINUE

      END
