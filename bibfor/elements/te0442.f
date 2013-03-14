      SUBROUTINE TE0442(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 11/03/2013   AUTEUR IDOUX L.IDOUX 
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

      IMPLICIT NONE
      INCLUDE 'jeveux.h'

      CHARACTER*16 OPTION,NOMTE
C......................................................................
C
C    - FONCTION REALISEE: CHANGEMENT DE REPERE POUR LES PLAQUES
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                        'REPE_TENS'  :  TENSEURS
C                        'REPE_GENE'  :  QUANTITES GENERALISEES
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................


      INTEGER       NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDX,JGANO,IRET(4)
      INTEGER       JGEOM,JIN,JOUT,JANG,NP,ITAB(7),IRET1,IRET2,NBSP
      INTEGER       NPTMAX,NCPMAX,NSPMAX
      INTEGER       JCARA,NCMP,VALI(2)
      PARAMETER    (NPTMAX=9,NCPMAX=8,NSPMAX=162)
      REAL*8        PGL(3,3), ALPHA, BETA,C,S
      REAL*8        T2EV1(2,2), T2VE1(2,2)
      REAL*8        T2EV2(2,2), T2VE2(2,2)
      REAL*8        R8DGRD,CONIN(NPTMAX*NCPMAX*NSPMAX)
      REAL*8        REP
      CHARACTER*4   FAMI
      CHARACTER*8   PAIN, PAOUT
C
      IF (OPTION.NE.'REPE_TENS' .AND.
     &    OPTION.NE.'REPE_GENE') THEN
CC OPTION DE CALCUL INVALIDE
         CALL ASSERT(.FALSE.)
      END IF
C
      IF (OPTION.EQ.'REPE_TENS') THEN
         NCMP=6
         CALL TECACH('ONO','PCOGAIN','L',7,ITAB,IRET(1))
         CALL TECACH('ONO','PCONOIN','L',7,ITAB,IRET(2))
         CALL TECACH('ONO','PDEGAIN','L',7,ITAB,IRET(3))
         CALL TECACH('ONO','PDENOIN','L',7,ITAB,IRET(4))
         IRET1 = IRET(1) + IRET(2) + IRET(3) + IRET(4)
         CALL ASSERT(IRET1.EQ.6)
C
         IF(IRET(1).EQ.0) THEN
            PAIN  = 'PCOGAIN'
            PAOUT = 'PCOGAOUT'
         ELSE IF(IRET(2).EQ.0) THEN
            PAIN  = 'PCONOIN'
            PAOUT = 'PCONOOUT'
         ELSE IF(IRET(3).EQ.0) THEN
            PAIN  = 'PDEGAIN'
            PAOUT = 'PDEGAOUT'
         ELSE IF(IRET(4).EQ.0) THEN
            PAIN  = 'PDENOIN'
            PAOUT = 'PDENOOUT'
         ENDIF
C
      ELSE IF (OPTION.EQ.'REPE_GENE') THEN
         NCMP=8
         CALL TECACH('ONO','PEFGAIN','L',7,ITAB,IRET(1))
         CALL TECACH('ONO','PEFNOIN','L',7,ITAB,IRET(2))
         CALL TECACH('ONO','PDGGAIN','L',7,ITAB,IRET(3))
         CALL TECACH('ONO','PDGNOIN','L',7,ITAB,IRET(4))
         IRET1 = IRET(1) + IRET(2) + IRET(3) + IRET(4)
         CALL ASSERT(IRET1.EQ.6)
C
         IF(IRET(1).EQ.0) THEN
            PAIN  = 'PEFGAIN'
            PAOUT = 'PEFGAOUT'
         ELSE IF(IRET(2).EQ.0) THEN
            PAIN  = 'PEFNOIN'
            PAOUT = 'PEFNOOUT'
         ELSE IF(IRET(3).EQ.0) THEN
            PAIN  = 'PDGGAIN'
            PAOUT = 'PDGGAOUT'
         ELSE IF(IRET(4).EQ.0) THEN
            PAIN  = 'PDGNOIN'
            PAOUT = 'PDGNOOUT'
         ENDIF
      ENDIF
C
      IF (PAIN(4:5).EQ.'NO') THEN
         FAMI = 'NOEU'
      ELSE IF (PAIN(4:5).EQ.'GA') THEN
         FAMI = 'RIGI'
      ENDIF
      CALL ELREF4(' ',FAMI,NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDX,JGANO)
      IF (PAIN(4:5).EQ.'NO') THEN
         NP = NNO
      ELSE IF (PAIN(4:5).EQ.'GA') THEN
         NP = NPG
      ENDIF

      CALL JEVECH('PGEOMER','L',JGEOM)
      CALL JEVECH('PCACOQU','L',JCARA)
      CALL JEVECH('PANGREP','L',JANG)
      CALL JEVECH(PAIN,'L',JIN)
      CALL JEVECH(PAOUT,'E',JOUT)
      CALL TECACH('OOO',PAIN,'L',7,ITAB,IRET2)
      NBSP = ITAB(7)
      IF((NBSP.NE.1).AND.(MOD(NBSP,3).NE.0)) THEN
         CALL U2MESI('F','ELEMENTS5_54',1,NBSP)
      END IF

      IF (NNO.EQ.3) THEN
         CALL DXTPGL(ZR(JGEOM),PGL)
      ELSE IF (NNO.EQ.4) THEN
         CALL DXQPGL(ZR(JGEOM),PGL,'S',IRET1)
      END IF
      CALL ASSERT(NCMP.LE.NCPMAX)
      CALL ASSERT(NP.LE.NPTMAX)
      VALI(1)=NSPMAX
      VALI(2)=NBSP
      IF(NBSP.GT.NSPMAX)CALL U2MESI('F','ELEMENTS5_4',2,VALI)
C
C     LE TABLEAU CONIN A ETE ALLOUE DE FACON STATIQUE POUR
C     OPTIMISER LE CPU CAR LES APPELS A WKVECT DANS LES TE SONT COUTEUX.
C
      ALPHA = ZR(JCARA+1) * R8DGRD()
      BETA  = ZR(JCARA+2) * R8DGRD()
      CALL COQREP(PGL,ALPHA,BETA,T2EV1,T2VE1,C,S)

      REP = ZR(JANG+2)
      IF(REP.EQ.0.D0) THEN
C
C --- PASSAGE DES CONTRAINTES DU REPERE LOCAL 1
C --- A L'ELEMENT AU REPERE INTRINSEQUE DE LA COQUE
C     ---------------------------------------
        IF (OPTION.EQ.'REPE_TENS' ) THEN
          CALL DXSIRO(NP*NBSP,T2EV1,ZR(JIN),CONIN)
        ELSE IF (OPTION.EQ.'REPE_GENE' ) THEN
          CALL DXEFRO(NP,T2EV1,ZR(JIN),CONIN)
        ENDIF
C
C --- CALCUL DES MATRICES DE PASSAGE DU CHGT DE REPERE
        ALPHA = ZR(JANG)   * R8DGRD()
        BETA  = ZR(JANG+1) * R8DGRD()
        CALL COQREP(PGL,ALPHA,BETA,T2EV2,T2VE2,C,S)

C ---   PASSAGE DES QUANTITES DU REPERE INTRINSEQUE
C ---   A L'ELEMENT AU REPERE LOCAL 2 DE LA COQUE
        IF (OPTION.EQ.'REPE_TENS' ) THEN
          CALL DXSIRO(NP*NBSP,T2VE2,CONIN,ZR(JOUT))
        ELSE IF (OPTION.EQ.'REPE_GENE' ) THEN
          CALL DXEFRO(NP,T2VE2,CONIN,ZR(JOUT))
        ENDIF

C --- PASSAGE DES CONTRAINTES DU REPERE INTRINSEQUE
C --- A L'ELEMENT AU REPERE LOCAL 1 DE LA COQUE
C     REPERE = 'COQUE_INTR_UTIL'
C     ---------------------------------------
      ELSE IF(REP.EQ.1.D0) THEN
        IF (OPTION.EQ.'REPE_TENS' ) THEN
          CALL DXSIRO(NP*NBSP,T2VE1,ZR(JIN),ZR(JOUT))
        ELSE IF (OPTION.EQ.'REPE_GENE' ) THEN
          CALL DXEFRO(NP,T2VE1,ZR(JIN),ZR(JOUT))
        ENDIF
C
C --- PASSAGE DES CONTRAINTES DU REPERE LOCAL 1
C --- A L'ELEMENT AU REPERE INTRINSEQUE DE LA COQUE
C     REPERE = 'COQUE_UTIL_INTR'
C     ---------------------------------------
      ELSE IF(REP.EQ.2.D0) THEN
        IF (OPTION.EQ.'REPE_TENS' ) THEN
          CALL DXSIRO(NP*NBSP,T2EV1,ZR(JIN),ZR(JOUT))
        ELSE IF (OPTION.EQ.'REPE_GENE' ) THEN        
          CALL DXEFRO(NP,T2EV1,ZR(JIN),ZR(JOUT))
        ENDIF
C
      ENDIF
      END
