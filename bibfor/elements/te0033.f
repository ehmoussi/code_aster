      SUBROUTINE TE0033 (OPTION,NOMTE)
      IMPLICIT  NONE
      CHARACTER*16        OPTION, NOMTE
C ----------------------------------------------------------------------
C MODIF ELEMENTS  DATE 30/08/2011   AUTEUR PELLET J.PELLET 
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     CALCUL DE CONTRAINTES, DEFORMATIONS, EFFORTS ET DEFORMATIONS
C     GENERALISES POUR LES ELEMENTS DKT, DKTG, DST, DKQ, DSQ ET Q4G
C     POUR UN MATERIAU ISOTROPE OU MULTICOUCHE
C         OPTIONS TRAITEES  ==>  SIEF_ELGA
C                                EFGE_ELNO
C                                SIGM_ELNO
C                                EPSI_ELNO
C                                DEGE_ELNO
C     IN   K16   OPTION : NOM DE L'OPTION A CALCULER
C     IN   K16   NOMTE  : NOM DU TYPE_ELEMENT
C     ------------------------------------------------------------------
C     ----- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER         ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8          ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16      ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL         ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8     ZK8
      CHARACTER*16            ZK16
      CHARACTER*24                     ZK24
      CHARACTER*32                              ZK32
      CHARACTER*80                                       ZK80
      COMMON /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
      INTEGER       NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDX,JGANO
      INTEGER       I, IC, INIV, IRET, JCARA,VALI(2),
     &              JDEPG, JEFFG, JGEOM, JMATE, JNUMCO, JSIGM,
     &              NP, MULTIC,
     &              JNBSPI, NBCOU, ICOU
      REAL*8        ZERO,EPI,EPAIS,EPTOT
      REAL*8        PGL(3,3), XYZL(3,4), R8BID,VALR(2)
      REAL*8        DEPL(24)
      REAL*8        EFFGT(32), SIGTOT(24)
      REAL*8        T2EV(4), T2VE(4)
      LOGICAL       DKG
      INTEGER       ICODRE
      CHARACTER*2   VAL
      CHARACTER*4   FAMI
      CHARACTER*8   NOMRES
      CHARACTER*16  PHENOM
      CHARACTER*3   NUM
C     ------------------------------------------------------------------
C
      IF (OPTION(6:9).EQ.'ELNO') THEN
        FAMI = 'NOEU'
      ELSE
        FAMI = 'RIGI'
      ENDIF
      CALL ELREF4(' ',FAMI,NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDX,JGANO)
C
      IF (OPTION.NE.'SIEF_ELGA' .AND.
     &    OPTION.NE.'EFGE_ELNO' .AND.
     &    OPTION.NE.'SIGM_ELNO' .AND.
     &    OPTION.NE.'EPSI_ELNO' .AND.
     &    OPTION.NE.'DEGE_ELNO') THEN
CC OPTION DE CALCUL INVALIDE
        CALL ASSERT(.FALSE.)
      END IF

      DKG = .FALSE.

      IF ((NOMTE.EQ.'MEDKTG3').OR.
     &    (NOMTE.EQ.'MEDKQG4')) THEN
        DKG = .TRUE.
      END IF

      ZERO   = 0.0D0

      DO 10 I = 1,32
        EFFGT(I) = ZERO
   10 CONTINUE

      DO 20 I = 1,24
        SIGTOT(I) = ZERO
   20 CONTINUE

      CALL JEVECH('PGEOMER','L',JGEOM)
      CALL JEVECH('PMATERC','L',JMATE)
      CALL JEVECH('PCACOQU','L',JCARA)

