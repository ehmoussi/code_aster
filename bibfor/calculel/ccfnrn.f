      SUBROUTINE CCFNRN(OPTION,RESUIN,RESUOU,LISORD,NBORDR,
     &                  LISCHA,NCHARG,CHTYPE,TYPESD)
      IMPLICIT NONE
C     --- ARGUMENTS ---
      INCLUDE 'jeveux.h'
      INTEGER      NBORDR,NCHARG
      CHARACTER*4  CHTYPE
      CHARACTER*8  RESUIN,RESUOU
      CHARACTER*16 OPTION,TYPESD
      CHARACTER*19 LISCHA,LISORD
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 10/09/2012   AUTEUR SELLENET N.SELLENET 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C ----------------------------------------------------------------------
C  CALC_CHAMP - CALCUL DES FORCES NODALES ET DES REACTIONS NODALES
C  -    -                  -      -              -         -
C ----------------------------------------------------------------------
C RESPONSABLE SELLENET N.SELLENET
      INTEGER      JORDR,JREF,IBID,IRET,IORDR,I,JINFC,NBCHAR,IC
      INTEGER      IACHAR,ICHAR,II,NUORD,NH,JNMO,NBDDL,LMAT,LREF,IAD,IND
      INTEGER      NEQ,JNOCH,JFO,JFONO,LONCH,JCHMP,JRENO
      INTEGER      JCGMP,JFPIP,LDEPL,LONC2,LTRAV,J,INUME,JDDL,JDDR,LACCE
      INTEGER      IERD,CRET
      REAL*8       ETAN,TIME,PARTPS(3),OMEGA2,COEF(3)
      CHARACTER*1  STOP
      CHARACTER*2  CODRET
      CHARACTER*6  NOMPRO
      CHARACTER*8  K8BID,KIORD,CTYP,NOMCMP(3)
      CHARACTER*16 TYPMO,OPTIO2
      CHARACTER*19 LIGREL,CHDEP2,INFCHA
      CHARACTER*24 NUMREF,FOMULT,CHARGE,INFOCH,VECHMP,VACHMP,CNCHMP
      CHARACTER*24 VECGMP,VACGMP,CNCGMP,VEFPIP,VAFPIP,CNFPIP,VFONO,CARAC
      CHARACTER*24 VAFONO,VRENO, VARENO,SIGMA,CHDEPL,VALK(3),NUME,MATER
      CHARACTER*24 CHVIVE,CHACVE,MASSE, CHVARC,COMPOR,K24BID,CHAMNO,STRX
      CHARACTER*24 BIDON, CHACCE,K24B,MODELE,KSTR
      LOGICAL      EXITIM,FNOEVO,LBID,LSTR
      PARAMETER(NOMPRO='CCFNRN')
      DATA CHVARC/'&&CCFNRN.CHVARC'/
      DATA INFCHA/'&&INFCHA.INFCHA'/
      DATA K24BID/' '/
      DATA NOMCMP/'DX','DY','DZ'/
C
      CALL JEMARQ()
      BIDON='&&'//NOMPRO//'.BIDON'
C
      CALL JEVEUO(LISORD,'L',JORDR)
C
C ----ON VERIFIE SI DERRIERE UN CONCEPT MODE_MECA SE TROUVE UN MODE_DYN
      IF (TYPESD(1:9).EQ.'MODE_MECA') THEN
        CALL RSADPA(RESUIN,'L',1,'TYPE_MODE',1,0,IAD,K8BID)
        TYPMO=ZK16(IAD)
      ENDIF
