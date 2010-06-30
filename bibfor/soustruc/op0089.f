      SUBROUTINE OP0089()
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF SOUSTRUC  DATE 30/06/2010   AUTEUR DELMAS J.DELMAS 
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
C     COMMANDE:  DEPL_INTERNE
C
C ---------------- COMMUNS NORMALISES  JEVEUX  -------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*8 UL,UG,MAIL,NOCAS
      CHARACTER*16 KBI1,KBI2,CORRES,TYSD
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8,KBID,PM,OUIRI,OUIMA,AFFICK(2)
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32,JEXNUM,JEXNOM
      CHARACTER*80 ZK80
C
      INTEGER ISMA,IAMACR,IAREFM,IBID,IE,N1,LREF
      CHARACTER*8 NOMA,MACREL,PROMES,MODLMS
      CHARACTER*24 VRANGE,VREF
C
      CALL JEMARQ()

      CALL INFMAJ()
      CALL GETRES(UL,KBI1,KBI2)
      CALL GETVID(' ','DEPL_GLOBAL',1,1,1,UG,N1)
      CALL GETVTX(' ','SUPER_MAILLE',1,1,1,MAIL,N1)

      CALL GETTCO(UG,TYSD)
      IF (TYSD(1:4).NE.'CHAM') THEN
C       UG DE TYPE RESULTAT (POUR MODIF STRUCTURALE)
        CALL DISMOI('F','NOM_MAILLA',UG,'RESULTAT',IBID,NOMA,IE)
        CALL JEVEUO(NOMA//'.NOMACR','L',IAMACR)

        CALL JENONU(JEXNOM(NOMA//'.SUPMAIL',MAIL),ISMA)

        AFFICK(1) = MAIL
        AFFICK(2) = NOMA
        IF (ISMA.LE.0) CALL U2MESK('F','SOUSTRUC_26',2,AFFICK)

        MACREL= ZK8(IAMACR-1+ISMA)

        CALL DISMOI('F',
     &   'NOM_PROJ_MESU',MACREL,'MACR_ELEM_STAT',IBID,PROMES,IE)
        IF (PROMES .EQ. ' ') CALL U2MESS('F','SOUSTRUC_79')

        VREF = MACREL//'.PROJM    .PJMRF'
        CALL JEVEUO(VREF,'L',LREF)
        KBI1=ZK16(LREF-1 +1)
        MODLMS=KBI1(1:8)

C       VERIFIER SI LES MATRICES MASSE ET RAIDEUR CONDENSEES
C       ONT ETE CALCULEES
        CALL JEVEUO(MACREL//'.REFM' ,'L',IAREFM)

        OUIRI = ZK8(IAREFM-1+6)
        IF (OUIRI .NE. 'OUI_RIGI') CALL U2MESS('F','SOUSTRUC_80')

        OUIMA = ZK8(IAREFM-1+7)
        IF (OUIMA .NE. 'OUI_MASS') CALL U2MESS('F','SOUSTRUC_81')

        CORRES = ' '
        CALL PJXXPR(UG,UL,NOMA,MODLMS,CORRES,'G')

      ELSE
C       UG DE TYPE CHAM_NO
        CALL CHPVER('F',UG,'NOEU','DEPL_R',IE)
        CALL DISMOI('F','NOM_MAILLA',UG,'CHAM_NO',IBID,NOMA,IE)
        CALL GETVTX(' ','NOM_CAS',1,1,1,NOCAS,N1)
        CALL SSDEIN(UL,UG,MAIL,NOCAS)
      ENDIF


C     -- CREATION DE L'OBJET .REFD SI NECESSAIRE:
C     -------------------------------------------
      CALL AJREFD(UG,UL,'ZERO')


      CALL JEDEMA()

      END
