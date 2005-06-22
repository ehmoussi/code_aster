      SUBROUTINE TE0516(OPTION,NOMTE)
      IMPLICIT NONE
      CHARACTER*16 OPTION,NOMTE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 23/06/2005   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
C
C ======================================================================
C-----------------------------------------------------------------------
C     ELEMENTS DE POUTRE MULTI-FIBRES DE TIMOSHENKO AVEC GAUCHISSEMENT.
C
C    - FONCTION REALISEE:  CALCUL DES OPTIONS NON-LINEAIRES MECANIQUES
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  RAPH_MECA ET FULL_MECA
C                                        OU RIGI_MECA_TANG
C                      NOMTE        -->  MECA_POU_D_TGM
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
C     NC  : NOMBRE DE COMPOSANTES DE CONTRAINTES
C     NNO : NOMBRE DE NOEUDS
C     NPG : NOMBRE DE POINTS DE GAUSS
      INTEGER     NC, NNO, DIMKLV , NPG,IRET,CODREP
      PARAMETER ( NC = 7 , DIMKLV = 2*NC*(2*NC+1)/2 ,NNO = 2 , NPG = 3)
      REAL*8 HOEL(NC),FL(2*NC),HOTA(NC,NC),D1B(NC,2*NC)
      REAL*8 RG0(2*NC*2*NC),EPS(NC),DEPS(NC),U(2*NC),DU(2*NC)
      REAL*8 KLV(DIMKLV),WORK(NC,2*NC)
      REAL*8 CO(NPG),EPSM


      REAL*8 PGL(3,3),FFP(3),MATSCT(6)
      REAL*8 ALFA1,BETA1,GAMMA1,XD(3),XUG(6),ANG1(3),UTG(14),TET1,TET2
      REAL*8  ALFA, BETA, EY, EZ, GAMMA, XL, XL2, XLS2
      LOGICAL VECTEU,MATRIC,REACTU
      INTEGER ITREF,I,ITEMP,ITEMPM,ITEMPP,JCRET,ISECAN,IRETM,IRETP
      INTEGER IGEOM,IMATE,ICONTM,ISECT,IORIEN,ICOMPO,IVARIM,IINSTP
      INTEGER ICARCR,IDEPLM,IDEPLP,IINSTM,IVECTU,ICONTP,IVARIP,IMAT
      INTEGER NCARFI,NBFIB,JACF,JTAB(7),IVARMP,CODRET

      INTEGER NCOMP,JDEFM,JDEFP,JMODFB,JSIGFB,NBVALC,JVARFB
      INTEGER KP,J,K,KK
      REAL*8 AA,XIY,XIZ,ALFAY,ALFAZ,XJX,XJG,R8VIDE
      REAL*8 E,G,EM,NU,NUM,ALPHAP,ALPHAM,TEMP,TEMM,PHIY,PHIZ,F,DF
      REAL*8 DEFAM(6),DEFAP(6)
C     ------------------------------------------------------------------

      CALL R8INIR(NC,0.D0,HOEL,1)
      CALL R8INIR(2*NC,0.D0,FL,1)
      CALL R8INIR(NC*NC,0.D0,HOTA,1)
      CALL R8INIR(2*NC*2*NC,0.D0,RG0,1)
      CODRET=0
      CODREP=0

C     POIDS DES POINTS DE GAUSS
      CO(1) = 5.D0/9.D0
      CO(2) = 8.D0/9.D0
      CO(3) = 5.D0/9.D0

C     -- BOOLEENS PRATIQUES :
      MATRIC = OPTION .EQ. 'FULL_MECA' .OR. OPTION .EQ. 'RIGI_MECA_TANG'
      VECTEU = OPTION .EQ. 'FULL_MECA' .OR. OPTION .EQ. 'RAPH_MECA'

C     --- RECUPERATION DES CARACTERISTIQUES DES FIBRES
C     NOMBRE DE VARIABLES PAR POINT DE GAUSS EN PLUS DU NBFIB
      NCOMP = 7
      CALL JEVECH('PNBSP_I','L',I)
      NBFIB = ZI(I)
      CALL JEVECH('PFIBRES','L',JACF)
      NCARFI = 3
