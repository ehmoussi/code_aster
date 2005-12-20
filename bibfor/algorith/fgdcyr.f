      SUBROUTINE FGDCYR(TPS,S,T,EPSFAB,TPREC,FLUPHI,F1,FP1,FS1,F2,
     *                  FP2,FS2,G1,DG1DS,G2,DG2DS)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 15/06/2004   AUTEUR MABBAS M.ABBAS 
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
      IMPLICIT REAL*8 (A-H,O-Z)
C
CDEB
C---------------------------------------------------------------
C     CALCUL DES FONCTIONS F1,G1,F2,G2 ET DE LEURS DERIVEES
C---------------------------------------------------------------
C IN  TPS   :R: TEMPS
C     S     :R: CONTRAINTE EQUIVALENTE SIGMA
C     T     :R: TEMPERATURE DU POINT CONSIDERE
C     EPSFAB:R: DEFORMATION DE FLUAGE OBTENUE DANS UN TEST A 400C
C               100MPA ET 250H. (%)
C     TPREC :R: TEMPERATURE DE TRAITEMENT FINAL (C)
C     FLUPHI:R: FLUX NEUTRONIQUE
C OUT F1    :R: VALEUR DE F1(TPS)
C     FP1   :R: VALEUR DE F'1(TPS)
C     FS1   :R: VALEUR DE F"1(TPS)
C     F2    :R: VALEUR DE F2(TPS)
C     FP2   :R: VALEUR DE F'2(TPS)
C     FS2   :R: VALEUR DE F"2(TPS)
C     G1    :R: VALEUR DE G1(SIGMA,T)
C     DG1DS :R: VALEUR DE DG1/DSIGMA(SIGMA,T)
C     G2    :R: VALEUR DE G2(SIGMA,T)
C     DG2DS :R: VALEUR DE DG2/DSIGMA(SIGMA,T)
C---------------------------------------------------------------
C     CETTE ROUTINE CALCULE LES FONCTIONS F1,G1,F2,G2 DANS :
C
C            EV = F1(TPS)*G1(S,T) + F2(TPS)*G2(S,T)
C
C      ET LEURS DERIVEES F'1,F"1,DG1/DSIGMA,F'2,F"2,DG2/DSIGMA
C---------------------------------------------------------------
CFIN
C
      REAL*8 R8GAEM
C
      R3S2 = 0.5D0*SQRT(3.D0)
C
C----CALCUL DE F1,FP1,FS1---------------------------------------
C
      CTH = 4450.D0
      CTPS = 4.5 D-3
      FREC = 1.816D-4*EXP(6400.D0/(TPREC+273.15D0))
C
C ---      ATTENTION : MESSAGE D'ERREUR SI EXP(X<-LOG(R8GAEM()))
C                      D'OU LE TEST SUIVANT SUR CTPS2
C
      CTPS2=CTPS*TPS
      IF (CTPS2.GE.LOG(R8GAEM())) THEN
         F1 = (CTH*EPSFAB+TPS)*FREC
         FP1= FREC
         FS1= 0.D0
      ELSE
         IF (ABS(CTPS2).GE.1.D-12) THEN
            F1 = (CTH*EPSFAB*(1.D0-EXP(-CTPS2))+TPS)*FREC
         ELSE
            F1 = (CTH*EPSFAB*CTPS2+TPS)*FREC
         ENDIF
         FP1 = (CTH*EPSFAB*CTPS*EXP(-CTPS2)+1.D0)*FREC
         FS1 = -CTH*EPSFAB*CTPS*CTPS*EXP(-CTPS2)*FREC
      ENDIF
C
C----CALCUL DE F2,FP2,FS2---------------------------------------
C
      CTH = 4000.D0
      CTPS = 3. D-3
C
C ---      ATTENTION : MESSAGE D'ERREUR SI EXP(X<-LOG(R8GAEM()))
C                      D'OU LE TEST SUIVANT SUR CTPS2
C
      CTPS2=CTPS*TPS
      IF (CTPS2.GE.LOG(R8GAEM())) THEN
         F2 = (CTH*EPSFAB+TPS)*FREC
         FP2= FREC
         FS2= 0.D0
      ELSE
         IF (ABS(CTPS2).GE.1.D-12) THEN
            F2 = (CTH*EPSFAB*(1.D0-EXP(-CTPS2))+TPS)*FREC
         ELSE
            F2 = (CTH*EPSFAB*CTPS2+TPS)*FREC
         ENDIF
         FP2 = (CTH*EPSFAB*CTPS*EXP(-CTPS2)+1.D0)*FREC
         FS2 = -CTH*EPSFAB*CTPS*CTPS*EXP(-CTPS2)*FREC
      ENDIF
C
C----CALCUL DE G1,DG1DS-----------------------------------------
C
C     LES CONTRAINTES DOIVENT ETRE CONVERTIES DE N/CM2 EN MPA
C     S1=S/100.D0
      S1=S
      S1=S1/R3S2
C
      ATH = 9.529D17
      XN = EXP(2.304D-3*S1-0.413D0)
      XK = 39000.D0
      G1 = ATH*EXP(-XK/(T+273.15D0))*S1**XN
      G1 = G1/R3S2
C
      DG1DS = ATH*EXP(-XK/(T+273.15D0))*(S1**XN)*
     *        XN*(2.304D-3*LOG(S1)+1.D0/S1)
C     DG1DS = DG1DS/100.D0 ! CHANG PHILIPPE DE BONNIERES
      DG1DS = DG1DS/R3S2/R3S2
C
C----CALCUL DE G2,DG2DS-----------------------------------------
C
C     LES CONTRAINTES DOIVENT ETRE CONVERTIES DE N/CM2 EN MPA
C     S1=S/100.D0
C     S1=S1/R3S2
C
      AIRR = 1.2D-22
      G2 = AIRR*FLUPHI*S1/R3S2
      DG2DS = AIRR*FLUPHI/(R3S2*R3S2)
C     DG2DS = DG2DS/100.D0
C
      END
