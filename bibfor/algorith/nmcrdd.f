      SUBROUTINE NMCRDD(NOMA  ,NOMO  ,SDIETO,SDSUIV)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 11/06/2012   AUTEUR PELLET J.PELLET 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT     NONE
      CHARACTER*8  NOMA,NOMO
      CHARACTER*19 SDSUIV
      CHARACTER*24 SDIETO
C
C ----------------------------------------------------------------------
C
C ROUTINE *_NON_LINE (STRUCTURES DE DONNES)
C
C LECTURE SUIVI_DDL ET CREATION DE LA SD SUIVI_DDL
C
C ----------------------------------------------------------------------
C
C IN  SDIETO : SD GESTION IN ET OUT
C IN  NOMA   : NOM DU MAILLAGE
C IN  NOMO   : NOM DU MODELE
C IN  SDSUIV : NOM DE LA SD POUR SUIVI_DDL
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      INTEGER      ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8       ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16   ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL      ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8  ZK8
      CHARACTER*16    ZK16
      CHARACTER*24        ZK24
      CHARACTER*32            ZK32
      CHARACTER*80                ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      INTEGER      NMAX
      PARAMETER    (NMAX=99)
      INTEGER      IFM,NIV
      INTEGER      NTSDDL,NBOCC
      CHARACTER*16 MOTFAC
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> ... CREATION SD SUIVI_DDL'
      ENDIF
C
C --- INITIALISATIONS
C
      NTSDDL = 0
      MOTFAC = 'SUIVI_DDL'
C
C --- NOMBRE OCCURRENCES
C
      CALL GETFAC(MOTFAC,NBOCC)
      IF (NBOCC.GT.NMAX) THEN
        CALL U2MESI('F','OBSERVATION_5',1,NMAX)
      ENDIF
C
C --- LECTURE DES DONNEES
C
      CALL NMEXTR(NOMA  ,NOMO  ,SDSUIV,SDIETO,MOTFAC,
     &            NBOCC ,NTSDDL)
C
C --- CONTROLE
C
      IF (NTSDDL.GT.NMAX) THEN
        CALL U2MESI('F','OBSERVATION_5',1,NMAX)
      ENDIF
C
C --- NOM DES COLONNES
C
      IF (NBOCC.NE.0) THEN
        CALL NMCRDN(SDSUIV,MOTFAC,NBOCC )
      ENDIF
C
      CALL JEDEMA()

      END
