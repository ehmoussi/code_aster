      SUBROUTINE CALCYC(NOMRES)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 27/11/2012   AUTEUR BERRO H.BERRO 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_6
      IMPLICIT NONE
C
C***********************************************************************
C    P. RICHARD     DATE 14/03/91
C-----------------------------------------------------------------------
C  BUT:  CALCUL DES MODES CYCLIC OU RECOPIE DE CEUX DEJA EXISTANT
C   DANS UN EVENTUEL CALCUL DE MODES CYCLIQUES PRECEDANT
C
C-----------------------------------------------------------------------
C
C NOMRES  /I/: NOM UTILISATEUR DU CONCEPT RESULTAT
C
C
      INCLUDE 'jeveux.h'

      INTEGER VALI(3)
C
C
      CHARACTER*6      PGC
      CHARACTER*8 NOMRES,TYPINT,BASMOD,K8B
      CHARACTER*14 OPTION
      CHARACTER*24 REPMAT,SOUMAT
      CHARACTER*24 VALK
      COMPLEX*16 COMSHI
      LOGICAL AXOK
      REAL*8 RLOME2(2)
      INTEGER      IARG
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      INTEGER I ,IAD ,IBID ,ICOMP ,ICONE ,IDIA ,IDIAM
      INTEGER IF ,IMES ,IUNIFI ,LDFRE ,LDMOC ,LDNBD ,LLITMP
      INTEGER LLNBS ,LLNUM ,LLREF ,LLTYP ,LTEIG ,LTKCOM ,LTLAX0
      INTEGER LTLAX1 ,LTLBID ,LTMCOM ,LTNBD ,LTRV1 ,LTRV2 ,LTTRGE
      INTEGER LTZM1 ,LTZM2 ,LTZV1 ,LTZV2 ,LTZV3 ,MAXDIA ,NBDAX
      INTEGER NBDAX0 ,NBDAX1 ,NBDDEF ,NBDDG ,NBDDR ,NBDIA ,NBDIA1
      INTEGER NBDIA2 ,NBLIF ,NBMCAL ,NBMOBT ,NBMOS ,NBNEW ,NBSEC
      INTEGER NBTMP ,NMAXIT ,NTAIL ,NTT ,NUMA
      REAL*8 BETA ,BID ,OMEG2 ,PI ,PIMA ,PRECAJ ,PRECSE

C-----------------------------------------------------------------------
      DATA PGC /'CALCYC'/
C-----------------------------------------------------------------------
C
C
      CALL JEMARQ()
      PI=4.D0*ATAN(1.D0)
      LLITMP=1
      IMES=IUNIFI('MESSAGE')
C
      SOUMAT='&&OP0080.CYCLIC.SOUS.MAT'
      REPMAT='&&OP0080.CYCLIC.REPE.MAT'