C
C --- VERIFICATION DE LA COHERENCE DES INFORMATIONS
C --- PROVENANT DE DEFI_COQU_MULT ET DE AFFE_CARA_ELEM
C     ----------------------------------
      JNBSPI = 0
      CALL TECACH('NNN','PNBSP_I',1,JNBSPI,IRET)
      IF (IRET.EQ.0) THEN
        NBCOU = ZI(JNBSPI)
        ICOU = 0
        EPTOT = 0.D0
        EPI = 0.D0
        CALL JEVECH('PCACOQU','L',JCARA)
        EPAIS  = ZR(JCARA)
  5     CONTINUE
        ICOU=ICOU+1
        CALL CODENT(ICOU,'G',NUM)
        CALL CODENT(1,'G',VAL)
        NOMRES = 'C'//NUM//'_V'//VAL
        CALL RCVALA(ZI(JMATE),' ','ELAS_COQMU',0,' ',R8BID,
     &       1,NOMRES,EPI,ICODRE,0)
        IF (ICODRE.EQ.0) THEN
          EPTOT=EPTOT+EPI
          GOTO 5
        ENDIF
        IF (EPTOT.NE.0.D0) THEN
          IF ((ICOU-1).NE.NBCOU) THEN
            VALI(1) = ICOU-1
            VALI(2) = NBCOU
            CALL U2MESG('F','ELEMENTS3_51',0,' ',2,VALI,0,0.D0)
          ENDIF
          IF (ABS(EPAIS-EPTOT)/EPAIS.GT.1.D-2) THEN
            VALR(1) = EPTOT
            VALR(2) = EPAIS
            CALL U2MESG('F','ELEMENTS3_52',0,' ',0,0,2,VALR)
          ENDIF
        ENDIF
      ENDIF

      IF (OPTION(8:9).EQ.'GA') THEN
        NP = NPG
      ELSE IF (OPTION(8:9).EQ.'NO') THEN
        NP = NNO
      END IF

      IF (NNO.EQ.3) THEN
        CALL DXTPGL(ZR(JGEOM),PGL)
      ELSE IF (NNO.EQ.4) THEN
        CALL DXQPGL(ZR(JGEOM),PGL)
      END IF

      CALL UTPVGL(NNO,3,PGL,ZR(JGEOM),XYZL)
      CALL DXREPE( PGL,T2EV, T2VE)

      CALL JEVECH('PDEPLAR','L',JDEPG)
      CALL UTPVGL(NNO,6,PGL,ZR(JDEPG),DEPL)


C     ---------- CONTRAINTES ET DEFORMATIONS --------------------------

C          ----------------------------
      IF ( OPTION(1:9) .EQ. 'SIGM_ELNO' ) THEN
C          ----------------------------
        CALL JEVECH('PNUMCOR','L',JNUMCO)
        IC = ZI(JNUMCO)
        INIV = ZI(JNUMCO+1)
        CALL JEVECH('PCONTRR','E',JSIGM)

C ---   CALCUL DES CONTRAINTES VRAIES (I.E. SIG_MECA - SIG_THERM)
C ---   AUX POINTS DE CALCUL
C       --------------------
        CALL DXSIGV(FAMI,NOMTE,XYZL,PGL,IC,INIV,DEPL,SIGTOT)

C ---   PASSAGE DES CONTRAINTES DU REPERE INTRINSEQUE
C ---   A L'ELEMENT AU REPERE LOCAL DE LA COQUE
C       ---------------------------------------
        CALL DXSIRO(NP,T2VE,SIGTOT,ZR(JSIGM))

C               ----------------------------
      ELSE IF ( OPTION(1:9) .EQ. 'EPSI_ELNO' ) THEN
C               ----------------------------
        CALL JEVECH('PDEFORR','E',JSIGM)
        CALL JEVECH('PNUMCOR','L',JNUMCO)
        IC = ZI(JNUMCO)
        INIV = ZI(JNUMCO+1)

        IF (NOMTE.EQ.'MEDKTR3' ) THEN
          CALL DKTCOD(XYZL,PGL,IC,INIV,DEPL,SIGTOT)
        ELSE IF (NOMTE.EQ.'MEDKTG3') THEN
          CALL DKTGCO(XYZL,PGL,INIV,DEPL,SIGTOT)
        ELSE IF (NOMTE.EQ.'MEDSTR3') THEN
          CALL DSTCOD(XYZL,PGL,IC,INIV,DEPL,SIGTOT)
        ELSE IF (NOMTE.EQ.'MEDKQU4') THEN
          CALL DKQCOD(XYZL,PGL,IC,INIV,DEPL,SIGTOT)
        ELSE IF (NOMTE.EQ.'MEDKQG4') THEN
          CALL DKQGCO(XYZL,PGL,INIV,DEPL,SIGTOT)
        ELSE IF (NOMTE.EQ.'MEDSQU4') THEN
          CALL DSQCOD(XYZL,PGL,IC,INIV,DEPL,SIGTOT)
        ELSE IF (NOMTE.EQ.'MEQ4QU4') THEN
          CALL Q4GCOD(XYZL,PGL,IC,INIV,DEPL,SIGTOT)
        END IF

