      SUBROUTINE NMINIT(RESULT,MODELE,MODEDE,NUMEDD,MATE,SOLVDE,NUMEDE,
     &                 COMPOR,CARELE,MEMASS,MEDIRI,LISCHA,DEPPLU,DEPMOI,
     &                 SIGPLU,SIGMOI,VARPLU,VARMOI,VALMOI,VITPLU,ACCPLU,
     &                 MAPREC,SOLVEU,DEPENT,VITENT,ACCENT,CARCRI,COMMOI,
     &                 COMPLU,VARDEP,LAGDEP,VARIGV,CNFEDO,CNFEPI,CNDIDO,
     &                 CNDIPI,CNFSDO,CNFSPI,CNDIDI,CNCINE,DEPKM1,VITKM1,
     &                 ACCKM1,ROMKM1,ROMK  ,DDEPLA,FONDEP,FONVIT,FONACC,
     &                 MULTAP,PSIDEL,VALPLU,SECMBR,POUGD ,MULTIA,PARTPS,
     &                 NURO  ,REAROT,VARDEM,LAGDEM,PILOTE,DEFICO,RESOCO,
     &                 CRITNL,ZFON  ,FONACT,CMD   ,NBMODS,CNVFRE,PARCON,
     &                 PARCRI,ICONTX,NBPASE,INPSCO,LISCH2,NBOBSE,NUINS0,
     &                 LOBSER,NUOBSE,NOMTAB,MAILL2,NBOBAR,LISINS,LISOBS,
     &                 INSTAM,IMPRCO)

C MODIF ALGORITH  DATE 23/01/2006   AUTEUR MABBAS M.ABBAS 
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
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
C TOLE CRP_21 CRP_20

      IMPLICIT NONE
      INTEGER      ZFON
      LOGICAL REAROT,FONACT(ZFON),LOBSER
      INTEGER NBMODS,NBPASE,ICONTX
      INTEGER NBOBSE, NUINS0,NUOBSE,NBOBAR
      REAL*8      PARCON(5),PARCRI,R8VIDE,INSTAM,DIINST
      CHARACTER*8 MODEDE,RESULT,MAILL2
      CHARACTER*19 NOMTAB,LISOBS
      CHARACTER*24 LISINS
      CHARACTER*13 INPSCO
      CHARACTER*14 PILOTE,NUPOSS
      CHARACTER*16 CMD
      CHARACTER*19 LISCHA,SOLVEU,SOLVDE,NURO,PARTPS,CRITNL
      CHARACTER*19 LISCH2
      CHARACTER*19 MAPREC,CNVFRE
      CHARACTER*24 MODELE,COMPOR,NUMEDD,NUMEDE,VALMOI(8),DEPMOI
      CHARACTER*24 DEFICO,RESOCO,CARCRI,DEPENT,VITENT,ACCENT
      CHARACTER*24 CNDIDI,VARDEM,LAGDEM
      CHARACTER*24 MATE,CARELE,MEMASS,MEDIRI
      CHARACTER*24 VITPLU,ACCPLU
      CHARACTER*24 SIGMOI, VARMOI
      CHARACTER*24 DEPPLU, SIGPLU, VARPLU, VARDEP, LAGDEP
      CHARACTER*24 COMMOI, COMPLU, DDEPLA
      CHARACTER*24 CNFEDO, CNFEPI, CNDIDO, CNDIPI, CNFSDO, CNFSPI
      CHARACTER*24 CNCINE, VARIGV
      CHARACTER*24 DEPKM1, VITKM1, ACCKM1, ROMKM1
      CHARACTER*24 ROMK,   FONDEP, FONVIT, FONACC, MULTAP, PSIDEL
      CHARACTER*24 VALPLU(8), SECMBR(8), POUGD(8), MULTIA(8)
      CHARACTER*24 IMPRCO

C ---------------------------------------------------------------------

C               COMMANDES STAT/DYNA_NON_LINE : INITIALISATIONS

