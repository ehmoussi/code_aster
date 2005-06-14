      SUBROUTINE NMCHAR (MODE  , MODELE, NUMEDD, MATE  , CARELE,
     &                   COMPOR, LISCHA, CARCRI, INST  , DEPMOI,
     &                   DEPDEL, LAMORT, VITPLU, ACCPLU, MASSE,
     &                   AMORT,  VITKM1, VITENT, NMODAM, VALMOD,
     &                   BASMOD, NREAVI, LIMPED, LONDE,  NONDP,
     &                   CHONDP, TEMPLU, NRPASE, NBPASE, INPSCO,
     &                   NOPASE, SECMBR)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 18/04/2005   AUTEUR VABHHTS J.PELLET 
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
C RESPONSABLE PBADEL P.BADEL
C TOLE CRP_21

      IMPLICIT NONE
      INTEGER       NMODAM, NREAVI, NONDP,  NBPASE, NRPASE
      REAL*8        INST(3)
      LOGICAL       LAMORT, LIMPED, LONDE
      CHARACTER*4   MODE
      CHARACTER*8   NOPASE
      CHARACTER*13  INPSCO
      CHARACTER*19  LISCHA
      CHARACTER*24  MODELE, MATE,   CARELE, NUMEDD, SECMBR(8)
      CHARACTER*24  DEPMOI, DEPDEL, TEMPLU, COMPOR, CARCRI
      CHARACTER*24  ACCPLU, VITPLU, MASSE,  AMORT,  TABTRA
      CHARACTER*24  VITKM1, VITENT, VALMOD, BASMOD, CHONDP

C ----------------------------------------------------------------------
C
C COMMANDE STAT_NON_LINE : CALCUL DES EFFORTS EXTERIEURS
C COMMANDE DYNA_TRAN_EXPLI : CALCUL DU SECOND MEMBRE
C
C ----------------------------------------------------------------------

C     IN   MODE   : 'FIXE' -> CALCUL CHARGES FIXES
C                   'SUIV' -> CALCUL CHARGES SUIVEUSES
C                   'INER' -> CALCUL FORCES D'INERTIE
C                   'TOUS' -> CALCUL CHARGES FIXES ET SUIVEUSES
C                   'EXPL' -> CALCUL DES FORCES "EXPLICITES"
C     IN   MODELE : MODELE
C     IN   NUMEDD : NUME_DDL
C     IN   MATE   : CHAMP MATERIAU
C     IN   CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
C     IN   COMPOR : COMPORTEMENT      (VIEUX THM) ('SUIV')
C     IN   LISCHA : L_CHARGES
C     IN   CARCRI : PARAMETRES LOCAUX (VIEUX THM) ('SUIV')
C     IN   INST   : PARAMETRES INTEGRATION EN TEMPS (T+, DT, THETA)
C     IN   DEPMOI : DEPLACEMENT              ('SUIV')
C     IN   DEPDEL : INCREMENT DE DEPLACEMENT ('SUIV')
C     IN   TEMPLU : TEMPERATURE T+ (POUTRES)
C     IN   OLDTHM : PARAMETRES POUR VIELLE VERSION THM (DANS VECGME)
C     IN   NRPASE : NUMERO DU PARAMETRE SENSIBLE (0=CALCUL CLASSIQUE)
C     IN   NBPASE : NOMBRE DE PARAMETRES SENSIBLES
C     IN   INPSCO : SD CONTENANT LISTE DES NOMS POUR SENSIBILITE
C IN/JXOUT SECMBR : VECTEURS ASSEMBLES DES CHARGEMENTS ('FIXE' 'SUIV')

