           SUBROUTINE CJSNCV(ROUCJS,NITIMP,ITER,NDT,NVI,UMESS,
     &          ERIMP,
     &          EPSD,DEPS,SIGD,VIND)
C       ================================================================
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
C       ----------------------------------------------------------------
C
C  DUMP EN CAS NON CONVERGENCE ITE INTERNES CJS
C
           IMPLICIT NONE
           CHARACTER*(*) ROUCJS
           INTEGER NITIMP,ITER,NDT,NVI,UMESS
           REAL*8  ERIMP(NITIMP,3)
           REAL*8 EPSD(NDT),DEPS(NDT),SIGD(NDT),VIND(NVI)
C
         INTEGER I
         WRITE(UMESS,2001)
 2001    FORMAT(
     &       T3,' ITER',T10,' ERR1=DDY',
     &       T30,'ERR2=DY',T50,'ERR=DDY/DY')
         DO 300 I = 1 , MIN(NITIMP,ITER)
          WRITE(UMESS,1000) I,ERIMP(I,1),ERIMP(I,2),ERIMP(I,3)
  300    CONTINUE
 1000    FORMAT(
     &       T3,I4,T10,E12.5,
     &       T30,E12.5,T50,E12.5)
         CALL U2MESS('F','ALGORITH2_18')
           WRITE(6,1002) (I,EPSD(I),I = 1 , NDT)
           WRITE(UMESS,*) ' DEPS '
           WRITE(6,1002) (I,DEPS(I),I = 1 , NDT)
           WRITE(UMESS,*) ' SIGD '
           WRITE(6,1002) (I,SIGD(I),I = 1 , NDT)
           WRITE(UMESS,*) ' VIND '
           WRITE(6,1002) (I,VIND(I),I = 1 , NVI)
 1002 FORMAT(2X,I5,2X,E12.5)
      END
