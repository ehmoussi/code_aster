      SUBROUTINE VP2INI(LDYNAM,LMASSE,LDYNFA,NEQ,NBVECT,NBORTO,PRORTO,
     &                  DDLEXC,DDLLAG,ALPHA,BETA,SIGNES,VECT,PRSUDG,
     &                  NSTOC,OMESHI)
      IMPLICIT NONE
      INTEGER LDYNAM,LMASSE,LDYNFA,NEQ,NBVECT,NBORTO,DDLEXC(*),
     &        DDLLAG(*),NSTOC
      REAL*8 PRSUDG,PRORTO,OMESHI
      REAL*8 ALPHA(*),BETA(*),SIGNES(*),VECT(NEQ,*)
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 01/02/2000   AUTEUR VABHHTS J.PELLET 
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
C     GENERATION DE VECTEURS ORTHOGONAUX PAR LA METHODE DE LANCZOS
C     LES VECTEURS OBTENUS SONT K-ORTHOGONAUX ET PAS FORCEMENT M-ORTHOG.
C     ------------------------------------------------------------------
C IN  LDYNAM : IS : DESCRIPTEUR MATRICE DE "RAIDEUR"
C IN  LMASSE : IS : DESCRIPTEUR MATRICE DE "MASSE"
C IN  LDYNFA : IS : DESCRIPTEUR MATRICE DE "RAIDEUR" FACTORISEE
C IN  NEQ    : IS : DIMENSION DES VECTEURS
C IN  NBVECT : IS : NOMBRE DE VECTEURS A GENERER
C IN  PRORTO : R8 : PRECISON DEMANDEE POUR L'ORTHOGONALISATION
C IN  NBORTO : IS : NOMBRE MAXIMUM D'ORTHOGONALISATION PERMISE.
C IN  DDLEXC : IS : POSITION DES DDLS BLOQUES
C IN  DDLLAG : IS : POSITION DES LAGRANGES
C IN  PRSUDG : R8 : PRECISION TERME BETA NUL PAR RAPPORT A ALPHA
C IN  NSTOC  : IS : NOMBRE DE MODES DE CORPS RIGIDE
C OUT ALPHA  : R8 : TERME DIAGONAL DE LA MATRICE TRIDIAGONALE
C OUT BETA   : R8 : TERME SURDIAGONAL DE LA MATRICE TRIDIAGONALE
C OUT SIGNES : R8 : (+/- 1)  SIGNE DU TERME SOUS-DIAGONAL
C OUT VECT   : R8 : VECT(1..NEQ,1..NBVECT) VECTEURS DE LANCZOS
C     ------------------------------------------------------------------
C       ON A DEJA CALCULE DYNAM = RAIDEUR - SHIFT * MASSE
C       PRENDRE  V(1)  ALEATOIRE
C             % A = ALPHA
C             % B = BETA
C       A(1) = V(1) * MASSE * V(1)    % TERME DIAGONAL
C       B(1) = 0.
C       POUR I= 2, N FAIRE
C          A(I) = V(I)   * MASSE * V(I)    % TERME DIAGONAL
C          B(I) = V(I-1) * MASSE * V(I)    % TERME EXTRA DIAGONAL
C          W(I+1) = (DYNAM**-1) * MASSE * V(I) - A(I)*V(I) - B(I)*V(I-1)
C          V(I+1) = W(I+1) / SQRT( W(I+1) * DYNAM * W(I+1) )
C       FIN_FAIRE

C     ------------------------------------------------------------------

C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------

C     -----------------------------------------------------------------
      REAL*8 AI,COEF,BI,XIKXI,XJKXI,XJKXIS
      REAL*8 DSEED
      COMPLEX*16 CBID
      INTEGER IABLO,NBBLOC,IADIA,IDEB
      INTEGER LX,LMX,LKX,IRDIAK,IVECD,ISTO,LKXSTO,IEQ,IBLOC
      INTEGER IL,IAA,JJ,LKX1,IVEC,IVECP1,IVECM1,LKXP1,JVEC
      CHARACTER*24 VALE
C     -----------------------------------------------------------------
      CHARACTER*24 WORK(5)
      DATA WORK(1)/'&&VP2INI.VECTEUR_INITIAL'/
      DATA WORK(2)/'&&VP2INI.VECTEUR_MX     '/
      DATA WORK(3)/'&&VP2INI.VECTEURS_KX    '/
      DATA WORK(4)/'&&VP2INI.RDIAK          '/
      DATA VALE/'                   .VALE'/
C     -----------------------------------------------------------------

C     -----------------------------------------------------------------
C     ---------------- ALLOCATION DES ZONES DE TRAVAIL ----------------
C     -----------------------------------------------------------------
      CALL JEMARQ()
      CALL WKVECT(WORK(1),'V V R',NEQ,LX)
      CALL WKVECT(WORK(2),'V V R',NEQ,LMX)
      CALL WKVECT(WORK(3),'V V R',NEQ*NBVECT,LKX)
      CALL WKVECT(WORK(4),'V V R',NEQ,IRDIAK)