C
C TRI DES OPTIONS SUIVANT TYPESD
      LMAT=0
      EXITIM=.FALSE.
      IF (TYPESD.EQ.'EVOL_ELAS' .OR. TYPESD.EQ.'EVOL_NOLI') THEN
        EXITIM=.TRUE.
      ELSEIF (TYPESD.EQ.'MODE_MECA' .OR. TYPESD.EQ.'DYNA_TRANS') THEN
        CALL JEEXIN(RESUIN//'           .REFD',IRET)
        IF (IRET.NE.0) THEN
          CALL JEVEUO(RESUIN//'           .REFD','L',LREF)
          MASSE=ZK24(LREF+1)
          IF (MASSE.NE.' ') THEN
            CALL MTDSCR(MASSE)
            CALL JEVEUO(MASSE(1:19)//'.&INT','E',LMAT)
          ENDIF
        ENDIF
        IF (TYPESD.EQ.'DYNA_TRANS')EXITIM=.TRUE.
      ELSEIF (TYPESD.EQ.'DYNA_HARMO') THEN
        CALL JEEXIN(RESUIN//'           .REFD',IRET)
        IF (IRET.NE.0) THEN
          CALL JEVEUO(RESUIN//'           .REFD','L',LREF)
          MASSE=ZK24(LREF+1)
          IF (MASSE.NE.' ') THEN
            CALL MTDSCR(MASSE)
            CALL JEVEUO(MASSE(1:19)//'.&INT','E',LMAT)
          ENDIF
        ENDIF
      ENDIF
      IF (TYPESD.EQ.'MODE_MECA' .OR. TYPESD.EQ.'DYNA_TRANS') THEN
        NUMREF=' '
        CALL JEVEUO(RESUIN//'           .REFD','L',JREF)
        IF (ZK24(JREF).NE.' ') THEN
          CALL DISMOI('F','NOM_NUME_DDL',ZK24(JREF),'MATR_ASSE',
     &                IBID,NUMREF,IRET)
        ENDIF
      ENDIF
      CARAC=' '
      CHARGE=' '
      MATER=' '
      MODELE=' '
      NUORD=ZI(JORDR)
      IF (TYPESD.EQ.'EVOL_THER') THEN
        CALL NTDOTH(MODELE,MATER,CARAC,K24B,LBID,LBID,INFCHA,
     &              RESUOU(1:8),NUORD)
      ELSE
        CALL NMDOME(MODELE,MATER,CARAC,INFCHA,RESUOU(1:8),
     &              NUORD)
      ENDIF
      IF (MODELE(1:2).EQ.'&&') THEN
        CALL U2MESS('F','CALCULEL3_50')
      ENDIF
C
      FOMULT=INFCHA//'.FCHA'
      CHARGE=INFCHA//'.LCHA'
      INFOCH=INFCHA//'.INFC'
      CALL JEEXIN(INFOCH,IRET)
      IF (IRET.NE.0) THEN
        CALL JEVEUO(INFOCH,'L',JINFC)
        NBCHAR=ZI(JINFC)
        IF (NBCHAR.NE.0) THEN
          CALL JEVEUO(CHARGE,'L',IACHAR)
          CALL JEDETR('&&'//NOMPRO//'.L_CHARGE')
          CALL WKVECT('&&'//NOMPRO//'.L_CHARGE','V V K8',NBCHAR,
     &                ICHAR)
          DO 150 II=1,NBCHAR
            ZK8(ICHAR-1+II)=ZK24(IACHAR-1+II)(1:8)
150       CONTINUE
        ELSE
          ICHAR=1
        ENDIF
      ELSE
        NBCHAR=0
        ICHAR=1
      ENDIF
      CALL EXLIMA(' ',0,'V',MODELE,LIGREL)
C     ON REGARDE S'IL Y A DES PMF POUR SAVOIR SI STRX_ELGA EXISTE
      STRX=' '
      CALL DISMOI('F','EXI_STRX',MODELE,'MODELE',IBID,KSTR,IERD)
      LSTR=(KSTR(1:3).EQ.'OUI')
C
      TIME=0.D0
      DO 290 I=1,NBORDR
        CALL JEMARQ()
        IORDR=ZI(JORDR+I-1)
C
        VECHMP=' '
        VACHMP=' '
        CNCHMP=' '
        VECGMP=' '
        VACGMP=' '
        CNCGMP=' '
        VEFPIP=' '
        VAFPIP=' '
        CNFPIP=' '
        ETAN=0.D0
        VFONO=' '
        VAFONO=' '
        VRENO='&&'//NOMPRO//'           .RELR'
        VARENO='&&'//NOMPRO//'           .RELR'
C
        NH=0
        IF (TYPESD(1:8).EQ.'FOURIER_') THEN
          CALL RSADPA(RESUIN,'L',1,'NUME_MODE',IORDR,0,JNMO,K8BID)
          NH=ZI(JNMO)
        ENDIF
C ICI
        CALL RSEXCH(' ',RESUIN,'SIEF_ELGA',IORDR,SIGMA,IRET)
        IF (IRET.NE.0) THEN
          OPTIO2 = 'SIEF_ELGA'
          CALL CALCOP(OPTIO2,' ',RESUIN,RESUOU,LISORD,NBORDR,
     &                LISCHA,NCHARG,CHTYPE,TYPESD,CRET)
        ENDIF
        IF (LSTR) THEN
          CALL RSEXCH(' ',RESUIN,'STRX_ELGA',IORDR,STRX,IRET)
          IF (IRET.NE.0) THEN
            OPTIO2 = 'STRX_ELGA'
            CALL CALCOP(OPTIO2,' ',RESUIN,RESUOU,LISORD,NBORDR,
     &                  LISCHA,NCHARG,CHTYPE,TYPESD,CRET)
          ENDIF
        ENDIF
C
        CALL RSEXCH(' ',RESUIN,'DEPL',IORDR,CHDEPL,IRET)
        IF (IRET.NE.0) THEN
          CALL CODENT(IORDR,'G',KIORD)
          VALK(1)=KIORD
          VALK(2)=OPTION
          CALL U2MESK('A','PREPOST5_3',2,VALK)
          GOTO 280
C
        ELSE
C
C         CREATION D'UN VECTEUR ACCROISSEMENT DE DEPLACEMENT NUL
C         POUR LE CALCUL DE FORC_NODA DANS LES POU_D_T_GD
          CHDEP2='&&'//NOMPRO//'.CHDEP_NUL'
          CALL COPISD('CHAMP_GD','V',CHDEPL,CHDEP2)
          CALL JELIRA(CHDEP2//'.VALE','LONMAX',NBDDL,K8BID)
          CALL JERAZO(CHDEP2//'.VALE',NBDDL,1)
        ENDIF
C
C       -- CALCUL D'UN NUME_DDL "MINIMUM" POUR ASASVE :
        IF (TYPESD.EQ.'MODE_MECA' .OR. TYPESD.EQ.'DYNA_TRANS') THEN
          NUME=NUMREF(1:14)//'.NUME'
        ELSE
          CALL NUMECN(MODELE,CHDEPL,NUME)
        ENDIF
C
        CALL RSEXCH(' ',RESUIN,'VITE',IORDR,CHVIVE,IRET)
        IF (IRET.EQ.0) THEN
          CHVIVE='&&'//NOMPRO//'.CHVIT_NUL'
          CALL COPISD('CHAMP_GD','V',CHDEPL,CHVIVE)
          CALL JELIRA(CHVIVE(1:19)//'.VALE','LONMAX',NBDDL,K8BID)
          CALL JERAZO(CHVIVE(1:19)//'.VALE',NBDDL,1)
        ENDIF
        CALL RSEXCH(' ',RESUIN,'ACCE',IORDR,CHACVE,IRET)
        IF (IRET.EQ.0) THEN
          CHACVE='&&'//NOMPRO//'.CHACC_NUL'
          CALL COPISD('CHAMP_GD','V',CHDEPL,CHACVE)
          CALL JELIRA(CHACVE(1:19)//'.VALE','LONMAX',NBDDL,K8BID)
          CALL JERAZO(CHACVE(1:19)//'.VALE',NBDDL,1)
        ENDIF
C
        IF (EXITIM) THEN
          CALL RSADPA(RESUIN,'L',1,'INST',IORDR,0,IAD,CTYP)
          TIME=ZR(IAD)
        ENDIF
C
        CALL VRCINS(MODELE,MATER,CARAC,TIME,CHVARC(1:19),CODRET)
        CALL RSEXCH(' ',RESUIN,'COMPORTEMENT',IORDR,COMPOR,IRET)
C
        FNOEVO=.FALSE.
        CALL VEFNME(MODELE,SIGMA,CARAC,CHDEPL,CHDEP2,VFONO,MATER,
     &              COMPOR,NH,FNOEVO,PARTPS,K24BID,CHVARC,LIGREL,
     &              INFCHA,OPTION,STRX)
C
C       --- ASSEMBLAGE DES VECTEURS ELEMENTAIRES ---
        CALL ASASVE(VFONO,NUME,'R',VAFONO)
C
C       --- CREATION DE LA STRUCTURE CHAM_NO ---
        CALL RSEXCH(' ',RESUIN,OPTION,IORDR,CHAMNO,IRET)
C
        CALL JEEXIN(CHAMNO(1:19)//'.REFE',IRET)
        IF (IRET.NE.0) THEN
          CALL CODENT(IORDR,'G',KIORD)
          VALK(1)=OPTION
          VALK(2)=KIORD
          CALL U2MESK('A','PREPOST5_1',2,VALK)
          CALL DETRSD('CHAM_NO',CHAMNO(1:19))
        ENDIF
        CALL VTCREB(CHAMNO,NUME,'G','R',NEQ)
        CALL JEVEUO(CHAMNO(1:19)//'.VALE','E',JNOCH)
C
C       --- REMPLISSAGE DE L'OBJET .VALE DU CHAM_NO ---
        CALL JEVEUO(VAFONO,'L',JFO)
        CALL JEVEUO(ZK24(JFO)(1:19)//'.VALE','L',JFONO)
        CALL JELIRA(CHAMNO(1:19)//'.VALE','LONMAX',LONCH,K8BID)
C
C       --- STOCKAGE DES FORCES NODALES ---
        IF (OPTION.EQ.'FORC_NODA') THEN
          DO 160 J=0,LONCH-1
            ZR(JNOCH+J)=ZR(JFONO+J)
  160     CONTINUE
          GOTO 270
        ENDIF
C
C       --- CALCUL DES FORCES NODALES DE REACTION
        IF (CHARGE.NE.' ') THEN
          PARTPS(1)=TIME
C
C --- CHARGES NON PILOTEES (TYPE_CHARGE: 'FIXE_CSTE')

          STOP = 'S'
          IF (LIGREL(1:8).NE.MODELE) STOP = 'C'
          CALL VECHME(STOP  ,MODELE,CHARGE,INFOCH,PARTPS,
     &                CARAC,MATER ,CHVARC,LIGREL,VECHMP)

          CALL ASASVE(VECHMP,NUME,'R',VACHMP)
          CALL ASCOVA('D',VACHMP,FOMULT,'INST',TIME,'R',CNCHMP)
C
C --- CHARGES SUIVEUSE (TYPE_CHARGE: 'SUIV')
          CALL DETRSD('CHAMP_GD',BIDON)
          CALL VTCREB(BIDON,NUME,'G','R',NEQ)
          CALL VECGME(MODELE,CARAC,MATER,CHARGE,INFOCH,PARTPS,
     &                CHDEPL,BIDON,VECGMP,PARTPS,COMPOR,K24BID,
     &                LIGREL,CHVIVE)
          CALL ASASVE(VECGMP,NUME,'R',VACGMP)
          CALL ASCOVA('D',VACGMP,FOMULT,'INST',TIME,'R',CNCGMP)
C
C --- POUR UN EVOL_NOLI, PRISE EN COMPTE DES FORCES PILOTEES
          IF (TYPESD.EQ.'EVOL_NOLI') THEN
C - CHARGES PILOTEES (TYPE_CHARGE: 'FIXE_PILO')
            CALL VEFPME(MODELE,CARAC,MATER,CHARGE,INFOCH,PARTPS,
     &                  K24BID,VEFPIP,LIGREL)
            CALL ASASVE(VEFPIP,NUME,'R',VAFPIP)
            CALL ASCOVA('D',VAFPIP,FOMULT,'INST',TIME,'R',CNFPIP)
C - RECUPERATION DU PARAMETRE DE CHARGE ETAN DANS LA SD EVOL_NOLI
            CALL RSADPA(RESUIN,'L',1,'ETA_PILOTAGE',IORDR,0,IAD,
     &                  CTYP)
            ETAN=ZR(IAD)
          ENDIF
C
C --- CALCUL DU CHAMNO DE REACTION PAR DIFFERENCE DES FORCES NODALES
C --- ET DES FORCES EXTERIEURES MECANIQUES NON SUIVEUSES
          CALL JEVEUO(CNCHMP(1:19)//'.VALE','L',JCHMP)
          CALL JEVEUO(CNCGMP(1:19)//'.VALE','L',JCGMP)
          DO 170 J=0,LONCH-1
            ZR(JNOCH+J)=ZR(JFONO+J)-ZR(JCHMP+J)-ZR(JCGMP+J)
  170     CONTINUE
          IF ((TYPESD.EQ.'EVOL_NOLI') .AND. (ETAN.NE.0.D0)) THEN
            CALL JEVEUO(CNFPIP(1:19)//'.VALE','L',JFPIP)
            DO 180 J=0,LONCH-1
              ZR(JNOCH+J)=ZR(JNOCH+J)-ETAN*ZR(JFPIP+J)
  180       CONTINUE
          ENDIF
        ELSE
C         --- CALCUL DU CHAMNO DE REACTION PAR RECOPIE DE FORC_NODA
          DO 190 J=0,LONCH-1
            ZR(JNOCH+J)=ZR(JFONO+J)
  190     CONTINUE
        ENDIF
C
C       --- TRAITEMENT DES MODE_MECA ---
        IF (TYPESD.EQ.'MODE_MECA' .AND. TYPMO(1:8).EQ.'MODE_DYN') THEN
          CALL RSADPA(RESUIN,'L',1,'OMEGA2',IORDR,0,IAD,CTYP)
          OMEGA2=ZR(IAD)
          CALL JEVEUO(CHDEPL(1:19)//'.VALE','L',LDEPL)
          CALL JELIRA(CHDEPL(1:19)//'.VALE','LONMAX',LONC2,K8BID)
          CALL WKVECT('&&'//NOMPRO//'.TRAV','V V R',LONC2,LTRAV)
          IF (LMAT.EQ.0) CALL U2MESS('F','PREPOST3_81')
          CALL MRMULT('ZERO',LMAT,ZR(LDEPL),ZR(LTRAV),1,.TRUE.)
          DO 200 J=0,LONCH-1
            ZR(JNOCH+J)=ZR(JNOCH+J)-OMEGA2*ZR(LTRAV+J)
  200     CONTINUE
          CALL JEDETR('&&'//NOMPRO//'.TRAV')
C
C       --- TRAITEMENT DES MODE_STAT ---
        ELSEIF (TYPESD.EQ.'MODE_MECA' .AND.
     &          TYPMO(1:8).EQ.'MODE_STA') THEN
          CALL RSADPA(RESUIN,'L',1,'TYPE_DEFO',IORDR,0,IAD,CTYP)
          IF (ZK16(IAD)(1:9).EQ.'FORC_IMPO') THEN
            CALL RSADPA(RESUIN,'L',1,'NUME_DDL',IORDR,0,IAD,CTYP)
            INUME=ZI(IAD)
            ZR(JNOCH+INUME-1)=ZR(JNOCH+INUME-1)-1.D0
          ELSEIF (ZK16(IAD)(1:9).EQ.'ACCE_IMPO') THEN
            CALL JELIRA(CHDEPL(1:19)//'.VALE','LONMAX',LONC2,K8BID)
            CALL RSADPA(RESUIN,'L',1,'COEF_X',IORDR,0,IAD,CTYP)
            COEF(1)=ZR(IAD)
            CALL RSADPA(RESUIN,'L',1,'COEF_Y',IORDR,0,IAD,CTYP)
            COEF(2)=ZR(IAD)
            CALL RSADPA(RESUIN,'L',1,'COEF_Z',IORDR,0,IAD,CTYP)
            COEF(3)=ZR(IAD)
            CALL WKVECT('&&'//NOMPRO//'.POSI_DDL','V V I',3*LONC2,
     &                  JDDL)
            CALL PTEDDL('NUME_DDL',NUME,3,NOMCMP,LONC2,ZI(JDDL))
            CALL WKVECT('&&'//NOMPRO//'.POSI_DDR','V V R',LONC2,
     &                  JDDR)
            DO 220 IC=1,3
              IND=LONC2*(IC-1)
              DO 210 J=0,LONC2-1
                ZR(JDDR+J)=ZR(JDDR+J)+ZI(JDDL+IND+J)*COEF(IC)
  210         CONTINUE
  220       CONTINUE
            CALL WKVECT('&&'//NOMPRO//'.TRAV','V V R',LONC2,LTRAV)
            IF (LMAT.EQ.0) CALL U2MESS('F','PREPOST3_81')
            CALL MRMULT('ZERO',LMAT,ZR(JDDR),ZR(LTRAV),1,.TRUE.)
            DO 230 J=0,LONCH-1
              ZR(JNOCH+J)=ZR(JNOCH+J)-ZR(LTRAV+J)
  230       CONTINUE
            CALL JEDETR('&&'//NOMPRO//'.POSI_DDR')
            CALL JEDETR('&&'//NOMPRO//'.POSI_DDL')
            CALL JEDETR('&&'//NOMPRO//'.TRAV')
          ENDIF
C
C       --- TRAITEMENT DE DYNA_TRANS ---
        ELSEIF (TYPESD.EQ.'DYNA_TRANS') THEN
          CALL RSEXCH(' ',RESUIN,'ACCE',IORDR,CHACCE,IRET)
          IF (IRET.EQ.0) THEN
            CALL JEVEUO(CHACCE(1:19)//'.VALE','L',LACCE)
            CALL WKVECT('&&'//NOMPRO//'.TRAV','V V R',LONCH,LTRAV)
            IF (LMAT.EQ.0) CALL U2MESS('F','PREPOST3_81')
            CALL MRMULT('ZERO',LMAT,ZR(LACCE),ZR(LTRAV),1,.TRUE.)
            DO 240 J=0,LONCH-1
              ZR(JNOCH+J)=ZR(JNOCH+J)+ZR(LTRAV+J)
  240       CONTINUE
            CALL JEDETR('&&'//NOMPRO//'.TRAV')
          ELSE
            CALL U2MESS('A','CALCULEL3_1')
          ENDIF
C
C       --- TRAITEMENT DE DYNA_HARMO ---
        ELSEIF (TYPESD.EQ.'DYNA_HARMO') THEN
          CALL RSEXCH(' ',RESUIN,'ACCE',IORDR,CHACCE,IRET)
          IF (IRET.EQ.0) THEN
            CALL JEVEUO(CHACCE(1:19)//'.VALE','L',LACCE)
            CALL WKVECT('&&'//NOMPRO//'.TRAV','V V C',LONCH,LTRAV)
            IF (LMAT.EQ.0) CALL U2MESS('F','PREPOST3_81')
            CALL MCMULT('ZERO',LMAT,ZC(LACCE),ZC(LTRAV),1,.TRUE.)
            DO 250 J=0,LONCH-1
              ZR(JNOCH+J)=ZR(JNOCH+J)+DBLE(ZC(LTRAV+J))
  250       CONTINUE
            CALL JEDETR('&&'//NOMPRO//'.TRAV')
          ELSE
            CALL U2MESS('A','CALCULEL3_1')
          ENDIF
C
C       --- TRAITEMENT DE EVOL_NOLI ---
        ELSEIF (TYPESD.EQ.'EVOL_NOLI') THEN
          CALL RSEXCH(' ',RESUIN,'ACCE',IORDR,CHACCE,IRET)
          IF (IRET.EQ.0) THEN
            OPTIO2='M_GAMMA'
C
C           --- CALCUL DES MATRICES ELEMENTAIRES DE MASSE
            CALL MEMAM2(OPTIO2,MODELE,NBCHAR,ZK8(ICHAR),MATER,CARAC,
     &                  COMPOR,EXITIM,TIME,CHACCE,VRENO,'V',LIGREL)
C
C           --- ASSEMBLAGE DES VECTEURS ELEMENTAIRES ---
            CALL ASASVE(VRENO,NUME,'R',VARENO)
            CALL JEVEUO(VARENO,'L',JREF)
            CALL JEVEUO(ZK24(JREF)(1:19)//'.VALE','L',JRENO)
            DO 260 J=0,LONCH-1
              ZR(JNOCH+J)=ZR(JNOCH+J)+ZR(JRENO+J)
  260       CONTINUE
          ENDIF
        ENDIF
C
  270   CONTINUE
        CALL RSNOCH(RESUIN,OPTION,IORDR)
C
        IF (TYPESD.EQ.'EVOL_THER') THEN
          CALL NTDOTH(MODELE,MATER,CARAC,K24B,LBID,LBID,INFCHA,
     &                RESUOU(1:8),IORDR)
        ELSE
          CALL NMDOME(MODELE,MATER,CARAC,INFCHA,RESUOU(1:8),
     &                IORDR)
        ENDIF
        CALL DETRSD('CHAMP_GD','&&'//NOMPRO//'.SIEF')
        CALL DETRSD('VECT_ELEM',VFONO(1:8))
        CALL DETRSD('VECT_ELEM',VRENO(1:8))
        CALL DETRSD('VECT_ELEM',VECHMP(1:8))
        CALL DETRSD('VECT_ELEM',VECGMP(1:8))
        CALL DETRSD('VECT_ELEM',VEFPIP(1:8))
        CALL DETRSD('CHAMP_GD',CNCHMP(1:8)//'.ASCOVA')
        CALL DETRSD('CHAMP_GD',CNCGMP(1:8)//'.ASCOVA')
        CALL DETRSD('CHAMP_GD',CNFPIP(1:8)//'.ASCOVA')
        CALL JEDETR(VACHMP(1:8))
        CALL JEDETR(VACGMP(1:8))
        CALL JEDETR(VAFPIP(1:8))
        CALL JEDETR(VACHMP(1:6)//'00.BIDON')
        CALL JEDETR(VACGMP(1:6)//'00.BIDON')
        CALL JEDETR(VAFPIP(1:6)//'00.BIDON')
        CALL JEDETR(VACHMP(1:6)//'00.BIDON     .VALE')
        CALL JEDETR(VACGMP(1:6)//'00.BIDON     .VALE')
        CALL JEDETR(VAFPIP(1:6)//'00.BIDON     .VALE')
        CALL JEDETR(VACHMP(1:6)//'00.BIDON     .DESC')
        CALL JEDETR(VACGMP(1:6)//'00.BIDON     .DESC')
        CALL JEDETR(VAFPIP(1:6)//'00.BIDON     .DESC')
        CALL JEDETR(VACHMP(1:6)//'00.BIDON     .REFE')
        CALL JEDETR(VACGMP(1:6)//'00.BIDON     .REFE')
        CALL JEDETR(VAFPIP(1:6)//'00.BIDON     .REFE')
        CALL JEDETR(VACHMP(1:8)//'.ASCOVA')
        CALL JEDETR(VACGMP(1:8)//'.ASCOVA')
        CALL JEDETR(VAFPIP(1:8)//'.ASCOVA')
  280   CONTINUE
        CALL JEDEMA()
  290 CONTINUE
      CALL DETRSD('CHAMP_GD',BIDON)
      CALL JEDEMA()
      END