C ---------------------------------------------------------------------

C       IN RESULT K8   NOM UTILISATEUR DU RESULTAT DE STAT_NON_LINE
C       IN MODELE K24  MODELE MECANIQUE
C       IN MODEDE K8   MODELE NON LOCAL
C      OUT NUMEDD K24  NOM DE LA NUMEROTATION MECANIQUE
C       IN MATE   K24  NOM DU CHAMP DE MATERIAU
C       IN SOLVDE K19  NOM DU SOLVEUR DU LAGRANGIEN AUGMENTE
C      OUT NUMEDE K24  NOM DE LA NUMEROTATION NON LOCALE
C       IN COMPOR K24  CARTE COMPORTEMENT
C       IN CARELE K24  CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
C IN/JXOUT MEMASS K24  MATRICES ELEMENTAIRES DE MASSE  
C IN/JXOUT MEDIRI K24  MATRICES ELEMENTAIRES DE RIGIDITE DIRICHLET
C       IN LISCHA K19  SD L_CHARGE
C IN/JXOUT DEPPLU K24  DEPLACEMENT INSTANT PLUS
C IN/JXOUT DEPMOI K24  DEPLACEMENTS INITIAUX
C IN/JXOUT SIGPLU K24  CONTRAINTES INSTANT PLUS
C IN/JXOUT SIGMOI K24  CONTRAINTES  INITIALES
C IN/JXOUT VARPLU K24  VARIABLES INSTANT PLUS
C IN/JXOUT VARMOI K24  VARIABLES INTERNES INITIALES
C IN/JXOUT VALMOI K24  VARIABLE CHAPEAU ETAT INITAL
C IN/JXOUT VITPLU K24  VITESSE INSTANT PLUS
C IN/JXOUT ACCPLU K24  ACCELERATION INSTANT PLUS
C IN/JXOUT MAPREC K19  MATRICE PRECONDITIONNEMENT
C      IN  SOLVEU K19  NOM DU SOLVEUR DE NEWTON
C IN/JXOUT DEPENT K24  CHAMP MULTI APPUI
C IN/JXOUT VITENT K24  CHAMP MULTI APPUI
C IN/JXOUT ACCENT K24  CHAMP MULTI APPUI
C IN/JXOUT CARCRI K24  CARTE DES CRITERES DE CONVERGENCE LOCAUX
C IN/JXOUT COMMOI K24  VARIABLES DE COMMANDE INSTANT MOINS
C IN/JXOUT COMPLU K24  VARIABLES DE COMMANDE INSTANT PLUS
C IN/JXOUT VARDEP K24  VARIABLES INTERNES MODELISATION NON LOCALE
C IN/JXOUT LAGDEP K24  MULTIPLICATEURS MODELISATION NON LOCALE
C IN/JXOUT VARIGV K24  GRADIENT VARIABLE MODELISATION NON LOCALE
C IN/JXOUT CNFEDO K24  CHARGEMENT FORCES FIXES
C IN/JXOUT CNFEPI K24  CHARGEMENT FORCES PILOTEES
C IN/JXOUT CNDIDO K24  CHARGEMENT DIRICHLETS FIXES
C IN/JXOUT CNDIPI K24  CHARGEMENT DIRICHLET PILOTES
C IN/JXOUT CNFSPI K24  CHARGEMENT FORCES SUIVEUSES
C IN/JXOUT CNDIDI K24  DIRICHLET DIFFERENTIEL B_DIDI.U_REF
C IN/JXOUT CNCINE K24  CHARGES CINEMATIQUES
C IN/JXOUT DEPKM1 K24  DEPLACEMENT ITERATION MOINS
C IN/JXOUT VITKM1 K24  VITESSE ITERATION MOINS
C IN/JXOUT ACCKM1 K24  ACCELERATION ITERATION MOINS
C IN/JXOUT ROMKM1 K24  VECTEUR ROTATION ITERATION MOINS
C IN/JXOUT ROMK   K24  VECTEUR ROTATION ITERATION COURANTE
C IN/JXOUT DDEPLA K24  INCREMENT DEPLACEMENT
C IN/JXOUT FONDEP K24  NOM DE LA FONCTION DEPLACEMENT
C IN/JXOUT FONVIT K24  NOM DE LA FONCTION VITESSE
C IN/JXOUT FONACC K24  NOM DE LA FONCTION ACCELERATION
C IN/JXOUT MULTAP K24  INFOS MULTIAPPUIS
C IN/JXOUT PARTPS K24  INFOS SUR DISCRETISATION TEMPORELLE
C IN/JXOUT NURO   K19  NUMEROTATION DES DDL DE GRANDES ROTATIONS
C      OUT REAROT  L   .TRUE. S'IL Y A DES DDL DE GRANDES ROTATIONS
C IN/JXOUT VARDEM K24  VARIABLES NON LOCALES INITIALES
C IN/JXOUT LAGDEM K24  MULTIPLICATEURS DE LAGRANGE NON LOCAUX INITIAUX
C IN/JXOUT PILOTE K14  SD ASSOCIEE AU PILOTAGE
C      OUT DEFICO K24  SD DE DEFINITION DU CONTACT
C IN/JXOUT RESOCO K24  SD DE TRAITEMENT NUMERIQUE DU CONTACT
C IN/JXOUT IMPRCO K24  SD AFFICHAGE
C IN/JXOUT CRITNL K19  SD ARCHIVAGE DES PARAMETRES A CONVERGENCE
C       IN ZFON    I   LONGUEUR DU VECTEUR FONACT
C      OUT FONACT  L   FONCTIONNALITES SPECIFIQUES ACTIVEES
C            FONACT(1):  RECHERCHE LINEAIRE
C            FONACT(2):  PILOTAGE
C            FONACT(3):  LOIS NON LOCALES
C            FONACT(4):  CONTACT DISCRET
C            FONACT(5):  CONTACT CONTINU
C            FONACT(6):  METHODE XFEM
C            FONACT(7):  ALGORITHME DE DE BORST
C            FONACT(8):  CONVERGENCE PAR RESIDU DE REFERENCE
C            FONACT(9):  METHODE XFEM AVEC CONTACT
C            FONACT(10): CONTACT/FROTTEMENT CONTINU
C       IN CMD    K16  NOM DE LA COMMANDE 
C                         STAT_NON_LINE
C                         DYNA_NON_LINE
C                         DYNA_TRAN_EXPLI
C       IN NBMODS  I   NOMBRE MODES STATIQUES MODELISATION MULTI-APPUI
C IN/JXOUT CNVFRE K19  FORCE DE REFERENCE POUR CONVERGENCE EN REFERENCE
C       IN PARCON  R8  PARAMETRES DU CRITERE DE CONVERGENCE REFERENCE
C                         SI PARCRI(6)=RESI_CONT_RELA != R8VIDE()
C                            1 : SIGM_REFE
C                            2 : FLUX_THER_REFE
C                            3 : FLUX_HYD1_REFE
C                            4 : FLUX_HYD2_REFE
C       IN PARCRI  R8  PARCRI(6) = RESI_CONT_RELA : R8VIDE SI NON ACTIF
C      OUT ICONTX  I   CONTACT X-FEM : ICONTX = 1 SI CONTACT X-FEM
C                                               0 SINON
C       IN NBPASE  I   NOMBRE DE PARAMETRES SENSIBLES
C       IN INPSCO K13  SD CONTENANT LISTE DES NOMS POUR SENSIBILITE
C IN/JXOUT LISCH2 K19  NOM DE LA SD INFO CHARGE POUR STOCKAGE DANS LA SD
C                       RESULTAT
C      OUT  NBOBSE   NOMBRE DE PAS A OBSERVER
C      OUT  NUINS0   NUMERO DU PREMIER INSTANT DE CALCUL DANS LISTE
C                      D'INSTANT D'OBSERVATION
C      OUT  LOBSER   BOOLEEN OBSERVATION
C       IN  INSTAM   PREMIER INSTANT DE CALCUL
C       IN  RESULT   NOM UTILISATEUR DU RESULTAT
C      OUT  NUOBSE   ??
C      OUT  NOMTAB   NOM DE LA TABLE RESULTAT DE L'OBSERVATION
C      OUT  MAILL2   MAILLAGE OBSERVATION (?)
C      OUT  NBOBAR   LONGUEUR DU CHAMP OBSERVE
C      OUT  LISINS   LISTE D'INSTANTS DE L'OBSERVATION
C IN/JXOUT  LISOBS   SD LISTE OBSERVATION
C      OUT  INSTAM   INSTANT INITIAL
C   -------------------------------------------------------------------
C     ASTER INFORMATIONS:
C       19/03/04 (OB): PAR ADHERENCE A NUMER2.
C----------------------------------------------------------------------
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ---------------------------

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