C
C     -- RECUPERATION DES PARAMETRES "IN"/"OUT":
C
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)

      CALL TECACH('OON','PCONTMR',7,JTAB,IRET)
      CALL ASSERT(JTAB(7).EQ. (NBFIB+NCOMP))
      ICONTM = JTAB(1)

      CALL TECACH('OON','PVARIMR',7,JTAB,IRET)
      CALL ASSERT(JTAB(7).EQ. (NBFIB+NCOMP))
      IVARIM = JTAB(1)

      IF (VECTEU) THEN
         CALL TECACH('OON','PVARIMP',7,JTAB,IRET)
         CALL ASSERT(JTAB(7).EQ. (NBFIB+NCOMP))
         IVARMP = JTAB(1)
      ENDIF
      
      CALL JEVECH('PCAGNPO','L',ISECT)
      CALL JEVECH('PCAORIE','L',IORIEN)
      CALL JEVECH('PCOMPOR','L',ICOMPO)
      CALL JEVECH('PINSTMR','L',IINSTM)
      CALL JEVECH('PINSTPR','L',IINSTP)
      CALL JEVECH('PDEPLMR','L',IDEPLM)
      CALL JEVECH('PCARCRI','L',ICARCR)
      CALL JEVECH('PDEPLPR','L',IDEPLP)
      CALL JEVECH('PTEREF', 'L',ITREF)
      
      

      CALL TECACH('ONN','PTEMPMR',1,ITEMPM,IRETM)
      CALL TECACH('ONN','PTEMPPR',1,ITEMPP,IRETP)
      IF ((IRETM.EQ.0).AND.(IRETP.EQ.0)) THEN
         ITEMP = 1
      ELSE
         ITEMP = 0
      ENDIF

      IF ( MATRIC ) CALL JEVECH('PMATUUR','E',IMAT)
      IF ( VECTEU ) THEN
        CALL JEVECH('PVECTUR','E',IVECTU)
        CALL JEVECH('PCONTPR','E',ICONTP)
        CALL JEVECH('PVARIPR','E',IVARIP)
      END IF
C DEFORMATIONS ANELASTIQUES
      CALL R8INIR (6,0.D0,DEFAM,1)
      CALL R8INIR (6,0.D0,DEFAP,1)
C
      IF ( ZK16(ICOMPO+3) .EQ. 'COMP_ELAS' ) THEN
         CALL UTMESS('F','TE0516','COMP_ELAS NON VALIDE')
      ENDIF

C     GEOMETRIE EVENTUELLEMENT  REACTUALISEE :
C
      DO 100 I = 1,14
        UTG(I) = ZR(IDEPLM-1+I) + ZR(IDEPLP-1+I)
100   CONTINUE
      REACTU =  ZK16(ICOMPO+2)(6:10) .EQ. '_REAC'
      IF ( REACTU ) THEN
        DO 110 I = 1,3
          XUG(I) = UTG(I) + ZR(IGEOM-1+I)
          XUG(I+3) = UTG(I+7) + ZR(IGEOM-1+I+3)
110     CONTINUE
        CALL VDIFF(3,XUG(4),XUG(1),XD)
        CALL PSCAL(3,XD,XD,XL2)
        XL = SQRT(XL2)
        CALL PSCAL(3,UTG(4),XD,TET1)
        CALL PSCAL(3,UTG(11),XD,TET2)
        TET1 = TET1/XL
        TET2 = TET2/XL
        CALL ANGVX(XD,ALFA1,BETA1)
        GAMMA = ZR(IORIEN+2)
        GAMMA1 = GAMMA + (TET1+TET2)/2.D0
        ANG1(1) = ALFA1
        ANG1(2) = BETA1
        ANG1(3) = GAMMA1
        CALL MATROT ( ANG1 , PGL )
      ELSE
        CALL VDIFF(3,ZR(IGEOM-1+4),ZR(IGEOM),XD)
        CALL PSCAL(3,XD,XD,XL2)
        XL = SQRT(XL2)
        ALFA = ZR(IORIEN+0)
        BETA = ZR(IORIEN+1)
        GAMMA = ZR(IORIEN+2)
        ANG1(1) = ALFA
        ANG1(2) = BETA
        ANG1(3) = GAMMA
        CALL MATROT ( ANG1 , PGL )
      END IF
      XLS2  = XL / 2.D0

