      SUBROUTINE CALCOP(OPTION,RESUIN,RESUOU,NBORDR,LORDRE,
     &                  KCHARG,NCHARG,CHTYPE,TYPESD,NBCHRE,
     &                  IOCCUR,SUROPT,CODRET)
      IMPLICIT NONE
C     --- ARGUMENTS ---
      INTEGER      NBORDR,LORDRE(*),NCHARG,CODRET,NBCHRE,IOCCUR
      CHARACTER*4  CHTYPE
      CHARACTER*8  RESUIN,RESUOU
      CHARACTER*16 OPTION,TYPESD
      CHARACTER*19 KCHARG
      CHARACTER*24 SUROPT
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 07/12/2010   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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
C  CALC_CHAMP - CALCUL D'UNE OPTION
C                ---          --
C ----------------------------------------------------------------------
C
C  ROUTINE DE BASE DE CALC_CHAMP
C
C IN  :
C   OPTION  K16  NOM DE L'OPTION A CALCULER
C   RESUIN  K8   NOM DE LA STRUCTURE DE DONNEES RESULTAT IN
C   RESUOU  K8   NOM DE LA STRUCTURE DE DONNEES RESULTAT OUT
C   NBORDR  I    NOMBRE DE NUMEROS D'ORDRE
C   LORDRE  I*   LISTE DE NUMEROS D'ORDRE
C   KCHARG  K19  NOM DE L'OBJET JEVEUX CONTENANT LES CHARGES
C   NCHARG  I    NOMBRE DE CHARGES
C   CHTYPE  K4   TYPE DES CHARGES
C   TYPESD  K16  TYPE DE LA STRUCTURE DE DONNEES RESULTAT
C   NBCHRE  I    NOMBRE DE CHARGES REPARTIES (POUTRES)
C   IOCCUR  I    NUMERO D'OCCURENCE OU SE TROUVE LE CHARGE REPARTIE
C   SUROPT  K24
C
C OUT :
C   CODRET  I    CODE RETOUR (0 SI OK, 1 SINON)
C ----------------------------------------------------------------------
C RESPONSABLE SELLENET N.SELLENET
C     ----- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER        ZI
      COMMON /IVARJE/ZI(1)
      REAL*8         ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16     ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL        ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8    ZK8
      CHARACTER*16          ZK16
      CHARACTER*24                  ZK24
      CHARACTER*32                          ZK32
      CHARACTER*80                                  ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     ----- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
      LOGICAL      EXITIM,EXIPOU,OPTDEM

      INTEGER      NOPOUT,JLISOP,IOP,IBID,NBORD2,LRES,IER,NBVAL
      INTEGER      NBTROU,MINORD,MAXORD,JLINST,IORDR,NBORDL,IFISS
      INTEGER      NBPAIN,NUMORD,IEXCIT,NBPAOU,IRET,NPASS

      REAL*8       R8B

      COMPLEX*16   C16B

      CHARACTER*8  MODELE,CARAEL,K8B,LIPAIN(100),LIPAOU(1)
      CHARACTER*8  NOMA,NOBASE,POUX,NOMCMP
      CHARACTER*16 OPTIO2,NOMCHA
      CHARACTER*19 EXCIT
      CHARACTER*24 LICHIN(100),LICHOU(2),LIGREL,MATECO
      CHARACTER*24 NOLIOP,LISINS
      CHARACTER*32 JEXNOM

      CALL JEMARQ()
      CODRET = 1
      NPASS = 0
      NOBASE = '&&CALCOP'

      IF ( (OPTION.EQ.'DEDE_ELNO_DLDE').OR.
     &     (OPTION.EQ.'DESI_ELNO_DLSI').OR.
     &     (OPTION.EQ.'DETE_ELNO_DLTE').OR.
     &     (OPTION.EQ.'DEUL_ELGA_DEPL').OR.
     &     (OPTION.EQ.'DEUL_ELGA_TEMP').OR.
     &     (OPTION.EQ.'DISS_ELGA').OR.
     &     (OPTION.EQ.'DISS_ELNO_ELGA').OR.
     &     (OPTION.EQ.'ENDO_ELNO_SIGA').OR.
     &     (OPTION.EQ.'ENDO_ELNO_SINO').OR.
     &     (OPTION.EQ.'ERME_ELEM').OR.
     &     (OPTION.EQ.'ERTH_ELEM').OR.
     &     (OPTION.EQ.'ERME_ELNO').OR.
     &     (OPTION.EQ.'ERTH_ELNO').OR.
     &     (OPTION.EQ.'ERZ1_ELEM_SIGM').OR.
     &     (OPTION.EQ.'ERZ2_ELEM_SIGM') ) GOTO 9999
      IF ( (OPTION.EQ.'HYDR_ELNO_ELGA').OR.
     &     (OPTION.EQ.'PROJ_ELEM_SIGM').OR.
     &     (OPTION.EQ.'QIRE_ELEM_SIGM').OR.
     &     (OPTION.EQ.'QIRE_ELNO_ELEM').OR.
     &     (OPTION.EQ.'QIZ1_ELEM_SIGM').OR.
     &     (OPTION.EQ.'QIZ2_ELEM_SIGM').OR.
     &     (OPTION.EQ.'SIGM_NOZ1_ELGA').OR.
     &     (OPTION.EQ.'SIGM_NOZ2_ELGA').OR.
     &     (OPTION.EQ.'SING_ELEM').OR.
     &     (OPTION.EQ.'SING_ELNO_ELEM').OR.
     &     (OPTION.EQ.'EQUI_ELNO_SIGM') ) GOTO 9999
      IF ( (OPTION.EQ.'ETOT_ELEM').OR.
     &     (OPTION.EQ.'ETOT_ELGA').OR.
     &     (OPTION.EQ.'ETOT_ELGA_DEPL').OR.
     &     (OPTION.EQ.'ETOT_ELNO_ELGA').OR.
     &     (OPTION.EQ.'SIGM_ELNO_DEPL').OR.
     &     (OPTION.EQ.'EFGE_ELNO_CART').OR.
     &     (OPTION.EQ.'EFGE_ELNO_DEPL').OR.
     &     (OPTION(1:5).EQ.'DCHA_').OR.
     &     (OPTION(1:5).EQ.'RADI_') ) GOTO 9999

      CALL CCLIOP(OPTION,NOBASE,NOLIOP,NOPOUT)
      IF ( NOPOUT.EQ.0 ) GOTO 9999

      CALL JEVEUO(NOLIOP,'L',JLISOP)

      EXITIM = .FALSE.
      CALL JENONU(JEXNOM(RESUIN//'           .NOVA','INST'),IRET)
      IF (IRET.NE.0) EXITIM = .TRUE.

      CALL RSORAC(RESUIN,'TOUT_ORDRE',IBID,R8B,K8B,C16B,R8B,K8B,
     &            NBORD2,1,NBTROU)
      IF ( NBTROU.LT.0 ) NBTROU = -NBTROU
      CALL WKVECT('&&CALCOP.NB_ORDRE','V V I',NBTROU,LRES)
      CALL RSORAC(RESUIN,'TOUT_ORDRE',IBID,R8B,K8B,C16B,R8B,
     &            K8B,ZI(LRES),NBTROU,NBORD2)
C     ON EN EXTRAIT LE MIN ET MAX DES NUMEROS D'ORDRE DE LA SD_RESUTLAT
      MINORD = ZI(LRES)
      MAXORD = ZI(LRES+NBORD2-1)

      CALL RSLESD(RESUIN,MINORD,MODELE,MATECO(1:8),CARAEL,EXCIT,IEXCIT)
      CALL JEEXIN(MODELE(1:8)//'.FISS',IFISS)
      IF (IFISS.NE.0.AND.OPTION.EQ.'SIEF_ELNO_ELGA') THEN
        NOPOUT = 0
        GOTO 9998
      ENDIF
      CALL DISMOI('F','NOM_MAILLA',MODELE,'MODELE',IBID,NOMA,IRET)

      POUX = 'NON'
      CALL DISMOI('F','EXI_POUX',MODELE,'MODELE',IBID,POUX,IER)
      EXIPOU = .FALSE.
      IF (POUX.EQ.'OUI') EXIPOU = .TRUE.

C     COMME ON PARCOURT LES OPTIONS DANS L'ORDRE INVERSE DES DEPENDANCES
C     ON SAIT QUE LES LISTES D'INSTANT SERONT CORRECTEMENT CREES
      DO 10 IOP = 1,NOPOUT
        OPTIO2 = ZK24(JLISOP+IOP-1)
        IF ( OPTION.EQ.'VALE_NCOU_MAXI' ) THEN
          CALL GETVTX(' ','NOM_CHAM',1,1,1,NOMCHA,NBVAL)
          CALL GETVTX(' ','NOM_CMP',1,1,1,NOMCMP,NBVAL)
        ENDIF

        IF ( OPTION.EQ.OPTIO2 ) THEN
          OPTDEM = .TRUE.
        ELSE
          OPTDEM = .FALSE.
        ENDIF

        CALL CCLORD(IOP,NBORDR,LORDRE,NOBASE,OPTDEM,
     &              MINORD,MAXORD,RESUIN,RESUOU,LISINS)

        CALL JEVEUO(LISINS,'L',JLINST)
        NBORDL = ZI(JLINST)
        DO 20 IORDR = 1,NBORDL
          NUMORD = ZI(JLINST+IORDR+2)

          CALL MEDOM2(MODELE,MATECO,CARAEL,KCHARG,NCHARG,CHTYPE,
     &                RESUIN,NUMORD,NBORDR,NPASS,LIGREL)

          CALL CCLPCI(OPTIO2,MODELE,RESUIN,RESUOU,MATECO(1:8),
     &                CARAEL,TYPESD,LIGREL,NUMORD,NBPAIN,
     &                LIPAIN,LICHIN,IRET)

          IF ( IRET.NE.0 ) THEN
            CODRET = 1
            GOTO 9998
          ENDIF

          CALL CCLPCO(OPTIO2,RESUOU,NUMORD,NBPAOU,LIPAOU,
     &                LICHOU)

C         A PARTIR D'ICI, ON TRAITE LES CAS PARTICULIERS
          IF ( EXIPOU ) THEN
            CALL CCPOUX(RESUIN,TYPESD,NUMORD,NBCHRE,IOCCUR,
     &                  KCHARG,MODELE,NBPAIN,LIPAIN,LICHIN,
     &                  SUROPT,IRET)
            IF ( IRET.NE.0 ) GOTO 10
          ENDIF

          CALL CCACCL(OPTIO2,MODELE,RESUIN,MATECO(1:8),CARAEL,
     &                LIGREL,ZI(JLINST+3),IORDR,TYPESD,NBPAIN,
     &                LIPAIN,LICHIN,EXITIM,NOMCHA,NOMCMP,
     &                LICHOU,IRET)
          IF ( IRET.NE.0 ) GOTO 10
C         FIN DES CAS PARTICULIERS

          CALL MECEUC('C',POUX,OPTIO2,LIGREL,NBPAIN,
     &                LICHIN,LIPAIN,NBPAOU,LICHOU,LIPAOU,'G')
          CALL RSNOCH(RESUOU,OPTIO2,NUMORD,' ')

          IF (POUX.EQ.'OUI') CALL JEDETC('V','&&MECHPO',1)
          CALL DETRSD('CHAM_ELEM_S',LICHOU(1))
   20   CONTINUE
   10 CONTINUE

      CODRET = 0

 9998 CONTINUE

      CALL JEDETR('&&CALCOP.NB_ORDRE')

      CALL CCNETT(NOBASE,NOPOUT)

 9999 CONTINUE

      CALL JEDEMA()

      END
