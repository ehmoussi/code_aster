      SUBROUTINE CAARLE ( CHARGE )
      IMPLICIT NONE
      CHARACTER*8   CHARGE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
C TOLE CRP_20
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
C ----------------------------------------------------------------------
C              CREATION D'UN CHARGEMENT DE TYPE ARLEQUIN
C ----------------------------------------------------------------------
C VARIABLES D'ENTREE
C CHARACTER*8   CHARGE  : SD CHARGE
C
C SD DE SORTIE
C CHARGE.POIDS_MAILLE   : VECTEUR DE PONDERATION DES MAILLES DU MAILLAGE
C                           (P1, P2, ...) AVEC P* POIDS DE LA MAILLE *
C
C SD D'ENTREE / SORTIE
C CHARGE.CHME.LIGRE     : LIGREL DE CHARGE
C CHARGE.CHME.CIMPO     : CARTE COEFFICIENTS IMPOSES
C CHARGE.CHME.CMULT     : CARTE COEFFICIENTS MULTIPLICATEURS
C ----------------------------------------------------------------------
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      CHARACTER*32       JEXNUM , JEXNOM , JEXR8 , JEXATR
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
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------

C --- PARAMETRES D'ECHANTILLONNAGE
      INTEGER      NHAPP,NHINT
      PARAMETER   (NHAPP = 4)
      PARAMETER   (NHINT = 2)

C --- VARIABLES
      CHARACTER*16 NBOITA,NBOITB,NBOIT1,NBOIT2
      CHARACTER*10 NOMA,NOMB,NOMC,NOM1,NOM2,NOMN,NOMT,QUAD,COL
      CHARACTER*8  MOD,MAIL,CARA,CLIM,MODEL(3),CINE(3)
      CHARACTER*8  K8B
      INTEGER      DM1,DM2,DIME,NNO,NOC,N1,N2,NC,NMA,NMAX,NH,NAPP,NCL
      INTEGER      IOC,I,IAD1,IAD2,ICOL,IMED,IFIN
      INTEGER      JTYPM,JDIME,JNOMA,JPOIM,JCOLM,JGRM1,JGRM2,JGRMC
      INTEGER      JARLEQ,JARLNH,JCHM1,JCHM2,JCHMB,JCNC1,JCNC2
      INTEGER      JBOITA,JBOITB,JTRAVR,JTRAVI,JTRAVL
      REAL*8       A1,A2,BC(2,3),R1,R2,L
      LOGICAL      ID

C --- FONCTIONS
      INTEGER      ARLFG
      LOGICAL      ARLCOL
C ----------------------------------------------------------------------

      CALL JEMARQ()

      CALL GETFAC('ARLEQUIN',NOC)
      IF (NOC.EQ.0) GOTO 110

      IFIN = 0
      NMAX = 0

      NOMA = CHARGE//'.A'
      NOMB = CHARGE//'.B'
      NOMC = CHARGE//'.C'
      NOM1 = CHARGE//'.1'
      NOM2 = CHARGE//'.2'
      NOMN = CHARGE//'.N'
      NOMT = CHARGE//'.T'
      QUAD = CHARGE//'.Q'
      NBOITA = NOMA//'.BOITE'
      NBOITB = NOMB//'.BOITE'
      NBOIT1 = NOM1//'.BOITE'
      NBOIT2 = NOM2//'.BOITE'

C --- VECTEUR NOM TYPE DE MAILLES

      CALL JELIRA('&CATA.TM.NOMTM','NOMMAX',NC,K8B)
      CALL WKVECT ( '&&ARL.NOMTM', 'V V K8', NC, JTYPM )
      DO 10 I = 1, NC
        CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',I),ZK8(JTYPM-1+I))
 10   CONTINUE

C --- VECTEURS DE TRAVAIL

      NH = MAX(NHAPP,NHINT)**2
      CALL WKVECT ( '&&ARL.ZR', 'V V R', 12+276*NH,  JTRAVR )
      CALL WKVECT ( '&&ARL.ZI', 'V V I', 56+1536*NH, JTRAVI )
      CALL WKVECT ( '&&ARL.ZL', 'V V L', 24*NH,      JTRAVL )
      CALL WKVECT ( '&&ARL.NH', 'V V I', 2,          JARLNH )
      ZI(JARLNH  ) = NHAPP
      ZI(JARLNH+1) = NHINT

