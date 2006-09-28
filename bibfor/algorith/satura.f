      SUBROUTINE SATURA(HYDR,P1,SAT,DSATP1)

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
C
      REAL*8 P1,SAT,DSATP1
      CHARACTER*16 HYDR

      IF (HYDR.EQ.'HYDR') THEN

         CALL U2MESS('F','ALGORITH9_80')

          IF (P1.GT.0) THEN
          SAT    = (1.D0+(2.907D-8*P1)**(1.388D0))**(-.963D0)
          DSATP1 = (-.963D0)*1.388D0*2.907D-8*(2.907D-8*P1)**(.388D0)
     &                    *(1.D0+(2.907D-8*P1)**1.388D0)**(-1.963D0)
          ELSE
             SAT    = 1.D0
             DSATP1 = 0.D0
          ENDIF

      ENDIF

      END