C --- FIN DECLARATIONS NORMALISEES JEVEUX -----------------------------
      LOGICAL      EXIGEO,EXICAR
      INTEGER      NEQ,LONDE,JCRR,JCRK,IRET,IBID,NOCC,N1,JLVE
      INTEGER      DERNIE,NRPASE,IAUX,JAUX,TYPALC,TYPALF
      INTEGER      JSOLVE,IFISS,IXFEM,ICONT
      REAL*8       R8BID
      COMPLEX*16   CBID
      CHARACTER*8  MAILLA,K8BID,SIGERE(5),LPAIN(20),LPAOUT(1)
      CHARACTER*16 NOMCMD,K16BID
      CHARACTER*19 LIGREL,LIGRMO,VEREFE,CARTE
      CHARACTER*24 K24BLA,TEXTE,CHGEOM,LVEDIP
      CHARACTER*24 LCHOUT(1),LCHIN(20),NOOJB
      CHARACTER*24 CHCARA(15)
      DATA         LVEDIP  /'&&VEREFE.LISTE_RESU'/
C
C ---------------------------------------------------------------------
C

C -- DEFINITION DES NOMS DES CHAMPS 
      IAUX = 0
      JAUX = 4
      CALL PSNSLE(INPSCO,IAUX,JAUX,DEPPLU)
      JAUX = 5
      CALL PSNSLE(INPSCO,IAUX,JAUX,DEPMOI)
      JAUX = 8
      CALL PSNSLE(INPSCO,IAUX,JAUX,SIGPLU)
      JAUX = 9
      CALL PSNSLE(INPSCO,IAUX,JAUX,SIGMOI)
      JAUX = 10
      CALL PSNSLE(INPSCO,IAUX,JAUX,VARPLU)
      JAUX = 11
      CALL PSNSLE(INPSCO,IAUX,JAUX,VARMOI)
      IF (CMD(1:4).EQ.'DYNA') THEN
        JAUX = 14
        CALL PSNSLE(INPSCO,IAUX,JAUX,VITPLU)
        JAUX = 16
        CALL PSNSLE(INPSCO,IAUX,JAUX,ACCPLU)
        JAUX = 18
        CALL PSNSLE(INPSCO,IAUX,JAUX,DEPENT)
        JAUX = 20
        CALL PSNSLE(INPSCO,IAUX,JAUX,VITENT)
        JAUX = 22
        CALL PSNSLE(INPSCO,IAUX,JAUX,ACCENT)
      END IF