C     -- RECUPERATION DES CARACTERISTIQUES DE LA SECTION
      AA    = ZR(ISECT)
      XIY   = ZR(ISECT + 1)
      XIZ   = ZR(ISECT + 2)
      ALFAY = ZR(ISECT + 3)
      ALFAZ = ZR(ISECT + 4)
      XJX   = ZR(ISECT + 7)
      XJG   = ZR(ISECT + 11)
C     -- PASSAGE DE G (CENTRE DE GRAVITE) A C (CENTRE DE TORSION)
      EY = -ZR(ISECT + 5)
      EZ = -ZR(ISECT + 6)

C     -- CALCUL DES DEPLACEMENTS ET DE LEURS INCREMENTS
C        PASSAGE DANS LE REPERE LOCAL:
      CALL UTPVGL ( NNO, NC, PGL, ZR(IDEPLM),  U )
      CALL UTPVGL ( NNO, NC, PGL, ZR(IDEPLP), DU )
C       EPSM = (U(8)-U(1))/XL      
      
C     PRISE EN COMPTE DE LA POSITION DU CENTRE DE TORSION
      DO 200 I = 1 , 2
         U(7*(I-1)+2) =  U(7*(I-1)+2) - EZ* U(7*(I-1)+4)
         U(7*(I-1)+3) =  U(7*(I-1)+3) + EY* U(7*(I-1)+4)
        DU(7*(I-1)+2) = DU(7*(I-1)+2) - EZ*DU(7*(I-1)+4)
        DU(7*(I-1)+3) = DU(7*(I-1)+3) + EY*DU(7*(I-1)+4)
  200 CONTINUE

C     COEFFICIENT DEPENDANT DE LA TEMPERATURE MOYENNE
      IF(ITEMP.EQ.0) THEN
         TEMP=0.D0
         TEMM=0.D0
         CALL MATELA(ZI(IMATE),ITEMP,TEMP,E,NU,ALPHAP)
         EM=E
         NUM=NU
         ALPHAM=ALPHAP
      ELSE
         TEMP = (ZR(ITEMPP)+ZR(ITEMPP+1))/2.D0
         CALL MATELA(ZI(IMATE),ITEMP,TEMP,E,NU,ALPHAP)
         TEMM = (ZR(ITEMPM)+ZR(ITEMPM+1))/2.D0
         CALL MATELA(ZI(IMATE),ITEMP,TEMM,EM,NUM,ALPHAM)
      ENDIF
      G = E / (2.D0*(1.D0+NU))

C     MATRICE DE RAIDEUR ELASTIQUE : MATERIAU INTEGRE SUR LA SECTION
      HOEL(1) = E*AA
      HOEL(2) = G*AA/ALFAY
      HOEL(3) = G*AA/ALFAZ
      HOEL(4) = G*XJX
      HOEL(5) = E*XIY
      HOEL(6) = E*XIZ
      HOEL(7) = E*XJG
      PHIY = E*XIZ*12.D0*ALFAY/ (XL*XL*G*AA)
      PHIZ = E*XIY*12.D0*ALFAZ/ (XL*XL*G*AA)

C --- DEFORMATIIONS MOINS ET INCREMENT DE DEFORMATION POUR CHAQUE FIBRE
      CALL WKVECT('&&TE0516.DEFMFIB','V V R8',NBFIB,JDEFM)
      CALL WKVECT('&&TE0516.DEFPFIB','V V R8',NBFIB,JDEFP)

C --- NOMBRE DE VARIABLE INTERNE DE LA LOI DE COMPORTEMENT
      READ (ZK16(ICOMPO-1+2),'(I16)') NBVALC
C --- MODULE ET CONTRAINTES SUR CHAQUE FIBRE (COMPORTEMENT)
      CALL WKVECT('&&TE0516.MODUFIB','V V R8',NBFIB,JMODFB)
      CALL WKVECT('&&TE0516.SIGFIB' ,'V V R8',NBFIB,JSIGFB)
      CALL WKVECT('&&TE0516.VARFIB' ,'V V R8',NBFIB*NBVALC,JVARFB)

C     BOUCLE SUR LES POINTS DE GAUSS
      DO 300 KP = 1 , 3

