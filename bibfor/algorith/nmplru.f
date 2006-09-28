      SUBROUTINE NMPLRU(NDIM,TYPMOD,IMATE,COMPOR,TEMP,TREF,PPG,EPS,
     &                  EPSP,RP,ENER)
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
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INTEGER       NDIM,IMATE
      CHARACTER*8   TYPMOD(*)
      CHARACTER*16  COMPOR(*)
      REAL*8        TEMP,TREF,PPG,EPS(6),EPSP(6),ENER(2)
C.......................................................................
C
C     REALISE LE CALCUL DE L'ENERGIE LIBRE ET DE LA DERIVEE DE L'ENERGIE
C             LIBRE PAR RAPPORT A LA TEMPERATURE (POUR LE CALCUL DE G)
C             EN PLASTICITE
C
C IN  NDIM    : DIMENSION DE L'ESPACE
C IN  TYPMOD  : TYPE DE MODELISATION
C IN  IMATE   : NATURE DU MATERIAU
C IN  COMPOR  : COMPORTEMENT
C IN  TEMP    : TEMPERATURE
C IN  TREF    : TEMPERATURE DE REFERENCE
C IN  PPG     : DEFORMATION PLASTIQUE CUMULEE
C IN  EPS     : DEFORMATION TOTALE
C IN  EPSP    : DEFORMATION PLASTIQUE
C
C OUT RP      :
C OUT ENER(1) : ENRGIE LIBRE
C OUT ENER(1) : DERIVEE DE L'ENERGIE LIBRE / A LA TEMPERATURE
C.......................................................................
C
      CHARACTER*2  CODRET(3)
      CHARACTER*8  NOMRES(3)
C
      REAL*8       E,NU,DEMU,K,K3,ALPHA
      REAL*8       DE,DNU,DEMUDT,DK,DALPHA
      REAL*8       DSDE,SIGY,RPRIM,RP,AIREP
      REAL*8       DSDEDT,DSIGY,DRPRIM,DRP,DAIREP
      REAL*8       NRJ,DNRJ,VALRES(3),DEVRES(3)
      REAL*8       EPSTH(6),EPSDV(6),EPSEQ,KRON(6)
      REAL*8       THER,RBID,DIVU,EPSMO
C
      INTEGER      I,JPROL,JVALE,NBVAL
C
      LOGICAL      CP,TRAC,LINE
C
C----------DEBUT- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER        ZI
      REAL*8         ZR
      COMPLEX*16     ZC
      LOGICAL        ZL
      CHARACTER*8    ZK8
      CHARACTER*16   ZK16
      CHARACTER*24   ZK24
      CHARACTER*32   ZK32
      CHARACTER*80   ZK80
C------------FIN- COMMUNS NORMALISES  JEVEUX  --------------------------
C
      DATA  KRON/1.D0,1.D0,1.D0,0.D0,0.D0,0.D0/
C
      CP   = TYPMOD(1) .EQ. 'C_PLAN'
      TRAC = COMPOR(1)(1:14).EQ.'VMIS_ISOT_TRAC'
      LINE = COMPOR(1)(1:14).EQ.'VMIS_ISOT_LINE'
C
C -  LECTURE DE E, NU, ALPHA ET DERIVEES / TEMPERATRURE
C
      NOMRES(1) = 'E'
      NOMRES(2) = 'NU'
      NOMRES(3) = 'ALPHA'
      CALL RCVADA (IMATE,'ELAS',TEMP,3,NOMRES,VALRES,DEVRES,CODRET)
C
      IF (CODRET(3).NE.'OK') THEN
        VALRES(3)= 0.D0
        DEVRES(3)= 0.D0
      ENDIF
C
      E     = VALRES(1)
      NU    = VALRES(2)
      ALPHA = VALRES(3)
C
      DE    = DEVRES(1)
      DNU   = DEVRES(2)
      DALPHA= DEVRES(3)
C
      DEMU  = E/(1.D0+NU)
      DEMUDT= ((1.D0+NU)*DE-E*DNU)/(1.D0+NU)**2
C
      K    = E/(1.D0-2.D0*NU)/3.D0
      DK   = (DE+2.D0*K*DNU)/(1.D0-2.D0*NU)/3.D0
C
      K3   =  3.D0*K
C
C - LECTURE DES CARACTERISTIQUES DE NON LINEARITE DU MATERIAU
C
      IF (LINE) THEN
        NOMRES(1)='D_SIGM_EPSI'
        NOMRES(2)='SY'
        CALL RCVADA(IMATE,'ECRO_LINE',TEMP,2,NOMRES,VALRES,DEVRES,
     &              CODRET)
        IF ( CODRET(1) .NE. 'OK' )
     &    CALL U2MESS('F','ALGORITH7_74')
        IF ( CODRET(2) .NE. 'OK' )
     &    CALL U2MESS('F','ALGORITH7_75')
        DSDE  = VALRES(1)
        SIGY  = VALRES(2)
        DSDEDT= DEVRES(1)
        DSIGY = DEVRES(2)
C
        RPRIM  = E*DSDE/(E-DSDE)
        DRPRIM = (DE*DSDE+E*DSDEDT+RPRIM*(DSDEDT-DE))/(E-DSDE)
C
        RP  = SIGY +RPRIM*PPG
        DRP = DSIGY+DRPRIM*PPG
C
        AIREP  = 0.5D0*(SIGY+RP)*PPG
        DAIREP = 0.5D0*(DSIGY+DRP)*PPG
C
      ELSE IF (TRAC) THEN
        CALL RCTRAC(IMATE,'TRACTION','SIGM',TEMP,
     &              JPROL,JVALE,NBVAL,E)
        CALL RCFONC('V','TRACTION',JPROL,JVALE,NBVAL,RBID,RBID,
     &              RBID,PPG,RP,RPRIM,AIREP,RBID,RBID)
        DAIREP = 0.D0
      ENDIF
C
C - CALCUL DE EPSMO ET EPSDV
      THER = ALPHA*(TEMP-TREF)
      IF (CP) EPS(3)=-NU/(1.D0-NU)*(EPS(1)+EPS(2))
     &                +(1.D0+NU)/(1.D0-NU)*THER
      DIVU = 0.D0
      DO 10 I=1,3
        EPSTH(I)   = EPS(I)-EPSP(I)-THER
        EPSTH(I+3) = EPS(I+3)-EPSP(I+3)
        DIVU       = DIVU + EPSTH(I)
10    CONTINUE
      EPSMO = DIVU/3.D0
      DO 20 I=1,2*NDIM
        EPSDV(I)   = EPSTH(I) - EPSMO * KRON(I)
20    CONTINUE
C
C - CALCUL DE LA CONTRAINTE ELASTIQUE EQUIVALENTE
      EPSEQ = 0.D0
      DO 30 I=1,2*NDIM
        EPSEQ = EPSEQ + EPSDV(I)*EPSDV(I)
30    CONTINUE
      EPSEQ = SQRT(1.5D0*EPSEQ)
C
C  CALCUL DE L'ENERGIE LIBRE ET DE LA DERIVEE /TEMPERATURE
C
      NRJ  = 0.5D0*K*DIVU*DIVU+DEMU*EPSEQ*EPSEQ/3.D0
      DNRJ = 0.5D0*DK*DIVU*DIVU-K3*DIVU*(ALPHA+DALPHA*(TEMP-TREF))
     &       +DEMUDT*EPSEQ*EPSEQ/3.D0
C
      ENER(1) = NRJ + AIREP
      ENER(2) = DNRJ+ DAIREP
C
      END
