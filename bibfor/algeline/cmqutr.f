      SUBROUTINE CMQUTR ( BASZ, NOMAIN, NOMAOU, NBMA, NUMMAI, PREFIX,
     +                    NDINIT )
      IMPLICIT   NONE
      INTEGER             NBMA, NUMMAI(*), NDINIT
      CHARACTER*8         NOMAIN, NOMAOU, PREFIX
      CHARACTER*(*)       BASZ
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 14/09/2004   AUTEUR MCOURTOI M.COURTOIS 
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
C     OPTION = 'QUAD_TRIA3' 
C
C     ------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER         ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8          ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16      ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL         ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8     ZK8
      CHARACTER*16            ZK16
      CHARACTER*24                     ZK24
      CHARACTER*32                              ZK32
      CHARACTER*80                                       ZK80
      COMMON /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
      CHARACTER*32 JEXNUM,JEXNOM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER      I, IMA, NBMAT, NBMAIL, TYPTRI, NBTRI, IRET, NBGRNO,
     +             NBNOMX, NBPT, INO, IMA2, IMAV, IATYMA, JREFE, JVG,
     +             JTYPM, JDIME, JOPT, JNPT, NBNO, IER, JGG, IM, J, 
     +             LGPREF, LXLGUT, LGND, NBMAG, NBGRM,
     +             IFM, NIV, IQ4, IQ8, IQ9, IGRMA, NBGM, JLGRMA, JGRMA,
     +             NBMA2, JDEC, IG, IND
      LOGICAL      LOGIC
      CHARACTER*1  K1B, BASE
      CHARACTER*8  K8B, NOMG, TYPM, NIMA
      CHARACTER*16 KNUME
      CHARACTER*24 NOMMAI, TYPMAI, CONNEX, NODIME, NOMNOE, GRPNOE,
     &             COOVAL, COODSC, COOREF, GRPMAI
      CHARACTER*24 TYPMAV, CONNEV, NODIMV, NOMNOV, GRPNOV, 
     &             COOVAV, COODSV, COOREV, NOMMAV, GRPMAV
      INTEGER     VERSIO
      PARAMETER ( VERSIO = 1 )
C  --- TABLEAU DE DECOUPAGE
      INTEGER    NTYELE,MAXEL,MAXNO
      PARAMETER (NTYELE = 27)
      PARAMETER (MAXEL  = 48)
      PARAMETER (MAXNO  =  8)
      INTEGER             TDEC(NTYELE,MAXEL,MAXNO)
      INTEGER                   TYPD(NTYELE,3)
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFNIV(IFM,NIV)
C
C====
C 1. TABLEAU DE DECOUPAGE
C====
C
      CALL IRGMTB(TDEC,TYPD,VERSIO)
C
C====
C 2. INITIALISATIONS DES NOMS D'OBJETS
C====
C
      BASE = BASZ
C
      NOMMAV = NOMAIN//'.NOMMAI         '
      NOMNOV = NOMAIN//'.NOMNOE         '
      TYPMAV = NOMAIN//'.TYPMAIL        '
      CONNEV = NOMAIN//'.CONNEX         '
      GRPNOV = NOMAIN//'.GROUPENO       '
      GRPMAV = NOMAIN//'.GROUPEMA       '
      NODIMV = NOMAIN//'.DIME           '
      COOVAV = NOMAIN//'.COORDO    .VALE'
      COODSV = NOMAIN//'.COORDO    .DESC'
      COOREV = NOMAIN//'.COORDO    .REFE'
C
      NOMMAI = NOMAOU//'.NOMMAI         '
      NOMNOE = NOMAOU//'.NOMNOE         '
      TYPMAI = NOMAOU//'.TYPMAIL        '
      CONNEX = NOMAOU//'.CONNEX         '
      GRPNOE = NOMAOU//'.GROUPENO       '
      GRPMAI = NOMAOU//'.GROUPEMA       '
      NODIME = NOMAOU//'.DIME           '
      COOVAL = NOMAOU//'.COORDO    .VALE'
      COODSC = NOMAOU//'.COORDO    .DESC'
      COOREF = NOMAOU//'.COORDO    .REFE'
C
      CALL JEVEUO ( TYPMAV, 'L', JTYPM )
      CALL JEVEUO ( NODIMV, 'L', JDIME )
C
C====
C 3. DIMENSIONNEMENT DU MAILLAGE RESULTAT
C    NBRE DE TRIANGLES A CREER
C====
C
C  NBMAT  : NB DE MAILLES DU MAILLAGE INITIAL
C  NBMA   : NB DE MAILLES POTENTIELLEMENT A DECOUPER
C  NBMAIL : NB DE MAILLES EN SORTIE DONT NBTRI TRIA3 CREES
      NBMAT = ZI(JDIME+3-1)
