      SUBROUTINE LCJACB (FAMI,KPG,KSP,LOI,MOD,NMAT,
     &                   MATERF,TIMED,TIMEF,YF,DEPS,
     &                   ITMAX,TOLER, NBCOMM, CPMONO,
     &                   PGL,TOUTMS,HSR,NR,COMP,NVI,
     &                   VIND,EPSD, YD,DY, DRDY ,IRET)
        IMPLICIT   NONE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 11/07/2011   AUTEUR PROIX J-M.PROIX 
C ======================================================================
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
C TOLE CRP_21
C       ----------------------------------------------------------------
C       CALCUL DU JACOBIEN DU SYSTEME NL A RESOUDRE = DRDY(DY)
C       IN  FAMI   :  FAMILLE DES POINTS DE GAUSS
C           KPG    :  NUMERO DU POINT DE GAUSS
C           KSP    :  NUMERO DU SOUS POINT DE GAUSS
C           LOI    :  MODELE DE COMPORTEMENT
C           MOD    :  TYPE DE MODELISATION
C           IMAT   :  ADRESSE DU MATERIAU CODE
C           NMAT   :  DIMENSION MATER
C           MATERF :  COEFFICIENTS MATERIAU A T+DT
C           YF     :  VARIABLES A T + DT =    ( SIGF  VINF  (EPS3F)  )
C           TOLER  :  TOLERANCE DE CONVERGENCE LOCALE
C           DEPS   :  INCREMENT DE DEFORMATION
C           ITMAX  :  NOMBRE MAXI D'ITERATIONS LOCALES
C           TIMED  :  INSTANT  T
C           TIMEF  :  INSTANT  T+DT
C           NBCOMM :  INCIDES DES COEF MATERIAU monocristal
C           CPMONO :  NOM DES COMPORTEMENTS monocristal
C           PGL    :  MATRICE DE PASSAGE
C           TOUTMS :  TENSEURS D'ORIENTATION monocristal
C           HSR    :  MATRICE D'INTERACTION monocristal
C           NR     :  DIMENSION DECLAREE DRDY
C           COMP   :  COMPOR - LOI ET TYPE DE DEFORMATION
C           NVI    :  NOMBRE DE VARIABLES INTERNES
C           VIND   :  VARIABLE INTERNES A T
C           EPSD   :  DEFORMATION A T
C           YD     :  VARIABLES A T   = ( SIGD  VARD  ) A T
C           DY     :  SOLUTION           =    ( DSIG  DVIN  (DEPS3)  )
C       OUT DRDY   :  JACOBIEN DU SYSTEME NON LINEAIRE
C           IRET   :  CODE RETOUR
C       ----------------------------------------------------------------
C
        INTEGER         NR,NMAT,KPG,KSP,ITMAX,IRET,NVI
        REAL*8          DEPS(6) , EPSD(6), TOLER
        REAL*8          DRDY(NR,NR) , YF(NR), DY(NR),YD(NR)
C
        REAL*8          MATERF(NMAT,2)
        REAL*8          TIMED, TIMEF,VIND(*)
        REAL*8          TOUTMS(5,24,6),HSR(5,24,24)
C
        CHARACTER*(*)   FAMI
        CHARACTER*8     MOD
        CHARACTER*16    LOI

        INTEGER         NBCOMM(NMAT,3)
        REAL*8          PGL(3,3)
        CHARACTER*16    CPMONO(5*NMAT+1),COMP(*)

C       ----------------------------------------------------------------

      IRET=0
      IF ( LOI(1:9) .EQ. 'VISCOCHAB' ) THEN
         CALL CVMJAC ( MOD, NMAT, MATERF, TIMED, TIMEF,
     &                  YF,  DY,   NR, EPSD,   DEPS,  DRDY )
C
      ELSEIF ( LOI(1:8)  .EQ. 'MONOCRIS' ) THEN
         CALL LCMMJA (COMP,MOD, NMAT, MATERF,TIMED, TIMEF,
     &  ITMAX,TOLER,NBCOMM, CPMONO, PGL,TOUTMS,HSR,NR,NVI,VIND,
     &             DEPS,YF,  YD,DY,   DRDY, IRET )
      ELSEIF ( LOI(1:7)  .EQ. 'IRRAD3M' ) THEN
         CALL IRRJAC ( FAMI,KPG,KSP,MOD, NMAT, MATERF,
     &                  YF,  DY,   NR,  DRDY )
      ENDIF
C
      END