C --- LECTURE MAILLAGE ET DIMENSION

      CALL GETVID(' ','MODELE',0,1,1,MOD,I)
      CALL JEVEUO(MOD//'.MODELE    .NOMA','L',JNOMA)
      MAIL = ZK8(JNOMA)
      CALL JEVEUO(MAIL//'.DIME','L',JDIME)
      NNO = ZI(JDIME)
      NMA = ZI(JDIME+2)

C --- INITIALISATION VECTEUR CHARGE.P_MAILLE

      CALL WKVECT ( CHARGE//'.POIDS_MAILLE', 'G V R', NMA, JPOIM )
      DO 20 I = 1, NMA
        ZR(JPOIM-1+I) = 1.D0
 20   CONTINUE

C --- VECTEUR DECRIVANT LA ZONE DE COLLAGE ET LES MAILLES APPARIEES

      CALL WKVECT ( NOMC, 'V V L', NMA, JCOLM )

C --- MOT-CLEF FACTEUR ARLEQUIN

      DO 30 IOC = 1, NOC

C ----- LECTURE ET VERIFICATION DES MAILLES DES MODELES

        CALL GETVID('ARLEQUIN','GROUP_MA_1',IOC,1,0,K8B,N1)
        CALL GETVID('ARLEQUIN','GROUP_MA_2',IOC,1,0,K8B,N2)

        CALL WKVECT ( '&&CAARLE.GMA1', 'V V K8', -N1, JGRM1 )
        CALL WKVECT ( '&&CAARLE.GMA2', 'V V K8', -N2, JGRM2 )

        CALL GETVID('ARLEQUIN','GROUP_MA_1',IOC,1,-N1,ZK8(JGRM1),N1)
        CALL GETVID('ARLEQUIN','GROUP_MA_2',IOC,1,-N2,ZK8(JGRM2),N2)

        CALL ARLVER(MOD,ZK8(JGRM1),N1,NOMA,MODEL(1),CINE(1),DM1)
        CALL ARLVER(MOD,ZK8(JGRM2),N2,NOMB,MODEL(2),CINE(2),DM2)

        CALL JEDETR('&&CAARLE.GMA1')
        CALL JEDETR('&&CAARLE.GMA2')

        IF (MODEL(1).NE.MODEL(2))
     &    CALL U2MESS('F','MODELISA2_33')

C ----- DIMENSION

        IF (MODEL(1)(1:2).EQ.'3D') THEN
          DIME = 3
        ELSE
          DIME = 2
        ENDIF

C ----- LISSAGE DES NORMALES

        IF ((CINE(1).EQ.'COQUE   ').OR.(CINE(2).EQ.'COQUE   ')) THEN

          CALL JEEXIN(NOMN,I)

          IF (I.EQ.0) THEN

            CALL GETVID('ARLEQUIN','CARA_ELEM',IOC,1,1,CARA,I)

            IF (I.EQ.0) CALL U2MESS('F','MODELISA2_34')
            CALL LISNOR(CARA,DIME,NOMN,NOMT)

          ENDIF

        ENDIF

C ----- MISE EN BOITES DES MAILLES DES MODELES

        CALL BOITE(MAIL,NOMA//'.GROUPEMA',NOMN,DIME,ZK8(JTYPM),NBOITA)
        CALL BOITE(MAIL,NOMB//'.GROUPEMA',NOMN,DIME,ZK8(JTYPM),NBOITB)

C ----- BOITE DE LA ZONE DE SUPERPOSITION (BS)

        L = 1.D0
        CALL JEVEUO ( NOMA//'.BOITE.MMGLOB', 'L', JBOITA )
        CALL JEVEUO ( NOMB//'.BOITE.MMGLOB', 'L', JBOITB )

        DO 40 I = 1, DIME

          R1 = MAX(ZR(JBOITA),ZR(JBOITB))
          JBOITA = JBOITA + 1
          JBOITB = JBOITB + 1

          R2 = MIN(ZR(JBOITA),ZR(JBOITB))
          JBOITA = JBOITA + 1
          JBOITB = JBOITB + 1

          IF (R1.GE.R2)
     &    CALL U2MESS('F','MODELISA2_35')

          BC(1,I) = R1
          BC(2,I) = R2
          L = L * (R2-R1)

 40     CONTINUE

        L = 0.5D0*(L**(2.D0/DIME))

C ----- FILTRAGE DES MAILLES SITUEES DANS BS

        CALL ARLFLT(NOMA,BC,NOM1,N1)
        CALL ARLFLT(NOMB,BC,NOM2,N2)

C ----- LECTURE ET VERIFICATION PONDERATION

        CALL GETVR8('ARLEQUIN','POIDS_1',IOC,1,1,A1,I)
        IF (I.NE.0) THEN
          A2 = 1.D0 - A1
          GOTO 50
        ENDIF

        CALL GETVR8('ARLEQUIN','POIDS_2',IOC,1,1,A2,I)
        IF (I.NE.0) THEN
          A1 = 1.D0 - A2
          GOTO 50
        ENDIF

        IFIN = ARLFG(NBOIT1,NBOIT2)

        CALL GETVR8('ARLEQUIN','POIDS_FIN',IOC,1,1,A1,I)
        IF (I.NE.0) THEN
          IF (IFIN.EQ.1) THEN
            A2 = 1.D0 - A1
          ELSE
            A2 = A1
            A1 = 1.D0 - A2
          ENDIF
          GOTO 50
        ENDIF

        CALL GETVR8('ARLEQUIN','POIDS_GROSSIER',IOC,1,1,A1,I)
        IF (IFIN.EQ.1) THEN
          A2 = A1
          A1 = 1.D0 - A2
        ELSE
          A2 = 1.D0 - A1
        ENDIF

 50     CONTINUE

C        IF ((A1.LE.0.D0).OR.(A2.LE.0.D0))
C     &     CALL UTMESS('F','CAARLE','IL FAUT 0 < POIDS < 1')

C ----- CHOIX DU MEDIATEUR

        CALL GETVTX('ARLEQUIN','COLLAGE',IOC,1,1,COL,I)
        IF (COL.EQ.'GROUP_MA_1') THEN
          IMED = 1
        ELSEIF (COL.EQ.'GROUP_MA_2') THEN
          IMED = 2
        ELSE
          IF (IFIN.EQ.0) IFIN = ARLFG(NBOIT1,NBOIT2)
          IF (COL.EQ.'GROSSIER') THEN
            IMED = 3 - IFIN
          ELSE
            IMED = IFIN
          ENDIF
        ENDIF

C ----- MAILLES DE LA ZONE DE COLLAGE

        CALL GETVID('ARLEQUIN','GROUP_MA_COLL',IOC,1,0,K8B,NC)

        IF (NC.NE.0) THEN

C ------- LECTURE ET FILTRAGE DES MAILLES DE LA ZONE DE COLLAGE

          CALL WKVECT('&&CAARLE.GMAC','V V K8',-NC,JGRMC)
          CALL GETVID('ARLEQUIN','GROUP_MA_COLL',IOC,1,-NC,
     &                                                 ZK8(JGRMC),NC)
          CALL ARLVER(MOD,ZK8(JGRMC),NC,NOMA,MODEL(3),CINE(3),I)
          CALL JEDETR('&&CAARLE.GMAC')

          CALL BOITE(MAIL,NOMA//'.GROUPEMA',NOMN,DIME,ZK8(JTYPM),NBOITA)
          CALL ARLFLT(NOMA,BC,NOMB,NC)

C ------- VERIFICATION DES MAILLES DE LA ZONE DE COLLAGE

          CALL JEVEUO ( NOM1//'.GROUPEMA', 'E', JCHM1 )
          CALL JEVEUO ( NOM2//'.GROUPEMA', 'E', JCHM2 )
          CALL JEVEUO ( NOMB//'.GROUPEMA', 'E', JCHMB )

          IF (ARLCOL(ZI(JCHMB),NC,ZI(JCHM1),N1,ZL(JCOLM))) THEN
            ICOL = 1
          ELSEIF(ARLCOL(ZI(JCHMB),NC,ZI(JCHM2),N2,ZL(JCOLM))) THEN
            ICOL = 2
          ELSE
            CALL U2MESS('F','MODELISA2_36')
          ENDIF

          CALL JEDETR(NOMB//'.GROUPEMA')
          CALL JEDETR(NOMB//'.BOITE.DIME')
          CALL JEDETR(NOMB//'.BOITE.MINMAX')
          CALL JEDETR(NOMB//'.BOITE.PAN')
          CALL JEDETR(NOMB//'.BOITE.SOMMET')
          CALL JEDETR(NOMB//'.BOITE.MMGLOB')
          CALL JEDETR(NOMB//'.BOITE.H')

        ELSE

C ------- ZONE DE COLLAGE EST IDENTIQUE A LA ZONE DE SUPERPOSITION

          IF (N1.GE.N2) THEN
            ICOL = 1
            NC = N1
          ELSE
            ICOL = 2
            NC = N2
          ENDIF

          DO 60 I = 1, NC
            ZL(JCOLM-1+I) = .TRUE.
 60       CONTINUE

        ENDIF

        ID = ICOL.EQ.IMED
        CINE(3) = CINE(IMED)

C ----- CALCUL DU DEGRE MAXIMAL DES GRAPHES NOEUDS -> MAILLES

        CALL JEVEUO ( NOM1//'.GROUPEMA', 'L', JCHM1 )
        CALL CNCINV(MAIL,ZI(JCHM1),N1,'V',NOM1//'.CNCINV')
        CALL GRMAMA(MAIL,NOM1//'.CNCINV',N1,DM1,'V',NOM1//'.GRMAMA')
        CALL JEVEUO ( JEXATR(NOM1//'.CNCINV', 'LONCUM'), 'L', JCNC1 )

        IAD1 = ZI(JCNC1)
        DO 70 I = 1, NNO
          JCNC1 = JCNC1 + 1
          IAD2 = ZI(JCNC1)
          IF ((IAD2-IAD1).GT.NMAX) NMAX = IAD2-IAD1
          IAD1 = IAD2
 70     CONTINUE

        CALL JEVEUO(NOM2//'.GROUPEMA','L',JCHM2)
        CALL CNCINV(MAIL,ZI(JCHM2),N2,'V',NOM2//'.CNCINV')
        CALL GRMAMA(MAIL,NOM2//'.CNCINV',N2,DM2,'V',NOM2//'.GRMAMA')
        CALL JEVEUO(JEXATR(NOM2//'.CNCINV','LONCUM'),'L',JCNC2)

        IAD1 = ZI(JCNC2)
        DO 80 I = 1, NNO
          JCNC2 = JCNC2 + 1
          IAD2 = ZI(JCNC2)
          IF ((IAD2-IAD1).GT.NMAX) NMAX = IAD2-IAD1
          IAD1 = IAD2
 80     CONTINUE

C ----- APPARIEMENT DES MAILLES ET FAMILLES D'INTEGRALES

        IF (ICOL.EQ.1) THEN

          CALL BISSEC(NBOIT2)
          CALL ARLAPP(MAIL,NOM1,NOM2,NOMN,NMAX,ZK8(JTYPM),ZL(JCOLM),
     &                                                         NC,NAPP)
          CALL JEDETR(NOM2//'.ARBRE.CELL')
          CALL JEDETR(NOM2//'.ARBRE.LIMA')
          CALL ARLFAM(MAIL,NOM1,NOM2,NAPP,ZK8(JTYPM),ZL(JCOLM),ID,QUAD)
          IF (ID) THEN
            CALL ARLFC1(MAIL,DIME,NOM1,CINE(1),NOM2,CINE(2),NOMC,
     &                                                       ZL(JCOLM))
          ELSE
            CALL ARLFC2(MAIL,DIME,NOM1,CINE(1),NOM2,CINE(2),NOMC,
     &                                                       ZL(JCOLM))
          ENDIF

        ELSE

          CALL BISSEC(NBOIT1)
          CALL ARLAPP(MAIL,NOM2,NOM1,NOMN,NMAX,ZK8(JTYPM),ZL(JCOLM),
     &                                                         NC,NAPP)
          CALL JEDETR(NOM1//'.ARBRE.CELL')
          CALL JEDETR(NOM1//'.ARBRE.LIMA')
          CALL ARLFAM(MAIL,NOM2,NOM1,NAPP,ZK8(JTYPM),ZL(JCOLM),ID,QUAD)
          IF (ID) THEN
            CALL ARLFC1(MAIL,DIME,NOM2,CINE(2),NOM1,CINE(1),NOMC,
     &                                                       ZL(JCOLM))
          ELSE
            CALL ARLFC2(MAIL,DIME,NOM2,CINE(2),NOM1,CINE(1),NOMC,
     &                                                       ZL(JCOLM))
          ENDIF

        ENDIF

        CALL JEDETR(NOM1//'.CNCINV')
        CALL JEDETR(NOM2//'.CNCINV')

C ----- ELIMINATION REDONDANCE CONDITIONS LIMITES / COUPLAGE ARLEQUIN

        CALL JELIRA(NOMC//'.INO','LONMAX',NC,K8B)
        CALL WKVECT ( '&&ARL.EQ', 'V V L', 5*NC, JARLEQ )

        DO 90 I = 1, 5*NC
          ZL(JARLEQ-1+I) = .TRUE.
 90     CONTINUE

        CALL ARLCLR(DIME,IOC,NNO,NOMC,NOMT,ZL(JARLEQ))

C ----- CALCUL DES EQUATIONS DE COUPLAGE

        DO 100 I = 1, NMA
          ZL(JCOLM-1+I) = .FALSE.
 100    CONTINUE

        IF (IMED.EQ.1) THEN
          CALL ARLCPL(MAIL,QUAD,NOMC,NOM1,CINE(1),NOM2,
     &                CINE(2),ZK8(JTYPM),NOMN,NOMT,L,ZL(JCOLM))
        ELSE
          CALL ARLCPL(MAIL,QUAD,NOMC,NOM2,CINE(2),NOM1,
     &                CINE(1),ZK8(JTYPM),NOMN,NOMT,L,ZL(JCOLM))
        ENDIF
        CALL JEDETR(QUAD//'.LIMAMA')
        CALL JEDETR(QUAD//'.MAMA')
        CALL JEDETR(QUAD//'.NUMERO')
        CALL JEDETR(QUAD//'.TYPEMA')

C ----- PONDERATION DES MAILLES

         IF (ICOL.EQ.1) THEN
          CALL ARLPND(DIME,MAIL,NOM1,CINE(1),NOM2,CINE(2),
     &                A1,NOMN,BC,ZK8(JTYPM),ZL(JCOLM),ZR(JPOIM))
          CALL JEDETR(NOM1//'.'//NOM2)
        ELSE
          CALL ARLPND(DIME,MAIL,NOM2,CINE(2),NOM1,CINE(1),
     &                A2,NOMN,BC,ZK8(JTYPM),ZL(JCOLM),ZR(JPOIM))
          CALL JEDETR(NOM2//'.'//NOM1)
        ENDIF

C ----- DESALLOCATION DOMAINES 1 ET 2

        CALL JEDETR(NOM1//'.GROUPEMA')
        CALL JEDETR(NOM1//'.GRMAMA')
        CALL JEDETR(NBOIT1//'.DIME')
        CALL JEDETR(NBOIT1//'.MINMAX')
        CALL JEDETR(NBOIT1//'.SOMMET')
        CALL JEDETR(NBOIT1//'.MMGLOB')
        CALL JEDETR(NBOIT1//'.PAN')
        CALL JEDETR(NBOIT1//'.H')

        CALL JEDETR(NOM2//'.GROUPEMA')
        CALL JEDETR(NOM2//'.GRMAMA')
        CALL JEDETR(NBOIT2//'.DIME')
        CALL JEDETR(NBOIT2//'.MINMAX')
        CALL JEDETR(NBOIT2//'.SOMMET')
        CALL JEDETR(NBOIT2//'.MMGLOB')
        CALL JEDETR(NBOIT2//'.PAN')
        CALL JEDETR(NBOIT2//'.H')

        CALL JEDETR(NOMC)

C ----- ASSEMBLAGE EN CHARGE .CHME

        CALL ARLCHA(DIME,CINE,NOM1,NOM2,ZL(JARLEQ),CHARGE)

        CALL JEDETR(NOM1//'.MORSE.DIME')
        CALL JEDETR(NOM1//'.MORSE.INO')
        CALL JEDETR(NOM1//'.MORSE.VALE')

        CALL JEDETR(NOM2//'.MORSE.DIME')
        CALL JEDETR(NOM2//'.MORSE.INO')
        CALL JEDETR(NOM2//'.MORSE.VALE')

        CALL JEDETR(NOMC//'.INO')
        CALL JEDETR('&&ARL.EQ')

 30   CONTINUE

C --- DESALLOCATION

      CALL JEDETR('&&ARL.ZR')
      CALL JEDETR('&&ARL.ZI')
      CALL JEDETR('&&ARL.ZL')
      CALL JEDETR('&&ARL.NH')
      CALL JEDETR('&&ARL.NOMTM')

      CALL JEDETR(NOMC)

      CALL JEEXIN(NOMN,I)
      IF (I.NE.0) THEN
        CALL JEDETR(NOMN)
        CALL JEDETR(NOMT)
      ENDIF

 110  CONTINUE

      CALL JEDEMA()

      END
