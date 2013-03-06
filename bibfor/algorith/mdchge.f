      SUBROUTINE MDCHGE ( NUMDDL, TYPNUM, IMODE, IAMOR, PULSAT, MASGEN,
     &                    AMOGEN, LFLU, NBNLI, NOECHO, LOGCHO, PARCHO,
     &                    INTITU, DDLCHO, IER )
      IMPLICIT  NONE
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNOM
      INTEGER             NBNLI, IAMOR, IMODE, IER, LOGCHO(NBNLI,*),
     &                    DDLCHO(*)
      REAL*8              PARCHO(NBNLI,*),PULSAT(*),MASGEN(*),AMOGEN(*)
      LOGICAL             LFLU
      CHARACTER*8         NOECHO(NBNLI,*), INTITU(*)
      CHARACTER*14        NUMDDL
      CHARACTER*16        TYPNUM
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 05/03/2013   AUTEUR BRIE N.BRIE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
C     ROUTINE APPELEE PAR MDCHOC
C     TRAITEMENT DU CAS OU NUME_DDL = 'NUME_DDL_GENE'
C
C IN  : NUMDDL : NOM DE LA NUMEROTATION
C IN  : TYPNUM : TYPE DE LA NUMEROTATION
C IN  : IMODE  : NUMERO DU MODE DE MASSE LA PLUS ELEVEE
C IN  : IAMOR  : NUMERO DE L'AMORTISSEMENT ASSOCIE
C IN  : PULSAT : PULSATIONS DES MODES
C IN  : MASGEN : MASSES GENERALISEES DES MODES
C IN  : AMOGEN : MATRICE DES AMORTISSEMENTS GENERALISES
C IN  : LFLU   : LOGIQUE INDIQUANT LA PRESENCE DE LAME FLUIDE
C IN  : NBNLI  : DIMENSION DES TABLEAUX (NBCHOC+NBSISM+NBFLAM)
C OUT : NOECHO : NOEUD DE CHOC (VOIR MDCHOC)
C OUT : LOGCHO : LOGIQUE CHOC (VOIR MDCHOC)
C OUT : PARCHO : PARAMETRE DE CHOC (VOIR MDCHOC)
C OUT : INTITU : INTITULE DE CHOC
C OUT : DDLCHO : TABLEAU DES NUMEROTATIONS DES NOEUDS DE CHOC
C OUT : IER    : NIVEAU D'ERREUR
C     ------------------------------------------------------------------

      INTEGER       NBCHOC, I, J, IBID, JCOOR1, JCOOR2, IRETT,
     &              NN1, NN2, INO1,
     &              INO2, N1, N2, IRET, LLREFE
      REAL*8        KTANG, CTANG, K, COOR1(3), COOR2(3), XJEU, R8BID
      COMPLEX*16    CBID
      LOGICAL       LNOUE2
      CHARACTER*8   KBID, NOMNO1, NOMNO2,
     &              SST1, SST2, MAYA1, MAYA2, REPERE, K8TYP
      CHARACTER*10  MOTFAC
      CHARACTER*14  NUME1, NUME2
      CHARACTER*24  MDGENE, MDSSNO, REFO, NOMGR1, NOMGR2
      CHARACTER*24  VALK(2)
      INTEGER       IARG
C     ------------------------------------------------------------------
C
      CALL GETFAC ( 'CHOC', NBCHOC )
