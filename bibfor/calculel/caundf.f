      SUBROUTINE CAUNDF(CODE,OPT,TE)
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 07/05/2008   AUTEUR COURTOIS M.COURTOIS 
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
C RESPONSABLE                            VABHHTS J.PELLET
C     ARGUMENTS:
C     ----------
      INTEGER OPT,TE
      CHARACTER*5 CODE
C ----------------------------------------------------------------------
C     ENTREES:
C      CODE :  / 'ECRIT' : ON ECRIT UNE VALEUR UNDEF AU BOUT DES CHLOC
C              / 'VERIF' : ON VERIFIE LA VALEUR UNDEF AU BOUT DES CHLOC
C      OPT : OPTION
C      TE  : TYPE_ELEMENT
C ----------------------------------------------------------------------
      COMMON /CAII02/IAOPTT,LGCO,IAOPMO,ILOPMO,IAOPNO,ILOPNO,IAOPDS,
     &       IAOPPA,NPARIO,NPARIN,IAMLOC,ILMLOC,IADSGD
      INTEGER        IAWLOC,IAWTYP,NBELGR,IGR,JCTEAT,LCTEAT
      COMMON /CAII06/IAWLOC,IAWTYP,NBELGR,IGR,JCTEAT,LCTEAT
      COMMON /CAII04/IACHII,IACHIK,IACHIX
      COMMON /CAII07/IACHOI,IACHOK
      COMMON /CAII08/IEL
      INTEGER EVFINI,CALVOI,JREPE,JPTVOI,JELVOI
      COMMON /CAII19/EVFINI,CALVOI,JREPE,JPTVOI,JELVOI
      INTEGER NBPARA,ISNNEM,INDIK8,INNEM
      CHARACTER*8 NOPARA
      INTEGER NP,IPAR,LGCATA
      INTEGER IAOPTT,LGCO,IAOPMO,ILOPMO,IAOPNO,ILOPNO,IAOPDS,IAOPPA
      INTEGER NPARIO,NPARIN,IAMLOC,ILMLOC,IADSGD
      INTEGER IACHII,IACHIK,IACHIX,IACHOI
      INTEGER IACHOK,IEL,IPARG,JCELD,LGGREL,IACHLO
      CHARACTER*3 TYPSCA
      CHARACTER*8 NOMPAR
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*32 JEXNUM,JEXNOM,JEXATR,JEXR8
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL,ECRAS,ARRET,ETENDU
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16,NOMTE,NOMOPT
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C ---------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------
      INTEGER IUNDF,IISNAN,ICH,JRSVI,JCRSVI
      REAL*8 RNNEM,R8NNEM
      CHARACTER*8 KNNEM,TYCH
      CHARACTER*24 VALK(3)

C DEB-------------------------------------------------------------------

      INNEM = ISNNEM()
      RNNEM = R8NNEM()
      KNNEM='????????'

      CALL ASSERT((CODE.EQ.'ECRIT').OR.(CODE.EQ.'VERIF'))
      IF (CODE.EQ.'ECRIT') THEN
C     ------------------------------------------------

C        -- CHAMPS "OUT" :
        NP = NBPARA(OPT,TE,'OUT')
        DO 10 IPAR = 1,NP
          NOMPAR = NOPARA(OPT,TE,'OUT',IPAR)

          IPARG = INDIK8(ZK8(IAOPPA),NOMPAR,1,NPARIO)
          LGCATA = ZI(IAWLOC-1+7* (IPARG-1)+4)
          IF (LGCATA.LE.0) GO TO 10
          ICH = ZI(IAWLOC-1+7* (IPARG-1)+7)
          IF (ICH.EQ.0) GOTO 10

          CALL CHLOET(IPARG,ETENDU,JCELD)
          IF (ETENDU) THEN
C           -- LE CHAMP LOCAL EST ETENDU :
            LGGREL = ZI(JCELD-1+ZI(JCELD-1+4+IGR)+4)
          ELSE
            LGGREL = NBELGR*LGCATA
            TYCH=ZK8(IACHOK-1+2*(ICH-1)+1)
            IF (TYCH.EQ.'RESL' .AND. EVFINI.EQ.1) THEN
              JRSVI = ZI(IACHOI-1+3*(ICH-1)+2)
              JCRSVI = ZI(IACHOI-1+3*(ICH-1)+3)
              LGGREL = ZI(JRSVI-1+ZI(JCRSVI-1+IGR)+NBELGR)-1
            ENDIF
          END IF

          IACHLO = ZI(IAWLOC-1+7* (IPARG-1)+1)
          IF ((IACHLO.EQ.-1) .OR. (IACHLO.EQ.-2)) GOTO 10
          TYPSCA = ZK8(IAWTYP-1+IPARG)

          IF (TYPSCA.EQ.'R') THEN
            ZR(IACHLO-1+LGGREL+1) = RNNEM
          ELSE IF (TYPSCA.EQ.'C') THEN
            ZC(IACHLO-1+LGGREL+1) = DCMPLX(RNNEM,RNNEM)
          ELSE IF (TYPSCA.EQ.'I') THEN
            ZI(IACHLO-1+LGGREL+1) = INNEM
          ELSE
            CALL ASSERT(.FALSE.)
          END IF
   10   CONTINUE