C -- CREATION DE VARIABLES "CHAPEAU" POUR STOCKER LES NOMS
C      VALMOI : ETAT EN T-
C      VALPLU : ETAT EN T+
C      SECMBR : CHARGEMENTS
C      POUGD  : INFOS POUTRES EN GRANDES ROTATIONS
C      MULTIA : INFOS MULTI-APPUI

      CALL AGGLOM (DEPMOI, SIGMOI, VARMOI, COMMOI,
     &             K24BLA, K24BLA, K24BLA, K24BLA, 4, VALMOI)
      CALL AGGLOM (DEPPLU, SIGPLU, VARPLU, COMPLU,
     &             VARDEP, LAGDEP, VARIGV, K24BLA, 7, VALPLU)
      CALL AGGLOM (CNFEDO, CNFEPI, CNDIDO, CNDIPI,
     &             CNFSDO, CNFSPI, CNDIDI, CNCINE, 8, SECMBR)
      CALL AGGLOM (DEPKM1, VITKM1, ACCKM1, VITPLU,
     &             ACCPLU, ROMKM1, ROMK  , DDEPLA, 8, POUGD )
      CALL AGGLOM (FONDEP, FONVIT, FONACC, MULTAP,
     &             PSIDEL, K24BLA, K24BLA, K24BLA, 5, MULTIA )


