      SUBROUTINE ALGOCP(DEFICO,RESOCO,LMAT,LDSCON,
     &           RESU,DEPTOT,LREAC,DEPDEL)
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
      IMPLICIT      NONE
      LOGICAL       LREAC(4)
      INTEGER       LMAT,LDSCON
      CHARACTER*24  DEFICO,RESOCO,RESU,DEPTOT,DEPDEL
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : NMCONT
C ----------------------------------------------------------------------
C
C METHODE PENALISEE POUR LE CONTACT UNILATERAL.
C
C RESOLUTION DE : C.DU + k ATA.DU  = F- k ATA(E-U)
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
C IN  DEPTOT  : DEPLACEMENT TOTAL OBTENU A L'ISSUE DE L'ITERATION
C               DE NEWTON PRECEDENTE
C VAR RESU    : INCREMENT "DDEPLA" DE DEPLACEMENT DEPUIS DEPTOT
C                 EN ENTREE : SOLUTION OBTENUE SANS TRAITER LE CONTACT
C                 EN SORTIE : SOLUTION CORRIGEE PAR LE CONTACT
C
C ON UTILISE UNIQUEMENT LE VECTEUR AFMU CAR LES DONNEES DE ATMU SONT
C NECESSAIRE POUR LE CALCUL DE LA MATRICE TANGENTE QUI SE FAIT
C A L'AIDE DU VECTEUR AFMU
C
C --------------- DEBUT DECLARATIONS NORMALISEES JEVEUX ---------------
C
      CHARACTER*32       JEXNUM , JEXNOM
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
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      LOGICAL      TROUAC,DELPOS
      INTEGER      IBID,IER,IFM,NIV,ICONTA,II,JJ,KK
      INTEGER      JRESU,JDEPP,JMU,JATMU,JAFMU,POSMA,NEQMAX
      INTEGER      JDEPDE,JDELT0,JDELTA,JLIAC,JCOCO,JCM1A
      INTEGER      NEQ,NESCL,NBLIAC,NBLIAI,NBLCIN,KKMIN,LLMIN
      INTEGER      POS1,POS2,NUM1,NUM2,JDECAL,NBDDL,IPENA
      INTEGER      JAPPAR,JAPPTR,JAPCOE,JAPJEU,JAPDDL,JNOCO,JMACO
      INTEGER      AJLIAI, SPLIAI, LLF, LLF1, LLF2, POSIT, INDIC
      REAL*8       AJEU,VAL,XMU
      COMPLEX*16   CBID
      CHARACTER*1  TYPEAJ
      CHARACTER*2  TYPEC0
      CHARACTER*8  NOM1,NOM2
      CHARACTER*14 CHAIN,NUMEDD
      CHARACTER*19 AFMU,MAT,CM1A,MAFROT
      CHARACTER*19 LIAC,MU,ATMU,DELT0,DELTA,COCO
      CHARACTER*24 APPARI,APPOIN,APCOEF,APJEU,APDDL
      CHARACTER*24 MACONT,CONTNO,CONTMA,PENAL
C
C ----------------------------------------------------------------------
C
C ======================================================================
C             INITIALISATIONS DES OBJETS ET DES ADRESSES
C ======================================================================
C
C U      : DEPTOT + RESU+
C DEPTOT : DEPLACEMENT TOTAL OBTENU A L'ISSUE DE L'ITERATION DE NEWTON
C          PRECEDENTE. C'EST U/I/N.
C RESU   : INCREMENT DEPUIS DEPTOT 
C          C'EST DU/K OU DU/K+1.
C DELTA  : INCREMENT DONNE PAR CHAQUE ITERATION DE CONTRAINTES ACTIVES.
C          C'EST D/K+1.
C DELT0  : INCREMENT DE DEPLACEMENT DEPUIS LA DERNIERE ITERATION DE
C          NEWTON SANS TRAITER LE CONTACT. C'EST C-1.F.
C
      CALL INFNIV (IFM,NIV)
      CALL JEMARQ ()
C
C --- LE CONTACT DOIT-IL ETRE MODELISE ?
C
      APPARI = RESOCO(1:14)//'.APPARI'
      CALL JEEXIN (APPARI,ICONTA)
      IF (ICONTA.EQ.0) GO TO 99999
      CALL JEVEUO (APPARI,'L',JAPPAR)
      NESCL = ZI(JAPPAR)
