      SUBROUTINE TE0245(OPTION,NOMTE)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*(*)     OPTION,NOMTE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 23/04/2013   AUTEUR SELLENET N.SELLENET 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C     CALCULE DES TERMES PROPRES A UNE STRUCTURE  (ELEMENT DE BARRE)
C     ------------------------------------------------------------------
C IN  OPTION : K16 : NOM DE L'OPTION A CALCULER
C        'MASS_INER      : CALCUL DES CARACTERISTIQUES DE STRUCTURES
C IN  NOMTE  : K16 : NOM DU TYPE ELEMENT
C        'MECA_BARRE'       : BARRE
C        'MECA_2D_BARRE'    : BARRE 2D
C
C
      INTEGER CODRES
      CHARACTER*16 CH16, PHENOM
      CHARACTER*8  NOMAIL
      REAL*8       RHO, A, XL, R8B, R8PREM
      INTEGER      IADZI,IAZK24
C     ------------------------------------------------------------------
C
C     --- RECUPERATION DES CARACTERISTIQUES MATERIAUX ---
C-----------------------------------------------------------------------
      INTEGER LCASTR ,LMATER ,LSECT ,LX
C-----------------------------------------------------------------------
      CALL JEVECH ('PMATERC', 'L', LMATER )
C
      CALL RCCOMA (ZI(LMATER),'ELAS',1,PHENOM,CODRES)
C
      IF ( PHENOM .EQ. 'ELAS'          .OR.
     &     PHENOM .EQ. 'ELAS_ISTR'     .OR.
     &     PHENOM .EQ. 'ELAS_ORTH'   )  THEN
         CALL RCVALB('FPG1',1,1,'+',ZI(LMATER),' ',PHENOM,0,' ',R8B,
     &                 1, 'RHO', RHO, CODRES, 1)
         IF(RHO.LE.R8PREM()) THEN
           CALL U2MESS('F','ELEMENTS5_45')
         ENDIF
      ELSE
        CALL U2MESS('F','ELEMENTS_50')
      ENDIF
C
C     --- RECUPERATION DES CARACTERISTIQUES GENERALES DES SECTIONS ---
      CALL JEVECH ('PCAGNBA', 'L',LSECT)
      A  =  ZR(LSECT)
C
C     --- RECUPERATION DES COORDONNEES DES NOEUDS ---
      CALL JEVECH ('PGEOMER', 'L',LX)
      LX = LX - 1
C
      IF (NOMTE.EQ.'MECA_BARRE') THEN
        CALL LONELE( ZR(LX),3,XL)
      ELSE IF (NOMTE.EQ.'MECA_2D_BARRE') THEN
        CALL LONELE( ZR(LX),2,XL)
C
      ENDIF
      IF( XL .EQ. 0.D0 ) THEN
        CALL TECAEL(IADZI,IAZK24)
        NOMAIL = ZK24(IAZK24-1+3)(1:8)
        CALL U2MESK('F','ELEMENTS2_43',1,NOMAIL)
      ENDIF
C
C     --- CALCUL DES CARACTERISTIQUES ELEMENTAIRES ----
      IF ( OPTION.EQ.'MASS_INER' ) THEN
         CALL JEVECH ('PMASSINE', 'E', LCASTR)
C
C        --- MASSE ET CDG DE L'ELEMENT ---
      IF (NOMTE.EQ.'MECA_BARRE') THEN
         ZR(LCASTR)   = RHO * A * XL
         ZR(LCASTR+1) =( ZR(LX+4) + ZR(LX+1) ) / 2.D0
         ZR(LCASTR+2) =( ZR(LX+5) + ZR(LX+2) ) / 2.D0
         ZR(LCASTR+3) =( ZR(LX+6) + ZR(LX+3) ) / 2.D0
      ELSE IF (NOMTE.EQ.'MECA_2D_BARRE') THEN
         ZR(LCASTR)   = RHO * A * XL
         ZR(LCASTR+1) =( ZR(LX+3) + ZR(LX+1) ) / 2.D0
         ZR(LCASTR+2) =( ZR(LX+4) + ZR(LX+2) ) / 2.D0
      ENDIF

C        --- INERTIE DE L'ELEMENT ---
         ZR(LCASTR+4) = 0.D0
         ZR(LCASTR+5) = 0.D0
         ZR(LCASTR+6) = 0.D0
         ZR(LCASTR+7) = 0.D0
         ZR(LCASTR+8) = 0.D0
         ZR(LCASTR+9) = 0.D0
C
      ELSE
         CH16 = OPTION
         CALL U2MESK('F','ELEMENTS2_47',1,CH16)
      ENDIF
C
      END
