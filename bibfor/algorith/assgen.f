      SUBROUTINE  ASSGEN (NOMRES,OPTION,NUGENE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 08/11/2007   AUTEUR SALMONA L.SALMONA 
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
C
C***********************************************************************
C    P. RICHARD     DATE 13/10/92
C-----------------------------------------------------------------------
C  BUT:      < ASSEMBLAGE GENERALISEE >
C
C  ASSEMBLER UNE MATRICE A PARTIR D'UNE NUMEROTATION GENERALISEE
C  ET D'UNE OPTION (RIGI_GENE,MASS_GENE,AMOR_GENE)
C
C REMARQUE : L'ASSEMBLAGE DONNE UNE MATRICE ASSEMBLEE LIGNE DE CIEL
C            IL CONSIDERE LES MATRICE ELEMENTAIRE GENERALISEES
C  A ASSEMBLER COMME DES BLOCS
C  CHAQUE MATRICE ELEMENTAIRE POUVANT ETRE CONSTITUE DE PLUSIEURS BLOCS
C  CE QUI SEMBLE COMPLIQUER NETTEMENT LA TACHE POUR LE MOMENT MAIS
C  LE TRAVAIL POUR CONSIDERE UNE MATRICE ASSEMBLEE LIGNE DE CIEL
C     COMME UNE MATRICE ELEMENTAIRE DEVRAIT ETRE MINIME
C
C-----------------------------------------------------------------------
C
C NOM----- / /:
C
C NOMRES   /I/: NOM K8 DE LA MATRICE GENERALISEE RESULTAT
C OPTION   /I/: OPTION DE CALCUL (RIGI_GENE,MASS_GENE)
C NUGENE   /I/: NOM K14 DE LA NUMEROTATION GENERALISEE
C STOLCI   /I/: NOM K19 DU STOCKAGE DE LA MATRICE (LIGN_CIEL)
C
C-------- DEBUT COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16              ZK16
      CHARACTER*24                        ZK24
      CHARACTER*32                                  ZK32
      CHARACTER*80                                            ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
      CHARACTER*32  JEXNUM,JEXNOM
C
C----------  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      CHARACTER*8 NOMRES,MODGEN,NOMPRN
      CHARACTER*14 NUGENE
      CHARACTER*19 PRGENE,STOLCI
      CHARACTER*9  RIGOPT,KSST,LSST
      CHARACTER*24 TMADBL,TMNOBL,TMINBL,TMNOMB,TMNUMB,TMREP,TMCONL
      CHARACTER*11 ADNOM,RICOPT,OPTION
      CHARACTER*24 NOMBLO
      REAL*8       ZERO,UN
      REAL*8       VALR
C
      INTEGER      BID
      CHARACTER*8 K8BID
      CHARACTER*1 K1BID
C
C-----------------------------------------------------------------------
      DATA RIGOPT,RICOPT/'RIGI_GENE','RIGI_GENE_C'/
      DATA KSST /'&SOUSSTR'/
      DATA LSST /'LIAISONS'/
      DATA ZERO , UN / 0.0D+00 , 1.0D+00 /
      DATA EPSI / 1.D-20 /
C-----------------------------------------------------------------------
C
C--------------------------CREATION DU .REFA----------------------------
C

      CALL JEMARQ()
      PRGENE=NUGENE//'.NUME'
      STOLCI=NUGENE//'.SLCS'

      CALL WKVECT(NOMRES//'           .REFA','G V K24',10,JREFA)
      ZK24(JREFA-1+1)=' '
      ZK24(JREFA-1+2)=NUGENE
      ZK24(JREFA-1+8) = 'ASSE'
      ZK24(JREFA-1+9) = 'MS'
      ZK24(JREFA-1+10) = 'GENE'
C
C--------------------RECUPERATION DU MODE_GENE AMONT--------------------
C
      CALL JEVEUO(PRGENE//'.REFN','L',LLREF)
      MODGEN=ZK24(LLREF)(1:8)
C
C--------------------------CREATION DU .LIME----------------------------
C   POUR L'INSTANT ON DONNE LE NOM DU MODELE GENERALISE
C
      CALL WKVECT(NOMRES//'           .LIME','G V K8',1,LDLIM)
      ZK8(LDLIM)=MODGEN
C
C
C------------------RECUPERATION DU NOMBRE DE SOUS-STRUCTURE-------------
C
      CALL JENONU(JEXNOM(PRGENE//'.LILI',KSST),IBID)
      CALL JELIRA(JEXNUM(PRGENE//'.PRNO',IBID),'LONMAX',NBSST,K1BID)
      NBSST=NBSST/2
C------------------RECUPERATION DU NOMBRE DE LIAISON-------------
C
      CALL JENONU(JEXNOM(PRGENE//'.LILI',LSST),IBID)
      CALL JELIRA(JEXNUM(PRGENE//'.PRNO',IBID),'LONMAX',NBLIA,K1BID)
      IF (NBLIA.EQ.1) THEN
        CALL U2MESS('F','ALGORITH_32')
      ENDIF

C
C--------------------RECUPERATION DES CARACTERISTIQUES BLOCS------------
C
      CALL JEVEUO(STOLCI//'.SCDE','L',JSCDE)
      NEQ=ZI(JSCDE-1+1)
      NTBLOC=ZI(JSCDE-1+2)
      NBLOC=ZI(JSCDE-1+3)
      CALL JELIBE(STOLCI//'.SCDE')
      IF(OPTION.EQ.RICOPT) THEN
        CALL JECREC(NOMRES//'           .UALF','G V C',
     &              'NU','DISPERSE','CONSTANT',NBLOC)
      ELSE
        CALL JECREC(NOMRES//'           .UALF','G V R',
     &              'NU','DISPERSE','CONSTANT',NBLOC)
      ENDIF    
      CALL JEECRA(NOMRES//'           .UALF','LONMAX',NTBLOC,K8BID)
C
C------------------CREATION DU NOM A CONCATENER-------------------------
C   POUR RECUPERER LE NOM DES MATRICES PROJETEES
C
C
C------------------------RECUPERATION DU NOMBRE DE LIGRELS--------------
C
      CALL JELIRA(PRGENE//'.PRNO','NMAXOC',NBPRNO,K1BID)
      IF((OPTION.NE.RIGOPT).AND.(OPTION.NE.RICOPT)) NBPRNO=1
C
C--------------INITIALISATION DES NOMS OBJETS COURANTS------------------
C
C REPERTOIRE DES NOMS DES LIGRELS
      TMREP ='&&ASSGEN.REP.NOM.PROF'
C
C FAMILLE NOMMES, DONNANT POUR CHAQUE ELEMENTS A ASSEMBLER LE NUMERO
C  DE SON PREMIER BLOC DANS LA LISTE TOTALE
      TMINBL='&&ASSGEN.BLOCEL.PROF'
C
C FAMILLE NUMEROTEE (NMAXOC=NOMBRE DE BLOCS ELEMENTAIRES) ET
C CHAQUE OBJET DIMMENSIONNE A LA TAILLE DU BLOC DONT IL PORTE LE
C NUMERO DONNE POUR CHAQUE TERME DU BLOC L'ADRESSE RELATIVE DANS
C  SON BLOC DE DESTINATION
      TMADBL='&&ASSGEN.BLOCEL.ADBLO'
C
C FAMILLE NUMEROTEE (NMAXOC=NOMBRE DE BLOCS ELEMENTAIRES) ET
C CHAQUE OBJET DIMMENSIONNE A LA TAILLE DU BLOC DONT IL PORTE LE
C NUMERO DONNE POUR CHAQUE TERME DU BLOC ELEMENTAIRE LE NUMERO DE SON
C  BLOC D'ARRIVEE
      TMNOBL='&&ASSGEN.BLOCEL.NOBLO'
C
C VECTEUR DIMENSIONNE AU NOMBRE DE BLOCS ELEMENTAIRES ET DONNANT LE
C   NOM K24 DU BLOC OU DE LA FAMILLE CONTENNANT LE BLOC
      TMNOMB='&&ASSGEN.NOM.BLOCEL'
C
C VECTEUR DIMENSIONNE AU NOMBRE DE BLOCS ELEMENTAIRES ET DONNANT LE
C   NUMERO  DU BLOC ELEMENTAIRE DANS SA FAMILLE OU 0
      TMNUMB='&&ASSGEN.NUM.BLOCEL'
C
C VECTEUR DIMENSIONNE AU NOMBRE DE BLOCS ELEMENTAIRES ET DONNANT LE
C   COEF DE CONDITIONNEMENT DU BLOC
      TMCONL='&&ASSGEN.CONL.BLOCEL'
C
C
      CALL JECREO(TMREP,'V N K8')
      CALL JEECRA(TMREP,'NOMMAX',NBPRNO,K8BID)
      CALL JECREC(TMINBL,'V V I','NU','DISPERSE','VARIABLE',
     &NBPRNO)
C
C--------------------COMPTAGE DU NOMBRE DE BLOCS ELEMENTAIRES----------
C
      ICOMP=0
C
C   BOUCLE SUR LE LIGRELS
C
      DO 10 I=1,NBPRNO
        CALL JENUNO(JEXNUM(PRGENE//'.LILI',I),NOMPRN)
        CALL JELIRA(JEXNUM(PRGENE//'.PRNO',I),'LONMAX',NTPRNO,K1BID)
        NTPRNO=NTPRNO/2
C
C  TEST SI ON EST SUR LE LIGREL DES SOUS-STRUCTURES
C
        IF(NOMPRN.EQ.KSST) THEN
          CALL JECROC(JEXNOM(TMREP,NOMPRN))
          CALL JENONU(JEXNOM(TMREP,NOMPRN),IBID)
          CALL JEECRA(JEXNUM(TMINBL,IBID),'LONMAX',NTPRNO*2,' ')
          CALL JEVEUO(JEXNUM(TMINBL,IBID),'E',LTINBL)
C
C     BOUCLE SUR LES ELEMENTS DU LIGREL COURANTS
C           MATRICE PROJETEE=1BLOC
C
          DO 20 J=1,NTPRNO
            ICOMP=ICOMP+1
            ZI(LTINBL+(J-1)*2)=ICOMP
            ZI(LTINBL+(J-1)*2+1)=1
20        CONTINUE
C
C
C TEST SI ON EST SUR DES LAGRANGES ET SI L'OPTION EST RIGI_GENE
C
        ELSEIF(NOMPRN.NE.KSST.AND.
     &        (OPTION.EQ.RIGOPT.OR.OPTION.EQ.RICOPT)) THEN
          CALL JECROC(JEXNOM(TMREP,NOMPRN))
          CALL JENONU(JEXNOM(TMREP,NOMPRN),IBID)
          CALL JEECRA(JEXNUM(TMINBL,IBID),'LONMAX',NTPRNO*3,' ')
          CALL JEVEUO(JEXNUM(TMINBL,IBID),'E',LTINBL)
          CALL JEVEUO(MODGEN//'      .MODG.LIPR','L',LLPROF)
          CALL JENONU(JEXNOM(PRGENE//'.LILI',NOMPRN),IBID)
          CALL JEVEUO(JEXNUM(PRGENE//'.ORIG',IBID),'L',LLORL)
C
C    BOUCLE SUR LES ELEMENTS DU LIGREL COURANTS
C
          DO 30 J=1,NTPRNO
C NUMERO DE BLOCS MATRICE LIAISON 1
            ZI(LTINBL+(J-1)*3)=ICOMP+1
            ICOMP=ICOMP+1
C NUMERO DE BLOCS MATRICE LIAISON 2
            ZI(LTINBL+(J-1)*3+1)=ICOMP+1
            ICOMP=ICOMP+1
C NUMERO LAGRANGE-LAGRANGE
            ZI(LTINBL+(J-1)*3+2)=ICOMP+1
            ICOMP=ICOMP+1
30        CONTINUE
C
          CALL JELIBE(MODGEN//'      .MODG.LIPR')
C
        ENDIF
10    CONTINUE
C
C   NOMBRE DE BLOC ELEMENTAIRES A ASSEMBLER
      NBBLEL=ICOMP
C
      CALL JECREC(TMADBL,'V V I','NU','DISPERSE','VARIABLE',NBBLEL)
      CALL JECREC(TMNOBL,'V V I','NU','DISPERSE','VARIABLE',NBBLEL)
      CALL WKVECT(TMNOMB,'V V K24',NBBLEL,LTNOMB)
      CALL WKVECT(TMNUMB,'V V I',NBBLEL,LTNUMB)

C
C---------------------REMPLISSAGE DES OBJETS DE TRAVAIL-----------------
C
      SSMAX=ZERO
C
      CALL WKVECT(NOMRES//'           .CONL','G V R',NEQ,LDCONL)
      CALL WKVECT(TMCONL,'V V R',NBBLEL,LTCONL)
C
C      BOUCLE SUR LES LIGRELS
C
      DO 40 I=1,NBPRNO
C
        CALL JENUNO(JEXNUM(TMREP,I),NOMPRN)
C
C    CAS DU LIGRELS DES MATRICES PROJETEES
C
        CALL PRASMP(OPTION,NUGENE,TMINBL,NOMPRN,MODGEN,TMNOBL,
     &              TMADBL,ZK24(LTNOMB),ZI(LTNUMB),SSMAX)
C
C
C    CAS D'UN LIGREL DE LAGRANGES ET OPTION=RIGI_GENE
C
        CALL PRASML(OPTION,NUGENE,TMINBL,NOMPRN,MODGEN,TMNOBL,
     &              TMADBL,ZK24(LTNOMB),ZI(LTNUMB),ZR(LDCONL),
     &              ZR(LTCONL))
C
40    CONTINUE
C
C
      CALL JEDETR(TMINBL)
C
C------------------------------TRAITEMENT DU CONDITIONNEMENT-----------
C  ON TIENT COMPTE DES TERMES EXTRA DIAGONAUX DANS LES BLOCS PHYSIQUES
C
C  CONDITIONNEMENT = MAX(BLOC PHYSIQUE)/MAX(BLOC LAGRANGE)
C
      XMAXBL=0.D0
      DO 60 I=1,NBBLEL
        XMAXBL=MAX(XMAXBL,ABS(ZR(LTCONL+I-1)))
60    CONTINUE
C
         IF(XMAXBL.GT.EPSI) THEN
           SSCONL=SSMAX/XMAXBL
         ELSE
            SSCONL=UN
         ENDIF
C
          VALR = SSCONL
          CALL U2MESG('I','ALGORITH14_79',0,' ',0,0,1,VALR)
C
      DO 70 I=1,NBBLEL
        IF(ZR(LTCONL+I-1).NE.ZERO) THEN
          ZR(LTCONL+I-1)=SSCONL
        ELSE
          ZR(LTCONL+I-1)=UN
        ENDIF
70    CONTINUE
      DO 80 I=1,NEQ
        IF(ZR(LDCONL+I-1).NE.ZERO) THEN
          ZR(LDCONL+I-1)=SSCONL
        ELSE
          ZR(LDCONL+I-1)=UN
        ENDIF
80    CONTINUE
C
C-----------------------------------ASSEMBLAGE--------------------------
C
C    BOUCLE SUR LES BLOCS RESULTATS
C
      DO 100 IBLO=1,NBLOC
C
        CALL JECROC(JEXNUM(NOMRES//'           .UALF',IBLO))
        CALL JEVEUO(JEXNUM(NOMRES//'           .UALF',IBLO),'E',LDBLO)
C
C    BOUCLE SUR LES BLOCS ELEMENTAIRES

        DO 110 IBLEL=1,NBBLEL
C
C PRISE EN COMPTE DU CONDITIONNEMENT
C
          XCON=ZR(LTCONL+IBLEL-1)
          CALL JEVEUO(JEXNUM(TMADBL,IBLEL),'L',LTADBL)
          CALL JEVEUO(JEXNUM(TMNOBL,IBLEL),'L',LTNOBL)
          NOMBLO=ZK24(LTNOMB+IBLEL-1)
          NUMBLO=ZI(LTNUMB+IBLEL-1)
          CALL JELIRA(JEXNUM(TMNOBL,IBLEL),'LONMAX',NBTERM,K1BID)
          IF (OPTION.EQ.'RIGI_GENE_C') THEN
            CALL ASGNBC(IBLO,ZC(LDBLO),NBTERM,ZI(LTNOBL),
     &      ZI(LTADBL),NOMBLO,NUMBLO,XCON)
C
          ELSE
            CALL ASGNBN(IBLO,ZR(LDBLO),NBTERM,ZI(LTNOBL),
     &       ZI(LTADBL),NOMBLO,NUMBLO,XCON)
C
          ENDIF
          CALL JELIBE(JEXNUM(TMADBL,IBLEL))
          CALL JELIBE(JEXNUM(TMNOBL,IBLEL))
C
110    CONTINUE
C
        CALL JELIBE(JEXNUM(NOMRES//'           .UALF',IBLO))
C
100   CONTINUE

      CALL UALFVA(NOMRES,'G')
C     CALL CHEKSD('sd_matr_asse',NOMRES,IRET)

      CALL JEDETR(TMADBL)
      CALL JEDETR(TMNOBL)
      CALL JEDETR(TMNOMB)
      CALL JEDETR(TMNUMB)
      CALL JEDETR(TMREP)
      CALL JEDETR(TMCONL)
C
 9999 CONTINUE
      CALL JEDEMA()
      END
