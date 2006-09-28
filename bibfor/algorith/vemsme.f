      SUBROUTINE VEMSME(MODELE,MATE,COMPOR,INPSCO,NRPASE,TYPESE,
     &                   NOPASE,VEMASE,STYPSE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2003  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE PABHHHH N.TARDIEU
      IMPLICIT NONE
      CHARACTER*24 MATE,MODELE,COMPOR,STYPSE
      CHARACTER*13 INPSCO
      CHARACTER*8  NOPASE,VEMASE
      INTEGER       NRPASE,TYPESE
C ----------------------------------------------------------------------
C
C     => CALCUL DES TERMES ELEMENTAIRES DU PSEUDO-CHARGEMENT
C        DU A LA DERIVATION (PARTIE COMPORTEMENT)
C
C  AUJOURD'HUI : CALCUL DE L'OPTION MECA_SENS_MATE
C  A FAIRE     : CALCUL DE L'OPTION MECA_SENS_CHAR
C ----------------------------------------------------------------------
C
C     IN   MODELE : MODELE
C     IN   MATE   : CHAMP MATERIAU
C     IN   COMPOR : COMPORTEMENT      (VIEUX THM) ('SUIV')
C     IN   INPSCO : SD CONTENANT LISTE DES NOMS POUR SENSIBILITE
C     IN   NRPASE : NUMERO DU PARAMETRE SENSIBLE (0=CALCUL CLASSIQUE)
C     IN   NOPASE : NOM DU PARAMETRE SENSIBLE
C     IN   TYPESE : TYPE DE DERIVATION
C               -1 : DERIVATION EULERIENNE (VIA UN CHAMP THETA)
C                1 : CALCUL INSENSIBLE
C                2 : DEPLACEMENT IMPOSE
C                3 : PARAMETRE MATERIAU
C                4 : CARACTERISTIQUE ELEMENTAIRE (COQUES, ...)
C                5 : FORCE
C     IN   STYPSE : SOUS-TYPE DU PARAMETRE SENSIBLE
C     OUT  VEMASE : VECTEURS ELEMENTAIRES DU PSEUDO-CHARGEMENT
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------

      CHARACTER*32 JEXNUM
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

C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------

      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'VEMSME' )

      INTEGER NCHINX,NCHOUX
      PARAMETER (NCHINX = 13, NCHOUX = 2)

      INTEGER IBID,IAUX,JAUX,IFM,NIV,JDUTMP,JDEPMO,NEQ,JVEMSM
      INTEGER IRET
      REAL*8       RBID
      COMPLEX*16  CBID
      CHARACTER*8 MA,LPAIN(NCHINX),LPAOU(NCHOUX),K8BID,MATERS
      CHARACTER*24 DEPPLU,DEPMOI,SIGMOI,VARMOI,OPTION
      CHARACTER*24 SIGPLU,VARPLU,MATERI,MATSEN
      CHARACTER*24 DEPMOS,SIGPLS,SIGMOS,VARMOS,DUTMP
      CHARACTER*19 LCHIN(NCHINX),LCHOU(NCHOUX),LIGRMO,CHDERI
      CHARACTER*19 CHGEOM
      DATA DUTMP /'&&VEMSME.DUTMP'/
C ----------------------------------------------------------------------


      CALL JEMARQ()

      CALL INFNIV(IFM,NIV)

      IF (NRPASE.EQ.0) GO TO 9999

