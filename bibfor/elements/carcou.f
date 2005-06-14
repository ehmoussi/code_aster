      SUBROUTINE CARCOU(ORIEN,L,PGL,RAYON,THETA,PGL1,PGL2,PGL3,PGL4,
     &                  NNO,OMEGA,ICOUDE)
      IMPLICIT REAL*8 (A-H,O-Z)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 27/04/2001   AUTEUR JMBHH01 J.M.PROIX 
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
      INTEGER    ICOUDE
      REAL*8 ORIEN(17),ANGL1(3),ANGL2(3),ANGL3(3),ANGL4(3),PGL4(3,3)
      REAL*8 L,RAYON,THETA,PGL1(3,3),PGL2(3,3),PGL3(3,3),OMEGA,PGL(3,3)
C ......................................................................
C
C    - FONCTION REALISEE:  RECUP LA GEOMETRIE COUDE
C                          TUYAU
C    - ARGUMENTS
C        DONNEES:  ORIEN(*) : CARTE PRODUITE PAR AFFE_CARA_ELEM
C                  NNO      : NOMBRE DE NOEUDS DE L'ELEMENT (3 OU 4)
C         SORTIE    
C                   L       : LONGUEUR DE L'ELEMENT DROIT
C                   RAYON   : RAYON DE CINTRAGE DU COUDE
C                   THETA   :  ANGLE D'OUVERTURE DU COUDE (RADIANS)
C                   PGL1,2,3   -->  MATRICE DE CHAGMENT DE REPERE 
C                   OMEGA      -->  ANGLE ENTRE N ET LA GENERATRICE  
C                  ICOUDE   :   =0 DROIT AVEC MODI_METRIQUE=OUI
C                  ICOUDE   :   =10 DROIT AVEC MODI_METRIQUE=NON
C                           :   =1 COUDE  AVEC MODI_METRIQUE=OUI
C                           :   =11 COUDE  AVEC MODI_METRIQUE=NON
C ......................................................................
C
C
      DO 63 I=1,3
         ANGL1(I)=ORIEN(I)
         ANGL2(I)=ORIEN(3+I)
         ANGL3(I)=ORIEN(6+I)
63    CONTINUE
      ICMP=9
      IF (NNO.EQ.4) THEN
         DO 64 I=1,3
            ANGL4(I)=ORIEN(9+I)
64       CONTINUE
         ICMP=12
      ELSEIF (NNO.NE.3) THEN
         CALL UTMESS('F','TUYAU','NNO INVALIDE')
      ENDIF

      ICOUDE   = NINT(ORIEN(ICMP+1))
      L        = ORIEN(ICMP+2)
      RAYON    = ORIEN(ICMP+3)
      THETA    = ORIEN(ICMP+4)
      OMEGA    = ORIEN(ICMP+5)

      IF ((ICOUDE.EQ.0).OR.(ICOUDE.EQ.10)) THEN
         CALL MATROT(ANGL1,PGL)
      ELSE
         CALL MATROT(ANGL1,PGL1)
         CALL MATROT(ANGL2,PGL2)
         CALL MATROT(ANGL3,PGL3)
         IF (NNO.EQ.4) THEN
            CALL MATROT(ANGL4,PGL4)
         ENDIF
      ENDIF
      END