C -- NUMEROTATION ET CREATION DU PROFIL DE LA MATRICE

C    INCONNUES DE TYPE DEPLACEMENT
      NUMEDD = '12345678.NUMED'
      NOOJB='12345678.00000.NUME.PRNO'
      CALL GNOMSD ( NOOJB,10,14 )
      NUMEDD=NOOJB(1:14)
      CALL RSNUME(RESULT,'DEPL',NUPOSS)
      CALL NUMERO(NUPOSS,MODELE,LISCHA,SOLVEU,'VG',NUMEDD)

      DO 10 NRPASE=NBPASE,0,-1
        IAUX = NRPASE
        JAUX = 5
        CALL PSNSLE(INPSCO,IAUX,JAUX,DEPMOI)
        CALL VTCREB(DEPMOI,NUMEDD,'V','R',NEQ)
        IF (CMD(1:4).EQ.'DYNA') THEN
          JAUX = 14
          CALL PSNSLE(INPSCO,IAUX,JAUX,VITPLU)       
          CALL VTCREB(VITPLU,NUMEDD,'V','R',NEQ)
          JAUX = 16
          CALL PSNSLE(INPSCO,IAUX,JAUX,ACCPLU)       
          CALL VTCREB(ACCPLU,NUMEDD,'V','R',NEQ)
      END IF

10    CONTINUE


C -- INCONNUES DE TYPE VARIABLES NON LOCALES

      IF (MODEDE.NE.' ') THEN
        NUMEDE = '12345678.NUMED'
        LIGREL = MODEDE(1:8) // '.MODELE'
        NOOJB='12345678.00000.NUME.PRNO'
        CALL GNOMSD ( NOOJB,10,14 )
        NUMEDE=NOOJB(1:14)
        CALL RSNUME(RESULT,'VARI_NON_LOCAL',NUPOSS)
        CALL NUMER2(NUPOSS,1,LIGREL,'DDL_NLOC',SOLVDE,'VG',NUMEDE,IBID)
        CALL VTCREB(VARDEM,NUMEDE,'V','R',LONDE)
      END IF

C -- CREATION DE LA STRUCTURE DE DONNEE DE CONTACT

      CALL DISMOI('F','NOM_MAILLA',MODELE,'MODELE',IBID,MAILLA,IRET)
      CALL CFCRSD(MAILLA,LISCHA,NUMEDD,NEQ,DEFICO,RESOCO)

