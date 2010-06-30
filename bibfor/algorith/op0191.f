      SUBROUTINE OP0191()
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 30/06/2010   AUTEUR DELMAS J.DELMAS 
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
C RESPONSABLE JMBHH01 J.M.PROIX
      IMPLICIT   NONE
C ----------------------------------------------------------------------
C
C     COMMANDE : MODI_REPERE
C
C ----------------------------------------------------------------------
C ----- DEBUT COMMUNS NORMALISES  JEVEUX  ------------------------------
      INTEGER           ZI
      COMMON / IVARJE / ZI(1)
      REAL*8            ZR
      COMMON / RVARJE / ZR(1)
      COMPLEX*16        ZC
      COMMON / CVARJE / ZC(1)
      LOGICAL           ZL
      COMMON / LVARJE / ZL(1)
      CHARACTER*8       ZK8
      CHARACTER*16              ZK16
      CHARACTER*24                       ZK24
      CHARACTER*32                                ZK32
      CHARACTER*80                                         ZK80
      COMMON / KVARJE / ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
      CHARACTER*32      JEXNUM, JEXNOM
C ----- FIN COMMUNS NORMALISES  JEVEUX  -------------------------------
C
      INTEGER      N0    , NBORDR, IRET  , NOCC  , I , J  , NP, IORDR
      INTEGER VALI
      INTEGER      N1    , NBCMP , IORD  , IOC , IBID, NC
      INTEGER      JORDR , NBCHAM, NBNOSY, JPA, IADIN, IADOU
      INTEGER      NBPARA, NBAC  , NBPA  , IFM   , NIV
      REAL*8       PREC
      CHARACTER*8  CRIT  , REPERE, K8B   , TYCH  , NOMMA , TYPE
      CHARACTER*16 CONCEP, NOMCMD, K16BID, OPTION, TYSD
      CHARACTER*19 KNUM  , RESUIN, RESUOU
      CHARACTER*24 NOMPAR, CHAMP0, CHAMP1
      CHARACTER*24 VALK(2)
C ---------------------------------------------------------------------
      CALL JEMARQ()
C
C ----- RECUPERATION DU NOM DE LA COMMANDE -----
C
      CALL INFMAJ
      CALL INFNIV(IFM, NIV)
C
      CALL GETRES ( RESUOU, CONCEP, NOMCMD )
      CALL GETVID ( ' ', 'RESULTAT', 1,1,1, RESUIN, N0 )
