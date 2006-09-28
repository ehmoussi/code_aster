      SUBROUTINE RCMOME(JMAT,JPROL,JVALE,NBVALE,E,ITRAC)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C ----------------------------------------------------------------------
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER            IMATE, JPROL, JVALE, NBVALE,ITRAC,JMAT
      REAL*8             E
C ----------------------------------------------------------------------
C     DETERMINATION DU MODULE DE YOUNG ET DE LA FONCTION D'ECROUISSAGE
C     A PARTIR DE LA COURBE DE TRACTION D'UN MATERIAU DONNE

C IN  IMATE  : ADRESSE DU MATERIAU CODE
C OUT JPROL  : ADRESSE DE L'OBJET .PROL DE LA S.D. FONCTION R(P)
C OUT JVALE  : ADRESSE DE L'OBJET .VALE DE LA S.D. FONCTION R(P)
C OUT NBVALE : NOMBRE DE VALEURS DE LA FONCTION R(P)
C OUT E      : MODULE DE YOUNG
C OUT ITRAC  : =1 SI LA COURBE EXISTE, =0 SINON
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      CHARACTER*32       JEXNUM , JEXNOM
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------

      LOGICAL       PROCON
      INTEGER       ICOMP, IPI, IDF, NBF, IVALK, IK, IPIF, IPIFC, JPRO
      INTEGER       JVALF1, NBVF1, K, NBMAT
      INTEGER       JVALN, NBVN, I, J, JVALF2, NBVF2, NBV
      REAL*8        COEF
C ----------------------------------------------------------------------
C PARAMETER ASSOCIE AU MATERIAU CODE
      INTEGER       LMAT,   LFCT
      PARAMETER    (LMAT=7, LFCT=9)
      INTEGER            NBPTMS
      COMMON/ICOELJ/      NBPTMS
C DEB ------------------------------------------------------------------

      NBMAT=ZI(JMAT)
      CALL ASSERT(NBMAT.EQ.1)
      IMATE = JMAT+ZI(JMAT+NBMAT+1)

      ITRAC=1
      DO 10 ICOMP=1,ZI(IMATE+1)
        IF ( 'DIS_CONTACT' .EQ. ZK16(ZI(IMATE)+ICOMP-1)(1:11) ) THEN
          IPI = ZI(IMATE+2+ICOMP-1)
          GOTO 11
        ENDIF
 10   CONTINUE
      ITRAC=0
      GOTO 9999
 11   CONTINUE
      IDF   = ZI(IPI)+ZI(IPI+1)
      NBF   = ZI(IPI+2)
      IVALK = ZI(IPI+3)
      DO 160 IK = 1,NBF
        IF ('RELA_MZ' .EQ. ZK8(IVALK+IDF+IK-1)(1:7)) THEN
          IPIF = IPI+LMAT-1+LFCT*(IK-1)
          GOTO 170
        ENDIF
 160  CONTINUE
      ITRAC=0
      GOTO 9999
 170  CONTINUE
C
      IPIFC  = ZI(IPIF+6)
      JPROL  = ZI(IPIFC)
      JVALE  = ZI(IPIFC+1)
C LES POINTEURS JPROL ET JVALE SUR ZONE DE TRAVAIL RDPE
C ETENDU SONT MODIFIES PAR RCTRAC
      JPRO   = ZI(IPIF+1)
      IF (ZK16(JPRO)(1:1).EQ.'C') THEN
C
C ----- FONCTION CONSTANTE - IMPOSSIBLE
C
        CALL U2MESS('F','MODELISA6_66')
      ELSE IF (ZK16(JPRO)(1:1).EQ.'F') THEN
C
C ----- FONCTION D'UNE SEULE VARIABLE
C
        JVALF1= ZI(IPIF+2)
        NBVF1 = ZI(IPIF)
        NBVALE  = NBVF1
        DO 50 K=1,NBVF1
          ZR(JVALE+K-1)       = ZR(JVALF1+K-1)
          ZR(JVALE+K-1+NBVF1) = ZR(JVALF1+K-1+NBVF1)
 50     CONTINUE
        ZK16(JPROL+4) = ZK16(JPRO+4)
      ELSE IF (ZK16(JPRO)(1:1).EQ.'N') THEN
C
C ----- NAPPE - IMPOSSIBLE
C
        CALL U2MESS('F','MODELISA6_67')
      ELSE
        CALL U2MESK('F','MODELISA6_68',1,ZK16(JPRO))
      ENDIF
C
C --- CONSTRUCTION DE LA COURBE R(P)
C
      E = ZR(JVALE+NBVALE)/ZR(JVALE)
C
      ZR(JVALE) = 0.D0
      DO 300 K=1,NBVALE-1
        ZR(JVALE+K) = ZR(JVALE+K) - ZR(JVALE+NBVALE+K)/E
 300  CONTINUE
9999  CONTINUE
      END
