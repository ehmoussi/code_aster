      SUBROUTINE ALGOCO(DEFICO,RESOCO,LMAT,LDSCON,NOMA,CINE,RESU,DEPTOT,
     &                  LICCVG,ISTO)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 29/06/2004   AUTEUR MABBAS M.ABBAS 
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
C TOLE CRP_20

      IMPLICIT NONE

      CHARACTER*8 NOMA
      CHARACTER*24 DEFICO,RESOCO,CINE,RESU,DEPTOT
      INTEGER LMAT,LDSCON,NEQMAX,LICCVG(5),ISTO

C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : NMCONT
C ----------------------------------------------------------------------
C
C METHODE DES CONTRAINTES ACTIVES POUR LE CONTACT UNILATERAL.
C
C RESOLUTION DE : C.DU + AT.MU  = F
C                 A(U+DU)      <= E (= POUR LES LIAISONS ACTIVES)
C
C AVEC E = JEU COURANT (CORRESPONDANT A U/I/N)
C
C      C = ( K  BT ) MATRICE DE RIGIDITE INCLUANT LES LAGRANGE
C          ( B  0  )
C
C      U = ( DEPL )
C          ( LAM  )
C
C      F = ( DL  ) DANS LA PHASE DE PREDICTION
C          ( DUD )
C
C      F = ( L - QT.SIG - BT.LAM  ) AU COURS D'UNE ITERATION DE NEWTON
C          (           0          )
C
C IN  DEFICO  : SD DE DEFINITION DU CONTACT (ISSUE D'AFFE_CHAR_MECA)
C IN  RESOCO  : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C IN  LMAT    : DESCRIPTEUR DE LA MATR_ASSE DU SYSTEME MECANIQUE
C IN  LDSCON  : DESCRIPTEUR DE LA MATRICE -A.C-1.AT
C IN  NOMA    : NOM DU MAILLAGE
C IN  CINE    : CHAM_NO CINEMATIQUE
C IN  DEPTOT  : DEPLACEMENT TOTAL OBTENU A L'ISSUE DE L'ITERATION
C               DE NEWTON PRECEDENTE
C IN  ISTO    : 0 ON ARRETE LE CALCUL SI ON PERD PLUS DE 8 DECIMALES
C               1 ON N'ARRETE PAS LE CALCUL
C VAR RESU    : INCREMENT "DDEPLA" DE DEPLACEMENT DEPUIS DEPTOT
C                 EN ENTREE : SOLUTION OBTENUE SANS TRAITER LE CONTACT
C                 EN SORTIE : SOLUTION CORRIGEE PAR LE CONTACT
C
C --------------- DEBUT DECLARATIONS NORMALISEES JEVEUX ---------------

      CHARACTER*32 JEXNUM,JEXNOM
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

      LOGICAL TROUAC,DELPOS,GCPC
      INTEGER JCHSEC,JCHSOL,JSLVK,NESMAX,LLF,LLF1,LLF2
      CHARACTER*19 MATASS,MATAS1,MATPRE,CHASEC,CHASOL,SOLVEU
      INTEGER IBID,IER,IFM,NIV,NDECI,ISINGU,NPVNEG
      INTEGER ICONTA,II,KK,ITER,IDEBUT,ILIAC,INDICL,IDEBUC
      INTEGER JRESU,JDEPP,JMU,JCMU,JATMU,POSMA,PIVOT,IOTE
      INTEGER JDELT0,JDELTA,JLIAC,JCOCO,JCM1A,JLIOT
      INTEGER NEQ,NESCL,NBLIAC,NBLIAI,INDIC,KKMIN,LLMIN
      INTEGER LLIAC,POS1,POS2,NUM1,NUM2,JDECAL,NBDDL,NDIM
      INTEGER JAPPAR,JAPPTR,JAPCOE,JAPJEU,JAPDDL,JNOCO,JMACO
      INTEGER INDFAC,AJLIAI,SPLIAI,POSIT,SPAVAN
      REAL*8 R8MAEM,AJEU,RHO,RHORHO,AADELT,RMINMU,VAL,R8PREM
      REAL*8 XJVMAX
      COMPLEX*16 CBID
      CHARACTER*1 TYPEAJ,TYPESP
      CHARACTER*2 TYPEC0
      CHARACTER*8 NOM1,NOM2
      CHARACTER*14 CHAIN
      CHARACTER*19 LIAC,MU,ATMU,DELT0,DELTA,CM1A,COCO,LIOT
      CHARACTER*24 MACONT
      CHARACTER*24 APPARI,APPOIN,APCOEF,APJEU,APDDL,COEFMU
      CHARACTER*24 CONTNO,CONTMA,K24BID


C ----------------------------------------------------------------------

C ======================================================================
C             INITIALISATIONS DES OBJETS ET DES ADRESSES
C ======================================================================

C U      : DEPTOT + RESU+
C DEPTOT : DEPLACEMENT TOTAL OBTENU A L'ISSUE DE L'ITERATION DE NEWTON
C          PRECEDENTE. C'EST U/I/N.
C RESU   : INCREMENT DEPUIS DEPTOT (ACTUALISE AU COURS DES ITERATIONS
C          DE CONTRAINTES ACTIVES : RESU+ = RESU- + RHO.DELTA)
C          C'EST DU/K OU DU/K+1.
C DELTA  : INCREMENT DONNE PAR CHAQUE ITERATION DE CONTRAINTES ACTIVES.
C          C'EST D/K+1.
C DELT0  : INCREMENT DE DEPLACEMENT DEPUIS LA DERNIERE ITERATION DE
C          NEWTON SANS TRAITER LE CONTACT. C'EST C-1.F.
      CALL INFNIV(IFM,NIV)
      CALL JEMARQ()

C --- LE CONTACT DOIT-IL ETRE MODELISE ?

      APPARI = RESOCO(1:14)//'.APPARI'
      CALL JEEXIN(APPARI,ICONTA)
      IF (ICONTA.EQ.0) GO TO 212
      CALL JEVEUO(APPARI,'L',JAPPAR)
      NESCL = ZI(JAPPAR)

C --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT

C LIAC   : LISTE DES INDICES DES LIAISONS ACTIVES
C MU     : MULTIPLICATEURS DE LAGRANGE DU CONTACT (DOIVENT ETRE > 0)
C COEFMU : COEFFICIENT PAR LEQUEL IL FAUT MULTIPLIER MU AVANT DE
C          TESTER SON SIGNE (-1 SI CONDITION EN PRESSION OU TEMPERATURE)
C ATMU   : FORCES DE CONTACT
C CM1A   : C-1.AT AVEC C MATRICE DE RIGIDITE TANGENTE,
C          ET A MATRICE DE CONTACT (AT SA TRANSPOSEE)

      CONTNO = DEFICO(1:16)//'.NOEUCO'
      CONTMA = DEFICO(1:16)//'.MAILCO'
      APPARI = RESOCO(1:14)//'.APPARI'
      APPOIN = RESOCO(1:14)//'.APPOIN'
      APCOEF = RESOCO(1:14)//'.APCOEF'
      APJEU = RESOCO(1:14)//'.APJEU'
      APDDL = RESOCO(1:14)//'.APDDL'
      LIAC = RESOCO(1:14)//'.LIAC'
      LIOT = RESOCO(1:14)//'.LIOT'
      MU = RESOCO(1:14)//'.MU'
      COEFMU = RESOCO(1:14)//'.COEFMU'
      ATMU = RESOCO(1:14)//'.ATMU'
      DELT0 = RESOCO(1:14)//'.DEL0'
      DELTA = RESOCO(1:14)//'.DELT'
      CM1A = RESOCO(1:14)//'.CM1A'

      CALL JEVEUO(CONTNO,'L',JNOCO)
      CALL JEVEUO(CONTMA,'L',JMACO)
      CALL JEVEUO(APPARI,'L',JAPPAR)
      CALL JEVEUO(APPOIN,'L',JAPPTR)
      CALL JEVEUO(APCOEF,'L',JAPCOE)
      CALL JEVEUO(APJEU,'E',JAPJEU)
      CALL JEVEUO(APDDL,'L',JAPDDL)
      CALL JEVEUO(LIAC,'E',JLIAC)
      CALL JEVEUO(LIOT,'E',JLIOT)
      CALL JEVEUO(MU,'E',JMU)
      CALL JEVEUO(COEFMU,'L',JCMU)
      CALL JEVEUO(ATMU,'E',JATMU)
      CALL JEVEUO(DELT0,'E',JDELT0)
      CALL JEVEUO(DELTA,'E',JDELTA)
      CALL JEVEUO(RESU(1:19)//'.VALE','E',JRESU)
      CALL JEVEUO(DEPTOT(1:19)//'.VALE','E',JDEPP)

      NBLIAI = NESCL

      MACONT = ZK24(ZI(LDSCON+1))
      CALL JEECRA(MACONT(1:19)//'.REFA','DOCU',IBID,'ASSE')
      NEQ = ZI(LMAT+2)

C --- SOUVENIRS DE L'ETAT DE CONTACT -> ON NE PEUT PAS S'EN SERVIR
C --- AU DEBUT CAR SI ON A REAPPARIE LES LIAISONS SONT DIFFERENTES

C NBLIAC : NOMBRE DE LIAISONS ACTIVES
C INDIC  : 0  INITIALISATION,
C          +1 ON A RAJOUTE UNE LIAISON
C          -1 ON A ENLEVE UNE LIAISON
C ======================================================================
      COCO = RESOCO(1:14)//'.COCO'
      CALL JEVEUO(COCO,'E',JCOCO)
      NDIM   = ZI(JCOCO  )
C ======================================================================
      NBLIAC = 0
      INDIC  = 0
      INDFAC = 1
      LLF    = 0
      LLF1   = 0
      LLF2   = 0
      AJLIAI = 0
      SPLIAI = 0
C ======================================================================
C --- INITIALISATION DE VARIABLES --------------------------------------
C ======================================================================
      TYPEAJ = 'A'
      TYPESP = 'S'
      TYPEC0 = 'C0'
      NESMAX = 0
C ======================================================================
C                             INITIALISATIONS
C ======================================================================

C     SI SOLVEUR GCPC, ON ALLOUE 2 CHAM_NO UTILES POUR APPELER RESOUD :
C     -----------------------------------------------------------------
      SOLVEU = '&&OP0070.SOLVEUR'
      CALL JEVEUO(SOLVEU//'.SLVK','L',JSLVK)
      GCPC = (ZK24(JSLVK-1+1).EQ.'GCPC')
      IF (GCPC) THEN
        MATAS1 = ZK24(ZI(LMAT+1))
        MATASS = '&&MATASS'
        IF (MATAS1.NE.MATASS) CALL UTMESS('F','ALGOCO','STOP')
        MATPRE = '&&NMMATR.MAPREC'
        CHASOL = '&&ALGOCO.CHASOL'
        CHASEC = '&&ALGOCO.CHASEC'
        CALL COPISD('CHAMP_GD','V',DEPTOT,CHASOL)
        CALL COPISD('CHAMP_GD','V',DEPTOT,CHASEC)
        CALL JEVEUO(CHASOL//'.VALE','E',JCHSOL)
        CALL JEVEUO(CHASEC//'.VALE','L',JCHSEC)
      END IF

      ITER = 0

C --- RECOPIE DANS DELT0 DU CHAMP DE DEPLACEMENTS OBTENU SANS
C --- TRAITER LE CONTACT (LE DDEPLA DONNE PAR STAT_NON_LINE)

      DO 10 KK = 1,NEQ
        ZR(JDELT0-1+KK) = ZR(JRESU-1+KK)
        ZR(JRESU-1+KK)  = 0.0D0
   10 CONTINUE
      XJVMAX   = 0.0D0

C --- CALCUL DE -A.DEPTOT ET RANGEMENT DANS APJEU
C --- (UNIQUEMENT POUR LES CL SANS APPARIEMENT,
C --- C'EST-A-DIRE POUR P, T, OU U RIGIDE : LORSQUE POSMA = 0)
      DO 20 II = 1,NBLIAI
        POSMA = ZI(JAPPAR+3* (II-1)+2)
        IF (POSMA.EQ.0) THEN
          JDECAL = ZI(JAPPTR+II-1)
          NBDDL = ZI(JAPPTR+II) - ZI(JAPPTR+II-1)
          CALL CALADU(NEQ,NBDDL,ZR(JAPCOE+JDECAL),ZI(JAPDDL+JDECAL),
     &                ZR(JDEPP),VAL)
          ZR(JAPJEU+II-1) = ZR(JAPJEU+II-1) - VAL
        END IF
   20 CONTINUE


C --- DETECTION DES COUPLES DE NOEUDS INTERPENETRES
C --- ON CALCULE LE NOUVEAU JEU : AJEU+ = AJEU/I/N - A.DDEPLA
C --- (IL EST NEGATIF LORSQU'IL Y A INTERPENETRATION -> LIAISON ACTIVE)

      IF (NBLIAC.EQ.0) THEN
        ZI(JLIOT+4*NBLIAI) = 0
        DO 30 II = 1,NBLIAI
          JDECAL = ZI(JAPPTR+II-1)
          NBDDL = ZI(JAPPTR+II) - ZI(JAPPTR+II-1)
          CALL CALADU(NEQ,NBDDL,ZR(JAPCOE+JDECAL),ZI(JAPDDL+JDECAL),
     &                ZR(JDELT0),VAL)
          AJEU = ZR(JAPJEU+II-1) - VAL

          IF ((AJEU.LT.0.0D0) .OR. (ZR(JAPJEU+II-1).LT. (0.D0))) THEN
            INDIC = 0
            POSIT  = NBLIAC + 1
            CALL CFTABL(INDIC,NBLIAC,AJLIAI,SPLIAI,LLF,LLF1,LLF2,
     +                                    RESOCO,TYPEAJ,POSIT,II,TYPEC0)
            IF (NIV.GE.2) THEN
              POS1 = ZI(JAPPAR+3* (II-1)+1)
              NUM1 = ZI(JNOCO+POS1-1)
              CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',NUM1),NOM1)
              POS2 = ZI(JAPPAR+3* (II-1)+2)
              IF (POS2.GT.0) THEN
                CHAIN = ' A  LA MAILLE '
                NUM2 = ZI(JMACO+POS2-1)
                CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',NUM2),NOM2)
              ELSE IF (POS2.LT.0) THEN
                CHAIN = ' AU NOEUD     '
                NUM2 = ZI(JNOCO+ABS(POS2)-1)
                CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',NUM2),NOM2)
              ELSE IF (POS2.EQ.0) THEN
                CHAIN = ' '
                NOM2 = ' '
              END IF
              WRITE (IFM,1000) 'LE NOEUD ',NOM1,' EST ASSOCIE ',CHAIN,
     &          NOM2
            END IF
          END IF
   30   CONTINUE
      END IF
      IF (NIV.EQ.2) WRITE (IFM,*) 'NBLIAI',NBLIAI,'NBLIACINIT',NBLIAC


C ======================================================================
C                    REPRISE DE LA BOUCLE PRINCIPALE
C ======================================================================

   40 CONTINUE

C ==============================
C SI PAS DE LIAISON ACTIVE,
C ON REMPLIT DELTA ET ON VA
C DIRECTEMENT AU CALCUL DE RHO
C ==============================

      IF (NBLIAC.EQ.0) THEN
        DO 50 KK = 1,NEQ
          ZR(JDELTA+KK-1) = ZR(JDELT0+KK-1) - ZR(JRESU-1+KK)
   50   CONTINUE
      END IF

C ==============================
C S'IL Y A DES LIAISONS ACTIVES,
C ON CALCULE MU ET DELTA
C ==============================

C --- DETERMINATION DE LA 1ERE LIAISON AYANT CHANGE D'ETAT (IN/ACTIF)
C --- (ON NE RECONSTRUIRA -A.C-1.AT QU'A PARTIR DE CETTE LIAISON)

      IF (NIV.EQ.2) WRITE (IFM,*) 'NBLIAC',NBLIAC
      IF (NBLIAC.NE.0) THEN

        IF (GCPC) THEN
           INDFAC = MIN(INDFAC, SPLIAI+1)
           SPAVAN = 0
           IF (INDIC.NE.-1) THEN

C - PAR GRADIENT CONJUGUE

              DO 210 ILIAC = AJLIAI+1,NBLIAC
                 LLIAC = ZI(JLIAC+ILIAC-1)

C --- CALCUL DE CHAQUE COLONNE DE AT (UNE PAR LIAISON ACTIVE)

                 CALL JEVEUO(JEXNUM(CM1A,LLIAC),'E',JCM1A)
                 DO 110 KK = 1,NEQ
                    ZR(JCM1A-1+KK) = 0.0D0
 110             CONTINUE
                 JDECAL = ZI(JAPPTR+LLIAC-1)
                 NBDDL = ZI(JAPPTR+LLIAC) - ZI(JAPPTR+LLIAC-1)
                 CALL CALATM(NEQ,NBDDL,1.D0,ZR(JAPCOE+JDECAL),
     &                                 ZI(JAPDDL+JDECAL),ZR(JCM1A))

C --- CALCUL DE C-1.AT (EN TENANT COMPTE DES CHARGES DIRICHLET)
                 CALL JACOPO(NEQ,'R',JCM1A,JCHSEC)
                 CALL RESOUD(MATASS,MATPRE,CHASEC,SOLVEU,CINE,'V',
     &                  CHASOL,'&&ALGOCO_CRIT')
                 CALL JEVEUO(CHASOL//'.VALE','L',JCHSOL)
                 CALL JACOPO(NEQ,'R',JCHSOL,JCM1A)

                 CALL JELIBE(JEXNUM(CM1A,LLIAC))

 210          CONTINUE

           ENDIF

        ELSE

C --- CALCUL DE -A.C-1.AT COLONNE PAR COLONNE (A PARTIR DE IDEBUC)

           SPAVAN = SPLIAI
           CALL CFACAT(NDIM, INDIC, NBLIAC, AJLIAI, SPLIAI, LLF, LLF1,
     +      LLF2,INDFAC,NESMAX,DEFICO,RESOCO, LMAT, CINE, NBLIAI,XJVMAX)

        ENDIF

C --- ELIMINATION DES PIVOTS NULS

        CALL ELPIV1(XJVMAX, INDIC, NBLIAC, AJLIAI, SPLIAI, SPAVAN,
     +                                            NOMA, DEFICO, RESOCO)

        IF (INDIC.EQ.-1) THEN
           GOTO 150
        ENDIF

C --- FACTORISATION LDLT DE -A.C-1.AT

C --- ATTENTION : SI ON RAJOUTE DES LIAISONS ON NE FACTORISE QUE
C --- LA PARTIE RAJOUTEE (LE RESTE EST ENCORE VALABLE, CF. PROPRIETES
C --- MAGIQUES DES FACTORISATIONS).
C --- SI ON ENLEVE LA DERNIERE LIAISON (IDEBUT > NBLIAC),PAS BESOIN DE
C --- REFACTORISER : L'INSTRUCTION ZI(LDSCON+2) = NBLIAC ECRITE PLUS
C --- LOIN FERA QUE RLDLGG PRENDRA LA BONNE TAILLE DE MATRICE, QUI
C --- EST DEJA FACTORISEE (SI ON REFACTORISAIT A PARTIR DE 1, ON
C --- FACTORISERAIT LA FACTORISEE, CE QUI EST GENANT, CAR FACTORISATION
C --- EN PLACE)

        CALL JEECRA(MACONT(1:19)//'.REFA','DOCU',IBID,'ASSE')
        IF (INDFAC.LE.NBLIAC) THEN
          CALL TLDLGG(2,LDSCON,INDFAC,NBLIAC,0,NDECI,ISINGU,NPVNEG,IER)

          INDFAC = NBLIAC + 1
C--- LA MATRICE DE CONTACT EST-ELLE SINGULIERE?

          IF (IER.GT.ISTO) THEN
            LICCVG(4) = 1
            CALL JEDETR('&&ALGOCO.TRAV')
            GO TO 212
          END IF
        END IF

C --- SECOND MEMBRE : ON MET JEU(DEPTOT) - A.DELT0 DANS MU
        CALL CFADU(RESOCO, K24BID, NEQ, NDIM, NBLIAC, LLF,
     +                                               LLF1, LLF2, NESMAX)
C --- RESOLUTION POUR OBTENIR MU : -A.C-1.AT.MU = JEU(DEPTOT) - A.DELT0

C ON TRUANDE LA SD MATR_ASSE POUR NE RESOUDRE LE SYSTEME QUE
C DE 1 A NBLIAC :

        NEQMAX = ZI(LDSCON+2)
        ZI(LDSCON+2) = NBLIAC
        CALL RLDLGG(LDSCON,ZR(JMU),CBID,1)
        ZI(LDSCON+2) = NEQMAX

        DO 70 KK = 1,NEQ
          ZR(JDELTA-1+KK) = ZR(JDELT0-1+KK) - ZR(JRESU-1+KK)
   70   CONTINUE

C ======================================================================
C --- CALCUL DE DELTA = DELT0 - C-1.AT.MU ------------------------------
C ======================================================================
         CALL CFMAJU(RESOCO, NEQ, NDIM, NBLIAI, NBLIAC, LLF, LLF1, LLF2)
      END IF

C ==============================
C CALCUL DE RHO ET MISE A JOUR
C DE L'ENSEMBLE DES LIAISONS
C ACTIVES + TEST DE CV
C ==============================

C --- CALCUL DE RHO = MIN ( (E(DEPTOT) - A.RESU)II / (A.DELTA)II) )
C --- SUR LES LIAISONS NON ACTIVES DE NUMERO II
      RHO = R8MAEM()
      DELPOS = .FALSE.

C -- SI TOUTES LES LIAISONS SONT ACTIVES : RHO = 1

      IF (NBLIAC.EQ.NBLIAI) THEN

        RHO = 1.D0

C -- S'IL Y A DES LIAISONS NON ACTIVES : CALCUL DE RHO

      ELSE IF (NBLIAC.LT.NBLIAI) THEN

        DO 112 II = 1,NBLIAI

          TROUAC = .FALSE.

C - LA LIAISON II EST-ELLE ACTIVE ? (-> TROUAC)

          DO 90 ILIAC = 1,NBLIAC
            IF (ZI(JLIAC-1+ILIAC).EQ.II) TROUAC = .TRUE.
   90     CONTINUE

C - CALCUL DE A.DELTA SI LA LIAISON II N'EST PAS ACTIVE

          IF (.NOT.TROUAC) THEN
            JDECAL = ZI(JAPPTR+II-1)
            NBDDL = ZI(JAPPTR+II) - ZI(JAPPTR+II-1)
            CALL CALADU(NEQ,NBDDL,ZR(JAPCOE+JDECAL),ZI(JAPDDL+JDECAL),
     &                  ZR(JDELTA),AADELT)

C - SI A.DELTA EST POSITIF POUR II : CALCUL DE E(DEPTOT) - A.RESU
C - RHO = MIN ( ( E(DEPTOT) - A.RESU )II / (A.DELTA)II )
C - ON STOCKE DANS LLMIN LE NUMERO DE LA LIAISON REALISANT LE
C - MINIMUM (CE SERA LA LIAISON LA PLUS VIOLEE)

            IF (AADELT.GT.R8PREM()) THEN

C -  ON NE PREND PAS EN COMPTE UNE LIAISON A PIVOT NUL

              DO 100 IOTE = 1,ZI(JLIOT+4*NBLIAI)
                IF (ZI(JLIOT-1+IOTE).EQ.II) GO TO 112
  100         CONTINUE

C -  FIN ELIMINATION LIAISON A PIVOT NUL

              DELPOS = .TRUE.
              CALL CALADU(NEQ,NBDDL,ZR(JAPCOE+JDECAL),ZI(JAPDDL+JDECAL),
     &                    ZR(JRESU),VAL)
              AJEU = ZR(JAPJEU+II-1) - VAL
              AJEU = AJEU/AADELT
              IF (AJEU.LT.RHO) THEN
                RHO = AJEU
                LLMIN = II
              END IF
            END IF

          END IF

  112   CONTINUE

C - SI TOUS LES (A.DELTA)II SONT NEGATIFS : RHO = 1

        IF (.NOT.DELPOS) THEN
          RHO = 1.0D0
        END IF

      END IF

C --- TESTS SUR RHO ET ACTUALISATION DE RESU

      RHORHO = MIN(RHO,1.D0)

      DO 120 KK = 1,NEQ
        ZR(JRESU-1+KK) = ZR(JRESU-1+KK) + RHORHO*ZR(JDELTA-1+KK)
  120 CONTINUE

C -- SI RHO < 1 (AU MOINS UNE LIAISON SUPPOSEE NON ACTIVE EST VIOLEE) :
C -- ON AJOUTE A L'ENSEMBLE DES LIAISONS ACTIVES LA PLUS VIOLEE (LLMIN)

      IF (RHO.LT.1.0D0) THEN

        POSIT = NBLIAC + 1
        CALL CFTABL( INDIC, NBLIAC, AJLIAI, SPLIAI, LLF, LLF1, LLF2,
     +                             RESOCO, TYPEAJ, POSIT, LLMIN, TYPEC0)
        IF (NIV.EQ.2) WRITE (IFM,*) 'LIAISON ACTIVEE',LLMIN
        IF (NIV.GE.2) THEN
          POS1 = ZI(JAPPAR+3* (LLMIN-1)+1)
          NUM1 = ZI(JNOCO+ABS(POS1)-1)
          CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',NUM1),NOM1)
          POS2 = ZI(JAPPAR+3* (LLMIN-1)+2)
          IF (POS2.GT.0) THEN
            CHAIN = ' A  LA MAILLE '
            NUM2 = ZI(JMACO+POS2-1)
            CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',NUM2),NOM2)
          ELSE IF (POS2.LT.0) THEN
            CHAIN = ' AU NOEUD     '
            NUM2 = ZI(JNOCO+ABS(POS2)-1)
            CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',NUM2),NOM2)
          ELSE IF (POS2.EQ.0) THEN
            CHAIN = ' '
            NOM2 = ' '
          END IF
          WRITE (IFM,1000) 'LE NOEUD ',NOM1,' EST ASSOCIE  ',CHAIN,NOM2
        END IF

      ELSE

C -- SI RHO > 1 OU RHO = 1

C - SI PAS DE LIAISONS ACTIVES -> ON A CONVERGE (IL N'Y A PAS CONTACT)

        IF (NBLIAC.EQ.0) GO TO 160

        RMINMU = R8MAEM()
        DO 130 ILIAC = 1,NBLIAC
          ZR(JMU+ILIAC-1) = ZR(JCMU+ILIAC-1)*ZR(JMU+ILIAC-1)
          IF (RMINMU.GT.ZR(JMU-1+ILIAC)) THEN
            RMINMU = ZR(JMU-1+ILIAC)
            KKMIN = ILIAC
          END IF
  130   CONTINUE

C - SI TOUS LES MU SONT > 0 -> ON A CONVERGE (IL Y A CONTACT)

        IF (RMINMU.GE.0.0D0) GO TO 160

C - SINON ON ENLEVE LA LIAISON KKMIN AYANT LE MU LE PLUS NEGATIF
C - ET ON DECALE LA LISTE DES LIAISONS ACTIVES

        IF (NIV.GE.2) THEN
          LLIAC = ZI(JLIAC-1+KKMIN)
          POS1 = ZI(JAPPAR+3* (LLIAC-1)+1)
          NUM1 = ZI(JNOCO+ABS(POS1)-1)
          CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',NUM1),NOM1)
          POS2 = ZI(JAPPAR+3* (LLIAC-1)+2)
          IF (POS2.GT.0) THEN
            CHAIN = ' DE LA MAILLE '
            NUM2 = ZI(JMACO+POS2-1)
            CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',NUM2),NOM2)
          ELSE IF (POS2.LT.0) THEN
            CHAIN = ' DU NOEUD     '
            NUM2 = ZI(JNOCO+ABS(POS2)-1)
            CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',NUM2),NOM2)
          ELSE IF (POS2.EQ.0) THEN
            CHAIN = ' '
            NOM2 = ' '
          END IF
          WRITE (IFM,1000) 'LE NOEUD ',NOM1,' EST DISSOCIE ',CHAIN,NOM2
        END IF

        IF (NIV.EQ.2) WRITE (IFM,*) 'LIAISON DESACTIVEE',
     &      ZI(JLIAC-1+KKMIN)

        LLIAC = ZI(JLIAC-1+KKMIN)
        CALL CFTABL(INDIC,NBLIAC,AJLIAI,SPLIAI,LLF,LLF1,LLF2,
     +                                 RESOCO,TYPESP,KKMIN,LLIAC,TYPEC0)

      END IF

C ON PASSE A L'ITERATION DE CONTRAINTES ACTIVES SUIVANTES

  150 CONTINUE
      ITER = ITER + 1


C A-T-ON DEPASSE LE NOMBRE D'ITERATIONS DE CONTACT AUTORISE

      IF (ITER.GT.2*NBLIAI+1) THEN
        LICCVG(3) = 1
        CALL JEDETR('&&ALGOCO.TRAV')
        GO TO 212
      END IF

      GO TO 40

C ======================================================================
C                            ON A CONVERGE
C ======================================================================

  160 CONTINUE


C --- VALEUR DES VARIABLES DE CONVERGENCE

      LICCVG(3) = 0
      LICCVG(4) = 0


C --- CALCUL DE AT.MU

      DO 170 KK = 1,NEQ
        ZR(JATMU+KK-1) = 0.0D0
  170 CONTINUE

C ======================================================================
C --- CALCUL DE AT.MU --------------------------------------------------
C ======================================================================
      CALL CFATMU(NEQ , NESMAX, NDIM, NBLIAC, LLF, LLF1, LLF2, RESOCO)

C --- CALCUL DU JEU FINAL A CONVERGENCE DES CONTRAINTES ACTIVES

      DO 200 II = 1,NBLIAI
        INDICL = 0
        DO 190 ILIAC = 1,NBLIAC
          LLIAC = ZI(JLIAC+ILIAC-1)
          IF (LLIAC.EQ.II) INDICL = 1
  190   CONTINUE
        JDECAL = ZI(JAPPTR+II-1)
        NBDDL = ZI(JAPPTR+II) - ZI(JAPPTR+II-1)
        CALL CALADU(NEQ,NBDDL,ZR(JAPCOE+JDECAL),ZI(JAPDDL+JDECAL),
     &              ZR(JRESU),VAL)
        ZR(JAPJEU-1+II) = ZR(JAPJEU-1+II) - VAL
        IF (NIV.GE.2) THEN
          IF (INDICL.EQ.1) THEN
            WRITE (IFM,1010) ' JEU FINAL LIAISON ACTIVE',II,' : ',
     &        ZR(JAPJEU+II-1)
          ELSE
            WRITE (IFM,1010) ' JEU FINAL LIAISON LIBRE',II,' : ',
     &        ZR(JAPJEU+II-1)
          END IF
        END IF
  200 CONTINUE

      ZI(JCOCO+2) = NBLIAC 

      CALL JEDETR('&&ALGOCO.TRAV')

 1000 FORMAT ('<CONTACT_2> ',A9,A8,A14,A14,A8)
 1010 FORMAT ('<CONTACT_3> ',A27,I5,A3,E10.3)

  212 CONTINUE

      CALL DETRSD('CHAMP_GD','&&ALGOCO.CHASOL')
      CALL DETRSD('CHAMP_GD','&&ALGOCO.CHASEC')
      CALL JEDEMA()

C ======================================================================

      END