C
      CALL JEVEUO(NUMDDL//'.NUME.REFN','L',LLREFE)
      MDGENE = ZK24(LLREFE)
      MDSSNO = MDGENE(1:14)//'.MODG.SSNO'
C
      MOTFAC = 'CHOC'
      DO 100 I = 1 , NBCHOC
C
         LNOUE2 = .FALSE.
C
         CALL GETVTX(MOTFAC,'SOUS_STRUC_1',I,IARG,1,SST1,N1)
         IF (N1.EQ.0) THEN
            CALL U2MESS('F','ALGORITH5_31')
         ENDIF
         CALL JENONU(JEXNOM(MDSSNO,SST1),IRET)
         IF (IRET.EQ.0) THEN
            CALL U2MESS('F','ALGORITH5_32')
         ENDIF
         CALL MGUTDM(MDGENE,SST1,IBID,'NOM_NUME_DDL',IBID,NUME1)
         CALL MGUTDM(MDGENE,SST1,IBID,'NOM_MAILLAGE',IBID,MAYA1)
C
         CALL GETVTX(MOTFAC,'NOEUD_1',I,IARG,1,NOMNO1,IBID)
         IF (IBID.NE.0) THEN
            NOECHO(I,1) = NOMNO1
         ELSE
            CALL GETVTX(MOTFAC,'GROUP_NO_1',I,IARG,1,NOMGR1,IBID)
            CALL UTNONO(' ',MAYA1,'NOEUD',NOMGR1,NOMNO1,IRET)
            IF (IRET.EQ.10) THEN
               CALL U2MESK('F','ELEMENTS_67',1,NOMGR1)
            ELSEIF (IRET.EQ.1) THEN
               VALK(1) = NOMGR1
               VALK(2) = NOMNO1
               CALL U2MESK('A', 'SOUSTRUC_87',2,VALK)
            ENDIF
            NOECHO(I,1) = NOMNO1
         ENDIF
         NOECHO(I,2) = SST1
         NOECHO(I,3) = NUME1(1:8)
         NOECHO(I,4) = MAYA1
C
         CALL GETVTX(MOTFAC,'NOEUD_2'   ,I,IARG,1,NOMNO2,NN1)
         CALL GETVTX(MOTFAC,'GROUP_NO_2',I,IARG,1,NOMGR2,NN2)
         IF (NN1.NE.0.OR.NN2.NE.0) THEN
            LNOUE2 = .TRUE.
            CALL GETVTX(MOTFAC,'SOUS_STRUC_2',I,IARG,1,SST2,N2)
            IF (N2.EQ.0) THEN
               CALL U2MESS('F','ALGORITH5_33')
            ENDIF
            CALL JENONU(JEXNOM(MDSSNO,SST2),IRET)
            IF (IRET.EQ.0) THEN
               CALL U2MESS('F','ALGORITH5_34')
            ENDIF
            CALL MGUTDM(MDGENE,SST2,IBID,'NOM_NUME_DDL',IBID,NUME2)
            CALL MGUTDM(MDGENE,SST2,IBID,'NOM_MAILLAGE',IBID,MAYA2)
            IF (NN1.NE.0) THEN
               CALL GETVTX(MOTFAC,'NOEUD_2',I,IARG,1,NOMNO2,NN1)
               NOECHO(I,5) = NOMNO2
            ELSE
               CALL UTNONO(' ',MAYA2,'NOEUD',NOMGR2,NOMNO2,IRET)
               IF (IRET.EQ.10) THEN
                  CALL U2MESK('F','ELEMENTS_67',1,NOMGR2)
               ELSEIF (IRET.EQ.1) THEN
                  VALK(1) = NOMGR2
                  VALK(2) = NOMNO2
                  CALL U2MESK('A', 'SOUSTRUC_87',2,VALK)
               ENDIF
               NOECHO(I,5) = NOMNO2
            ENDIF
            CALL VECHBN(MDGENE,NOMNO1,SST1,NOMNO2,SST2)
            NOECHO(I,6) = SST2
            NOECHO(I,7) = NUME2(1:8)
            NOECHO(I,8) = MAYA2
         ELSE
            NOECHO(I,5) = NOMNO1
            NOECHO(I,6) = SST1
            NOECHO(I,7) = NUME1(1:8)
            NOECHO(I,8) = MAYA1
         ENDIF
C
         CALL MDCHDL ( NBNLI, NOECHO, LNOUE2, I, DDLCHO, IER )
C
         CALL JENONU(JEXNOM(NOECHO(I,4)//'.NOMNOE',NOECHO(I,1)),INO1)
         CALL JENONU(JEXNOM(NOECHO(I,8)//'.NOMNOE',NOECHO(I,5)),INO2)
         CALL JEVEUO(NOECHO(I,4)//'.COORDO    .VALE','L',JCOOR1)
         CALL JEVEUO(NOECHO(I,8)//'.COORDO    .VALE','L',JCOOR2)
         CALL ORIENT(MDGENE,NOECHO(I,2),JCOOR1,INO1,COOR1,1)
         CALL ORIENT(MDGENE,NOECHO(I,6),JCOOR2,INO2,COOR2,1)
         DO 110 J = 1,3
            PARCHO(I,7+J) = COOR1(J)
            PARCHO(I,10+J) = COOR2(J)
 110     CONTINUE
C
         KTANG = 0.D0
         CTANG = 0.D0
         CALL GETVTX(MOTFAC,'INTITULE'   ,I,IARG,1,INTITU(I)   ,N1)
         CALL GETVR8(MOTFAC,'JEU'        ,I,IARG,1,PARCHO(I,1) ,N1)
         CALL GETVR8(MOTFAC,'DIST_1'     ,I,IARG,1,PARCHO(I,30),N1)
         CALL GETVR8(MOTFAC,'DIST_2'     ,I,IARG,1,PARCHO(I,31),N1)
         CALL GETVR8(MOTFAC,'RIGI_NOR'   ,I,IARG,1,PARCHO(I,2) ,N1)
         CALL GETVR8(MOTFAC,'AMOR_NOR'   ,I,IARG,1,PARCHO(I,3) ,N1)
         CALL GETVR8(MOTFAC,'RIGI_TAN',I,IARG,1,
     &               KTANG       ,N1)
         CALL GETVR8(MOTFAC,'COULOMB'    ,I,IARG,1,PARCHO(I,6) ,N1)
         PARCHO(I,7) = PARCHO(I,6)
         CALL GETVR8(MOTFAC,'COULOMB_DYNA'    ,I,IARG,1,PARCHO(I,6) ,N1)
         CALL GETVR8(MOTFAC,'COULOMB_STAT'    ,I,IARG,1,PARCHO(I,7) ,N1)
         CALL GETVR8(MOTFAC,'AMOR_TAN'   ,I,IARG,1,CTANG       ,N1)
         CALL GETVTX(MOTFAC,'LAME_FLUIDE',I,IARG,1,KBID        ,N1)
         IF (KBID(1:3).EQ.'OUI') THEN
            LFLU = .TRUE.
            LOGCHO(I,2) = 1
            CALL GETVR8(MOTFAC,'ALPHA   ',I,IARG,1,PARCHO(I,32),N1)
            CALL GETVR8(MOTFAC,'BETA    ',I,IARG,1,PARCHO(I,33),N1)
            CALL GETVR8(MOTFAC,'CHI     ',I,IARG,1,PARCHO(I,34),N1)
            CALL GETVR8(MOTFAC,'DELTA   ',I,IARG,1,PARCHO(I,35),N1)
         ENDIF
C
         CALL GETVID(MOTFAC,'OBSTACLE',I,IARG,1,NOECHO(I,9),N1)
C
         CALL TBLIVA(NOECHO(I,9),1,'LIEU',
     &               IBID,R8BID,CBID,'DEFIOBST',KBID,R8BID,'TYPE',
     &               K8TYP,IBID,R8BID,CBID,REFO,IRETT)
         CALL ASSERT(IRETT.EQ.0)
         IF (REFO(1:9).EQ.'BI_PLAN_Y') THEN
           NOECHO(I,9) = 'BI_PLANY'
         ELSEIF (REFO(1:9).EQ.'BI_PLAN_Z') THEN
           NOECHO(I,9) = 'BI_PLANZ'
         ELSEIF (REFO(1:11).EQ.'BI_CERC_INT') THEN
           NOECHO(I,9) = 'BI_CERCI'
         ELSEIF (REFO(1:7).NE.'DISCRET') THEN
           NOECHO(I,9) = REFO(1:8)
         ENDIF
         IF (NOECHO(I,9).EQ.'BI_CERCI' .AND.
     &           PARCHO(I,31).LT.PARCHO(I,30)) THEN
           CALL U2MESS('F','ALGORITH5_35')
         ENDIF
C ------ SI CTANG NON PRECISE ON CALCULE UN AMORTISSEMENT CRITIQUE
         IF ( CTANG.EQ.0.D0 .AND. KTANG.NE.0.D0 ) THEN
            K = SQRT( PULSAT(IMODE) ) * MASGEN(IMODE)
            CTANG =   2.D0*SQRT( MASGEN(IMODE)*(K+KTANG) )
     &              - 2.D0*AMOGEN(IAMOR)*SQRT( K*MASGEN(IMODE) )
         ENDIF
         PARCHO(I,4) = KTANG
         PARCHO(I,5) = CTANG
C
         IF (NOECHO(I,9)(1:2).EQ.'BI') THEN
            XJEU = (PARCHO(I,11)-PARCHO(I,8))**2 +
     &           (PARCHO(I,12)-PARCHO(I,9))**2 +
     &           (PARCHO(I,13)-PARCHO(I,10))**2
         ENDIF
C
         CALL MDCHRE ( MOTFAC, I, I, MDGENE, TYPNUM, REPERE,
     &                                   NBNLI, PARCHO, LNOUE2 )
C
         CALL MDCHAN ( MOTFAC, I, I, MDGENE, TYPNUM, REPERE, XJEU,
     &                                     NBNLI, NOECHO, PARCHO )
C
100   CONTINUE
C
      END
