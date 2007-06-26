      SUBROUTINE NDDOET(RESULT,MODELE,NUMEDD,MATE,COMPOR,CARELE,
     &                  MEMASS,OPMASS,MASSE,MEDIRI,LISCHA,INSTAM,
     &                  COMMOI,DEPMOI,VITPLU,ACCPLU,SIGMOI,VARMOI,
     &                  MAPREC,SOLVEU,CARCRI,VARDEM,LAGDEM,PARTPS,
     &                  NBPASE,INPSCO,DEFICO,DEPOLD,PILOTE)

      IMPLICIT NONE
      REAL*8        INSTAM
      INTEGER       NBPASE
      CHARACTER*8   RESULT
      CHARACTER*13  INPSCO
      CHARACTER*24  MODELE,NUMEDD,CARELE,MEMASS,MEDIRI,MATE,VARDEM
      CHARACTER*24  COMMOI,COMPOR,LAGDEM,COMPOM,DEFICO,MASSE
      CHARACTER*24  DEPMOI,VITPLU,ACCPLU,SIGMOI,VARMOI,CARCRI,DEPOLD
      CHARACTER*19  SOLVEU,MAPREC,LISCHA,PARTPS
      CHARACTER*16  OPMASS
      CHARACTER*14  PILOTE
C ----------------------------------------------------------------------
C MODIF ALGORITH  DATE 26/06/2007   AUTEUR REZETTE C.REZETTE 
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
C RESPONSABLE ACBHHCD G.DEVESA
C TOLE CRP_21
C TOLE CRP_20
C
C     D Y N A M I Q U E  N O N  L I N E A I R E
C     SAISIE OU CREATION DES CHAMPS A L'ETAT INITIAL
C
C IN  MODELE  : NOM DU MODELE
C IN  LISCHA  : SD L_CHARGES
C OUT COMMOI  : VARIABLES DE COMMANDE INITIALES
C OUT INSTAM  : INSTANT INITIAL
C OUT NEWCAL  : =.TRUE.  SI LE CALCUL DEMARRE
C               =.FALSE. SI LE CALCUL SE POURSUIT
C OUT DEPMOI  : CHAM_NO DE DEPLACEMENTS INITIAUX
C OUT VITPLU  : CHAM_NO DE VITESSES INITIALES
C OUT ACCPLU  : CHAM_NO D'ACCELERATIONS INITIALES
C OUT SIGMOI  : CHAM_ELEM DE CONTRAINTES INITIALES
C OUT VARMOI  : CHAM_ELEM DE VARIABLES INTERNES INITIALES
C               VARMOI CONTIENDRA PAR LA SUITE LES VI MISES A JOUR
C               A LA FIN DES PAS DE TEMPS
C IN  NBPASE  : NOMBRE DE PARAMETRES SENSIBLES
C IN  INPSCO  : SD CONTENANT LISTE DES NOMS POUR SENSIBILITE

C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
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

C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'NDDOET' )
C
      INTEGER      IBID,IRETVI,IRETAC,IERR,IAUX,JAUX
      INTEGER      JINFC,NBCHAR,N2,NUME,NRPASE
      INTEGER      JCHAR,IACHA2,I,JINST,NCHOUT,IACHAR
      INTEGER      IRET,NOCC,REENTR,N1,NBR
      REAL*8       RBID,INST,PREC,R8VIDE,DT
      COMPLEX*16   CBID
      LOGICAL      LBID,EVONOL,LGRFL,LNOCC
      CHARACTER*1  BASE
      CHARACTER*8  K8BID,LPAIN(1),LPAOUT(2),CRITER,NOMCHA
      CHARACTER*8  NOPASE
      CHARACTER*16 OPT
      CHARACTER*19 LISINS
      CHARACTER*24 LIGRMO,EVOL,LCHIN(1),LCHOUT(2),RESUID, STRUCT
      CHARACTER*24 VALK(2)
      CHARACTER*24 K24BID,LIGRDE,TYPE,CHAMP,CHGEOM,CHGRFL
      DATA CHGRFL /'&&OP0070.GRAPPE_FLUIDE  '/
C ----------------------------------------------------------------------

C -- EXTENSION DU COMPORTEMENT : NOMBRE DE VARIABLES INTERNES
      CALL DISMOI('F','NOM_LIGREL',MODELE,'MODELE',IBID,LIGRMO,IRET)
      CALL EXISD('CHAM_ELEM_S',COMPOR,IRET)
      IF (IRET.EQ.0) CALL CESVAR(CARELE,COMPOR,LIGRMO,COMPOR)


