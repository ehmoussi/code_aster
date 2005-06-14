      SUBROUTINE ESTIVD(NBM,DT,VITG,DEPG,ACCG0,VITG0,DEPG0,TETAES,
     &                  MAXVIT,INEWTO)
      IMPLICIT NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 16/05/2000   AUTEUR KXBADNG T.KESTENS 
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
C DESCRIPTION : ESTIMATION DES VECTEURS VITESSES ET DEPLACEMENTS
C -----------   GENERALISES A L'INSTANT N+1 PAR LE SCHEMA D'EULER
C
C               APPELANTS : ALITMI, NEWTON
C
C-------------------   DECLARATION DES VARIABLES   ---------------------
C
C ARGUMENTS
C ---------
      INTEGER    NBM
      REAL*8     DT, VITG(*), DEPG(*), ACCG0(*), VITG0(*), DEPG0(*),
     &           TETAES, MAXVIT
      INTEGER    INEWTO
C
C VARIABLES LOCALES
C -----------------
      INTEGER    I, J
C
C FONCTIONS INTRINSEQUES
C ----------------------
C     INTRINSIC  ABS
C
C ROUTINES EXTERNES
C -----------------
C     EXTERNAL   UTMESS
C
C-------------------   DEBUT DU CODE EXECUTABLE    ---------------------
C
C 1.  CALCUL DU VECTEUR VITESSES GENERALISEES A L'INSTANT N+1
C     -------------------------------------------------------
C
      DO 10 I = 1, NBM
         VITG(I) = VITG0(I) + DT * ACCG0(I)
  10  CONTINUE
C
C --- SI L'APPELANT EST NEWTON : CORRECTION DU VECTEUR VITESSES
C     GENERALISEES DANS LE CAS D'UN CHANGEMENT DE SIGNE D'UNE
C     DES COMPOSANTES AU MOINS
C
      IF ( INEWTO.EQ.1 ) THEN
         DO 20 I = 1, NBM
            IF ( ABS(VITG0(I)).GT.(1.0D-04*MAXVIT) ) THEN
               IF ( (VITG(I)*VITG0(I)).LT.0.0D0 ) THEN
                   DO 21 J = 1, NBM
                      VITG(J) = VITG0(J)
  21               CONTINUE
                   CALL UTMESS('I','ESTIVD','CHANGEMENT DE SIGNE '//
     &                         'DE LA VITESSE --> ON PREND VITG0(I)')
                   GO TO 22
               ENDIF
            ENDIF
  20     CONTINUE
  22     CONTINUE
      ENDIF
C
C 2.  CALCUL DU VECTEUR DEPLACEMENTS GENERALISES A L'INSTANT N+1
C     ----------------------------------------------------------
C
      DO 30 I = 1, NBM
         DEPG(I) = DEPG0(I) + DT * (  VITG(I)  * TETAES
     &                              + VITG0(I) * (1.0D0-TETAES) )
  30  CONTINUE
C
C --- FIN DE ESTIVD.
      END