C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      INTEGER            ZI
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
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------

      INTEGER      NEQ, IRET, JTRA, NBCHAR, ICH, JINFC, JCHAR
      INTEGER      JDIDI, JDIDO, JMASS, JAMOR, JVITP, JACCP, JCNFS
      INTEGER      JCNFE, JCNLA, JVITKM, IONDP, TYPESE
      REAL*8       INSTAP, INSTAM
      LOGICAL      LGRFL
      CHARACTER*4  TYPCAL
      CHARACTER*8  K8BID,  VEMASE, NOMCHA
      CHARACTER*24 CNFEDO, CNFEPI, CNDIDO, CNDIPI, CNFSDO, CNFSPI
      CHARACTER*24 VEFEDO, VEFEPI, VEDIDO, VEDIPI, VEFSDO, VEANEC
      CHARACTER*24 VAFEDO, VAFEPI, VADIDO,         VAFSDO, VAANEC
      CHARACTER*24 K24BLA, STYPSE, CNDIDI, CNCINE, CNLAMP
      CHARACTER*24 CHARGE, INFOCH, FOMULT, CHGRFL
      CHARACTER*24 VECCOR, VELAMP, VALAMP, VAPRIN
C
      INTEGER      JCNST, NBSST,NBSS,IRET2
      CHARACTER*8  VESSTR
      CHARACTER*24 CNSSTR
C
      DATA VEFEDO,VEFEPI  /'&&VEFEDO.LISTE_RESU','&&VEFEPI.LISTE_RESU'/
      DATA VEFSDO         /'&&VEFSDO.LISTE_RESU'/
      DATA CHGRFL         /'&&OP0070.GRAPPE_FLUIDE  '/
      DATA VEDIDO,VEDIPI  /'&&VEDIDO.LISTE_RESU','&&VEDIPI.LISTE_RESU'/
      DATA TYPESE / 0 /
      DATA STYPSE / ' ' /
