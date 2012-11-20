      SUBROUTINE RSLESD (RESULT,NUORD,MODELE,MATERI,CARELE,EXCIT,
     &                   IEXCIT)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      INTEGER      NUORD,IEXCIT
      CHARACTER*8  RESULT,MODELE,CARELE,MATERI
      CHARACTER*19 EXCIT
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 20/11/2012   AUTEUR FLEJOU J-L.FLEJOU 
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
C RESPONSABLE PELLET J.PELLET
C
C     BUT:
C         LIRE OU ECRIRE DES NOMS DE CONCEPT DE LA SD RESULTAT ET
C         D'EXPLOITER DES OBJETS DE LA SD CORRESPONDANT AUX CHARGES.
C
C
C     ARGUMENTS:
C     ----------
C
C      ENTREE :
C-------------
C IN   RESULT : NOM DE LA SD RESULTAT
C IN   NUORD  : NUMERO D'ORDRE
C
C      SORTIE :
C-------------
C OUT  MODELE : NOM DU MODELE
C OUT  MATERI : NOM DU CHAMP MATERIAU
C OUT  CARELE : NOM DE LA CARACTERISTIQUE ELEMENTAIRE CARA_ELEM
C OUT  EXCIT  : NOM DE LA SD INFO_CHARGE
C OUT  IEXCIT : INDICE DEFINISSANT L'ORIGINE DU CHARGEMENT
C                      UTILISE LORS DES CALCLULS
C                      0 : LE CHARGEMENT EST ISSU DE LA SD RESULTAT
C                      1 : LE CHARGEMENT EST FOURNI PAR L'UTILISATEUR
C
C ......................................................................


      INTEGER      JPARA,N1,N2,N3,N4,IEX,JLCHA,JINFC,JFCHA,NCHA
      INTEGER      ILU,ISD,NCHALU,NCHASD,LCHALU,FCHALU,VALI(2)
      INTEGER      GETEXM

      CHARACTER*6  NOMPRO
      CHARACTER*8  NOMSD,NOMLU,FONCLU,K8B,FONCSD
      CHARACTER*16 TYPE,NOMCMD
      CHARACTER*19 KCHA, KFON
      CHARACTER*24 EXCISD,VALK(4)

      PARAMETER(NOMPRO='RSLESD')
      INTEGER      IARG

C ----------------------------------------------------------------------

      CALL JEMARQ()
C
C--- INITIALISATIONS
C               123456789012345678901234
      KCHA   = '&&'//NOMPRO//'.CHARGE    '
      KFON   = '&&'//NOMPRO//'.FONC_MULT '
      IEXCIT = 0
      N4     = 0
C
      CALL GETRES(K8B,TYPE,NOMCMD)

C
C==========================================================
C
C     T R A I T E M E N T  DU  M O D E L E
C
C==========================================================
C

C---  RECUPERATION DU NOM DU MODELE
C
      N1=0
      NOMLU=' '
      IF (GETEXM(' ','MODELE').EQ.1) THEN
        CALL GETVID(' ','MODELE'    ,0,IARG,1,NOMLU,N1)
      ENDIF

      CALL RSADPA(RESULT,'L',1,'MODELE',NUORD,0,JPARA,K8B)
      NOMSD=ZK8(JPARA)

      IF (NOMSD.NE.' ')THEN
        IF (N1.EQ.0) THEN
           MODELE = NOMSD
        ELSEIF (NOMSD.EQ.NOMLU) THEN
           MODELE = NOMLU
        ELSE
          CALL U2MESS('A','UTILITAI4_37')
          MODELE = NOMLU
        ENDIF
      ELSE
        IF (N1.NE.0) THEN
           MODELE = NOMLU
        ELSE
           MODELE = ' '
        ENDIF
      ENDIF

      IF(NOMSD.EQ.' '.AND.NOMLU.NE.' ') THEN
         CALL RSADPA(RESULT,'E',1,'MODELE',NUORD,0,JPARA,K8B)
         ZK8(JPARA)=MODELE
      ENDIF
