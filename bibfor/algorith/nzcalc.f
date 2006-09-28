      SUBROUTINE NZCALC(CRIT,PHASP,NZ,FMEL,SEUIL,DT,TRANS,
     &                  RPRIM,DEUXMU,ETA,UNSURN,DP,IRET)
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
      IMPLICIT NONE
      INTEGER      NZ, IRET
      REAL*8       SEUIL,DT,TRANS,RPRIM,DEUXMU,CRIT(3),PHASP(5),FMEL
      REAL*8       ETA(5),UNSURN(5),DP
C-------------------------------------------------------------
C CALCUL DE DP PAR RESOLUTION DE L'EQUATION SCALAIRE FPRIM=0
C FPRIM=F1-F(I) TEL QUE F1 : DROITE DECROISSANTE
C                       F(I):A*(DP**UNSURN(I))
C ------------------------------------------------------------
C IN CRIT : CRITERES DE CONVERGENCE LOCAUX
C IN FPRIM   : FONCTION SEUIL
C IN DT    :TP-TM
C
C OUT DP
C     IRET   CODE RETOUR DE LA RESOLUTION DE L'EQUATION SCALAIRE
C                              IRET=0 => PAS DE PROBLEME
C                              IRET=1 => ECHEC
C-------------------------------------------------------------
      REAL*8     FPRIM, FPLAS, FDEVI,DPU(5),FP(5),FD(5),EPS,DPNEW,FPNEW
      REAL*8     SPETRA, R0, COEFA(5), DPPLAS,DPMIN,DPMAX ,X(4),Y(4)
      INTEGER    ITER ,I,J


C INITIALISATION
      EPS =1.D-6
      SPETRA = 1.5D0*DEUXMU*TRANS +1.D0
      R0     = 1.5D0*DEUXMU + RPRIM*SPETRA


C ESSAI PLASTIQUE PUR

      DPPLAS = SEUIL/R0
      DP     = DPPLAS

      CALL NZFPRI(DEUXMU,TRANS,RPRIM,SEUIL,PHASP,NZ,FMEL,ETA,
     &              UNSURN,DT,DP,FPLAS,FP,FD,FPRIM,FDEVI)
      IF (ABS(FPRIM) / (1.D0+SEUIL) .LT. CRIT(3) ) GOTO 9999

      DPMAX = DPPLAS
      DPMIN = 0.D0


C RECHERCHE DES BORNES PAR RESOLUTION DE F1-FI=0 POUR CHAQUE I
C METHODE DE POINT FIXE COMBINEE AVEC NEWTON

      DO 10 I=1,NZ
         IF (PHASP(I) .GT. EPS) THEN
            DP=DPPLAS

            CALL NZFPRI(DEUXMU,TRANS,RPRIM,SEUIL,PHASP,NZ,FMEL,ETA,
     &                UNSURN,DT,DP,FPLAS,FP,FD,FPRIM,FDEVI)
            IF (ABS(FPRIM) / (1.D0+SEUIL) .LT. CRIT(3) ) GOTO 9999
            IF (ABS(FP(I)) / (1.D0+SEUIL) .LT. CRIT(3) ) GOTO 99

            DP= 0.D0
            COEFA(I)  = (ETA(I)*SPETRA) / DT**UNSURN(I)
            DO 11 ITER = 1,INT(CRIT(1))
               CALL NZFPRI(DEUXMU,TRANS,RPRIM,SEUIL,PHASP,NZ,FMEL,ETA,
     &                  UNSURN,DT,DP,FPLAS,FP,FD,FPRIM,FDEVI)
               IF (ABS(FPRIM) / (1+SEUIL) .LT. CRIT(3) ) GOTO 9999
               IF (ABS(FP(I)) / (1+SEUIL) .LT. CRIT(3) ) GOTO 99

               DP = (FPLAS/COEFA(I) )**(1.D0/UNSURN(I))
               IF (DP.GT.DPPLAS) DP = DPPLAS


               CALL NZFPRI(DEUXMU,TRANS,RPRIM,SEUIL,PHASP,NZ,FMEL,ETA,
     &                UNSURN,DT,DP,FPLAS,FP,FD,FPRIM,FDEVI)
               IF (ABS(FPRIM) / (1+SEUIL) .LT. CRIT(3) ) GOTO 9999
               IF (ABS(FP(I)) / (1+SEUIL) .LT. CRIT(3) ) GOTO 99
               DP = DP - FP(I) / FD(I)
  11        CONTINUE
            IRET = 1
            GOTO 9999
 99         CONTINUE
            DPU(I)=DP
            IF (DPMIN .EQ. 0.D0) THEN
              DPMIN=DPU(I)
              DPMAX=DPU(I)
            ELSE
              DPMIN=MIN(DPMIN,DPU(I))
              DPMAX=MAX(DPMAX,DPU(I))
            ENDIF
         ENDIF
 10    CONTINUE


C  RESOLUTION DE FPRIM=0 - METHODE SECANTE AVEC NEWTON SI BESOIN

C------EXAMEN DE LA SOLUTION DP=DPMIN
       DP =DPMIN
       CALL NZFPRI(DEUXMU,TRANS,RPRIM,SEUIL,PHASP,NZ,FMEL,ETA,
     &                UNSURN,DT,DP,FPLAS,FP,FD,FPRIM,FDEVI)
       IF (FPRIM .LT. 0.D0)
     &    CALL U2MESS('FPRIM','ALGORITH9_12')
       X(2) = DP
       Y(2) = FPRIM

C------EXAMEN DE LA SOLUTION DP=DPMAX

       DP = DPMAX
       CALL NZFPRI(DEUXMU,TRANS,RPRIM,SEUIL,PHASP,NZ,FMEL,ETA,
     &                UNSURN,DT,DP,FPLAS,FP,FD,FPRIM,FDEVI)

       X(1) = DP
       Y(1) = FPRIM

C------CALCUL DE DP : EQUATION SCALAIRE FPRIM = 0 AVEC DPMIN< DP < DPMAX
       X(3) = X(1)
       Y(3) = Y(1)
       X(4) = X(2)
       Y(4) = Y(2)
       DO 100 ITER = 1,INT(CRIT(1))


       CALL ZEROCO(X,Y)
          DP = X(4)
          CALL NZFPRI(DEUXMU,TRANS,RPRIM,SEUIL,PHASP,NZ,FMEL,ETA,
     &                UNSURN,DT,DP,FPLAS,FP,FD,FPRIM,FDEVI)
          IF (ABS(FPRIM)/(1.D0+SEUIL) .LT. CRIT(3) ) GOTO 9999
C
          DPNEW=DP-FPRIM/FDEVI
          IF ((DPNEW .GE. DPMIN) .AND. (DPNEW .LE. DPMAX)) THEN
             CALL NZFPRI(DEUXMU,TRANS,RPRIM,SEUIL,PHASP,NZ,FMEL,ETA,
     &                UNSURN,DT,DPNEW,FPLAS,FP,FD,FPNEW,FDEVI)


             IF (ABS(FPNEW)/(1.D0+SEUIL) .LT. CRIT(3) ) THEN
                DP=DPNEW
               GOTO 9999
             ENDIF
             IF (ABS(FPNEW)/(1.D0+SEUIL) .LT. ABS(FPRIM)/(1.D0+SEUIL))
     &      THEN
                DP=DPNEW
                FPRIM = FPNEW
            ENDIF

          ENDIF
          Y(4)=FPRIM
          X(4)=DP
 100   CONTINUE
       IRET = 1

 9999 CONTINUE
      END
