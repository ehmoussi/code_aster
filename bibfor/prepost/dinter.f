      SUBROUTINE DINTER(COORC,RAY,COOR1,COOR2,COORIN)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 11/07/2005   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.         
C ======================================================================

C*********************************************************
C              BUT DE CETTE ROUTINE :                    *
C CALCULER LES COORDONNEES DU POINT D INTERSECTION ENTRE *
C UNE DROITE ET UN CERCLE DE CENTRE X ET DE RAYON RAY    *
C*********************************************************

C IN  COORC(2)   : COORDONNEES DU CENTRE X
C IN  RAY        : RAYON DU CERCLE
C IN  COOR1(2)   : COORDONNEES DU NOEUD 1 DE LA DROITE
C IN  COOR2(2)   : COORDONNEES DU NOEUD 2 DE LA DROITE
C OUT COORIN(2) : COORDONNEES DE L INTERSECTION

      IMPLICIT NONE 

C DECLARATION GLOBALE

      REAL*8 COORC(2),RAY,COOR1(2),COOR2(2),COORIN(2) 
      
C DECLARATION LOCALE

      REAL*8  XC,YC,X1,Y1,X2,Y2,XI,YI
      REAL*8  DET,VAL,M,R1,R2
      REAL*8  PREC
      PARAMETER( PREC=10.D-6)

      XC = COORC(1)
      YC = COORC(2)
      X1 = COOR1(1) 
      Y1 = COOR1(2) 
      X2 = COOR2(1) 
      Y2 = COOR2(2) 

      IF ((Y2-Y1).GE.PREC .OR.(Y2-Y1).LE.-PREC ) THEN
        M = (X2-X1)/(Y2-Y1)
        VAL =  X1-XC-M*Y1 
        DET =(YC - M*VAL)**2 -(1.D0+M**2) *( VAL**2 + YC**2 - RAY**2 )
        IF (DET.GE.(-PREC)) THEN
          DET = ABS(DET)
          YI =( YC -M*VAL + SQRT(DET) ) /(1.D0+M**2)
          IF (((YI-Y1).LE. PREC.AND.(YI-Y2).GE.-PREC).OR.
     &        ((YI-Y1).GE.-PREC.AND.(YI-Y2).LE.PREC)    ) THEN
            COORIN(2) = YI
            COORIN(1) = X1 + M *(YI-Y1)
          ELSE 
            YI =( YC -M*VAL - SQRT(DET) ) /(1.D0+M**2)
            IF (((YI-Y1).LE. PREC.AND.(YI-Y2).GE.-PREC).OR.
     &        ((YI-Y1).GE.-PREC.AND.(YI-Y2).LE.PREC)    ) THEN
              COORIN(2) = YI
              COORIN(1) = X1 + M *(YI-Y1)
            ELSE
              CALL UTMESS('F','DINTER','PAS INTERS')    
            ENDIF
          ENDIF
        ELSE
C          R1 = SQRT((XC-X1)**2 +(YC-Y1)**2 )
C          R2 = SQRT((XC-X2)**2 +(YC-Y2)**2 )  
        ENDIF
      ELSE
        DET = RAY**2 -(Y1-YC)**2
        IF (DET.GE.(-PREC)) THEN
          DET = ABS(DET)
          XI = XC + SQRT(DET)
          IF (((XI-X1).LE. PREC.AND.(XI-X2).GE.-PREC).OR.
     &       ((XI-X1).GE.-PREC.AND.(XI-X2).LE.PREC)    ) THEN
            COORIN(1) = XI
            COORIN(2) = Y1
          ELSE 
            XI = XC - SQRT(DET)
            IF (((XI-X1).LE. PREC.AND.(XI-X2).GE.-PREC).OR.
     &         ((XI-X1).GE.-PREC.AND.(XI-X2).LE.PREC)) THEN
              COORIN(1) = XI
              COORIN(2) = Y1
            ELSE
              CALL UTMESS('F','DINTER','PAS INTERS')
            ENDIF
          ENDIF
        ELSE
          CALL UTMESS('F','DINTER','PAS INTERS')
        ENDIF
      ENDIF
      END