C     -----------------------------------------------------------------
C     -------------- CALCUL DU PREMIER VECTEUR DE LANCZOS -------------
C     -----------------------------------------------------------------

      IVECD = 1

      IVECD = IVECD + NSTOC
      DO 30 ISTO = 1,NSTOC
        ALPHA(ISTO) = 1.D0/OMESHI
        ALPHA(ISTO) = -ALPHA(ISTO)
        BETA(ISTO) = 0.D0
        LKXSTO = LKX + (ISTO-1)*NEQ
        CALL MRMULT('ZERO',LDYNAM,VECT(1,ISTO),'R',ZR(LKXSTO),1)
        XIKXI = 0.D0
        DO 10 IEQ = 1,NEQ
          XIKXI = XIKXI + VECT(IEQ,ISTO)*ZR(LKXSTO+IEQ-1)
   10   CONTINUE
        SIGNES(ISTO) = SIGN(1.D0,XIKXI)
        COEF = 1.D0/SQRT(ABS(XIKXI))
        DO 20 IEQ = 1,NEQ
          VECT(IEQ,ISTO) = COEF*VECT(IEQ,ISTO)
          ZR(LKXSTO+IEQ-1) = COEF*ZR(LKXSTO+IEQ-1)
   20   CONTINUE

        IF (ISTO.NE.1) THEN
          CALL VPLCOR(LDYNAM,NEQ,NBVECT,NBORTO,PRORTO,SIGNES,VECT,ISTO,
     &                ZR(LKX),ZR(LX))
        END IF
        ALPHA(ISTO) = SIGNES(ISTO)*ALPHA(ISTO)
   30 CONTINUE



      CALL MTDSC2(ZK24(ZI(LDYNAM+1)),'ADIA','L',IADIA)
      CALL MTDSC2(ZK24(ZI(LDYNAM+1)),'ABLO','L',IABLO)
      NBBLOC = ZI(LDYNAM+13)
      VALE(1:19) = ZK24(ZI(LDYNAM+1))
      IDEB = 1
      DO 50 IBLOC = 1,NBBLOC
        IL = ZI(IABLO+IBLOC)
        CALL JEVEUO(JEXNUM(VALE,IBLOC),'L',IAA)
        DO 40 JJ = IDEB,IL
          ZR(IRDIAK+JJ-1) = ZR(IAA+ZI(IADIA+JJ-1)-1)
   40   CONTINUE
        IDEB = IL
        CALL JELIBE(JEXNUM(VALE,IBLOC))
   50 CONTINUE

C     --- VECTEUR INITIAL : ALEATOIRE ---

   60 CONTINUE
      DSEED = 123457.D0*IVECD
      CALL GGUBS(DSEED,NEQ,ZR(LX))
      DO 70 IEQ = 1,NEQ
        ZR(LX+IEQ-1) = ZR(LX+IEQ-1)*DDLLAG(IEQ)*ZR(IRDIAK+IEQ-1)
   70 CONTINUE
      CALL RLDLGG(LDYNFA,ZR(LX),CBID,1)
      DO 80 IEQ = 1,NEQ
        ZR(LX+IEQ-1) = ZR(LX+IEQ-1)*DDLLAG(IEQ)
   80 CONTINUE

C     --- CALCUL DE (LDYNAM**-1)*MASSE * X0 ---

      LKX1 = LKX + NEQ* (IVECD-1) + NEQ*NSTOC

      CALL MRMULT('ZERO',LMASSE,ZR(LX),'R',ZR(LMX),1)
      DO 90 IEQ = 1,NEQ
        VECT(IEQ,IVECD) = ZR(LMX+IEQ-1)*DDLEXC(IEQ)
   90 CONTINUE
      CALL RLDLGG(LDYNFA,VECT(1,IVECD),CBID,1)

C     --- K-ORTHONORMALISATION DU 1-ER VECTEUR ---

      CALL MRMULT('ZERO',LDYNAM,VECT(1,IVECD),'R',ZR(LKX1),1)
      XIKXI = 0.D0
      DO 100 IEQ = 1,NEQ
        XIKXI = XIKXI + VECT(IEQ,IVECD)*ZR(LKX1+IEQ-1)
  100 CONTINUE
      SIGNES(IVECD) = SIGN(1.D0,XIKXI)
      COEF = 1.D0/SQRT(ABS(XIKXI))
      DO 110 IEQ = 1,NEQ
        VECT(IEQ,IVECD) = COEF*VECT(IEQ,IVECD)
        ZR(LKX1+IEQ-1) = COEF*ZR(LKX1+IEQ-1)
  110 CONTINUE

      IF (IVECD.GT.1) THEN
        CALL VPLCOR(LDYNAM,NEQ,NBVECT,NBORTO,PRORTO,SIGNES,VECT,IVECD,
     &              ZR(LKX),ZR(LX))
      END IF


