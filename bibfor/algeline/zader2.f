      SUBROUTINE ZADER2 (UPLO, N, ALPHA, X, INCX, Y, INCY, A, LDA)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER    N, INCX, INCY, LDA
      COMPLEX    *16 ALPHA, X(*), Y(*), A(LDA,*)
      CHARACTER*(*) UPLO
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 29/09/95   AUTEUR GIBHHAY A.Y.PORTABILITE 
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
C   CALCUL DE A: MATRICE HERMITIENNE
C   A = A + ALPHA*X*CONJG(Y)' + CONJG(ALPHA)*Y*CONJG(X)'
C-----------------------------------------------------------------------
C IN  : UPLO : INDIQUE LE MODE DE STOCKAGE DE LA MATRICE.
C              SI UPLO EST 'U' ALORS SEULEMENT LA PARTIE SUPERIEURE DE A
C              EST UTILISEE. SI UPLO EST 'L', ALORS LA PARTIE INFERIEURE
C              EST UTILISEE.
C     : N    : DIMENSION DE LA MATRICE A.
C     : ALPHA: SCALAIRE.
C     : X    : DVECTEURE COMPLEXE DE LONGUEUR (N-1)*IABS(INCX)+1.
C     : INCX : DEPLACEMENT ENTRE LES ELEMENTS DE X.
C     : Y    : DVECTEURE COMPLEXE DE LONGUEUR (N-1)*IABS(INCY)+1.
C     : INCY : DEPLACEMENT ENTRE LES ELEMENTS DE Y.
C I/O : A    : MATRICE COMPLEXE DE DIMENSION N.
C IN  : LDA  : DIMENSION DE A
C-----------------------------------------------------------------------
      INTEGER    IX, IY, J
      COMPLEX    *16 TEMPX, TEMPY, TEMP1
      LOGICAL    UPPER
      REAL *8 DBLE
      COMPLEX    *16 CONJG
C
      IF (N.EQ.0 .OR. ALPHA.EQ.(0.0D0,0.0D0)) GOTO 9999
C
      IX = 1
      IY = 1
      IF (INCX .LT. 0) IX = 1 - (N-1)*INCX
      IF (INCY .LT. 0) IY = 1 - (N-1)*INCY
C
      UPPER = (UPLO(1:1).EQ.'U') .OR. (UPLO(1:1).EQ.'u')
C
      DO 10  J=1, N
         TEMPX = DCONJG(ALPHA*X(IX))
         TEMPY = ALPHA*DCONJG(Y(IY))
         IF (UPPER) THEN
            IF (INCX .GE. 0) THEN
               CALL ZAXPY (J-1, TEMPY, X, INCX, A(1,J), 1)
            ELSE
               CALL ZAXPY (J-1, TEMPY, X(IX-INCX), INCX, A(1,J), 1)
            END IF
            IF (INCY .GE. 0) THEN
               CALL ZAXPY (J-1, TEMPX, Y, INCY, A(1,J), 1)
            ELSE
               CALL ZAXPY (J-1, TEMPX, Y(IY-INCY), INCY, A(1,J), 1)
            END IF
         ELSE
            IF (INCX .GE. 0) THEN
               CALL ZAXPY (N-J, TEMPY, X(IX+INCX), INCX, A(J+1,J), 1)
            ELSE
               CALL ZAXPY (N-J, TEMPY, X, INCX, A(J+1,J), 1)
            END IF
            IF (INCY .GE. 0) THEN
               CALL ZAXPY (N-J, TEMPX, Y(IY+INCY), INCY, A(J+1,J), 1)
            ELSE
               CALL ZAXPY (N-J, TEMPX, Y, INCY, A(J+1,J), 1)
            END IF
         END IF
         TEMP1 = A(J,J) + Y(IY)*TEMPX + X(IX)*TEMPY
         A(J,J) = DBLE(TEMP1)
         IX = IX + INCX
         IY = IY + INCY
   10 CONTINUE
C
 9999 CONTINUE
      END