C ---     PASSAGE DES DEFORMATIONS  DU REPERE INTRINSEQUE
C ---     A L'ELEMENT AU REPERE LOCAL DE LA COQUE
C         ---------------------------------------
        CALL DXSIRO(NP,T2VE,SIGTOT,ZR(JSIGM))
C
C               ----------------------------
      ELSE IF ( OPTION(1:9) .EQ. 'SIEF_ELGA' ) THEN
C               ----------------------------

        CALL JEVECH('PCONTRR','E',JSIGM)
C
        CALL RCCOMA ( ZI(JMATE), 'ELAS', PHENOM, ICODRE )
        IF ( PHENOM.EQ.'ELAS'      .OR.
     &       PHENOM.EQ.'ELAS_ORTH' .OR.
     &       PHENOM.EQ.'ELAS_ISTR' ) THEN
           CALL DXSIEF ( NOMTE, XYZL, DEPL, ZI(JMATE), PGL, ZR(JSIGM) )

        ELSEIF ( PHENOM.EQ.'ELAS_COQUE' ) THEN

          IF (DKG) THEN
            NBCOU = 1
          ELSE
            CALL JEVECH('PNBSP_I','L',JNBSPI)
            NBCOU = ZI(JNBSPI)
            IF (NBCOU.LE.0) CALL U2MESS('F','ELEMENTS_46')
          ENDIF

          IF ( NOMTE.EQ.'MEDKTR3' .OR.
     &         NOMTE.EQ.'MEDKTG3' ) THEN
             CALL DKTSIE(FAMI,XYZL,PGL,DEPL,NBCOU,ZR(JSIGM))
          ELSE IF (NOMTE.EQ.'MEDSTR3' ) THEN
             CALL DSTSIE(FAMI,XYZL,PGL,DEPL,NBCOU,ZR(JSIGM))
          ELSE IF (NOMTE.EQ.'MEDKQU4' .OR.
     &             NOMTE.EQ.'MEDKQG4' ) THEN
             CALL DKQSIE(FAMI,XYZL,PGL,DEPL,NBCOU,ZR(JSIGM))
          ELSE IF (NOMTE.EQ.'MEDSQU4' ) THEN
             CALL DSQSIE(FAMI,XYZL,PGL,DEPL,NBCOU,ZR(JSIGM))
          ELSE IF (NOMTE.EQ.'MEQ4QU4' ) THEN
             CALL Q4GSIE(FAMI,XYZL,PGL,DEPL,NBCOU,ZR(JSIGM))
          END IF
C
        ELSEIF ( PHENOM.EQ.'ELAS_COQMU' ) THEN

          IF (DKG) THEN
            NBCOU = 1
          ELSE
            CALL JEVECH('PNBSP_I','L',JNBSPI)
            NBCOU = ZI(JNBSPI)
            IF (NBCOU.LE.0) CALL U2MESS('F','ELEMENTS_46')
          ENDIF

          IF ( NOMTE.EQ.'MEDKTR3' .OR.
     &         NOMTE.EQ.'MEDKTG3' ) THEN
             CALL DKTSIE(FAMI,XYZL,PGL,DEPL,NBCOU,ZR(JSIGM))
          ELSE IF (NOMTE.EQ.'MEDSTR3' ) THEN
             CALL DSTSIE(FAMI,XYZL,PGL,DEPL,NBCOU,ZR(JSIGM))
          ELSE IF (NOMTE.EQ.'MEDKQU4' .OR.
     &             NOMTE.EQ.'MEDKQG4' ) THEN
             CALL DKQSIE(FAMI,XYZL,PGL,DEPL,NBCOU,ZR(JSIGM))
          ELSE IF (NOMTE.EQ.'MEDSQU4' ) THEN
             CALL DSQSIE(FAMI,XYZL,PGL,DEPL,NBCOU,ZR(JSIGM))
          ELSE IF (NOMTE.EQ.'MEQ4QU4' ) THEN
             CALL Q4GSIE(FAMI,XYZL,PGL,DEPL,NBCOU,ZR(JSIGM))
          END IF

        ELSE
           CALL U2MESK('F','ELEMENTS2_76',1,PHENOM)
        END IF