C -- PAS D'ETAT INITIAL EN PRESENCE D'UN CONCEPT REENTRANT
      CALL GETFAC('ETAT_INIT',NOCC)
      CALL JEEXIN(RESULT//'           .DESC',REENTR)
      IF (NOCC.EQ.0 .AND. REENTR.NE.0) CALL U2MESS('A','ALGORITH6_35')

      BASE = 'V'
      LGRFL = .FALSE.
      DT = 0.0D0

      CALL JEEXIN ( LISCHA//'.INFC', IRET )
      IF ( IRET .NE. 0 ) THEN
        CALL JEVEUO(LISCHA//'.INFC','L',JINFC )
        CALL JEVEUO(LISCHA//'.LCHA','L',JCHAR)
        NBCHAR = ZI(JINFC)
        DO 30 I = 1, NBCHAR
          NOMCHA = ZK24(JCHAR+I-1)(1:8)
          CALL JEEXIN ( NOMCHA//'.CHME.GRFLU.LINO', IRET )
          IF ( IRET .NE. 0 ) THEN
             LGRFL = .TRUE.
             CALL GETVID('INCREMENT','LIST_INST'  ,1,1,1,LISINS,N1)
             CALL JEVEUO(LISINS // '.VALE', 'L', JINST)
             DT = ZR(JINST+1) - ZR(JINST)
           ENDIF
  30     CONTINUE
      ELSE
         NBCHAR = 0
      ENDIF

      CALL GETVID('ETAT_INIT','EVOL_NOLI',1,1,1,EVOL,NOCC)
      EVONOL = NOCC .GT. 0

      IF (EVONOL) THEN
C ======================================================================
C         ETAT INITIAL DEFINI PAR UN CONCEPT DE TYPE EVOL_NOLI
C         DONNEES DISCRETISATION TEMPORELLE
C ======================================================================

        COMPOM=' '

C      CONTROLE DU TYPE DE EVOL
        CALL DISMOI('F','TYPE_RESU',EVOL,'RESULTAT',IBID,TYPE,IRET)
        IF (TYPE.NE.'EVOL_NOLI') CALL U2MESS('F','MECANONLINE_10')

C -- NUMERO D'ACCES ET INSTANT CORRESPONDANT
        CALL GETVR8('ETAT_INIT','INST',1,1,1,INST,N1)
        CALL GETVIS('ETAT_INIT','NUME_ORDRE',1,1,1,NUME,N2)

C      NUME_ORDRE ET INST ABSENTS, ON PREND LE DERNIER PAS ARCHIVE
        IF (N1+N2.EQ.0) THEN
          CALL RSORAC(EVOL,'DERNIER',IBID,RBID,K8BID,CBID,RBID,K8BID,
     &                NUME,1,N2)
          IF (N2.EQ.0) CALL U2MESK('F','ALGORITH6_37',1,EVOL)
        END IF

C      ACCES PAR INSTANT
        IF (N1.NE.0) THEN
          CALL GETVR8('ETAT_INIT','PRECISION',1,1,1,PREC,IBID)
          CALL GETVTX('ETAT_INIT','CRITERE',1,1,1,CRITER,IBID)
          CALL RSORAC(EVOL,'INST',IBID,INST,K8BID,CBID,PREC,CRITER,NUME,
     &                1,NBR)
          IF (NBR.EQ.0) CALL U2MESS('F','MECANONLINE_12')
          IF (NBR.LT.0) CALL U2MESS('F','MECANONLINE_13')
        END IF

C      ACCES PAR NUMERO D'ORDRE
        IF (N2.NE.0) THEN
          CALL RSADPA(EVOL,'L',1,'INST',NUME,0,JINST,K8BID)
          INST = ZR(JINST)
        END IF

      ELSE
C ======================================================================
C      DEFINITION CHAMP PAR CHAMP (OU PAS D'ETAT INITIAL DU TOUT)
C         DONNEES DISCRETISATION TEMPORELLE
C ======================================================================

        INSTAM = 0.D0
        CALL GETVR8('ETAT_INIT','INST_ETAT_INIT',1,1,1,INSTAM,N2)
        IF (N2.EQ.0) CALL GETVR8('INCREMENT','INST_INIT',1,1,1,INSTAM,
     &                           N2)
        IF (N2.EQ.0) THEN
           CALL GETVID('INCREMENT','LIST_INST',1,1,1,LISINS,N1)
           CALL JEVEUO(LISINS//'.VALE','L',JINST)
           INSTAM = ZR(JINST)
        END IF
        INST = INSTAM

      END IF

C ======================================================================

C -  CALCUL DES MATRICES ELEMENTAIRES DE MASSE
      CALL JEVEUO(LISCHA//'.INFC','L',JINFC)
      NBCHAR = ZI(JINFC)
      CALL JEVEUO(LISCHA//'.LCHA','L',IACHAR)
      CALL WKVECT('&&NDDOET.LISTE_CHARGE','V V K8',NBCHAR,IACHA2)
      DO 10,I = 1,NBCHAR
        ZK8(IACHA2-1+I) = ZK24(JCHAR-1+I) (1:8)
   10 CONTINUE
      CALL MEMAME(OPMASS,MODELE,NBCHAR,ZK8(IACHA2),MATE,CARELE,
     &              .TRUE.,INST,COMPOR,MEMASS,BASE)
      CALL JEDETR('&&NDDOET.LISTE_CHARGE')

C ======================================================================
C ======================================================================
C     BOUCLE SUR L'INITIALISATION DES CHAMPS PRINCIPAUX ET DERIVES
C ======================================================================
C ======================================================================

      DO 20 NRPASE = NBPASE,0,-1
        IAUX = NRPASE
        JAUX = 5
        CALL PSNSLE(INPSCO,IAUX,JAUX,DEPMOI)
        JAUX = 9
        CALL PSNSLE(INPSCO,IAUX,JAUX,SIGMOI)
        JAUX = 11
        CALL PSNSLE(INPSCO,IAUX,JAUX,VARMOI)
        JAUX = 14
        CALL PSNSLE(INPSCO,IAUX,JAUX,VITPLU)
        JAUX = 16
        CALL PSNSLE(INPSCO,IAUX,JAUX,ACCPLU)

        IF (EVONOL) THEN
C ======================================================================
C         ETAT INITIAL DEFINI PAR UN CONCEPT DE TYPE EVOL_NOLI
C ======================================================================

          IF ( NRPASE.GT.0 ) THEN
            IAUX = NRPASE
            JAUX = 1
            CALL PSNSLE ( INPSCO, IAUX, JAUX, NOPASE )
            CALL PSGENC ( EVOL, NOPASE, RESUID, IRET )
            IF ( IRET.NE.0 ) THEN
              VALK(1) = EVOL
C                               '1234567890123456'
              VALK(2) = NOPASE//'                '
              CALL U2MESK('A','SENSIBILITE_3', 2 ,VALK)
              CALL U2MESK('F','UTILITAI7_99', 1 ,NOMPRO)
            ENDIF
            STRUCT = RESUID
          ELSE
            STRUCT = EVOL
          END IF

C -- LECTURE DES DEPLACEMENTS (OU DERIVE)
          CALL RSEXCH(STRUCT,'DEPL',NUME,CHAMP,IRET)
          IF (IRET.NE.0) CALL U2MESK('F','ALGORITH6_41',1,STRUCT)
          CALL VTCOPY(CHAMP,DEPMOI,IRET)


C -- LECTURE DES CONTRAINTES AUX POINTS DE GAUSS (OU DERIVE)
          CALL RSEXCH(STRUCT,'SIEF_ELGA',NUME,CHAMP,IRET)
          IF (IRET.EQ.0) THEN
            CALL COPISD('CHAMP_GD','V',CHAMP,SIGMOI)
          ELSE

C        CONTRAINTES AUX NOEUDS : PASSAGE AUX POINTS DE GAUSS
            CALL RSEXCH(STRUCT,'SIEF_ELNO',NUME,CHAMP,IRET)
            IF (IRET.NE.0) CALL U2MESK('F','ALGORITH6_42',1,STRUCT)
            CALL MENOGA('SIEF_ELGA_ELNO  ',LIGRMO,COMPOR,CHAMP,SIGMOI,
     &                  K24BID)
          END IF

C -- LECTURE DES VITESSES (OU DERIVE)
          CALL RSEXCH(STRUCT,'VITE',NUME,CHAMP,IRETVI)
          IF (IRETVI.NE.0) THEN
            CALL U2MESK('I','ALGORITH6_43',1,EVOL)
            CALL NULVEC(VITPLU)
          ELSE
            CALL VTCOPY(CHAMP,VITPLU,IERR)

          END IF

C -- LECTURE DES ACCELERATIONS (OU DERIVE)
          CALL RSEXCH(STRUCT,'ACCE',NUME,CHAMP,IRETAC)
          IF (IRETAC.NE.0) THEN
            IF (IRETVI.NE.0) THEN
              CALL U2MESK('I','ALGORITH6_44',1,STRUCT)
              CALL ACCEL0(MODELE,NUMEDD,MATE,COMPOR,CARELE,MEMASS,
     &                  MASSE,MEDIRI,LISCHA,INST,COMMOI,DEPMOI,SIGMOI,
     &                  ACCPLU,MAPREC,SOLVEU,CARCRI,LGRFL,CHGRFL,DT,
     &                  DEFICO)
            ELSE
              CALL U2MESK('F','ALGORITH6_45',1,STRUCT)
              END IF
            ELSE
              CALL VTCOPY(CHAMP,ACCPLU,IERR)
            END IF

C -- LECTURE DES VARIABLES INTERNES AUX POINTS DE GAUSS (OU DERIVE)
          CALL RSEXCH(STRUCT,'COMPORTEMENT',NUME,COMPOM,IRET)
          IF (IRET.NE.0) COMPOM=' '

          CALL RSEXCH(STRUCT,'VARI_ELGA',NUME,CHAMP,IRET)
          IF (IRET.EQ.0) THEN
            CALL COPISD('CHAMP_GD','V',CHAMP,VARMOI)
            IF (NRPASE.EQ.NBPASE) CALL VRCOMP(COMPOM,COMPOR,VARMOI)
          ELSE

C        VARIABLES INTERNES AUX NOEUDS : PASSAGE AUX POINTS DE GAUSS
            CALL RSEXCH(STRUCT,'VARI_ELNO',NUME,CHAMP,IRET)
            IF (IRET.NE.0) CALL U2MESK('F','ALGORITH6_46',1,STRUCT)
            IF (NRPASE.EQ.NBPASE) CALL VRCOMP(COMPOM,COMPOR,CHAMP)
            CALL COPISD('CHAM_ELEM_S','V',COMPOR,VARMOI)
            CALL MENOGA('VARI_ELGA_ELNO  ',LIGRMO,COMPOR,CHAMP,VARMOI,
     &                K24BID)
          END IF


        ELSE

C ======================================================================
C      DEFINITION CHAMP PAR CHAMP (OU PAS D'ETAT INITIAL DU TOUT)
C ======================================================================
          NUME   = 0
          NCHOUT = 0

C -- LECTURE DES DEPLACEMENTS
          CALL GETVID('ETAT_INIT','DEPL',1,1,1,CHAMP,NOCC)
          LNOCC=(NOCC.NE.0)
          IF (NOCC.NE.0) THEN
            CALL CHPVER('F',CHAMP(1:19),'NOEU','DEPL_R',IERR)
            CALL VTCOPY(CHAMP,DEPMOI,IRET)
          ELSE
            IF (NRPASE.EQ.0) CALL U2MESS('I','MECANONLINE_76')
            CALL NULVEC(DEPMOI)
          END IF

C -- LECTURE DES VITESSES
          CALL GETVID('ETAT_INIT','VITE',1,1,1,CHAMP,NOCC)
          LNOCC=(LNOCC.OR.(NOCC.NE.0))
          IF (NOCC.NE.0) THEN
            CALL CHPVER('F',CHAMP(1:19),'NOEU','DEPL_R',IERR)
            CALL VTCOPY(CHAMP,VITPLU,IERR)
          ELSE
            CALL U2MESS('I','MECANONLINE_22')
            CALL NULVEC(VITPLU)
          END IF



C -- LECTURE DES CONTRAINTES AUX POINTS DE GAUSS
          CALL GETVID('ETAT_INIT','SIGM',1,1,1,CHAMP,NOCC)
          LNOCC=(LNOCC.OR.(NOCC.NE.0))

C      PREPARATION POUR CREER UN CHAMP NUL
          IF (NOCC.EQ.0) THEN
            NCHOUT = NCHOUT + 1
            LPAOUT(NCHOUT) = 'PSIEF_R'
            LCHOUT(NCHOUT) = SIGMOI
            CALL COPISD('CHAM_ELEM_S','V',COMPOR,SIGMOI)

          ELSE
            CALL CHPVER('F',CHAMP(1:19),'*','SIEF_R',IERR)
            CALL DISMOI('F','TYPE_CHAMP',CHAMP,'CHAMP',IBID,TYPE,IRET)

C        PASSAGE NOEUDS -> POINTS DE GAUSS LE CAS ECHEANT
            IF (TYPE.EQ.'ELNO') THEN
              CALL COPISD('CHAM_ELEM_S','V',COMPOR,SIGMOI)
              CALL MENOGA('SIEF_ELGA_ELNO  ',LIGRMO,COMPOR,CHAMP,SIGMOI,
     &                  K24BID)
            ELSE
              CALL COPISD('CHAMP_GD','V',CHAMP,SIGMOI)
            END IF
          END IF


C -- LECTURE DES VARIABLES INTERNES
          CALL GETVID('ETAT_INIT','VARI',1,1,1,CHAMP,NOCC)
          LNOCC=(LNOCC.OR.(NOCC.NE.0))

          IF (LNOCC .AND. NBPASE.GT.0) THEN
            CALL U2MESS('F','SENSIBILITE_21')
          ENDIF

C      PREPARATION POUR CREER UN CHAMP NUL
          IF (NOCC.EQ.0) THEN
            NCHOUT = NCHOUT + 1
            LPAOUT(NCHOUT) = 'PVARI_R'
            LCHOUT(NCHOUT) = VARMOI
            CALL COPISD('CHAM_ELEM_S','V',COMPOR,VARMOI)

          ELSE
            CALL CHPVER('F',CHAMP(1:19),'ELGA','VARI_R',IERR)
            CALL DISMOI('F','TYPE_CHAMP',CHAMP,'CHAMP',IBID,TYPE,IRET)

C        PASSAGE NOEUDS -> POINTS DE GAUSS LE CAS ECHEANT
            IF (TYPE.EQ.'ELNO') THEN
              IF (NRPASE.EQ.NBPASE) CALL VRCOMP(' ',COMPOR,CHAMP)
              CALL COPISD('CHAM_ELEM_S','V',COMPOR,VARMOI)
              CALL MENOGA('VARI_ELGA_ELNO  ',LIGRMO,COMPOR,CHAMP,VARMOI,
     &                  K24BID)
            ELSE
              CALL COPISD('CHAMP_GD','V',CHAMP,VARMOI)
              IF (NRPASE.EQ.NBPASE) CALL VRCOMP(' ',COMPOR,VARMOI)
            END IF
          END IF

C -- CREATION DES CHAM_ELEM DE CONTRAINTES ET DE VARIABLES INTERNES NULS
          IF (NCHOUT.GT.0) THEN
            CALL MEGEOM(MODELE,' ',LBID,CHGEOM)
            LCHIN(1) = CHGEOM
            LPAIN(1) = 'PGEOMER'
            OPT = 'TOU_INI_ELGA    '
            CALL CALCUL('S',OPT,LIGRMO,1,LCHIN,LPAIN,NCHOUT,LCHOUT,
     &                  LPAOUT,'V')

C        CHARGEMENTS DE TYPE PRECONTRAINTE (LE CAS ECHEANT)
            CALL NMSIGI(LIGRMO,COMPOR,SIGMOI)
          END IF

C -- LECTURE DES ACCELERATIONS
          CALL GETVID('ETAT_INIT','ACCE',1,1,1,CHAMP,NOCC)
          IF (NOCC.NE.0) THEN
            CALL CHPVER('F',CHAMP(1:19),'NOEU','DEPL_R',IERR)
            CALL VTCOPY(CHAMP,ACCPLU,IERR)
          ELSE
C           A DEFAUT, CALCUL DES ACCELERATIONS INITIALES
            IF (N2.EQ.0) THEN
               CALL GETVID('INCREMENT','LIST_INST'  ,1,1,1,LISINS,N1)
               CALL JEVEUO(LISINS // '.VALE', 'L', JINST)
               INST = ZR(JINST)
            ELSE
               INST = INSTAM
            END IF
            CALL ACCEL0(MODELE,NUMEDD,MATE,COMPOR,CARELE,MEMASS,MASSE,
     &                  MEDIRI,LISCHA,INST,COMMOI,DEPMOI,SIGMOI,ACCPLU,
     &                  MAPREC,SOLVEU,CARCRI,LGRFL,CHGRFL,DT,DEFICO)
          END IF

        END IF

   20 CONTINUE

C -- LECTURE DE L'INSTANT DU CHARGEMENT INITIAL (SI DONNE)
      CALL GETVR8('ETAT_INIT','INST_ETAT_INIT',1,1,1,INSTAM,NOCC)
      IF (NOCC.EQ.0) THEN
        IF (EVONOL) THEN
          INSTAM = INST
        ELSE
          INSTAM = R8VIDE()
        END IF
      END IF

C --- INITIALISATION DES COMMONS "FORCE_FLUIDE"
      IF ( LGRFL )  CALL GFINIT ( NUMEDD, NUME, DEPMOI, VITPLU,
     &                              ACCPLU,  DT, CHGRFL )
      END