C        -- CHAMPS "IN" :
        NP = NBPARA(OPT,TE,'IN ')
        DO 20 IPAR = 1,NP
          NOMPAR = NOPARA(OPT,TE,'IN ',IPAR)

          IPARG = INDIK8(ZK8(IAOPPA),NOMPAR,1,NPARIO)
          LGCATA = ZI(IAWLOC-1+7* (IPARG-1)+4)
          IF (LGCATA.LE.0) GOTO 20

C         -- LE CHAMP LOCAL EST-IL ETENDU ?
          CALL CHLOET(IPARG,ETENDU,JCELD)
          IF (ETENDU) THEN
            LGGREL = ZI(JCELD-1+ZI(JCELD-1+4+IGR)+4)
          ELSE
            LGGREL = NBELGR*LGCATA
          END IF

          IACHLO = ZI(IAWLOC-1+7* (IPARG-1)+1)
          IF ((IACHLO.EQ.-1) .OR. (IACHLO.EQ.-2)) GOTO 20
          TYPSCA = ZK8(IAWTYP-1+IPARG)

          IF (TYPSCA.EQ.'R') THEN
            ZR(IACHLO-1+LGGREL+1) = RNNEM
          ELSE IF (TYPSCA.EQ.'C') THEN
            ZC(IACHLO-1+LGGREL+1) = DCMPLX(RNNEM,RNNEM)
          ELSE IF (TYPSCA.EQ.'I') THEN
            ZI(IACHLO-1+LGGREL+1) = INNEM
          ELSE IF (TYPSCA.EQ.'K8') THEN
            ZK8(IACHLO-1+LGGREL+1) = KNNEM
          ELSE IF (TYPSCA.EQ.'K16') THEN
            ZK16(IACHLO-1+LGGREL+1) = KNNEM
          ELSE IF (TYPSCA.EQ.'K24') THEN
            ZK24(IACHLO-1+LGGREL+1) = KNNEM
          ELSE
            CALL ASSERT(.FALSE.)
          END IF
   20   CONTINUE


      ELSE IF (CODE.EQ.'VERIF') THEN
C     ------------------------------------------------

C        -- CHAMPS "OUT" :
        ARRET = .FALSE.
        NP = NBPARA(OPT,TE,'OUT')
        DO 30 IPAR = 1,NP
          ECRAS=.FALSE.
          NOMPAR = NOPARA(OPT,TE,'OUT',IPAR)

          IPARG = INDIK8(ZK8(IAOPPA),NOMPAR,1,NPARIO)
          LGCATA = ZI(IAWLOC-1+7* (IPARG-1)+4)
          IF (LGCATA.LE.0) GOTO 30
          ICH = ZI(IAWLOC-1+7* (IPARG-1)+7)
          IF (ICH.EQ.0) GOTO 30

          CALL CHLOET(IPARG,ETENDU,JCELD)
          IF (ETENDU) THEN
C           -- LE CHAMP LOCAL EST ETENDU :
            LGGREL = ZI(JCELD-1+ZI(JCELD-1+4+IGR)+4)
          ELSE
            LGGREL = NBELGR*LGCATA
            TYCH=ZK8(IACHOK-1+2*(ICH-1)+1)
            IF (TYCH.EQ.'RESL' .AND. EVFINI.EQ.1) THEN
              JRSVI = ZI(IACHOI-1+3*(ICH-1)+2)
              JCRSVI = ZI(IACHOI-1+3*(ICH-1)+3)
              LGGREL = ZI(JRSVI-1+ZI(JCRSVI-1+IGR)+NBELGR)-1
            ENDIF
          END IF

          IACHLO = ZI(IAWLOC-1+7* (IPARG-1)+1)
          IF ((IACHLO.EQ.-1) .OR. (IACHLO.EQ.-2)) GOTO 30
          TYPSCA = ZK8(IAWTYP-1+IPARG)

          IF (TYPSCA.EQ.'R') THEN
            IF (IISNAN(ZR(IACHLO-1+LGGREL+1)).EQ.0) ECRAS=.TRUE.
          ELSE IF (TYPSCA.EQ.'C') THEN
            IF (IISNAN(DBLE(ZC(IACHLO-1+LGGREL+1))).EQ.0) ECRAS=.TRUE.
            IF (IISNAN(DIMAG(ZC(IACHLO-1+LGGREL+1))).EQ.0) ECRAS=.TRUE.
          ELSE IF (TYPSCA.EQ.'I') THEN
            IF (ZI(IACHLO-1+LGGREL+1).NE.INNEM) ECRAS=.TRUE.
          ELSE
            CALL ASSERT(.FALSE.)
          END IF

          IF (ECRAS) THEN
            ARRET = .TRUE.
            CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',TE),NOMTE)
            CALL JENUNO(JEXNUM('&CATA.OP.NOMOPT',OPT),NOMOPT)
             VALK(1) = NOMTE
             VALK(2) = NOMOPT
             VALK(3) = NOMPAR
             CALL U2MESK('E','CALCULEL_42', 3 ,VALK)
          END IF

   30   CONTINUE

        CALL ASSERT(.NOT.ARRET)

      END IF


   40 CONTINUE
      END