C -- DEPLACEMENTS, CONTRAINTES ET VARIABLES INTERNES INITIAUX

      CALL DESAGG(VALMOI,K24BLA,SIGMOI,VARMOI,COMMOI,K24BLA,K24BLA,
     &            K24BLA,K24BLA)

      IF (CMD(1:4).EQ.'STAT') THEN
        CALL NMDOET(RESULT,MODELE,MODEDE,COMPOR,CARELE,INSTAM,DEPMOI,
     &              SIGMOI,VARMOI,VARDEM,LAGDEM,NBPASE,INPSCO)
      ELSE
        CALL NDDOET(RESULT,MODELE,MODEDE,NUMEDD,MATE,COMPOR,CARELE,
     &              MEMASS,MEDIRI,LISCHA,INSTAM,COMMOI,DEPMOI,VITPLU,
     &              ACCPLU,SIGMOI,VARMOI,MAPREC,SOLVEU,CARCRI,VARDEM,
     &              LAGDEM,PARTPS,NBPASE,INPSCO,DEFICO)
      END IF


C -- DISCRETISATION DU CALCUL : CREATION DE LA SD DISCRETISATION
C    DE LA SD ARCHIVAGE ET DE LA SD OBSERVATION

      CALL JEEXIN(RESULT//'           .DESC',IRET)
      IF (IRET.EQ.0) THEN
        DERNIE = 0
      ELSE
        CALL RSORAC(RESULT,'DERNIER',IBID,R8BID,K8BID,CBID,0.D0,
     &              'ABSOLU',DERNIE,1,IBID)
      END IF
      CALL DIINIT(INSTAM,PARTPS,DERNIE,RESULT,NBOBSE,NUINS0,LOBSER,
     &            NUOBSE,NOMTAB,MAILL2,NBOBAR,LISINS(1:19),LISOBS)

C -- SI OPTIMISATION LISTE D'INSTANT
      CALL GETVTX('INCREMENT','OPTI_LIST_INST',1,1,1,TEXTE,N1)
      IF (N1 .NE. 0)
     &  CALL OPTILI(RESULT,MODELE,MATE,LISCHA,PARTPS)

C -- CREATION DE LA SD POUR ARCHIVAGE DES INFORMATIONS DE CONVERGENCE

      CALL WKVECT(CRITNL//'.CRTR','V V R8',7,JCRR)
      CALL WKVECT(CRITNL//'.CRDE','V V K16',7,JCRK)
      ZK16(JCRK)   = 'ITER_GLOB'
      ZK16(JCRK+1) = 'ITER_LINE'
      ZK16(JCRK+2) = 'RESI_GLOB_RELA'
      ZK16(JCRK+3) = 'RESI_GLOB'
      ZK16(JCRK+4) = 'ETA_PILOTAGE'
      ZK16(JCRK+5) = 'CHAR_MINI'
      ZK16(JCRK+6) = 'RESI_GLOB_MOINS'


C -- PREPARATION DE LA STRUCTURE DE DONNEE "EVOL_NOLI"

      CALL NMNOLI(COMPOR,PARTPS,CRITNL,DERNIE,VARDEM,LAGDEM,
     &           CMD,VITPLU,ACCPLU,NBMODS,DEPENT,VITENT,ACCENT,
     &           NBPASE,INPSCO,MODELE,MATE,CARELE,LISCH2)


C -- INITIALISATIONS LIEES AUX POUTRES EN GRANDS DEPLACEMENTS

      CALL NUROTA(NUMEDD(1:14),COMPOR(1:19),NURO,REAROT)


C -- CONSTRUCTION DU CHAM_NO ASSOCIE AU PILOTAGE

      CALL NMDOPI(MODELE,NUMEDD,PILOTE)


C -- LECTURE DU DEPLACEMENT DE REFERENCE POUR DIRICHLET DIFFERENTIEL

      CALL NMDIDI(MODELE,NUMEDD,LISCHA,DEPMOI,CNDIDI)

C
C --- FONCTIONNALITES ACTIVEES
C
      CALL GETRES(K8BID,K16BID,NOMCMD)

C    RECHERCHE LINEAIRE
      NOCC = 0
      IF (NOMCMD.EQ.'STAT_NON_LINE') THEN
        CALL GETFAC('RECH_LINEAIRE',NOCC)
      ENDIF
      FONACT(1) = NOCC .NE. 0

C    PILOTAGE
      NOCC = 0
      IF (NOMCMD.EQ.'STAT_NON_LINE') THEN
        CALL GETFAC('PILOTAGE',NOCC)
      ENDIF
      FONACT(2) = NOCC .NE. 0

C    LOIS NON LOCALES
      FONACT(3) = MODEDE .NE. ' '

C    X-FEM 
      CALL JEEXIN(MODELE(1:8)//'.FISS',IXFEM)
      IF (IXFEM.NE.0) THEN
        FONACT(6) = .TRUE.
      ENDIF

C     X-FEM ET CONTACT (METHODE CONTINUE)
      IF (FONACT(6)) THEN
        CALL JEVEUO(MODELE(1:8)//'.FISS','L',IFISS)
        CALL JEEXIN(ZK8(IFISS)//'.CONTACT.XFEM',ICONTX)
        DEFICO(1:16)=ZK8(IFISS)//'.CONTACT'
        CALL  JEVEUO (SOLVEU//'.SLVK','L',JSOLVE)
        IF (ZK24(JSOLVE)(1:5).NE.'MUMPS') CALL UTMESS('A','NMINIT',
     &   'POUR LE TRAITEMENT DU CONTACT AVEC X-FEM, LE SOLVEUR MUMPS '//
     &   'EST VIVEMENT RECOMMANDE.') 
        IF (ICONTX.NE.0) THEN
          FONACT(5) = .TRUE.
          FONACT(9) = .TRUE.
        ENDIF
      ELSE
        ICONTX = 0
      ENDIF

C    CONTACT / FROTTEMENT 
      CALL JEEXIN(DEFICO(1:16)//'.METHCO',ICONT)
      IF (ICONT.NE.0) THEN
        CALL CFDISC(DEFICO,'              ',TYPALC,TYPALF,IBID,IBID)
        IF (ABS(TYPALC).EQ.3) THEN
          FONACT(5) = .TRUE.
          IF (ABS(TYPALF).EQ.3) THEN
            FONACT(10) = .TRUE.
          ELSE
            FONACT(10) = .FALSE.
          ENDIF
        ELSE
          FONACT(4) = .TRUE.
        ENDIF
      ENDIF

C  INCOMPATIBILITES DE CERTAINES FONCTIONNALITES
      IF (FONACT(4).OR.FONACT(5)) THEN
        IF (FONACT(2)) THEN
          CALL UTMESS('F','NMINIT',
     &    'CONTACT ET PILOTAGE SONT DES FONCTIONNALITES INCOMPATIBLES')
        ENDIF

        IF (FONACT(1).AND.ABS(TYPALC).NE.5) THEN 
          CALL UTMESS('F','NMINIT',
     &     'CONTACT ET RECH. LIN. SONT DES '//
     &     'FONCTIONNALITES INCOMPATIBLES')
        ENDIF

        CALL  JEVEUO (SOLVEU//'.SLVK','L',JSOLVE)
        IF (ZK24(JSOLVE)(1:4).EQ.'GCPC') THEN
          IF (ABS(TYPALC).EQ.3) THEN
            CALL UTMESS('F','NMINIT',
     &           'LA COMBINAISON: METHODE CONTINUE EN CONTACT'//
     &           ' ET SOLVEUR GCPC N''EST PAS DISPONIBLE.')
          ENDIF
          IF (ABS(TYPALF).NE.0) THEN
            CALL UTMESS('F','NMINIT',
     &           'LA COMBINAISON: CONTACT-FROTTEMENT'//
     &           ' ET SOLVEUR GCPC N''EST PAS DISPONIBLE.')
          ENDIF
        ENDIF
      ENDIF

C    DEBORST ?
      CALL NMBORS(FONACT(7))

C   CONVERGENCE SUR CRITERE EN CONTRAINTE GENERALISEE
      IF (PARCRI.NE.R8VIDE()) THEN
        FONACT(8) = .TRUE.
      ENDIF

C -- CONVERGENCE SUR CRITERE EN CONTRAINTE GENERALISEE
      IF (FONACT(8)) THEN
        CALL MECARA(CARELE(1:8),EXICAR,CHCARA)
        FONACT(8) = .TRUE.
        CARTE  = '&&NMINIT.SIGERE'
        VEREFE = '&&NMINIT.VEREFE'
        LIGRMO = MODELE(1:8) // '.MODELE'
        SIGERE(1) = 'SIGM'
        SIGERE(2) = 'EPSI'
        SIGERE(3) = 'FTHERM'
        SIGERE(4) = 'FHYDR1'
        SIGERE(5) = 'FHYDR2'
        CALL MECACT('V',CARTE,'MODELE',LIGRMO,'PREC', 5, SIGERE,
     &                  IBID, PARCON, CBID, K8BID)

        CALL MEGEOM(MODELE, ' ', EXIGEO, CHGEOM)
        LPAIN(1) = 'PGEOMER'
        LCHIN(1) =  CHGEOM
        LPAIN(2) = 'PREFCO'
        LCHIN(2) =  CARTE
      LPAIN(3) = 'PCAGNPO'
      LCHIN(3) = CHCARA(6)
      LPAIN(4) = 'PCAORIE'
      LCHIN(4) = CHCARA(1)
      LPAIN(5) = 'PCOMPOR'
      LCHIN(5) = COMPOR
      LPAIN(6) = 'PMATERC'
      LCHIN(6) = MATE
      LPAIN(7) = 'PDEPLMR'
      LCHIN(7) = DEPMOI
      LPAIN(8) = 'PDEPLPR'
      LCHIN(8) = DEPMOI
      LPAIN(9) = 'PCAARPO'
      LCHIN(9) = CHCARA(9)
      LPAIN(10) = 'PCADISK'
      LCHIN(10) = CHCARA(2)
      LPAIN(11) = 'PCACOQU'
      LCHIN(11) = CHCARA(7)
      LPAIN(12) = 'PHARMON'
      LCHIN(12) = ' '
      LPAIN(13) = 'PCAMASS'
      LCHIN(13) = CHCARA(12)
      LPAIN(14) = 'PCARCRI'
      LCHIN(14) = CARCRI
      LPAIN(15) = 'PINSTMR'
      LCHIN(15) = ' '
      LPAIN(16) = 'PINSTPR'
      LCHIN(16) = ' '
      LPAIN(17) = ' '
      LCHIN(17) = ' '
      LPAIN(18) = 'PCAGEPO'
      LCHIN(18) = CHCARA(5)
      LPAIN(19) = 'PNBSP_I'
      LCHIN(19) = CHCARA(1) (1:8)//'.CANBSP'
      LPAIN(20) = 'PFIBRES'
      LCHIN(20) = CHCARA(1) (1:8)//'.CAFIBR'

        LPAOUT(1) = 'PVECTUR'
        LCHOUT(1) =  VEREFE


        CALL CALCUL('S','REFE_FORC_NODA', LIGRMO, 20, LCHIN, LPAIN,
     &                                      1 , LCHOUT, LPAOUT, 'V')

        CALL DETRSD('VECT_ELEM',LVEDIP(1:8))
        CALL MEMARE('V',LVEDIP(1:8),MODELE(1:8),' ',' ','CHAR_MECA')
        CALL WKVECT(LVEDIP,'V V K24',1,JLVE)
        CALL JEECRA(LVEDIP,'LONUTI',1,K8BID)
        ZK24(JLVE) = LCHOUT(1)
        CALL ASSMIV('V',CNVFRE,1,LVEDIP,1.D0,NUMEDD,' ','ZERO',1)
      ENDIF

      INSTAM = DIINST(PARTPS, 0)

C
C --- INITIALISATION DES AFFICHAGES
C
      CALL IMPINI(IMPRCO,ZFON,FONACT)

      END