C -- INITIALISATION DE LA CHARGE
C    ----------------------------

      VEMASE='&&VEMSME'
      CHDERI = '&&VEMSME.PARSENS'
      CALL DETRSD('VECT_ELEM',VEMASE)
      CALL MEMARE('V',VEMASE,MODELE,MATE,K8BID,'CHAR_MECA')

      CALL WKVECT(VEMASE//'.LISTE_RESU','V V K24',1,JVEMSM)
      CALL JEECRA(VEMASE//'.LISTE_RESU','LONUTI',1,K8BID)
      ZK24(JVEMSM-1+1)=VEMASE//'.SECOND'


      IF((TYPESE.NE.2).AND.(TYPESE.NE.3).AND.(TYPESE.NE.5))THEN
        CALL U2MESS('F','ALGORITH11_23')
      ENDIF


C -- RECUPERATION DES DIVERS CHAMPS NECESSAIRES
C    -------------------------------------------

C -- LECTURE DES CHAMPS DIRECTS
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

C -- LECTURE DES CHAMPS DERIVES
      IAUX = NRPASE
      JAUX = 5
      CALL PSNSLE(INPSCO,IAUX,JAUX,DEPMOS)
      JAUX = 8
      CALL PSNSLE(INPSCO,IAUX,JAUX,SIGPLS)
      JAUX = 9
      CALL PSNSLE(INPSCO,IAUX,JAUX,SIGMOS)
      JAUX = 11
      CALL PSNSLE(INPSCO,IAUX,JAUX,VARMOS)


C -- DETERMINATION DU CHAMP DE GEOMETRIE
      CALL DISMOI('F','NOM_MAILLA',MODELE,'MODELE',IBID,MA,IBID)
      CHGEOM = MA//'.COORDO'


C -- DETERMINATION DU LIGREL
      CALL DISMOI('F','NOM_LIGREL',MODELE,'MODELE',IBID,LIGRMO,IBID)

C -- CALCUL DE L'INCREMENT DE DEPLACEMENT
      CALL JELIRA(DEPMOI(1:19)//'.VALE','LONMAX',NEQ,K8BID)
      CALL COPISD('CHAMP_GD','V',DEPPLU,DUTMP)
      CALL JEVEUO(DUTMP(1:19)//'.VALE', 'E',JDUTMP)
      CALL JEVEUO(DEPMOI(1:19)//'.VALE','L',JDEPMO)
      CALL DAXPY(NEQ,-1.D0,ZR(JDEPMO),1,ZR(JDUTMP),1)

      IF (TYPESE.EQ.3) THEN

C      ==> DEFINITION DU MATERIAU DERIVE CODE

C      DETERMINATION DU CHAMP MATERIAU A PARTIR DE LA CARTE CODEE
        MATERI = MATE(1:8)
C      DETERMINATION DU CHAMP MATERIAU DERIVE NON CODE MATSEN
        CALL PSRENC(MATERI,NOPASE,MATERS,IRET)
        IF (IRET.NE.0) THEN
          CALL U2MESK('F','CALCULEL2_87',1,MATERI)
        END IF
C      TRANSFORMATION EN CHAMP MATERIAU DERIVE CODE
        MATSEN = '                        '
        MATSEN(1:24) = MATERS(1:8)//MATE(9:24)

      ELSE

        MATSEN = '                        '

      ENDIF


C -- REMPLISSAGE DES TABLEAUX LCHIN,LPAIN ...
C -- POUR SECOND MEMBRE ET DE LA DERIVEE DU CHAMP DE DEPL
C    -----------------------------------------------------
      LPAIN(1) = 'PGEOMER'
      LCHIN(1) = CHGEOM

      LPAIN(2) = 'PMATERC'
      LCHIN(2) = MATE

      LPAIN(3) = 'PCOMPOR'
      LCHIN(3) = COMPOR

      LPAIN(4) = 'PCONTMR'
      LCHIN(4) = SIGMOI

      LPAIN(5) = 'PCONTMS'
      LCHIN(5) = SIGMOS

      LPAIN(6) = 'PVARIMS'
      LCHIN(6) = VARMOS

      LPAIN(7) = 'PDEPLMR'
      LCHIN(7) = DEPMOI

      LPAIN(8) = 'PDEPLPR'
      LCHIN(8) = DUTMP

      LPAIN(9) =  'PVARIMR'
      LCHIN(9) =  VARMOI

      LPAIN(10) = 'PARSENS'
      LCHIN(10) = CHDERI

      LPAIN(11) =  'PVARIPR'
      LCHIN(11) =  VARPLU

      LPAIN(12) = 'PCONTPR'
      LCHIN(12) = SIGPLU

      LPAIN(13) = 'PMATSEN'
      LCHIN(13) = MATSEN


      LPAOU(1) = 'PVECTUR'
      LCHOU(1) = VEMASE//'.SECOND'

      LPAOU(2) = 'PCONTPS'
      LCHOU(2) = SIGPLS

      IF ((TYPESE.EQ.2).OR.(TYPESE.EQ.5)) THEN
        OPTION='MECA_SENS_CHAR'
      ENDIF

      IF (TYPESE.EQ.3) THEN
        OPTION='MECA_SENS_MATE'
      ENDIF


C -- CREATION D'UNE CARTE UNIFORME CONTENANT STYPSE
C    ------------------------------------------------
      CALL MECACT('V',CHDERI,'MAILLAGE',MA,'NEUT_K24',1,'Z1',IBID,
     &              RBID,CBID,STYPSE)


C  -- CALCUL DU PSEUDO-CHARGEMENT
C     ----------------------------
      CALL CALCUL('S',OPTION,LIGRMO,NCHINX,LCHIN,LPAIN,NCHOUX,LCHOU,
     &            LPAOU,'V')



      IF (NIV .GT. 1) THEN
        WRITE (IFM,*) '<SENSIBILITE> <',NOMPRO,'> CALCUL DU '//
     &                'PSEUDO-CHARGEMENT PAR RAPPORT A ',NOPASE
      END IF

C  -- MENAGE
C     -------
      CALL JEDETR(DUTMP)

9999  CONTINUE

      CALL JEDEMA()
      END