C
C --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
C
C LIAC   : LISTE DES INDICES DES LIAISONS ACTIVES
C MU     : MULTIPLICATEURS DE LAGRANGE DU CONTACT (DOIVENT ETRE > 0)
C COEFMU : COEFFICIENT PAR LEQUEL IL FAUT MULTIPLIER MU AVANT DE
C          TESTER SON SIGNE (-1 SI CONDITION EN PRESSION OU TEMPERATURE)
C ATMU   : FORCES DE CONTACT
C CM1A   : C-1.AT AVEC C MATRICE DE RIGIDITE TANGENTE,
C          ET A MATRICE DE CONTACT (AT SA TRANSPOSEE)
C
      CONTNO   = DEFICO(1:16)//'.NOEUCO'
      CONTMA   = DEFICO(1:16)//'.MAILCO'
      APPARI   = RESOCO(1:14)//'.APPARI'
      APPOIN   = RESOCO(1:14)//'.APPOIN'
      APCOEF   = RESOCO(1:14)//'.APCOEF'
      APJEU    = RESOCO(1:14)//'.APJEU'
      APDDL    = RESOCO(1:14)//'.APDDL'
      LIAC     = RESOCO(1:14)//'.LIAC'
      MU       = RESOCO(1:14)//'.MU'
      ATMU     = RESOCO(1:14)//'.ATMU'
      AFMU     = RESOCO(1:14)//'.AFMU'
      DELT0    = RESOCO(1:14)//'.DEL0'
      DELTA    = RESOCO(1:14)//'.DELT'
      CM1A     = RESOCO(1:14)//'.CM1A'
      MAFROT   = RESOCO(1:8)//'.MAFR'
      PENAL    = DEFICO(1:16)//'.PENAL'