C ----------------------------------------------------------------------

      CALL JEMARQ()

      K24BLA = ' '
      CHARGE = LISCHA // '.LCHA'
      INFOCH = LISCHA // '.INFC'
      FOMULT = LISCHA // '.FCHA'
      VAFEDO = '&&VAFEDO'
      VAFSDO = '&&VAFSDO'
      VADIDO = '&&VADIDO'
      INSTAP = INST(1)
      TABTRA = '&&TABTRA'
      VECCOR = '&&VECCOR'
      VEANEC = '&&VEANEC'
      VAANEC = '&&VAANEC'
      VELAMP = '&&VELAME.LISTE_RESU'
      VALAMP = '&&VALAME'
      CNLAMP = '&&CNLAME'
      LGRFL  = .FALSE.

      VESSTR = '&&VESSTR'
      CNSSTR = '&&CNSSTR'


      CALL DESAGG (SECMBR, CNFEDO, CNFEPI, CNDIDO, CNDIPI,
     &                     CNFSDO, CNFSPI, CNDIDI, CNCINE)

      CALL JEEXIN ( CHARGE, IRET )
      IF ( IRET .NE. 0 ) THEN
         CALL JEVEUO ( INFOCH, 'L', JINFC )
         CALL JEVEUO ( CHARGE, 'L', JCHAR )
         NBCHAR = ZI(JINFC)
         DO 10 ICH = 1, NBCHAR
            NOMCHA = ZK24(JCHAR+ICH-1)(1:8)
            CALL JEEXIN ( NOMCHA//'.CHME.GRFLU.LINO', IRET )
            IF ( IRET .NE. 0 )  LGRFL = .TRUE.
 10      CONTINUE
      ENDIF
C ======================================================================
C                            CHARGEMENTS FIXES
C ======================================================================
      IF (MODE.EQ.'FIXE' .OR. MODE.EQ.'TOUS' ) THEN

C -- DEPLACEMENTS IMPOSES DONNES                             ---> CNDIDO

        TYPESE=0
        CALL VEDIME ( MODELE, CHARGE, INFOCH, INSTAP, 'R',
     &                TYPESE, NOPASE, VEDIDO)
        CALL ASASVE (VEDIDO, NUMEDD, 'R', VADIDO)
        CALL ASCOVA('D',VADIDO, FOMULT, 'INST', INSTAP, 'R', CNDIDO)


C      CORRECTION POUR TENIR COMPTE DU TYPE DIRICHLET DIFFERENTIEL
        CALL EXISD('CHAMP',CNDIDI, IRET)
        IF (IRET.NE.0) THEN
          CALL JEVEUO(CNDIDI(1:19) // '.VALE','L',JDIDI)
          CALL JEVEUO(CNDIDO(1:19) // '.VALE','E',JDIDO)
          CALL JELIRA(CNDIDO(1:19) // '.VALE','LONMAX',NEQ,K8BID)
          CALL DAXPY(NEQ, 1.D0, ZR(JDIDI), 1, ZR(JDIDO), 1)
        END IF


C -- DEPLACEMENTS IMPOSES PILOTES                            ---> CNDIPI

        CALL VEDPME (MODELE, CHARGE, INFOCH, INSTAP, 'R', VEDIPI)
        CALL ASSVEC ('V',CNDIPI,1,VEDIPI,1.D0,NUMEDD,' ','ZERO',1)


C -- CHARGEMENTS MECANIQUES DONNES                           ---> CNFEDO

        TYPCAL = 'MECA'
        TYPESE=0
        CALL VECHME ( TYPCAL, MODELE, CHARGE, INFOCH, INST,
     &                CARELE, MATE, TEMPLU, K24BLA,
     &                VAPRIN, NOPASE, TYPESE, STYPSE,
     &                VEFEDO )
        CALL ASASVE (VEFEDO, NUMEDD, 'R', VAFEDO)
        CALL ASCOVA('D',VAFEDO, FOMULT, 'INST', INSTAP, 'R', CNFEDO)

C   NECESSAIRE POUR LA PRISE EN COMPTE DE MACRO-ELEMENT STATIQUE
        CALL DISMOI('F','NB_SS_ACTI',MODELE,'MODELE',NBSS,K8BID,IRET)
        IF (NBSS.NE.0) THEN
          CALL GETFAC('SOUS_STRUC',NBSST)
          IF (NBSST.NE.0) THEN
            CALL EXISD('CHAMP',CNSSTR(1:19),IRET)
            IF (IRET.EQ.0) THEN
              CALL MEMARE('V',VESSTR,MODELE,MATE,CARELE(1:8),
     &           'CHAR_MECA')
              CALL JEEXIN ( VESSTR//'.LISTE_CHAR', IRET2 )
              IF (IRET2.NE.0) THEN
                CALL JEDETR(VESSTR//'.LISTE_CHAR')
              ENDIF
              CALL SS2MME(MODELE(1:8),VESSTR,'V')
              CALL ASSVEC('V',CNSSTR,1,VESSTR,1.0D0,NUMEDD,' ','ZERO',1)
              CALL JEVEUO(CNSSTR(1:19) // '.VALE','L',JCNST)
            ELSE
              CALL JEVEUO(CNSSTR(1:19) // '.VALE','L',JCNST)
            END IF
            CALL JEVEUO(CNFEDO(1:19) // '.VALE','E',JCNFE)
            CALL JELIRA(CNFEDO(1:19) // '.VALE','LONMAX',NEQ,K8BID)
            CALL DAXPY(NEQ, 1.D0, ZR(JCNST), 1, ZR(JCNFE), 1)
          ENDIF
        ENDIF
C   FIN MACRO-ELEMENT STATIQUE

C -- CHARGEMENTS MECANIQUES PILOTES                         ---> CNFEPI
        CALL VEFPME (MODELE, CARELE, MATE, CHARGE, INFOCH, INST, TEMPLU,
     &               VEFEPI, ' ')
        CALL ASASVE (VEFEPI, NUMEDD, 'R', VAFEPI)
        CALL ASCOVA('D',VAFEPI, FOMULT, 'INST', INSTAP, 'R', CNFEPI)


C -- CONDITIONS CINEMATIQUES IMPOSEES  (AFFE_CHAR_CINE) ---> CNCINE
        CALL NMCVCI(CHARGE,INFOCH,FOMULT,NUMEDD,DEPMOI,INSTAP,CNCINE)


C -- CHARGEMENTS FORCES DE LAPLACE                         ---> CNLAMP
        CALL JEVEUO(CNFEDO(1:19) // '.VALE','E',JCNFE)
        CALL VELAME(MODELE,CHARGE,INFOCH,DEPMOI,VELAMP)
        CALL ASASVE (VELAMP,NUMEDD,'R',VALAMP)
        CALL ASCOVA('D',VALAMP,FOMULT,'INST',INSTAP,'R',CNLAMP)
        CALL JEVEUO(CNLAMP(1:19) // '.VALE','L',JCNLA)
        CALL JELIRA(CNFEDO(1:19) // '.VALE','LONMAX',NEQ,K8BID)
        CALL DAXPY(NEQ, 1.D0, ZR(JCNLA), 1, ZR(JCNFE), 1)


C -- CHARGEMENTS ONDES PLANES                            ---> CHONDP

        CALL JEEXIN(TABTRA,IRET)
        IF (IRET.EQ.0) THEN
          CALL WKVECT(TABTRA,'V V R',NEQ,JTRA)
        ELSE
          CALL JEVEUO(TABTRA,'E',JTRA)
        ENDIF
        IF (LONDE) THEN
           CALL JEVEUO(CHONDP,'L',IONDP)
           CALL FONDPL(MODELE,MATE,NUMEDD,NEQ,ZK8(IONDP),NONDP,VECCOR,
     +                 VEANEC,VAANEC,INSTAP,ZR(JTRA))
           CALL DAXPY(NEQ, -1.D0, ZR(JTRA), 1, ZR(JCNFE), 1)
        ENDIF


C -- CHARGEMENTS FORCES FLUIDES SUR LES GRAPPES          ---> CNFEDO

        IF ( LGRFL ) CALL NMGRFL ( NUMEDD, CHGRFL, DEPMOI, DEPDEL,
     +                             VITPLU, ACCPLU, INST(2), CNFEDO )


C ======================================================================
C                        CHARGEMENTS SUIVEURS
C ======================================================================
      ELSE IF (MODE.EQ.'SUIV' .OR. MODE.EQ.'TOUS') THEN

C -- FORCES SUIVEUSES DONNEES

C      POUR THM
        INSTAM = INST(1) - INST(2)

        CALL VECGME (MODELE,CARELE,MATE,CHARGE,INFOCH,INSTAP,
     &               DEPMOI,DEPDEL,VEFSDO,INSTAM,COMPOR,CARCRI,' ',
     &               VITPLU,ACCPLU)
        CALL ASASVE (VEFSDO,NUMEDD,'R',VAFSDO)
        CALL ASCOVA('D',VAFSDO,FOMULT,'INST',INSTAP,'R',CNFSDO)


C    FORCES SUIVEUSES PILOTEES (NON IMPLANTEES -> VECTEUR NUL)

        CALL EXISD('CHAMP',CNFSPI(1:19),IRET)
        IF (IRET.EQ.0) THEN
          CALL VTCREB (CNFSPI,NUMEDD,'V','R',NEQ)
        END IF


C ======================================================================
C                        FORCES D'INERTIE
C ======================================================================
      ELSE IF (MODE.EQ.'INER' .OR. MODE.EQ.'TOUS') THEN

C -- FORCES D'INERTIE
C -- ON LES RANGE DANS LE MEME VECTEUR QUE LES FORCES SUIVEUSES
        INSTAM = INST(1) - INST(2)
        CALL EXISD('CHAMP',CNFSDO(1:19),IRET)
        IF (IRET.EQ.0) THEN
           CALL VTCREB (CNFSDO,NUMEDD,'V','R',NEQ)
        END IF
        CALL JELIRA(CNFSDO(1:19) // '.VALE','LONMAX',NEQ,K8BID)
        CALL JEEXIN(TABTRA,IRET)
        IF (IRET.EQ.0) THEN
          CALL WKVECT(TABTRA,'V V R',NEQ,JTRA)
        ELSE
          CALL JEVEUO(TABTRA,'E',JTRA)
        ENDIF
        CALL JEVEUO(CNFSDO(1:19) // '.VALE','E',JCNFS)
        CALL JEVEUO(ACCPLU(1:19) // '.VALE','E',JACCP)
        CALL JEVEUO(MASSE(1:19)  // '.&INT','L',JMASS)
        CALL MRMULT ('ZERO',JMASS,ZR(JACCP),'R',ZR(JTRA),1)
        CALL DAXPY(NEQ, -1.D0, ZR(JTRA), 1, ZR(JCNFS), 1)

        IF (LAMORT) THEN
           CALL JEVEUO(VITPLU(1:19)//'.VALE','L',JVITP)
           CALL JEVEUO(AMORT(1:19) //'.&INT','L',JAMOR)
           CALL MRMULT ('ZERO',JAMOR,ZR(JVITP),'R',ZR(JTRA),1)
           CALL DAXPY(NEQ, -1.D0, ZR(JTRA), 1, ZR(JCNFS), 1)
        ENDIF

        IF (NMODAM.NE.0) THEN
           CALL JEVEUO(VITPLU(1:19)//'.VALE','L',JVITP)
           CALL JEVEUO(VITKM1(1:19)//'.VALE','L',JVITKM)
           CALL FMODAM(NEQ,ZR(JVITKM),VALMOD,BASMOD,ZR(JTRA))
           IF (NREAVI.EQ.1)
     &       CALL FMODAM(NEQ,ZR(JVITP),VALMOD,BASMOD,ZR(JTRA))
           CALL DAXPY(NEQ, -1.D0, ZR(JTRA), 1, ZR(JCNFS), 1)
        ENDIF

        IF (LIMPED) THEN
           CALL FIMPED(MODELE,MATE,NUMEDD,NEQ,VITKM1,VITENT,VECCOR,
     &                 VEANEC,VAANEC,INSTAM,ZR(JTRA))
           CALL DAXPY(NEQ, -1.D0, ZR(JTRA), 1, ZR(JCNFS), 1)
        ENDIF


C ======================================================================
C                        FORCES EXPLICITES
C ======================================================================
      ELSE IF (MODE.EQ.'EXPL') THEN

C -- FORCES EXPLICITES
C -- ON LES TRAITE DE LA MEME FACON QUE LES FORCES D'INERTIE
        INSTAM = INST(1) - INST(2)
        CALL EXISD('CHAMP',CNFSDO(1:19),IRET)
        IF (IRET.EQ.0) THEN
           CALL VTCREB (CNFSDO,NUMEDD,'V','R',NEQ)
        END IF
        CALL JELIRA(CNFSDO(1:19) // '.VALE','LONMAX',NEQ,K8BID)
        CALL JEEXIN(TABTRA,IRET)
        IF (IRET.EQ.0) THEN
          CALL WKVECT(TABTRA,'V V R',NEQ,JTRA)
        ELSE
          CALL JEVEUO(TABTRA,'E',JTRA)
        ENDIF
        CALL JEVEUO(CNFSDO(1:19) // '.VALE','E',JCNFS)

        IF (LAMORT) THEN
           CALL JEVEUO(VITPLU(1:19)//'.VALE','L',JVITP)
           CALL JEVEUO(AMORT(1:19) //'.&INT','L',JAMOR)
           CALL MRMULT ('ZERO',JAMOR,ZR(JVITP),'R',ZR(JTRA),1)
           CALL DAXPY(NEQ, -1.D0, ZR(JTRA), 1, ZR(JCNFS), 1)
        ENDIF
        IF (NMODAM.NE.0) THEN
           CALL JEVEUO(VITPLU(1:19)//'.VALE','L',JVITP)
           CALL JEVEUO(VITKM1(1:19)//'.VALE','L',JVITKM)
           CALL FMODAM(NEQ,ZR(JVITKM),VALMOD,BASMOD,ZR(JTRA))
           IF (NREAVI.EQ.1)
     &       CALL FMODAM(NEQ,ZR(JVITP),VALMOD,BASMOD,ZR(JTRA))
           CALL DAXPY(NEQ, -1.D0, ZR(JTRA), 1, ZR(JCNFS), 1)
        ENDIF

        IF (LIMPED) THEN
           CALL FIMPED(MODELE,MATE,NUMEDD,NEQ,VITKM1,VITENT,VECCOR,
     &                 VEANEC,VAANEC,INSTAM,ZR(JTRA))
           CALL DAXPY(NEQ, -1.D0, ZR(JTRA), 1, ZR(JCNFS), 1)
        ENDIF


C ======================================================================
C                        CHARGEMENTS SENSIBILITE
C ======================================================================
      ELSE IF ((MODE.EQ.'SENS').OR.(MODE.EQ.'SEDY')) THEN

C -- TYPE DE SENSIBILIE
       CALL METYSE(NBPASE, INPSCO, NOPASE, TYPESE, STYPSE)

C -- CHARGEMENT DU A LA DERIVATION (PARTIE COMPORTEMENT)    ---> CNFEDO

       CALL VEMSME(MODELE,MATE,COMPOR,INPSCO,NRPASE,TYPESE,
     &            NOPASE,VEMASE,STYPSE)
       CALL ASSVEC ('V',CNFEDO,1,VEMASE,1.D0,NUMEDD,K24BLA,'ZERO',1)
       CALL DETRSD('VECT_ELEM',VEMASE)
      IF(TYPESE.NE.2)THEN
C -- DERIVATION CHARGEMENTS MECANIQUES DONNES                ---> CNFEDO

        TYPCAL = 'MECA'
        CALL VECHME ( TYPCAL, MODELE, CHARGE, INFOCH, INST,
     &                CARELE, MATE,   K24BLA, K24BLA,
     &                VAPRIN, NOPASE, TYPESE, STYPSE,
     &                VEFEDO )
        CALL ASASVE (VEFEDO, NUMEDD, 'R', VAFEDO)
        CALL ASCOVA('D',VAFEDO, FOMULT, 'INST', INSTAP, 'R', TABTRA)
        CALL JELIRA(CNFEDO(1:19) // '.VALE','LONMAX',NEQ,K8BID)
        CALL JEVEUO(TABTRA(1:19) // '.VALE','L',JTRA)
        CALL JEVEUO(CNFEDO(1:19) // '.VALE','E',JCNFE)
        CALL DAXPY(NEQ, 1.D0, ZR(JTRA), 1, ZR(JCNFE), 1)
      ENDIF
C -- DERIVATION DEPLACEMENTS IMPOSES DONNES                 ---> CNDIDO

        CALL VEDIME ( MODELE, CHARGE, INFOCH, INSTAP, 'R',
     &                TYPESE, NOPASE, VEDIDO)
        CALL ASASVE (VEDIDO, NUMEDD, 'R', VADIDO)
        CALL ASCOVA('D',VADIDO, FOMULT, 'INST', INSTAP, 'R', CNDIDO)

        IF (MODE.EQ.'SEDY') THEN
C -- CONTRIBUTION FORCES D'INERTIE ET AMORT. DERIVEES        ---> CNFEDO
          INSTAM = INST(1) - INST(2)
          CALL JEVEUO(TABTRA,'E',JTRA)
          CALL JEVEUO(ACCPLU(1:19) // '.VALE','E',JACCP)
          CALL JEVEUO(MASSE(1:19)  // '.&INT','L',JMASS)
          CALL MRMULT ('ZERO',JMASS,ZR(JACCP),'R',ZR(JTRA),1)
          CALL DAXPY(NEQ, -1.D0, ZR(JTRA), 1, ZR(JCNFE), 1)

          IF (LAMORT) THEN
            CALL JEVEUO(VITPLU(1:19)//'.VALE','L',JVITP)
            CALL JEVEUO(AMORT(1:19) //'.&INT','L',JAMOR)
            CALL MRMULT ('ZERO',JAMOR,ZR(JVITP),'R',ZR(JTRA),1)
            CALL DAXPY(NEQ, -1.D0, ZR(JTRA), 1, ZR(JCNFE), 1)
         ENDIF

         IF (NMODAM.NE.0) THEN
           CALL JEVEUO(VITPLU(1:19)//'.VALE','L',JVITP)
           CALL FMODAM(NEQ,ZR(JVITP),VALMOD,BASMOD,ZR(JTRA))
           CALL DAXPY(NEQ, -1.D0, ZR(JTRA), 1, ZR(JCNFE), 1)
         ENDIF

         IF (LIMPED) THEN
           CALL FIMPED(MODELE,MATE,NUMEDD,NEQ,VITPLU,VITENT,VECCOR,
     &                 VEANEC,VAANEC,INSTAM,ZR(JTRA))
           CALL DAXPY(NEQ, -1.D0, ZR(JTRA), 1, ZR(JCNFE), 1)
         ENDIF

       ENDIF


C ======================================================================
C                        FORCE INCONNUE
C ======================================================================
      ELSE
        CALL UTMESS('F','NMCHAR','MODE ' //MODE// ' NON RECONNU (DVLP)')
      END IF

      CALL JEDEMA()
      END