C  --- VECTEUR A_DECOUPER_EN(NUM_MAILLE) = 0 OU N TRIA3 A CREER
      CALL WKVECT('&&CMQUTR.A_DECOUPER_EN  ', 'V V I', NBMAT, JDEC)
C
      LOGIC = .FALSE.
      NBTRI = 0
C
      IQ4 = 0
      IQ8 = 0
      IQ9 = 0
      NBMAIL = NBMAT
      DO 10 IM = 1 , NBMA
         IMA = NUMMAI(IM)
C
         CALL JENUNO (JEXNUM('&CATA.TM.NOMTM',ZI(JTYPM+IMA-1)),TYPM)
C
         IF (TYPM .EQ. 'QUAD4') THEN
            NBMAIL =  NBMAIL- 1
            NBTRI = NBTRI + 2
            IQ4 = IQ4 + 1
            ZI(JDEC-1+IMA) = 2
C
         ELSE IF (TYPM .EQ. 'QUAD8') THEN
            NBMAIL =  NBMAIL- 1
            NBTRI = NBTRI + 6
            IQ8 = IQ8 + 1
            ZI(JDEC-1+IMA) = 6
C
         ELSE IF (TYPM .EQ. 'QUAD9') THEN
            NBMAIL =  NBMAIL- 1
            NBTRI = NBTRI + 6
            IQ9 = IQ9 + 1
            ZI(JDEC-1+IMA) = 6
         ENDIF
 10   CONTINUE
C
      IF ( NIV .GE. 1 ) THEN
         WRITE(IFM,1000) 1
         IF ( IQ4 .NE. 0 ) WRITE(IFM,1002) IQ4, 'QUAD4', 2*IQ4, 'TRIA3'
         IF ( IQ8 .NE. 0 ) WRITE(IFM,1002) IQ8, 'QUAD8', 6*IQ8, 'TRIA3'
         IF ( IQ9 .NE. 0 ) WRITE(IFM,1002) IQ9, 'QUAD9', 6*IQ9, 'TRIA3'
      ENDIF
C
      NBMAIL = NBMAIL + NBTRI
C
      CALL JEDUPO ( NODIMV, BASE, NODIME, LOGIC )
      CALL JEDUPO ( NOMNOV, BASE, NOMNOE, LOGIC )
      CALL JEDUPO ( COOVAV, BASE, COOVAL, LOGIC )
      CALL JEDUPO ( COODSV, BASE, COODSC, LOGIC )
      CALL JEDUPO ( COOREV, BASE, COOREF, LOGIC )
C
      CALL JEVEUO ( COOREF, 'E', JREFE )
      ZK24(JREFE) = NOMAOU
C
      CALL JEVEUO ( NODIME, 'E', JDIME )
      ZI(JDIME+3-1) = NBMAIL