C
C==========================================================
C
C     T R A I T E M E N T   D U   C A R A _ E L E M
C
C==========================================================
C
C--- RECUPERATION DU NOM DU CARA_ELEM
C
      CALL RSADPA(RESULT,'L',1,'CARAELEM',NUORD,0,JPARA,K8B)
      NOMSD=ZK8(JPARA)
      IF (GETEXM(' ','CARA_ELEM').EQ.1) THEN
        CALL GETVID(' ','CARA_ELEM',0,IARG,1,NOMLU,N2)
      ELSE
        N2=0
        NOMLU=' '
      ENDIF

      IF (NOMSD.NE.' ')THEN
        IF (N2.EQ.0) THEN
           CARELE = NOMSD
        ELSEIF (NOMSD.EQ.NOMLU) THEN
           CARELE = NOMLU
        ELSE
           CALL U2MESS('A','UTILITAI4_38')
           CARELE = NOMLU
        ENDIF
      ELSE
        IF (N2.NE.0) THEN
           CARELE = NOMLU
        ELSE
           CARELE = ' '
        ENDIF
      ENDIF

      IF(NOMSD.EQ.' '.AND.NOMLU.NE.' ') THEN
         CALL RSADPA(RESULT,'E',1,'CARAELEM',NUORD,0,JPARA,K8B)
         ZK8(JPARA)=CARELE
      ENDIF
C
C==========================================================
C
C     T R A I T E M E N T   D U   M A T E R I A U
C
C==========================================================

C
C---  RECUPERATION DU NOM DU CHAMP MATERIAU
C
      IF (GETEXM(' ','CHAM_MATER').EQ.1) THEN
        CALL GETVID(' ','CHAM_MATER',0,IARG,1,NOMLU,N3)
      ELSE
        N3=0
        NOMLU=' '
      ENDIF

      CALL RSADPA(RESULT,'L',1,'CHAMPMAT',NUORD,0,JPARA,K8B)
      NOMSD=ZK8(JPARA)

      IF (NOMSD.NE.' ')THEN
        IF (N3.EQ.0) THEN
           MATERI = NOMSD
        ELSEIF (NOMSD.EQ.NOMLU) THEN
           MATERI = NOMLU
        ELSE
           CALL U2MESS('A','UTILITAI4_39')
          MATERI = NOMLU
        ENDIF
      ELSE
        IF (N3.NE.0) THEN
           MATERI = NOMLU
        ELSE
           MATERI = ' '
        ENDIF
      ENDIF

      IF(NOMSD.EQ.' '.AND.NOMLU.NE.' ') THEN
         CALL RSADPA(RESULT,'E',1,'CHAMPMAT',NUORD,0,JPARA,K8B)
         ZK8(JPARA)=MATERI
      ENDIF

C
C==========================================================
C
C     T R A I T E M E N T   D E S    C H A R G E M E N T S
C
C==========================================================
C
C--- RECUPERATION DES CHARGEMENTS 'EXCIT'
C
C--- LECTURE DES INFORMATIONS UTILISATEUR
C
      NCHALU=0
C
      IF (GETEXM('EXCIT','CHARGE').EQ.1) THEN
         CALL GETFAC('EXCIT',NCHALU)
C
         IF ( NCHALU .NE. 0 ) THEN
            CALL WKVECT(KCHA,'V V K8',NCHALU,LCHALU)
            CALL WKVECT(KFON,'V V K8',NCHALU,FCHALU)
C
            DO 10 IEX = 1, NCHALU
               CALL GETVID('EXCIT','CHARGE',IEX,IARG,1,
     &                     ZK8(LCHALU+IEX-1),N1)
C
               CALL GETVID('EXCIT','FONC_MULT',IEX,IARG,1,FONCLU,N2)
               IF (N2.NE.0) THEN
                  ZK8(FCHALU+IEX-1) = FONCLU
               ENDIF
  10        CONTINUE
         ENDIF
      ENDIF

      IF (GETEXM(' ','CHARGE').EQ.1) THEN
         CALL GETVID(' ','CHARGE'    ,0,IARG,0,K8B   ,N4)
         NCHA = -N4
         NCHALU = MAX(1,NCHA)
         CALL WKVECT( KCHA ,'V V K8',NCHALU,LCHALU)
         CALL GETVID(' ','CHARGE',0,IARG,NCHA,ZK8(LCHALU),N4)
      ENDIF
C
C--- LECTURE DES INFORMATIONS CONTENUES DANS LA SD RESULTAT
C
      CALL RSADPA(RESULT,'L',1,'EXCIT',NUORD,0,JPARA,K8B)
      EXCISD=ZK24(JPARA)