C
C-----------------RECUPERATION DU TYPE D'INTERFACE----------------------
C
      CALL JEVEUO(NOMRES//'.CYCL_TYPE','L',LLTYP)
      TYPINT=ZK8(LLTYP)
C
C-----------------RECUPERATION DU NOMBRE DE SECTEURS--------------------
C
      CALL JEVEUO(NOMRES//'.CYCL_NBSC','L',LLNBS)
      NBSEC=ZI(LLNBS)
      MAXDIA=INT((NBSEC+1)/2)
C
C----------RECUPERATION DU NOMBRE DE DIAMETRES NODAUX EN COMMANDE-------
C
      CALL GETVIS('CALCUL','NB_DIAM',1,IARG,0,IBID,NBDIA1)
      NBDIA1=-NBDIA1
      CALL GETVTX('CALCUL','TOUT_DIAM',1,IARG,0,K8B,NBDIA2)
      NBDIA2=-NBDIA2
C
      IF(NBDIA2.GT.0) THEN
        NBDIA2=INT((NBSEC+1)/2)+1
      ENDIF
C
C
C  NOMBRE BRUT DE DIAMETRES MODAUX
C
      NBDIA=NBDIA1+NBDIA2
C
C-------------ALLOCATION DU VECTEUR TEMPORAIRE DES DIAMETRES MODAUX-----
C
      CALL WKVECT('&&'//PGC//'.DIAM.TOUT','V V I',NBDIA,LTNBD)
C
C-------------------RECUPERATION DES DIAMETRES MODAUX-------------------
C
      IF(NBDIA1.NE.0) THEN
        CALL GETVIS('CALCUL','NB_DIAM',1,IARG,NBDIA1,ZI(LTNBD),IBID)
      ENDIF
C
      IF(NBDIA2.NE.0) THEN
        DO 10 I=1,NBDIA2
          ZI(LTNBD+NBDIA1+I-1)=I-1
 10     CONTINUE
      ENDIF
C
C
C-----------------TRI DES VALEURS DES DIAMETRES MODAUX------------------
C
      NBNEW = NBDIA
      IF (NBNEW.NE.0) CALL UTTRII(ZI(LTNBD),NBNEW)
C
      NBDIA=NBNEW
C
      ICOMP=0
      DO 30 I=1,NBNEW
        IDIA=ZI(LTNBD+I-1)
        IF(IDIA.LE.MAXDIA) THEN
          ICOMP=ICOMP+1
        ELSE
          VALI (1) = IDIA
          CALL U2MESG('I','ALGORITH14_82',0,' ',1,VALI,0,0.D0)
        ENDIF
 30   CONTINUE
C
       IF(ICOMP.LT.NBDIA)  THEN
         VALI (1) = MAXDIA
         CALL U2MESG('I','ALGORITH14_83',0,' ',1,VALI,0,0.D0)
       ENDIF
C
      NBDIA=ICOMP
      IF(NBDIA.EQ.0) THEN
        CALL U2MESG('F','ALGORITH14_84',0,' ',0,0,0,0.D0)
      ENDIF
C
C---------ALLOCATION DU VECTEUR DES NOMBRES DE DIAMETRES MODAUX---------
C
      CALL WKVECT(NOMRES//'.CYCL_DIAM','G V I',NBDIA*2,LDNBD)
C
      DO 40 I=1,NBDIA
        ZI(LDNBD+I-1)=ZI(LTNBD+I-1)
 40   CONTINUE
C
      CALL JEDETR('&&'//PGC//'.DIAM.TOUT')
C
C----------------RECUPERATION DU TYPE DE METHODE------------------------
C
      CALL GETVTX('CALCUL','OPTION',1,IARG,1,OPTION,IBID)
      CALL GETVIS('CALCUL','NMAX_ITER',1,IARG,1,NMAXIT,IBID)
      CALL GETVR8('CALCUL','PREC_AJUSTE',1,IARG,1,PRECAJ,IBID)
      CALL GETVR8('CALCUL','PREC_SEPARE',1,IARG,1,PRECSE,IBID)
C
      COMSHI=DCMPLX(0.D0,0.D0)
C
      CALL GETVR8('CALCUL','FREQ',1,IARG,0,BID,NBLIF)
      NBLIF=-NBLIF
      IF(OPTION.EQ.'PLUS_PETITE'.OR.OPTION.EQ.'CENTRE') THEN
        IF(NBLIF.GT.1) THEN
          VALI (1) = NBLIF
          VALK = OPTION
          CALL U2MESG('F','ALGORITH14_85',1,VALK,1,VALI,0,0.D0)
        ELSEIF(NBLIF.EQ.1) THEN
          CALL GETVR8('CALCUL','FREQ',1,IARG,NBLIF,RLOME2,IBID)
          RLOME2(1)=(RLOME2(1)*2.D0*PI)**2
          COMSHI=DCMPLX(RLOME2(1),0.D0)
        ELSE
          COMSHI=DCMPLX(0.D0,0.D0)
        ENDIF
      ELSEIF (OPTION.EQ.'BANDE') THEN
        IF(NBLIF.NE.2) THEN
          VALI (1) = NBLIF
          VALK = OPTION
          CALL U2MESG('F','ALGORITH14_85',1,VALK,1,VALI,0,0.D0)
        ELSE
          CALL GETVR8('CALCUL','FREQ',1,IARG,NBLIF,RLOME2,IBID)
          RLOME2(1)=(RLOME2(1)*2.D0*PI)**2
          RLOME2(2)=(RLOME2(2)*2.D0*PI)**2
        ENDIF
      ENDIF
C
C--------RECUPERATION NOMBRE (PROJECTION) MODES ET DDL LIAISON----------
C              ET NOMBRE DE MODES A CALCULER
C
      CALL JEVEUO(NOMRES//'.CYCL_DESC','L',LLNUM)
      NBMOS=ZI(LLNUM)
      NBDDR=ZI(LLNUM+1)
      NBDAX=ZI(LLNUM+2)
      NBMCAL=ZI(LLNUM+3)
      NBDDG=NBMOS+NBDDR+NBDAX
C
C---------RECUPERATION DES DONNEES ASSEMBLAGE PARTIEL DDL AXE-----------
C
      LTLBID = 1
      IF(NBDAX.GT.0) THEN
        CALL JEVEUO(NOMRES//'.CYCL_NUIN','L',LLNUM)
        NUMA=ZI(LLNUM+2)
        CALL JEVEUO(NOMRES//'.CYCL_REFE','L',LLREF)
        BASMOD=ZK24(LLREF+2)
C
        CALL AXACTI(BASMOD,NUMA,0,IBID,0,NBDAX0)
        IF(NBDAX0.GT.0) THEN
          CALL WKVECT('&&'//PGC//'.LISTE.AXE0','V V I',NBDAX0,LTLAX0)
          CALL AXACTI(BASMOD,NUMA,0,ZI(LTLAX0),NBDAX0,IBID)
        ENDIF
        CALL AXACTI(BASMOD,NUMA,1,IBID,0,NBDAX1)
        IF(NBDAX1.GT.0) THEN
        CALL WKVECT('&&'//PGC//'.LISTE.AXE1','V V I',NBDAX1,LTLAX1)
        CALL AXACTI(BASMOD,NUMA,1,ZI(LTLAX1),NBDAX1,IBID)
        ENDIF
        NTT=MAX(NBMOS,NBDDR)
        CALL WKVECT('&&'//PGC//'.LISTE.BIDON','V V I',NTT,LTLBID)
        DO 5 I=1,NTT
          ZI(LTLBID+I-1)=I
5       CONTINUE
      ENDIF
C
C
C--------------------ALLOCATION DES OBJETS RESULTAT---------------------
C
      NTAIL=NBMCAL*NBDIA
      CALL WKVECT(NOMRES//'.CYCL_FREQ','G V R',NTAIL,LDFRE)
      NTAIL=NBDIA*NBMCAL*NBDDG
      CALL WKVECT(NOMRES//'.CYCL_CMODE','G V C',NTAIL,LDMOC)
C
C--------------ALLOCATION OBJET DE TRAVAIL POUR CALCUL DES MODES--------
C
C
      NTAIL = NBDDG*(NBDDG+1)/2
      CALL WKVECT('&&'//PGC//'COMPRAID','V V C',NTAIL,LTKCOM)
      CALL WKVECT('&&'//PGC//'COMPMASS','V V C',NTAIL,LTMCOM)
      CALL WKVECT('&&'//PGC//'TRAV.GENE','V V C',NBDDG,LTTRGE)
C
      CALL WKVECT('&&'//PGC//'.MAT.TRAV1','V V C',NTAIL,LTZM1)
      CALL WKVECT('&&'//PGC//'.MAT.TRAV2','V V C',NBDDG*NBDDG,LTZM2)
      CALL WKVECT('&&'//PGC//'.VEC.TRAV1','V V C',NBDDG,LTZV1)
      CALL WKVECT('&&'//PGC//'.EIGE','V V C',NBMCAL,LTEIG)
C
      IF(OPTION.EQ.'BANDE') THEN
        CALL WKVECT('&&'//PGC//'.VEC.TRAV2','V V C',NBDDG,LTZV2)
        CALL WKVECT('&&'//PGC//'.VEC.TRAV3','V V C',NBDDG,LTZV3)
        CALL WKVECT('&&'//PGC//'.VER.TRAV1','V V R',NBDDG+1,LTRV1)
        CALL WKVECT('&&'//PGC//'.VER.TRAV2','V V R',NBDDG+1,LTRV2)
      ENDIF
C
C---------------------------IMPRESSIONS DIMENSIONS---------------------
C
        VALI (1) = NBMOS
        VALI (2) = NBDDR
        CALL U2MESG('I','ALGORITH14_87',0,' ',2,VALI,0,0.D0)
        IF(NBDAX.GT.0) THEN
          VALI (1) = NBDAX
          VALI (2) = NBDAX0
          VALI (3) = NBDAX1
          CALL U2MESG('I','ALGORITH14_88',0,' ',3,VALI,0,0.D0)
        ENDIF
        VALI (1) = NBDDG
        CALL U2MESG('I','ALGORITH14_89',0,' ',1,VALI,0,0.D0)
C
C
C---------------------------CALCUL DES MODES PROPRES--------------------
C
C  COMPTEUR DES MODES PROPRES COMPLEXES
C
C  ICONE MODES ECRITS DANS NOMRES
C
      ICONE=0
C
      DO 80 I=1,NBDIA
C
        NBMOBT=NBMCAL
        IDIAM=ZI(LDNBD+I-1)
        BETA=(2.D0*PI/NBSEC)*IDIAM
C
C  DETERMINATION DU NOMBRE DE DDL GENERALISES EFFICACE ET INDICATEUR
C    DE PRISE EN COMPTE DES DDL GENERALISES RELATIF A L'AXE  (AXOK)
C  ( SELON PRESENCE DDL AXE ET DIAMETRE MODAUX ET TYPE D'INTERFACE)
C
C
C  DETERMINATION  DES  POINTEUR TEMPORAIRES POUR ASSEMBLAGE
C    DES EVENTUELS DDL AXE: AXOK,LLITMP,NBTMP
C
C CAS CRAIG-BAMPTON
        IF(TYPINT.EQ.'CRAIGB   '.OR.TYPINT.EQ.'CB_HARMO') THEN
          IF(NBDAX.GT.0.AND.IDIAM.EQ.0) THEN
            NBDDEF=NBMOS+NBDDR+NBDAX0
            AXOK=.TRUE.
            LLITMP=LTLAX0
            NBTMP=NBDAX0
          ELSEIF(NBDAX.GT.0.AND.IDIAM.EQ.1) THEN
            NBDDEF=NBMOS+NBDDR+NBDAX1
            AXOK=.TRUE.
            LLITMP=LTLAX1
            NBTMP=NBDAX1
          ELSE
            AXOK=.FALSE.
            NBDDEF=NBMOS+NBDDR
            NBTMP=0
          ENDIF
C
C CAS MAC NEAL OU AUCUN
C
        ELSE
          IF(NBDAX.GT.0.AND.IDIAM.EQ.0) THEN
            NBDDEF=NBMOS+NBDDR+NBDAX1
            AXOK=.TRUE.
            LLITMP=LTLAX1
            NBTMP=NBDAX1
          ELSEIF (NBDAX.GT.0.AND.IDIAM.EQ.1) THEN
            NBDDEF=NBMOS+NBDDR+NBDAX0
            AXOK=.TRUE.
            LLITMP=LTLAX0
            NBTMP=NBDAX0
          ELSE
            AXOK=.FALSE.
            NBDDEF=NBMOS+NBDDR
            NBTMP=0
          ENDIF
        ENDIF
C
C
        CALL ASMCYC(ZC(LTMCOM),NBDDEF,SOUMAT,BETA,NBMOS,NBDDR,NBDAX,
     &AXOK,ZI(LLITMP),NBTMP,ZI(LTLBID))

        CALL ASKCYC(ZC(LTKCOM),NBDDEF,SOUMAT,BETA,NBMOS,NBDDR,NBDAX,
     &AXOK,ZI(LLITMP),NBTMP,ZI(LTLBID))
C
      CALL SHIFTC(ZC(LTKCOM),ZC(LTMCOM),NBDDEF,COMSHI)
C
C
        IAD=LDMOC+(NBDDG*ICONE)
C
      IF (OPTION.EQ.'PLUS_PETITE'.OR.OPTION.EQ.'CENTRE') THEN
C
        CALL CMPHII(ZC(LTKCOM),ZC(LTMCOM),NBDDEF,NBMOBT,NMAXIT,
     &PRECAJ,ZC(LTEIG),ZC(IAD),NBDDG,ZC(LTZM1),ZC(LTZM2),ZC(LTZV1),
     &IMES)
C
      ELSE IF (OPTION.EQ.'BANDE') THEN
        CALL CMPHDI(ZC(LTKCOM),ZC(LTMCOM),NBDDEF,NBMOBT,NMAXIT,
     &PRECAJ,ZC(LTEIG),ZC(IAD),NBDDG,ZC(LTZM1),ZC(LTZM2),
     &ZC(LTZV1),ZC(LTZV2),ZR(LTRV1),ZR(LTRV2),
     &RLOME2(1),RLOME2(2),PRECSE,IMES)
C
      ENDIF
C
C--------------RECUPERATION DES FREQUENCES PROPRES REELLES--------------
C
      DO 110 IF=1,NBMOBT
        ZC(LTEIG+IF-1)=ZC(LTEIG+IF-1)-COMSHI
        CALL ZCONJU(ZC(LTEIG+IF-1),OMEG2,PIMA)
        IF(OMEG2.GE.0) THEN
          ZR(LDFRE+ICONE+IF-1)=(OMEG2**0.5D0)/(2.D0*PI)
        ELSE
          ZR(LDFRE+ICONE+IF-1)=-((-OMEG2)**0.5D0)/(2.D0*PI)
        ENDIF
 110   CONTINUE
C
C
C--------------REORGANISATION DES DDL GENERALISEE-----------------------
C                (DDL AXE ASSEMBLES PARTIELLEMENT)
C
      CALL ZREORD(ZC(IAD),NBDDG,NBMOBT,NBMOS,NBDDR,AXOK,ZI(LLITMP),
     &NBTMP,ZC(LTTRGE))
C
CC
        ICONE=ICONE+NBMOBT
        ZI(LDNBD+NBDIA+I-1)=NBMOBT
C
 80   CONTINUE
C
C
C   GRAND MENAGE DE PRINTEMPS !!!
C
      IF (NBDAX.GT.0) THEN
        CALL JEDETR('&&'//PGC//'.LISTE.BIDON')
        IF(NBDAX0.GT.0) CALL JEDETR('&&'//PGC//'.LISTE.AXE0')
        IF(NBDAX1.GT.0) CALL JEDETR('&&'//PGC//'.LISTE.AXE1')
      ENDIF
C
      CALL JEDETR('&&'//PGC//'COMPRAID')
      CALL JEDETR('&&'//PGC//'COMPMASS')
      CALL JEDETR('&&'//PGC//'TRAV.GENE')
      CALL JEDETR('&&'//PGC//'.MAT.TRAV1')
      CALL JEDETR('&&'//PGC//'.MAT.TRAV2')
      CALL JEDETR('&&'//PGC//'.VEC.TRAV1')
      CALL JEDETR('&&'//PGC//'.EIGE')
C
      IF(OPTION.EQ.'BANDE') THEN
        CALL JEDETR('&&'//PGC//'.VEC.TRAV2')
        CALL JEDETR('&&'//PGC//'.VEC.TRAV3')
        CALL JEDETR('&&'//PGC//'.VER.TRAV1')
        CALL JEDETR('&&'//PGC//'.VER.TRAV2')
      ENDIF
C
      CALL JEDETR(SOUMAT)
      CALL JEDETR(REPMAT)
C
      CALL JEDEMA()
      END