C
C               ----------------------------
      ELSE IF ( OPTION(1:9) .EQ. 'EFGE_ELNO' ) THEN
C               ----------------------------
C ---     CALCUL DES EFFORTS GENERALISES VRAIS
C ---     AUX POINTS DE CALCUL
C         --------------------
        CALL DXEFGV(NOMTE,OPTION,XYZL,PGL,DEPL,EFFGT)
C
C ---    PRISE EN COMPTE DE L'EXCENTREMENT SI ON CALCULE LES
C ---    EFFORTS GENERALISES SUR UN FEUILLET DE REFERENCE DIFFERENT
C ---    DU FEUILLET DU MAILLAGE (I.E. EN PEAU SUP, INF OU MOY)
C        ------------------------------------------------------
C
        CALL EXCENT(OPTION,NOMTE,NNO,EFFGT)

C ---   PASSAGE DES EFFORTS GENERALISES DU REPERE INTRINSEQUE
C ---   A L'ELEMENT AU REPERE LOCAL DE LA COQUE
C       ---------------------------------------
        CALL JEVECH('PEFFORR','E',JEFFG)
        CALL DXEFRO(NP,T2VE,EFFGT,ZR(JEFFG))

C
C               ----------------------------
      ELSE IF ( OPTION(1:9) .EQ. 'DEGE_ELNO' ) THEN
C               ----------------------------

        CALL JEVECH('PDEFOGR','E',JEFFG)


        IF (NOMTE.EQ.'MEDKTR3' .OR.
     &      NOMTE.EQ.'MEDKTG3' ) THEN
          CALL DKTEDG(XYZL,OPTION,PGL,DEPL,EFFGT,MULTIC)
        ELSE IF (NOMTE.EQ.'MEDSTR3' ) THEN
          CALL DSTEDG(XYZL,OPTION,PGL,DEPL,EFFGT)
        ELSE IF (NOMTE.EQ.'MEDKQU4' .OR.
     &           NOMTE.EQ.'MEDKQG4' ) THEN
          CALL DKQEDG(XYZL,OPTION,PGL,DEPL,EFFGT)
        ELSE IF (NOMTE.EQ.'MEDSQU4' ) THEN
          CALL DSQEDG(XYZL,OPTION,PGL,DEPL,EFFGT)
        ELSE IF (NOMTE.EQ.'MEQ4QU4' ) THEN
          CALL Q4GEDG(XYZL,OPTION,PGL,DEPL,EFFGT)
        END IF
C
C ---    PRISE EN COMPTE DE L'EXCENTREMENT SI ON CALCULE LES
C ---    EFFORTS GENERALISES SUR UN FEUILLET DE REFERENCE DIFFERENT
C ---    DU FEUILLET DU MAILLAGE (I.E. EN PEAU SUP, INF OU MOY)
C        ------------------------------------------------------
          CALL EXCENT(OPTION,NOMTE,NNO,EFFGT)
C
C ---     PASSAGE DES DEFORMATIONS GENERALISEES DU REPERE INTRINSEQUE
C ---     A L'ELEMENT AU REPERE LOCAL DE LA COQUE
C         ---------------------------------------
        CALL DXEFRO(NP,T2VE,EFFGT,ZR(JEFFG))

      END IF

      IF (OPTION.EQ.'SIEF_ELGA') THEN
C ---   PASSAGE DES CONTRAINTES DANS LE REPERE UTILISATEUR :
        CALL COSIRO(NOMTE,'PCONTRR','IU','G',JSIGM,'S')
      ENDIF

      END