C
      CALL JEVEUO (CONTNO,'L',JNOCO)
      CALL JEVEUO (CONTMA,'L',JMACO)
      CALL JEVEUO (APPARI,'L',JAPPAR)
      CALL JEVEUO (APPOIN,'L',JAPPTR)
      CALL JEVEUO (APCOEF,'L',JAPCOE)
      CALL JEVEUO (APJEU, 'E',JAPJEU)
      CALL JEVEUO (APDDL, 'L',JAPDDL)
      CALL JEVEUO (LIAC,  'E',JLIAC)
      CALL JEVEUO (MU,    'E',JMU)
      CALL JEVEUO (ATMU,  'E',JATMU)
      CALL JEVEUO (AFMU , 'E',JAFMU)
      CALL JEVEUO (DELT0, 'E',JDELT0)
      CALL JEVEUO (DELTA, 'E',JDELTA)
      CALL JEVEUO (RESU(1:19)//'.VALE'  ,'L',JRESU)
      CALL JEVEUO (DEPTOT(1:19)//'.VALE','L',JDEPP)
      CALL JEVEUO (DEPDEL(1:19)//'.VALE', 'L', JDEPDE)
      CALL JEVEUO (PENAL,'L',IPENA)
C
      NBLIAI = NESCL
C
      MACONT = ZK24(ZI(LDSCON+1))
      CALL JEECRA (MACONT(1:19)//'.REFA','DOCU',IBID,'ASSE')
      NEQ = ZI(LMAT+2)
      MAT = ZK24(ZI(LMAT+1))
      CALL DISMOI ('F','NOM_NUME_DDL',MAT,'MATR_ASSE',IBID,NUMEDD,IER)
C
C --- SOUVENIRS DE L'ETAT DE CONTACT -> ON NE PEUT PAS S'EN SERVIR
C --- AU DEBUT CAR SI ON A REAPPARIE LES LIAISONS SONT DIFFERENTES
C
C NBLIAC : NOMBRE DE LIAISONS ACTIVES
C LLMIN  : NUMERO DE LA LIAISON LA PLUS "VIOLEE"
C KKMIN  : NUMERO DE LA LIAISON LA PLUS "DECOLLEE"
C
      COCO   = RESOCO(1:14)//'.COCO'
      CALL JEVEUO (COCO,'E',JCOCO)
      NBLIAC = ZI(JCOCO+2)
      AJLIAI = 0
      SPLIAI = 0
      INDIC  = 0
      LLF    = 0
      LLF1   = 0
      LLF2   = 0
      TYPEAJ = 'A'
      TYPEC0 = 'C0'
C
C ======================================================================
C                             INITIALISATIONS
C ======================================================================
C
C --- CREATION DE DELTA = C-1B
C
      DO 1 II = 1, NEQ
         ZR(JATMU+II-1)  = 0.0D0
         ZR(JAFMU+II-1)  = 0.0D0
         ZR(JDELT0-1+II) = ZR(JRESU-1+II)
         ZR(JDELTA-1+II) = ZR(JRESU-1+II)+ZR(JDEPDE-1+II)
 1    CONTINUE
C
C --- CALCUL DE -A.DEPTOT ET RANGEMENT DANS APJEU
C --- (UNIQUEMENT POUR LES CL SANS APPARIEMENT,
C --- C'EST-A-DIRE POUR P, T, OU U RIGIDE : LORSQUE POSMA = 0)
C
      DO 2 II = 1,NBLIAI
         POSMA = ZI(JAPPAR+3*(II-1)+2)
         IF (POSMA.EQ.0) THEN
            JDECAL = ZI(JAPPTR+II-1)
            NBDDL  = ZI(JAPPTR+II) - ZI(JAPPTR+II-1)
            CALL CALADU (NEQ,NBDDL,ZR(JAPCOE+JDECAL),
     &           ZI(JAPDDL+JDECAL),ZR(JDEPP),VAL)
            ZR(JAPJEU+II-1) = ZR(JAPJEU+II-1) - VAL
         END IF
 2    CONTINUE
C
C ======================================================================
C ======================================================================
C      
      NBLCIN = NBLIAC
      IF ( NIV .EQ. 2 ) WRITE(IFM,*)'NBLIACI',NBLCIN
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
C --- RECUPERATION DES JEUX NEGATIFS ET CREATION DU SECOND
C --- MEMBRE -E_N*AT*JEU
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
      NBLIAC = 0
      DO 50 II = 1,NBLIAI
         ZR(JMU-1+II) = 0.0D0
         JDECAL = ZI(JAPPTR+II-1)
         NBDDL  = ZI(JAPPTR+II) - ZI(JAPPTR+II-1)
         CALL CALADU (NEQ,NBDDL,ZR(JAPCOE+JDECAL),
     &                ZI(JAPDDL+JDECAL),ZR(JDELT0),VAL)
         ZR(JAPJEU+II-1) = ZR(JAPJEU+II-1) - VAL
         CALL JEVEUO ( JEXNUM(CM1A,II), 'E', JCM1A )
         DO 20 KK = 1, NEQ
            ZR(JCM1A-1+KK) = 0.0D0
 20      CONTINUE
         IF ( ZR(JAPJEU+II-1).LT.0.0D0 ) THEN
            POSIT  = NBLIAC + 1 
            CALL CFTABL(INDIC,NBLIAC,AJLIAI,SPLIAI,LLF,LLF1,LLF2, 
     +                                   RESOCO,TYPEAJ,POSIT,II,TYPEC0) 
            XMU    = 1.D0
            CALL CALATM (NEQ,NBDDL,XMU,ZR(JAPCOE+JDECAL),
     &                                ZI(JAPDDL+JDECAL),ZR(JCM1A))
            ZR(JMU-1+NBLIAC) = -ZR(JAPJEU+II-1)*ZR(IPENA-1+2*II-1)
            CALL R8AXPY(NEQ,ZR(JMU-1+NBLIAC),ZR(JCM1A),1,ZR(JAFMU),1) 
         ENDIF
         CALL JELIBE(JEXNUM(CM1A,II))
 50   CONTINUE
      IF (NBLIAC.EQ.0) GOTO 99999
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
C --- CREATION DE E_N*ATA 
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      DO 210 II = 1, NBLIAI
         CALL JEVEUO ( JEXNUM(CM1A,II), 'E', JCM1A )
         DO 200 KK = 1, NEQ
            ZR(JCM1A-1+KK) = 0.0D0
 200     CONTINUE
         IF ( ZR(JAPJEU+II-1).LT.0.0D0 ) THEN
            JDECAL = ZI(JAPPTR+II-1)
            NBDDL  = ZI(JAPPTR+II)-ZI(JAPPTR+II-1)
            XMU  = SQRT(ZR(IPENA-1+2*II-1))
               CALL CALATM (NEQ,NBDDL,XMU,ZR(JAPCOE+JDECAL),
     &                      ZI(JAPDDL+JDECAL),ZR(JCM1A))
         ENDIF
         CALL JELIBE(JEXNUM(CM1A,II))
 210  CONTINUE
C
      CALL ATA000 (CM1A,NUMEDD,400.D0,MAFROT,'V',RESOCO,NBLIAI)
      CALL DETRSD ('MATR_ASSE', MAT   )
C
C --- STOCKAGE DE L'ETAT DE CONTACT DEFINITIF
C
      IF ( NIV .EQ. 2 ) WRITE(IFM,*)'NBLIACF',NBLIAC
      IF ( NIV .EQ. 2 ) WRITE(IFM,*)'NBLIACI',NBLCIN
C
      IF ( NBLIAC.NE.NBLCIN ) LREAC(2) = .TRUE.
C
      ZI(JCOCO+2) = NBLIAC
C
      IF (NIV.GE.2) THEN
         DO 500 II = 1,NBLIAI
            WRITE (IFM,1010) '<FROPGD> JEU FINAL LIAISON ',II,' : ',
     &           ZR(JAPJEU+II-1)
 500     CONTINUE
      END IF
C
99999 CONTINUE
      CALL JEDEMA ()
C
C ======================================================================
C
 1000 FORMAT ('<CONTACT_2> ',A9,A8,A14,A14,A8)
 1010 FORMAT ('<CONTACT_3> ',A27,I5,A3,E10.3)
C
      END