C
C--- VERIFICATIONS ET AFFECTATIONS
C
C     IEXCIT = 0 SD RESULTAT
C            = 1 UTILISATEUR
      IF(NOMCMD.EQ.'POST_ELEM') THEN
         IF (N4.EQ.0)  THEN
            IEXCIT = 0
            NCHALU = 0
         ELSE
            IEXCIT = 1
         ENDIF
      ELSE
         IF (NCHALU.NE.0)  IEXCIT = 1
      ENDIF
C
      IF (NCHALU.EQ.0.AND.EXCISD(1:1).EQ.' ') IEXCIT = 1
C
      IF (EXCISD.NE.' ') THEN
         EXCIT = EXCISD(1:19)
         CALL JEVEUO(EXCIT(1:19)//'.LCHA','L',JLCHA)
         CALL JEVEUO(EXCIT(1:19)//'.INFC','L',JINFC)
         CALL JEVEUO(EXCIT(1:19)//'.FCHA','L',JFCHA)
         NCHASD = ZI(JINFC)
      ELSE
         VALK(1) = RESULT
         IF ( NCHALU.EQ.0 ) THEN
            CALL U2MESK('I','UTILITAI4_2',1,VALK)
         ELSE
            CALL U2MESK('I','UTILITAI4_1',1,VALK)
         ENDIF
      ENDIF
C
C--- VERIFICATIONS DES CHARGEMENTS
C
      IF( (NCHALU.NE.0).AND.(EXCISD.NE.' ') ) THEN
C
C--- VERIFICATION DE LA COHERENCE DU NOMBRE DE CHARGES ENTRE
C    CELLES PRESENTES DANS LA SD RESULTAT ET CELLES FOURNIES
C    PAR L'UTILISATEUR
         IF(NCHALU.NE.NCHASD) THEN
            VALI(1)=NCHALU
            VALI(2)=NCHASD
            CALL U2MESI('A','CALCULEL6_65',2,VALI)
         ENDIF
C
C--- VERIFICATIONS DU NOM DES CHARGEMENTS
C
         DO 40 ILU = 1,NCHALU
            DO 20 ISD = 1,NCHASD
               IF(ZK8(LCHALU-1+ILU).EQ.ZK24(JLCHA-1+ISD)(1:8)) GOTO 30
20          CONTINUE
            CALL U2MESS('A','UTILITAI4_40')
30          CONTINUE
40       CONTINUE
C
C--- VERIFICATIONS DU NOM DES FONCTION MULTIPLICATRICES
C
         IF(NOMCMD.NE.'POST_ELEM') THEN
            DO 70 ILU = 1,NCHALU
               DO 50 ISD = 1,NCHASD
                  FONCSD = ZK24(JFCHA-1+ISD)(1:8)
                  IF(FONCSD(1:2).EQ.'&&') FONCSD = ' '
                  IF(ZK8(FCHALU-1+ILU).EQ.FONCSD) GOTO 60
50             CONTINUE
               CALL U2MESS('A','UTILITAI4_41')
60          CONTINUE
70          CONTINUE
         ENDIF
C
C--- VERIFICATIONS DES COUPLES NOM DE CHARGE ET FONCTION MULTIPLICATRICE
C    FOURNI PAR L'UTILISATEUR AVEC CEUX PRESENTS DANS LA SD RESULTAT
C
         IF(NOMCMD.NE.'POST_ELEM') THEN
            DO 80 ILU = 1,NCHALU
               DO 90 ISD = 1,NCHASD
                  IF(ZK8(LCHALU-1+ILU).EQ.ZK24(JLCHA-1+ISD)(1:8)) THEN
                     FONCSD = ZK24(JFCHA-1+ISD)(1:8)
                     IF(FONCSD(1:2).EQ.'&&') FONCSD = ' '
                     IF(ZK8(FCHALU-1+ILU).EQ.FONCSD) GOTO 95
                     VALK(1)=ZK8(LCHALU-1+ILU)
                     VALK(2)=ZK8(FCHALU-1+ILU)
                     VALK(3)=ZK24(JLCHA-1+ISD)(1:8)
                     VALK(4)=FONCSD
                     CALL U2MESK('A','CALCULEL6_66',4,VALK)
                  ENDIF
 90            CONTINUE
 95            CONTINUE
 80         CONTINUE
         ENDIF
      ENDIF
C
C--- MENAGE
C
      CALL JEDETR(KCHA)
      CALL JEDETR(KFON)
C
      CALL JEDEMA()
      END
