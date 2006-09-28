      SUBROUTINE MGUTDM(MDGENZ,NMSSTZ,NUSST,QUESTI,REPI,REPKZ)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
      IMPLICIT NONE
C
C***********************************************************************
C    P. RICHARD     DATE 13/11/92
C-----------------------------------------------------------------------
C  BUT:      < MODELE GENERALISE UTILITAIRE DIS MOI >
C
C  UTILITAIRE PERMETTANT D'ACCEDER AUX CONCEPT RELATIFS AUX
C  SOUS-STRUCTURES D'UN MODELE GENERALISE
C
C  LISTE DES QUESTIONS POSSIBLES:
C    NOM_MACR_ELEM
C    NOM_BASE_MODALE
C    NOM_MAILLAGE
C    NOM_MODELE
C    NOM_NUME_DDL
C    NOM_LIST_INTERF
C    NB_CMP_MAX
C
C-----------------------------------------------------------------------
C
C MDGENZ   /I/: NOM UTILISATEUR DU MODELE GENERALISE
C NMSSTZ   /I/: NOM K8 DE LA SOUS-STRUCTURE
C NUSST    /I/: NUMERO DE LA SOUS-STRUCTURE
C QUESTI   /I/: QUESTION
C REPI     /O/: REPONSE ENTIERE
C REPKZ    /O/: REPONSE CARACTERE
C
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
      INTEGER REPI,IRET,LLDESC,LLMCL,LLREF,NUSS,NUSST
      CHARACTER*(*) QUESTI
      CHARACTER*24  REPK
      CHARACTER*6      PGC
      CHARACTER*8 MODGEN,NOMMCL,BASMOD,NOMSST
      CHARACTER*14 NUME,LLREF2
      CHARACTER*(*) MDGENZ, NMSSTZ, REPKZ
C
C-----------------------------------------------------------------------
      DATA PGC /'MGUTDM'/
C-----------------------------------------------------------------------
C
C------------RECUPERATION NUMRERO DE SOUS-STRUCTURE ET VERIFS-----------
C
      CALL JEMARQ()
      MODGEN = MDGENZ
      NOMSST = NMSSTZ
      REPK   = REPKZ
C
      IF(NOMSST(1:1).NE.' ') THEN
        CALL JENONU(JEXNOM(MODGEN//'      .MODG.SSNO',NOMSST),
     &              NUSS)
        IF(NUSS.EQ.0) THEN
          CALL UTDEBM('F',PGC,
     &'SOUS-STRUCTURE INEXISTANTE DANS LE MODELE-GENERALISE')
          CALL UTIMPK('L','MODELE GENERALISE --> ',1,MODGEN)
          CALL UTIMPK('L','SOUS-STRUCTURE DEMANDEE --> ',1,NOMSST)
          CALL UTFINM
        ENDIF
      ELSE
        NUSS=NUSST
        CALL JEEXIN(JEXNUM(MODGEN//'      .MODG.SSME',NUSS),IRET)
        IF(NUSS.EQ.0) THEN
          CALL UTDEBM('F',PGC,
     &'SOUS-STRUCTURE INEXISTANTE DANS LE MODELE-GENERALISE')
          CALL UTIMPK('L','MODELE GENERALISE --> ',1,MODGEN)
          CALL UTIMPI('L','NUMERO SOUS-STRUCTURE DEMANDEE --> ',1,NUSS)
          CALL UTFINM
        ENDIF
        CALL JENUNO(JEXNUM(MODGEN//'      .MODG.SSNO',NUSS),
     &              NOMSST)
      ENDIF
C
C
      IF  (QUESTI(1:13).EQ.'NOM_MACR_ELEM') THEN
        CALL JEVEUO(JEXNUM(MODGEN//'      .MODG.SSME',NUSS),'L',LLMCL)
        REPK(1:8)=ZK8(LLMCL)
      ELSE IF (QUESTI(1:15).EQ.'NOM_BASE_MODALE') THEN
        CALL JEVEUO(JEXNUM(MODGEN//'      .MODG.SSME',NUSS),'L',LLMCL)
        NOMMCL=ZK8(LLMCL)
        CALL JEVEUO(NOMMCL//'.MAEL_REFE','L',LLREF)
        REPK(1:8)=ZK24(LLREF)
      ELSE IF (QUESTI(1:12).EQ.'NOM_MAILLAGE') THEN
        CALL JEVEUO(JEXNUM(MODGEN//'      .MODG.SSME',NUSS),'L',LLMCL)
        NOMMCL=ZK8(LLMCL)
        CALL JEVEUO(NOMMCL//'.MAEL_REFE','L',LLREF)
        REPK(1:8)=ZK24(LLREF+1)
      ELSE IF (QUESTI(1:12).EQ.'NOM_NUME_DDL') THEN
        CALL JEVEUO(JEXNUM(MODGEN//'      .MODG.SSME',NUSS),'L',LLMCL)
        NOMMCL=ZK8(LLMCL)
        CALL JEVEUO(NOMMCL//'.MAEL_REFE','L',LLREF)
        BASMOD(1:8)=ZK24(LLREF)
        CALL JEVEUO(BASMOD//'           .REFD','L',LLREF)
        REPK(1:14)=ZK24(LLREF+3)
      ELSE IF (QUESTI(1:12).EQ.'NOM_MODELE  ') THEN
        CALL JEVEUO(JEXNUM(MODGEN//'      .MODG.SSME',NUSS),'L',LLMCL)
        NOMMCL=ZK8(LLMCL)
        CALL JEVEUO(NOMMCL//'.MAEL_REFE','L',LLREF)
        BASMOD(1:8)=ZK24(LLREF)
        CALL JEVEUO(BASMOD//'           .REFD','L',LLREF)
        NUME(1:14)=ZK24(LLREF+3)
        CALL JENUNO(JEXNUM(NUME(1:14)//'.NUME.LILI',2),LLREF2)
        REPK(1:8)=LLREF2(1:8)
      ELSE IF (QUESTI(1:15).EQ.'NOM_LIST_INTERF') THEN
        CALL JEVEUO(JEXNUM(MODGEN//'      .MODG.SSME',NUSS),'L',LLMCL)
        NOMMCL=ZK8(LLMCL)
        CALL JEVEUO(NOMMCL//'.MAEL_REFE','L',LLREF)
        BASMOD(1:8)=ZK24(LLREF)
        CALL JEVEUO(BASMOD//'           .REFD','L',LLREF)
        REPK(1:8)=ZK24(LLREF+4)
      ELSE IF (QUESTI(1:10).EQ.'NB_CMP_MAX') THEN
        CALL JEVEUO(MODGEN//'      .MODG.DESC','L',LLDESC)
        REPI=ZI(LLDESC+1)
      ELSE
         REPK = QUESTI
         CALL U2MESK('F','UTILITAI_49',1,REPK)
         GO TO 9999
      END IF
C
 9999 CONTINUE
      REPKZ = REPK
      CALL JEDEMA()
      END