C       CALCUL DE EPS ET DEPS
C       CALCUL DE D1B ( EPSI = D1B * U ) :
        CALL JSD1FF(KP,XL,PHIY,PHIZ,D1B)
        CALL R8INIR(NC,0.D0,EPS,1)
        CALL R8INIR(NC,0.D0,DEPS,1)

        DO 310 I = 1,NC
          DO 311 J = 1,2*NC
             EPS(I) =  EPS(I) + D1B(I,J)* U(J)
            DEPS(I) = DEPS(I) + D1B(I,J)*DU(J)
311       CONTINUE
310     CONTINUE

C        IF ((ALPHAP.NE.0.D0).AND.(ITEMP.NE.0) ) THEN
C            F = ALPHAM*(TEMM-ZR(ITREF))
C           DF = ALPHAP*(TEMP-ZR(ITREF))-ALPHAM*(TEMM-ZR(ITREF))
C            EPS(1) =  EPS(1) -  F
C           DEPS(1) = DEPS(1) - DF
C        ENDIF

C       CALCUL DES DEFORMATIONS ET DES INCREMENTS DE DEF SUR LES FIBRES
        CALL PMFDEF(NBFIB,NCARFI,ZR(JACF),EPS ,ZR(JDEFM))
        CALL PMFDEF(NBFIB,NCARFI,ZR(JACF),DEPS,ZR(JDEFP))
        EPSM = (U(8)-U(1))/XL
C   --- AIGUILLAGE SUIVANT COMPORTEMENT
C       POUR AVOIR MODULE ET CONTRAINTE SUR CHAQUE FIBRE
C         ENDIF

        CALL PMFCOM(KP,OPTION,ZK16(ICOMPO),ZR(ICARCR),
     &            NBFIB,
     &            ZR(IINSTM),ZR(IINSTP),
     &            TEMM,TEMP,ZR(ITREF),
     &            E,ALPHAP,
     &            ZI(IMATE),NBVALC,
     &            DEFAM,DEFAP,
     &            ZR(IVARIM+NBFIB*NBVALC*(KP-1)),
     &            ZR(IVARMP+NBFIB*NBVALC*(KP-1)),
     &            ZR(ICONTM+(NBFIB+NCOMP)*(KP-1)),
     &            ZR(JDEFM),ZR(JDEFP),
     &            EPSM,
     &            ZR(JMODFB),ZR(JSIGFB),ZR(JVARFB),ISECAN,CODREP)
        IF (CODREP.NE.0) CODRET=CODREP


        IF ( VECTEU ) THEN
C   ---    CALCUL DES EFFORTS GENERALISES A "+"
C           FFP(1) = +INT(SE.DS)   = N
C           FFP(2) = +INT(SE.Z.DS) = MY
C           FFP(3) = -INT(SE.Y.DS) = MZ
           CALL PMFFOR(NBFIB,NCARFI,ZR(JACF),ZR(JSIGFB),FFP)
        ENDIF

C       CALCUL DE BT*H*B :
        IF ( MATRIC ) THEN
C    ---   CALCUL DE LA MATRICE TANGENTE AU COMPORTEMENT GLOBAL
C          SEULS 3 EFFORTS SONT CONCERNES, LES AUTRES ==> ELASTIQUE
C            EFFORT NORMAL   : COMPOSANTE 1
C            MOMENT AUTOUR Y : COMPOSANTE 5
C            MOMENT AUTOUR Z : COMPOSANTE 6

C   ----   CALCUL DE LA RAIDEUR TANGENTE AU COMPORTEMENT PAR FIBRE
           IF (ISECAN.EQ.1) THEN
             CALL PMFTGT(NBFIB,E,
     &               ZR(ICONTM+(NBFIB+NCOMP)*(KP-1)),
     &               ZR(JSIGFB),ZR(JDEFP),ZR(JMODFB))
           ENDIF


           CALL PMFITE(NBFIB,NCARFI,ZR(JACF),ZR(JMODFB),MATSCT)