C
C====
C 4. CREATION DE SD DU MAILLAGE RESULTAT
C====
C
C 4.1. ==> CREATION DU .NOMMAI ET DU .CONNEX
C
      CALL JENONU ( JEXNOM('&CATA.TM.NOMTM', 'TRIA3'  ), TYPTRI )

      CALL JECREO ( NOMMAI, BASE//' N K8' )
      CALL JEECRA ( NOMMAI, 'NOMMAX', NBMAIL, ' ' )

      CALL WKVECT ( TYPMAI, BASE//' V I', NBMAIL, IATYMA )

C     NBNOMX = NBRE DE NOEUDS MAX. POUR UNE MAILLE :
      CALL DISMOI('F','NB_NO_MAX','&CATA','CATALOGUE',NBNOMX,K1B,IER)

      CALL JECREC ( CONNEX, BASE//' V I', 'NU', 'CONTIG', 'VARIABLE',
     +                                                    NBMAIL )
      CALL JEECRA ( CONNEX, 'LONT', NBNOMX*NBMAIL, ' ' )
C
C 4.2. ==> LE .GROUPMA EST CREE ICI,
C          LES GROUPES EUX-MEMES SERONT REMPLIS A LA VOLEE
C
      CALL JEEXIN ( GRPMAV, IGRMA )
      IF ( IGRMA .NE. 0 ) THEN
         CALL JELIRA ( GRPMAV, 'NOMUTI', NBGRM, K1B )
         CALL JECREC ( GRPMAI, BASE//' V I', 'NO', 'DISPERSE',
     +                 'VARIABLE', NBGRM )
C     --- BCLE SUR LES GROUP_MA DU MAILLAGE INITIAL
         DO 421 I = 1, NBGRM
            CALL JENUNO( JEXNUM(GRPMAV, I), NOMG)
            CALL JEVEUO( JEXNUM(GRPMAV, I), 'L', JGRMA)
            CALL JELIRA( JEXNUM(GRPMAV, I), 'LONMAX', NBMAG, K1B)
            NBMA2 = NBMAG
C        --- BCLE SUR LES MAILLES DU GROUP_MA
            DO 4210 J = 1, NBMAG
               IM = ZI(JGRMA-1+J)
               IF (ZI(JDEC-1+IM).NE.0) THEN
                  NBMA2 = NBMA2 - 1 + ZI(JDEC-1+IM)
               ENDIF
 4210       CONTINUE
            CALL JECROC( JEXNOM(GRPMAI, NOMG))
C        --- LE NOUVEAU GROUP_MA CONTIENDRA NBMA2 MAILLES
            CALL JEECRA( JEXNOM(GRPMAI, NOMG), 'LONMAX', NBMA2, ' ')
            CALL JEECRA( JEXNOM(GRPMAI, NOMG), 'LONUTI', 0, ' ')
            IF ( NIV.GT.1 ) THEN
               WRITE(IFM,*) 'GROUP_MA '//NOMG,' (',I,') PASSE DE ',
     &                      NBMAG,' A ',NBMA2,' MAILLES'
            ENDIF
 421     CONTINUE
C     --- VECTEUR POUR STOCKER TEMPORAIREMENT LA LISTE DES GROUP_MA
C         D'UNE MAILLE
         CALL WKVECT('&&CMQUTR.LISTE_GROUP_MA ', 'V V I', NBMAG, JLGRMA)
      ENDIF
C
C====
C 5. ON PARCOURT LES MAILLES DU MAILLAGE INITIAL
C====
C
      LGPREF = LXLGUT(PREFIX)
      IMAV  = NDINIT - 1
C
      DO 500 IMA = 1 , NBMAT
C
         IND = ZI(JTYPM+IMA-1)
         CALL JENUNO ( JEXNUM('&CATA.TM.NOMTM',IND), TYPM )
         CALL JEVEUO ( JEXNUM(CONNEV,IMA), 'L', JOPT )
         CALL JELIRA ( JEXNUM(CONNEV,IMA), 'LONMAX', NBPT, K1B )
C
C 5.0. ==> PREPARE LA MISE DES GROUPES DE MAILLES
C
         CALL JENUNO ( JEXNUM(NOMMAV,IMA), NIMA )
         IF ( IGRMA.NE.0 ) THEN
C        --- GROUP_MA CONTENANT IMA
            CALL INGRMA(NOMAIN, NIMA, ZI(JLGRMA), NBGM, IER)
         ENDIF
C
C 5.1. ==> ON REGARDE SI LA MAILLE IMA DOIT ETRE DECOUPEE...
C
         IF ( ZI(JDEC-1+IMA) .EQ. 0 ) THEN
C
C 5.2. ==> ON CONSERVE LA MAILLE IMA TELLE QUELLE*
C          CAR IMA N'EST PAS DANS NUMMAI()
C
            CALL JEEXIN ( JEXNOM(NOMMAI,NIMA), IRET )
            IF (IRET.EQ.0) THEN
               CALL JECROC(JEXNOM(NOMMAI,NIMA))
            ELSE
               CALL UTDEBM('F','CMQUTR','ERREUR DONNEES')
               CALL UTIMPK('L','MAILLE DEJA EXISTANTE : ',1,NIMA)
               CALL UTFINM
            END IF
C
C 5.2.1. ==> TYPE DE MAILLE ET CONNECTIVITE
C
            CALL JENONU ( JEXNOM(NOMMAI,NIMA), IMA2 )
            ZI(IATYMA-1+IMA2) = ZI(JTYPM+IMA-1)

            CALL JEECRA(JEXNUM(CONNEX,IMA2),'LONMAX',NBPT,K8B)
            CALL JEVEUO(JEXNUM(CONNEX,IMA2),'E',JNPT)
            DO 521 INO = 1 , NBPT
               ZI(JNPT-1+INO) = ZI(JOPT+INO-1)
 521        CONTINUE
C
C 5.2.2. ==> MISE DES GROUPES DE MAILLES
C
            IF ( IGRMA.NE.0 .AND. IER.EQ.0 .AND. NBGM.GT.0) THEN
               DO 522 I = 1, NBGM
                  IG = ZI(JLGRMA-1+I)
                  CALL JEVEUO( JEXNUM(GRPMAI, IG), 'E', JGRMA)
                  CALL JELIRA( JEXNUM(GRPMAI, IG), 'LONUTI', IM, K1B )
                  IM = IM + 1
C                  print *,'GROUP_MA ',IG,' : ',IM,' MAILLES'
                  ZI(JGRMA-1+IM) = IMA2
                  CALL JEECRA( JEXNUM(GRPMAI, IG), 'LONUTI', IM, K1B )
 522           CONTINUE
            ENDIF
C
C 5.3. ==> LA MAILLE IMA DOIT ETRE DECOUPE
C
         ELSE
C
            NBPT = 3
            NBTRI = ZI(JDEC-1+IMA)
            DO 530 I = 1 , NBTRI
               IMAV = IMAV + 1
               CALL CODENT ( IMAV, 'G', KNUME )
               LGND = LXLGUT(KNUME)
               IF (LGND+LGPREF.GT.8)
     &            CALL UTMESS('F','CMQUTR','PREF_MAILLE EST '//
     &                        'TROP LONG OU PREF_NUME EST TROP GRAND')
               NOMG = PREFIX(1:LGPREF)//KNUME
               CALL JEEXIN ( JEXNOM(NOMMAI,NOMG), IRET )
               IF (IRET.EQ.0) THEN
                   CALL JECROC(JEXNOM(NOMMAI,NOMG))
               ELSE
                  CALL UTDEBM('F','CMQUTR','ERREUR DONNEES')
                  CALL UTIMPK('L','MAILLE DEJA EXISTANTE : ',1,NOMG)
                  CALL UTFINM
               ENDIF
C
               CALL JENONU ( JEXNOM(NOMMAI,NOMG), IMA2 )
               ZI(IATYMA-1+IMA2) = TYPTRI
C
               CALL JEECRA ( JEXNUM(CONNEX,IMA2), 'LONMAX', NBPT, K8B)
               CALL JEVEUO ( JEXNUM(CONNEX,IMA2), 'E', JNPT )
               DO 5300 INO = 1 , NBPT
C              --- TABLEAU DE DECOUPAGE SELON LE TYPE
                  ZI(JNPT-1+INO) = ZI(JOPT-1+TDEC(IND, I, INO))
 5300          CONTINUE
C
               IF ( IGRMA.NE.0 .AND. IER.EQ.0 .AND. NBGM.GT.0 ) THEN
                  DO 5301 J = 1, NBGM
                     IG = ZI(JLGRMA-1+J)
                     CALL JEVEUO( JEXNUM(GRPMAI,IG),'E', JGRMA)
                     CALL JELIRA( JEXNUM(GRPMAI,IG),'LONUTI', IM, K1B)
                     IM = IM + 1
C                     print *,'GROUP_MA ',IG,' : ',IM,' MAILLES'
                     ZI(JGRMA-1+IM) = IMA2
                     CALL JEECRA( JEXNUM(GRPMAI,IG),'LONUTI', IM, K1B)
 5301             CONTINUE
               ENDIF
C
 530        CONTINUE
C
         ENDIF
C
C  --- MAILLE SUIVANTE
C
 500  CONTINUE
C
C====
C 6. LE .GROUPENO REPRIS A L'IDENTIQUE
C====
C
      CALL JEEXIN ( GRPNOV, IRET )
      IF ( IRET .NE. 0 ) THEN
         CALL JELIRA ( GRPNOV, 'NOMUTI', NBGRNO, K1B )
         CALL JECREC ( GRPNOE, BASE//' V I', 'NO', 'DISPERSE',
     +                 'VARIABLE', NBGRNO )
         DO 20 I = 1,NBGRNO
            CALL JENUNO ( JEXNUM(GRPNOV,I), NOMG )
            CALL JEVEUO ( JEXNUM(GRPNOV,I), 'L', JVG )
            CALL JELIRA ( JEXNUM(GRPNOV,I), 'LONMAX', NBNO, K1B )
            CALL JEEXIN ( JEXNOM(GRPNOE,NOMG), IRET )
            IF (IRET.EQ.0) THEN
               CALL JECROC ( JEXNOM( GRPNOE, NOMG ) )
            ELSE
C           --- NE DEVRAIT PAS ARRIVER !
               CALL UTDEBM('F','CMQUTR','ERREUR DONNEES')
               CALL UTIMPK('L','GROUP_NO DEJA EXISTANT : ',1,NOMG)
               CALL UTFINM
            END IF
            CALL JEECRA(JEXNOM(GRPNOE,NOMG),'LONMAX',NBNO,' ')
            CALL JEVEUO(JEXNOM(GRPNOE,NOMG),'E',JGG)
            DO 22 J = 1, NBNO
               ZI(JGG-1+J) = ZI(JVG-1+J)
  22        CONTINUE
  20     CONTINUE
      END IF
C
 1000 FORMAT('MOT CLE FACTEUR "MODI_MAILLE", OCCURRENCE ',I4)
 1002 FORMAT('  MODIFICATION DE ',I6,' MAILLES ',A8,
     +                     ' EN ',I6,' MAILLES ',A8)
C
      CALL JEDEMA()
C
      END
