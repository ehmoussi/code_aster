      SUBROUTINE PBFLVP(UMOY,HMOY,RMOY,CF0,MCF0,RKIP,S1,S2,LAMBDA)
      IMPLICIT REAL*8 (A-H,O-Z)
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C-----------------------------------------------------------------------
C COUPLAGE FLUIDELASTIQUE, CONFIGURATIONS DU TYPE "COQUE_COAX"
C RESOLUTION DU PROBLEME FLUIDE INSTATIONNAIRE : DETERMINATION DES
C VALEURS PROPRES DE L'OPERATEUR DIFFERENTIEL
C APPELANT : PBFLUI
C-----------------------------------------------------------------------
C  IN : UMOY   : VITESSE DE L'ECOULEMENT MOYEN
C  IN : HMOY   : JEU ANNULAIRE MOYEN
C  IN : RMOY   : RAYON MOYEN
C  IN : CF0    : COEFFICIENT DE FROTTEMENT VISQUEUX
C  IN : MCF0   : EXPOSANT VIS-A-VIS DU NOMBRE DE REYNOLDS
C  IN : RKIP   : ORDRE DE COQUE DU MODE CONSIDERE, PONDERE PAR LA VALEUR
C                MOYENNE DU PROFIL DE PRESSION
C  IN : S1     : PARTIE REELLE     DE LA FREQUENCE COMPLEXE
C  IN : S2     : PARTIE IMAGINAIRE DE LA FREQUENCE COMPLEXE
C OUT : LAMBDA : VALEURS PROPRES DE L'OPERATEUR DIFFERENTIEL
C-----------------------------------------------------------------------
C
      REAL*8       UMOY,HMOY,RMOY,CF0,MCF0,RKIP,S1,S2
      COMPLEX*16   LAMBDA(3)
C
      REAL*8       DCABS2,DCARGU
      REAL*8       ARG,MODUL,PI,EPS
      COMPLEX*16   A,B,C,Z1,Z2,Z3,P,Q,R,S,DELTA,ALPHA,BETA,N3
      CHARACTER*1  K1BID
C
C-----------------------------------------------------------------------
C
      PI = R8PI()
      EPS = 1.D-4
      S = DCMPLX(S1,S2)
C
      A = S/UMOY + DCMPLX(CF0/HMOY)
      B = DCMPLX(-1.D0*((RKIP/RMOY)**2))
      C = S/UMOY + (MCF0+2.D0) * DCMPLX(CF0/HMOY)
      C = -1.D0*((RKIP/RMOY)**2)*C
      P = B - (A**2)/3.D0
      Q = 2.D0*(A**3)/27.D0 - A*B/3.D0 + C
      R = (Q/2.D0)**2 + (P/3.D0)**3
      R = R**0.5D0
      IF (DCABS2(R).LT.EPS) THEN
        CALL U2MESS('A','ALGELINE3_19')
      ENDIF
C
      DELTA = ((3.D0*Q/P)**2) + 4.D0*P/3.D0
      DELTA = DELTA**(0.5D0)
      ALPHA = 0.5D0*(-3.D0*Q/P + DELTA)
      BETA  = 0.5D0*(-3.D0*Q/P - DELTA)
      N3    = ALPHA/BETA
C
      MODUL = (DCABS2(N3))**(1.D0/3.D0)
      ARG = DCARGU(N3)/3.D0
      Z1 = MODUL * DCMPLX(DBLE(COS(ARG)),DBLE(SIN(ARG)))
      ARG = DCARGU(N3)/3.D0 + 2.D0*PI/3.D0
      Z2 = MODUL * DCMPLX(DBLE(COS(ARG)),DBLE(SIN(ARG)))
      ARG = DCARGU(N3)/3.D0 + 4.D0*PI/3.D0
      Z3 = MODUL * DCMPLX(DBLE(COS(ARG)),DBLE(SIN(ARG)))
C
      LAMBDA(1) = ((BETA*Z1-ALPHA)/(Z1-DCMPLX(1.D0)))-A/3.D0
      LAMBDA(2) = ((BETA*Z2-ALPHA)/(Z2-DCMPLX(1.D0)))-A/3.D0
      LAMBDA(3) = ((BETA*Z3-ALPHA)/(Z3-DCMPLX(1.D0)))-A/3.D0
C
      DO 10 I = 1,3
        IF (DCABS2(LAMBDA(I)).LT.EPS) THEN
          WRITE(K1BID,'(I1)') I
          CALL U2MESK('A','ALGELINE3_20',1,K1BID)
        ENDIF
 10   CONTINUE
C
      END