C          MATSCT(1) : INT(E.DS)
C          MATSCT(2) : INT(E.Y.DS)
C          MATSCT(3) : INT(E.Z.DS)
C          MATSCT(4) : INT(E.Y.Y.DS)
C          MATSCT(5) : INT(E.Z.Z.DS)
C          MATSCT(6) : INT(E.Y.Z.DS)

           HOTA(2,2) = HOEL(2)
           HOTA(3,3) = HOEL(3)
           HOTA(4,4) = HOEL(4)
           HOTA(7,7) = HOEL(7)

           HOTA(1,1) =  MATSCT(1)
           HOTA(1,5) =  MATSCT(3)
           HOTA(1,6) = -MATSCT(2)
           HOTA(5,1) =  MATSCT(3)
           HOTA(5,5) =  MATSCT(5)
           HOTA(5,6) = -MATSCT(6)
           HOTA(6,1) = -MATSCT(2)
           HOTA(6,5) = -MATSCT(6)
           HOTA(6,6) =  MATSCT(4)
           CALL DSCAL(NC*NC,XLS2,HOTA,1)
           CALL DSCAL(NC*NC,CO(KP),HOTA,1)
           CALL UTBTAB('CUMU',NC,2*NC,HOTA,D1B,WORK,RG0)
        END IF

C       ON STOCKE A "+" : CONTRAINTES, FL, VARI
        IF ( VECTEU ) THEN
           DO 330 I = 1 , NBFIB*NBVALC
              ZR(IVARIP-1+NBFIB*NBVALC*(KP-1)+I) = ZR(JVARFB-1+I)
330        CONTINUE
           DO 332 I = 1 , NBFIB
              ZR(ICONTP-1+(NBFIB+NCOMP)*(KP-1)+I) = ZR(JSIGFB-1+I)
332        CONTINUE

C UNE MAGOUILLE POUR STOCKER LES FORCES INTEGREES !!!
           KK = (NBFIB+NCOMP)*(KP-1) + NBFIB-1
           ZR(ICONTP+KK+1) = FFP(1)
           ZR(ICONTP+KK+2) = ZR(ICONTM+KK+2) + HOEL(2)*DEPS(2)
           ZR(ICONTP+KK+3) = ZR(ICONTM+KK+3) + HOEL(3)*DEPS(3)
           ZR(ICONTP+KK+4) = ZR(ICONTM+KK+4) + HOEL(4)*DEPS(4)
           ZR(ICONTP+KK+5) = FFP(2)
           ZR(ICONTP+KK+6) = FFP(3)
           ZR(ICONTP+KK+7) = ZR(ICONTM+KK+7) + HOEL(7)*DEPS(7)
C FIN MAGOUILLE !!!

           KK = ICONTP-1+(NBFIB+NCOMP)*(KP-1) + NBFIB
           DO 360 K = 1,2*NC
              DO 361 I = 1,NC
                 FL(K)=FL(K) + XLS2*ZR(KK+I)*D1B(I,K)*CO(KP)
361           CONTINUE
360        CONTINUE
        END IF

300   CONTINUE

      IF ( MATRIC ) THEN
         CALL MAVEC  ( RG0, 2*NC, KLV, DIMKLV )
      ENDIF

C ===================================================================

C     ON REND LE FL DANS LE REPERE GLOBAL :
      IF ( VECTEU ) THEN
        DO 216 I = 1,2
          FL(7*(I-1)+4)=FL(7*(I-1)+4)-EZ*FL(7*(I-1)+2)+EY*FL(7*(I-1)+3)
216     CONTINUE
C
        CALL UTPVLG ( NNO, NC, PGL, FL, ZR(IVECTU) )
      END IF

C     ON REND LA MATRICE TANGENTE :
      IF ( MATRIC ) THEN
        CALL POUEX7 ( KLV, EY, EZ )
        CALL UTPSLG ( NNO, NC, PGL, KLV, ZR(IMAT) )
      ENDIF

      IF ( VECTEU )  THEN
         CALL JEVECH('PCODRET','E',JCRET)
         ZI(JCRET) = CODRET
      ENDIF

      CALL JEDETR('&&TE0516.DEFMFIB')
      CALL JEDETR('&&TE0516.DEFPFIB')
      CALL JEDETR('&&TE0516.MODUFIB')
      CALL JEDETR('&&TE0516.SIGFIB')
      CALL JEDETR('&&TE0516.VARFIB')

      END