C     --- CALCUL DE ALPHA(1)

      CALL MRMULT('ZERO',LMASSE,VECT(1,IVECD),'R',ZR(LX),1)
      AI = 0.D0
      DO 120 IEQ = 1,NEQ
        AI = AI + VECT(IEQ,IVECD)*ZR(LX+IEQ-1)
  120 CONTINUE
      ALPHA(IVECD) = AI
      BETA(IVECD) = 0.D0

C     -----------------------------------------------------------------
C     -------------- CALCUL DES AUTRES VECTEURS DE LANCZOS ------------
C     -----------------------------------------------------------------

      DO 220 IVEC = IVECD,NBVECT - 1

        IVECP1 = IVEC + 1
        IVECM1 = IVEC - 1
        LKXP1 = LKX + NEQ*IVEC

        CALL MRMULT('ZERO',LMASSE,VECT(1,IVEC),'R',ZR(LMX),1)
        AI = 0.D0
        DO 130 IEQ = 1,NEQ
          AI = AI + VECT(IEQ,IVEC)*ZR(LMX+IEQ-1)
  130   CONTINUE
        DO 140 IEQ = 1,NEQ
          VECT(IEQ,IVECP1) = ZR(LMX+IEQ-1)*DDLEXC(IEQ)
  140   CONTINUE
        CALL RLDLGG(LDYNFA,VECT(1,IVECP1),CBID,1)

        IF (IVECM1.EQ. (IVECD-1)) THEN
          DO 150 IEQ = 1,NEQ
            VECT(IEQ,IVECP1) = VECT(IEQ,IVECP1) -
     &                         AI*SIGNES(IVEC)*VECT(IEQ,IVEC)
  150     CONTINUE
        ELSE
          BI = 0.D0
          DO 160 IEQ = 1,NEQ
            BI = BI + VECT(IEQ,IVECM1)*ZR(LMX+IEQ-1)
  160     CONTINUE
          DO 170 IEQ = 1,NEQ
            VECT(IEQ,IVECP1) = VECT(IEQ,IVECP1) -
     &                         AI*SIGNES(IVEC)*VECT(IEQ,IVEC) -
     &                         BI*SIGNES(IVECM1)*VECT(IEQ,IVECM1)
  170     CONTINUE
        END IF

C         --- K-NORMALISATION DU VECTEUR IVECP1 ---

        CALL MRMULT('ZERO',LDYNAM,VECT(1,IVECP1),'R',ZR(LKXP1),1)
        XIKXI = 0.D0
        DO 180 IEQ = 1,NEQ
          XIKXI = XIKXI + VECT(IEQ,IVECP1)*ZR(LKXP1+IEQ-1)
  180   CONTINUE
        SIGNES(IVECP1) = SIGN(1.D0,XIKXI)
        COEF = 1.D0/SQRT(ABS(XIKXI))
        DO 190 IEQ = 1,NEQ
          VECT(IEQ,IVECP1) = COEF*VECT(IEQ,IVECP1)
          ZR(LKXP1+IEQ-1) = COEF*ZR(LKXP1+IEQ-1)
  190   CONTINUE

C         --- K-REORTHOGONALISATION COMPLETE DU VECTEUR IVECP1

        CALL VPLCOR(LDYNAM,NEQ,NBVECT,NBORTO,PRORTO,SIGNES,VECT,IVECP1,
     &              ZR(LKX),ZR(LX))


C         --- CALCUL DE ALPHA ET BETA ---

        DO 210 JVEC = IVEC,IVECP1
          CALL MRMULT('ZERO',LMASSE,VECT(1,IVECP1),'R',ZR(LX),1)
          XJKXI = 0.D0
          DO 200 IEQ = 1,NEQ
            XJKXI = XJKXI + VECT(IEQ,JVEC)*ZR(LX+IEQ-1)
  200     CONTINUE
          IF (JVEC.EQ.IVEC) BETA(IVECP1) = XJKXI
  210   CONTINUE
        ALPHA(IVECP1) = XJKXI
        IF (ABS(BETA(IVECP1)).LE. (PRSUDG*ABS(ALPHA(IVECP1)))) THEN
          IVECD = IVECP1
          CALL UTDEBM('I','VP2INI','DETECTION D''UN TERME NUL SUR'//
     &                'LA SURDIAGONALE')
          CALL UTIMPR('L','VALEUR DE BETA  ',1,BETA(IVECP1))
          CALL UTIMPR('L','VALEUR DE ALPHA ',1,ALPHA(IVECP1))
          CALL UTFINM()
          GO TO 60
        END IF

  220 CONTINUE

C     -----------------------------------------------------------------
C     --------------- DESTRUCTION DES ZONES DE TRAVAIL ----------------
C     -----------------------------------------------------------------

      CALL JEDETR(WORK(1))
      CALL JEDETR(WORK(2))
      CALL JEDETR(WORK(3))
      CALL JEDETR(WORK(4))

      CALL JEDEMA()
      END
