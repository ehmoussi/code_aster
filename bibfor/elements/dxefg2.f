      SUBROUTINE DXEFG2(PGL,SIGT)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      REAL*8 PGL(3,3),SIGT(1)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 26/02/2013   AUTEUR DESROCHE X.DESROCHES 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     ------------------------------------------------------------------
C --- EFFORTS GENERALISES N, M, V D'ORIGINE THERMIQUE AUX POINTS
C --- D'INTEGRATION POUR LES ELEMENTS COQUES A FACETTES PLANES :
C --- DKTG DUS :
C ---  .A UN CHAMP DE TEMPERATURES SUR LE PLAN MOYEN DONNANT
C ---        DES EFFORTS DE MEMBRANE
C ---  .A UN GRADIENT DE TEMPERATURES DANS L'EPAISSEUR DE LA COQUE
C     ------------------------------------------------------------------
C     IN  PGL(3,3)     : MATRICE DE PASSAGE DU REPERE GLOBAL AU REPERE
C                        LOCAL
C     OUT SIGT(1)      : EFFORTS  GENERALISES D'ORIGINE THERMIQUE
C                        AUX POINTS D'INTEGRATION
      INTEGER  NDIM,NNO,NNOS,NPG,IPOIDS,ICOOPG,IVF,IDFDX,IDFD2,JGANO
      INTEGER  MULTIC,IPG,SOMIRE,I
      REAL*8   DF(3,3),DM(3,3),DMF(3,3)
      REAL*8   TMOYPG,TSUPPG,TINFPG
      REAL*8   T2EV(4),T2VE(4),T1VE(9)
      INTEGER ICODRE(56)
      CHARACTER*4   FAMI
      CHARACTER*10  PHENOM
C     ------------------------------------------------------------------
C
C-----------------------------------------------------------------------
      INTEGER IGAU ,INDITH ,IRET1 ,IRET ,IRETT ,IRETM ,JCARA 
      INTEGER JCOU ,JMATE 
      REAL*8 COE1 ,COE2 ,EPAIS ,TREF 
C-----------------------------------------------------------------------
      FAMI = 'RIGI'
      CALL ELREF5(' ',FAMI,NDIM,NNO,NNOS,NPG,IPOIDS,ICOOPG,
     &                                         IVF,IDFDX,IDFD2,JGANO)
C
      CALL R8INIR(32,0.D0,SIGT,1)
C
      CALL JEVECH('PMATERC','L',JMATE)
      CALL RCCOMA(ZI(JMATE),'ELAS',1,PHENOM,ICODRE)

C --- RECUPERATION DE LA TEMPERATURE DE REFERENCE ET
C --- DE L'EPAISSEUR DE LA COQUE
C     --------------------------
C
      CALL JEVECH('PCACOQU','L',JCARA)
      EPAIS = ZR(JCARA)

      CALL RCVARC(' ','TEMP','REF',FAMI,1,1,TREF,IRET1)

C
C --- CALCUL DES COEFFICIENTS THERMOELASTIQUES DE FLEXION,
C --- MEMBRANE, MEMBRANE-FLEXION
C     ----------------------------------------------------

      CALL DXMAT1('RIGI',EPAIS,DF,DM,DMF,PGL,INDITH,
     &                               T2EV,T2VE,T1VE,NPG)
      IF (INDITH.EQ.-1) GO TO 30

C --- BOUCLE SUR LES POINTS D'INTEGRATION
C     -----------------------------------
      DO 20 IGAU = 1,NPG

C  --      TEMPERATURES SUR LES FEUILLETS MOYEN, SUPERIEUR ET INFERIEUR
C  --      AU POINT D'INTEGRATION COURANT
C          ------------------------------
        CALL RCVARC(' ','TEMP_INF','+',FAMI,IGAU,1,TINFPG,IRET)
        CALL RCVARC(' ','TEMP_SUP','+',FAMI,IGAU,1,TSUPPG,IRET)
          CALL RCVARC(' ','TEMP','+',FAMI,IGAU,1,TMOYPG,IRETM)
          IF(IRET.EQ.0.AND.IRETM.NE.0) THEN
             TMOYPG=(TINFPG+TSUPPG)/2.D0
          ENDIF
CC        ENDIF

        SOMIRE = IRET
        IF (SOMIRE.EQ.0) THEN
          IF (IRET1.EQ.1) THEN
            CALL U2MESS('F','CALCULEL_31')
          ELSE

C  --      LES COEFFICIENTS SUIVANTS RESULTENT DE L'HYPOTHESE SELON
C  --      LAQUELLE LA TEMPERATURE EST PARABOLIQUE DANS L'EPAISSEUR.
C  --      ON NE PREJUGE EN RIEN DE LA NATURE DU MATERIAU.
C  --      CETTE INFORMATION EST CONTENUE DANS LES MATRICES QUI
C  --      SONT LES RESULTATS DE LA ROUTINE DXMATH.
C          ----------------------------------------
            COE1 = (TSUPPG+TINFPG+4.D0*TMOYPG)/6.D0 - TREF
            COE2 = (TSUPPG-TINFPG)/EPAIS

        SIGT(1+8* (IGAU-1)) = COE1* (DM(1,1)+DM(1,2)) +
     &                        COE2* (DMF(1,1)+DMF(1,2))
        SIGT(2+8* (IGAU-1)) = COE1* (DM(2,1)+DM(2,2)) +
     &                        COE2* (DMF(2,1)+DMF(2,2))
        SIGT(3+8* (IGAU-1)) = COE1* (DM(3,1)+DM(3,2)) +
     &                        COE2* (DMF(3,1)+DMF(3,2))
        SIGT(4+8* (IGAU-1)) = COE2* (DF(1,1)+DF(1,2)) +
     &                        COE1* (DMF(1,1)+DMF(1,2))
        SIGT(5+8* (IGAU-1)) = COE2* (DF(2,1)+DF(2,2)) +
     &                        COE1* (DMF(2,1)+DMF(2,2))
        SIGT(6+8* (IGAU-1)) = COE2* (DF(3,1)+DF(3,2)) +
     &                        COE1* (DMF(3,1)+DMF(3,2))
         ENDIF
        ENDIF
   20 CONTINUE
C
   30 CONTINUE
C
      END