C
      CALL JELIRA ( RESUIN//'.DESC', 'NOMMAX', NBNOSY, K8B )
      IF ( NBNOSY .EQ. 0 ) GOTO 9999
C
      CALL GETTCO ( RESUIN, TYSD )
C
C ----- RECUPERATION DU NOMBRE DE CHAMPS SPECIFIER -----
C
      CALL GETFAC ( 'MODI_CHAM', NOCC )
C
C ----- DEFINITION DU REPERE UTILISE -----
C
      CALL GETVTX ( 'DEFI_REPERE', 'REPERE', 1,1,1, REPERE, I )
C
C ----- RECUPERATION DES NUMEROS D'ORDRE DE LA STRUCTURE DE
C ----- DONNEES DE TYPE RESULTAT RESU A PARTIR DES VARIABLES
C ----- D'ACCES UTILISATEUR 'NUME_ORDRE','FREQ','INST','NOEUD_CMP'
C ----- (VARIABLE D'ACCES 'TOUT_ORDRE' PAR DEFAUT)
C
      KNUM = '&&OP0191.NUME_ORDRE'
      CALL GETVR8 ( ' ', 'PRECISION', 1,1,1, PREC, NP )
      CALL GETVTX ( ' ', 'CRITERE'  , 1,1,1, CRIT, NC )
      CALL RSUTNU ( RESUIN, ' ', 1, KNUM, NBORDR, PREC, CRIT, IRET )
      IF (IRET.EQ.10) THEN
         CALL U2MESK('F','CALCULEL4_8',1,RESUIN)
      ENDIF
      IF (IRET.NE.0) THEN
         CALL U2MESS('F','ALGORITH3_41')
      ENDIF
      CALL JEVEUO ( KNUM, 'L', JORDR )
C
      CALL RSCRSD('G', RESUOU, TYSD, NBORDR )
C
      DO 10 IOC = 1 , NOCC
C
         CALL GETVTX ('MODI_CHAM','NOM_CHAM' ,IOC,1,1,OPTION,N0)
         CALL GETVTX ('MODI_CHAM','TYPE_CHAM',IOC,1,1,TYPE  ,N0)
         CALL GETVTX ('MODI_CHAM','NOM_CMP'  ,IOC,1,0,K8B   ,N1)
         NBCMP  = - N1
C
         DO 12 IORD = 1 , NBORDR
            CALL JEMARQ()
            CALL JERECU('V')
            IORDR = ZI(JORDR-1+IORD)
C
            CALL RSEXCH( RESUIN, OPTION, IORDR, CHAMP0, IRET)
            IF ( IRET .NE. 0 ) THEN
               VALK (1) = RESUIN
               VALK (2) = OPTION
               VALI = IORDR
               CALL U2MESG('F', 'ALGORITH13_85',2,VALK,1,VALI,0,0.D0)
            ENDIF
            CALL DISMOI('F','NOM_MAILLA',CHAMP0(1:19),'CHAMP',
     &                   IBID, NOMMA, IRET)
            CALL DISMOI('C','TYPE_CHAMP',CHAMP0,'CHAMP',IBID,
     &                   TYCH, IRET)
C
            CALL RSEXCH ( RESUOU, OPTION, IORDR, CHAMP1, IRET )
C           CHAMP1 SERA ENSUITE RECREE SUR LA BASE GLOBALE
            CALL COPISD ( 'CHAMP_GD', 'V', CHAMP0, CHAMP1 )
C
C ----- RECUPERATION DE LA NATURE DES CHAMPS
C ----- (CHAM_NO OU CHAM_ELEM)
C
            IF (TYCH(1:4).EQ.'NOEU') THEN
               CALL CHRPNO( CHAMP1, REPERE, NBCMP, IOC, TYPE )
            ELSE IF (TYCH(1:2).EQ.'EL') THEN
               CALL CHRPEL( CHAMP1, REPERE, NBCMP, IOC, TYPE, OPTION )
            ELSE
                VALK(1) = TYCH
                VALK(2) = CHAMP1
                CALL U2MESK('A','ALGORITH9_69', 2 ,VALK)
            ENDIF
C
            CALL RSNOCH ( RESUOU, OPTION, IORDR, ' ' )
C
            CALL JEDEMA()
 12      CONTINUE
 10   CONTINUE
C
      NOMPAR = '&&OP0191.NOMS_PARA'
      CALL RSNOPA ( RESUIN, 2, NOMPAR, NBAC, NBPA )
      NBPARA = NBAC + NBPA
      CALL JEVEUO ( NOMPAR, 'L', JPA )
      DO 20 IORD = 1,NBORDR
         IORDR = ZI(JORDR-1+IORD)
         DO 22 J = 1,NBPARA
            CALL RSADPA(RESUIN,'L',1,ZK16(JPA+J-1),IORDR,1,IADIN,TYPE)
            CALL RSADPA(RESUOU,'E',1,ZK16(JPA+J-1),IORDR,1,IADOU,TYPE)
            IF (TYPE(1:1).EQ.'I') THEN
               ZI(IADOU) = ZI(IADIN)
            ELSE IF (TYPE(1:1).EQ.'R') THEN
               ZR(IADOU) = ZR(IADIN)
            ELSE IF (TYPE(1:1).EQ.'C') THEN
               ZC(IADOU) = ZC(IADIN)
            ELSE IF (TYPE(1:3).EQ.'K80') THEN
               ZK80(IADOU) = ZK80(IADIN)
            ELSE IF (TYPE(1:3).EQ.'K32') THEN
               ZK32(IADOU) = ZK32(IADIN)
            ELSE IF (TYPE(1:3).EQ.'K24') THEN
               ZK24(IADOU) = ZK24(IADIN)
            ELSE IF (TYPE(1:3).EQ.'K16') THEN
               ZK16(IADOU) = ZK16(IADIN)
            ELSE IF (TYPE(1:2).EQ.'K8') THEN
               ZK8(IADOU) = ZK8(IADIN)
            END IF
 22      CONTINUE
 20   CONTINUE

      CALL TITRE

      IF(NIV.EQ.2) CALL RSINFO(RESUOU,IFM)

 9999 CONTINUE


C     -- CREATION DE L'OBJET .REFD SI NECESSAIRE:
C     -------------------------------------------
      CALL AJREFD(RESUIN,RESUOU,'ZERO')

      CALL JEDEMA( )
C
      END
