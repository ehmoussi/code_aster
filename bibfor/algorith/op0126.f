      SUBROUTINE OP0126 ()
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
C***********************************************************************
      IMPLICIT NONE
C  P. RICHARD     DATE 13/07/90
C-----------------------------------------------------------------------
C  BUT: TRAITER LA DEFINITION DU MODELE GENERALISE DONNE PAR
C       L'UTILISATEUR ET TRAITER L'ORIENTATION DES MATRICES DE LIAISON
C       PROCEDER AUX VERIFICATIONS SUR LA COHERENCE DE LA DEFINITION
C       DES LIAISONS ET SUR LA COMPATIBILITE DES MACR_ELEM MIS EN JEU
C
C  CONCEPT CREE: MODE_GENE
C
C-----------------------------------------------------------------------
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
C-----  FIN  COMMUNS NORMALISES  JEVEUX  -------------------------------
C
      INTEGER     IVAL,IBID,NBLIA,I,IINC,IREP11,IREP12,
     &            IREP21,IREP22,IOPT,IRET
      CHARACTER*3 REP
      CHARACTER*8 NOMRES,SST1,SST2,INTF1,INTF2,K8BID,OPTION
      CHARACTER*16 NOMCON,NOMOPE
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
C
      CALL INFMAJ()
      CALL GETRES(NOMRES,NOMCON,NOMOPE)
C
C-----TRAITEMENT DES DONNEES UTILISATEUR
C
      CALL ARG126 (NOMRES)
C
C-----VERIFICATION COHERENCE DES SOUS-STRUCTURES ET CREATION DU .DESC
C
      CALL VERSST(NOMRES)
C
C
C-----VERIFICATION DE LA COHERENCE DU MODELE GENERALISE
C
      CALL GETFAC('VERIF',IVAL)
      IF (IVAL.NE.0) THEN
        CALL GETVTX('VERIF','STOP_ERREUR',1,1,1,REP,IBID)
        IF (REP.EQ.'NON') GO TO 20
      ENDIF

      CALL GETFAC('LIAISON',NBLIA)

      DO 10 I=1,NBLIA
        CALL GETVTX('LIAISON','OPTION',I,1,1,OPTION,IOPT)
        CALL GETVTX('LIAISON','SOUS_STRUC_1',I,1,1,SST1,IBID)
        CALL GETVTX('LIAISON','SOUS_STRUC_2',I,1,1,SST2,IBID)
        CALL GETVTX('LIAISON','INTERFACE_1',I,1,1,INTF1,IBID)
        CALL GETVTX('LIAISON','INTERFACE_2',I,1,1,INTF2,IBID)
        IINC=0
C     ON TESTE SI LA LIAISON EST INCOMPATIBLE
        CALL GETVTX('LIAISON','GROUP_MA_MAIT_1',I,1,1,K8BID,IREP11)
        CALL GETVTX('LIAISON','MAILLE_MAIT_1',I,1,1,K8BID,IREP12)
        CALL GETVTX('LIAISON','GROUP_MA_MAIT_2',I,1,1,K8BID,IREP21)
        CALL GETVTX('LIAISON','MAILLE_MAIT_2',I,1,1,K8BID,IREP22)
        IF ((IREP11.NE.0).OR.(IREP12.NE.0)) THEN
           IINC=1
        ELSEIF ((IREP21.NE.0).OR.(IREP22.NE.0)) THEN
           IINC=2
        ENDIF
        
C       SI ELLE EST COMPATIBLE ON VERIFIE LA COINCIDENCE DES NOEUDS
C       D'INTERFACE, SINON ON FAIT RIEN
        IF ((IINC.EQ.0).AND.(OPTION.EQ.'CLASSIQU')) THEN
         IRET=I
         CALL VECOMO(NOMRES,SST1,SST2,INTF1,INTF2,IRET,OPTION)
        ENDIF
10    CONTINUE
20    CONTINUE

C
C-----ORIENTATION DES MATRICES DE LIAISON
C
      CALL CALLIS(NOMRES)
      
C-----VERIFICATION DU MODELE GENERALISE
C

      END
