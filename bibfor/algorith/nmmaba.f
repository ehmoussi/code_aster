      SUBROUTINE NMMABA (ICODMA,COMPOR,E,DSDE,SIGY,
     &                   NCSTPM,CSTPM)
C ----------------------------------------------------------------------
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*16 COMPOR
      INTEGER ICODMA
      INTEGER NCSTPM
      REAL*8  CSTPM(NCSTPM)
      REAL*8  E,DSDE,SIGY
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 04/04/2011   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_21
C     RECUPERATION DES CARACTERISTIQUES DU MATERIAU POUR LES ELEMENTS
C     MECA_BARRE DANS LE CAS DES COMPORTEMENTS NON LINEAIRES.
C ----------------------------------------------------------------------
C
C IN  : ICODMA : NUMERO DU MATERIAU CODE
C       COMPOR : NOM DE LA RELATION DE COMPORTEMENT
C
C OUT : E      : MODULE D'YOUNG
C       DSDE   : PENTE D'ECROUISSAGE
C       SIGY   : LIMITE ELASTIQUE POUR L,ECROUISSAGE LINEAIRE
C       NCSTPM : NOMBRE DE CONSTANTES DE MATERIAU POUR INTO
C       CSTPM  : CONSTANTES DE MATERIAU :
C           E      : MODULE D'YOUNG
C           SY     : LIMITE ELASTIQUE
C           EPSU   : DEFORMATION ULTIME
C           SU     : CONTRAINTE ULTIME
C           EPSH   : DEFORMATION A LA FIN DU PALIER PLASTIQUE PARFAIT
C           R0     : COEFFICIENT EXPERIMENTAL
C           B      : COEFFICIENT
C           A1     : COEFFICIENT EXPERIMENTAL
C           A2     : COEFFICIENT EXPERIMENTAL
C           ELAN   : RAPPORT LONGUEUR/DIAMETRE DE LA BARRE
C           A6     : COEFFICIENT EXPERIMENTAL FLAMMBAGE
C           C      : COEFFICIENT EXPERIMENTAL FLAMMBAGE
C           COA    : COEFFICIENT EXPERIMENTAL FLAMMBAGE
C
C
C *************** DECLARATION DES VARIABLES LOCALES ********************
C
      PARAMETER    (NBVAL = 12)
      REAL*8       VALPAR,VALRES(NBVAL)
      CHARACTER*2  BL2, FB2, CODRES(NBVAL)
      CHARACTER*8  NOMPAR,NOMELA(1),NOMECL(2)
      CHARACTER*8  NOMPIM(12)
      CHARACTER*4  FAMI
C
C *********** FIN DES DECLARATIONS DES VARIABLES LOCALES ***************
C
C ****************************** DATA  *********************************
C
      DATA NOMELA / 'E' /
C     DATA NOMECL / 'D_SIGM_EPSI', 'SY' /
      DATA NOMECL / 'D_SIGM_E', 'SY' /
C     DATA NOMPIM / 'SY','EPSI_ULTM','SIGM_ULTM','ELAN','EPSP_HARD',
      DATA NOMPIM / 'SY','EPSI_ULT','SIGM_ULT','ELAN','EPSP_HAR',
     &              'R_PM','EP_SUR_E', 'A1_PM','A2_PM','A6_PM',
     &              'C_PM','A_PM' /
C
C ********************* DEBUT DE LA SUBROUTINE *************************
C
C --- MESSAGE D'ERREUR SI COMPORTEMENT NON REPERTORIE POUR LES BARRES
C
      IF((COMPOR.NE.'ELAS').AND.(COMPOR.NE.'VMIS_ISOT_LINE')
     &                     .AND.(COMPOR.NE.'VMIS_CINE_LINE')
     &                     .AND.(COMPOR.NE.'VMIS_ASYM_LINE')
     &                     .AND.(COMPOR.NE.'PINTO_MENEGOTTO')
     &                     .AND.(COMPOR.NE.'GRILLE_CINE_LINE')
     &                     .AND.(COMPOR.NE.'GRILLE_ISOT_LINE')
     &                     .AND.(COMPOR.NE.'GRILLE_PINTO_MEN')) THEN
         CALL U2MESK('F','ELEMENTS_32',1,COMPOR)
      END IF
C
C --- INITIALISATIONS
C
      BL2 = '  '
      FB2 = 'FM'
      FAMI = 'RIGI'
C
      CALL R8INIR (NBVAL,0.D0,VALRES,1)
      NBPAR  = 0
      NOMPAR = '  '
      VALPAR = 0.D0
C
C --- CARACTERISTIQUES ELASTIQUES
C
      NBRES = 2
      CALL RCVALB(FAMI,1,1,'+',ICODMA,' ','ELAS',
     &             NBPAR,NOMPAR,VALPAR,1,NOMELA,
     &             VALRES,CODRES,FB2)
      E     = VALRES(1)
C
C --- CARACTERISTIQUES ECROUISSAGE LINEAIRE
C
      IF ((COMPOR.EQ.'VMIS_ISOT_LINE').OR.
     &   (COMPOR.EQ.'VMIS_CINE_LINE').OR.
     &   (COMPOR.EQ.'GRILLE_CINE_LINE').OR.
     &   (COMPOR.EQ.'GRILLE_ISOT_LINE')) THEN
        NBRES= 2
C
      BL2 = '  '
      FB2 = 'FM'
C
      CALL R8INIR (NBVAL,0.D0,VALRES,1)
      NBPAR  = 0
      NOMPAR = '  '
      VALPAR = 0.D0
        CALL RCVALB(FAMI,1,1,'+',ICODMA,' ','ECRO_LINE',
     &             NBPAR,NOMPAR,VALPAR,1,NOMECL,
     &             VALRES,CODRES,FB2)
        CALL RCVALB(FAMI,1,1,'+',ICODMA,' ','ECRO_LINE',
     &            NBPAR,NOMPAR,VALPAR,1,
     &            NOMECL(2), VALRES(2),CODRES(2), BL2)
        IF (CODRES(2).NE.'OK') VALRES(2) = 0.D0
        DSDE    = VALRES(1)
        SIGY    = VALRES(2)
      ENDIF
C
C --- CARACTERISTIQUES MODELE PINTO MENEGOTTO
C
      IF ((COMPOR.EQ.'PINTO_MENEGOTTO').OR.
     &   (COMPOR.EQ.'GRILLE_PINTO_MEN')) THEN
C
        NBRES= 12
C
      BL2 = '  '
      FB2 = 'FM'
C
      CALL R8INIR (NBVAL,0.D0,VALRES,1)
      NBPAR  = 0
      NOMPAR = '  '
      VALPAR = 0.D0
C
      CALL RCVALB(FAMI,1,1,'+',ICODMA,' ','PINTO_MENEGOTTO',
     &            NBPAR,NOMPAR,VALPAR,
     &            NBRES, NOMPIM,VALRES,CODRES,BL2)
      IF (CODRES(7).NE.'OK') VALRES(7) = -1.D0
      CSTPM(1)    =E
      CSTPM(2)    =VALRES(1)
      CSTPM(3)    =VALRES(2)
      CSTPM(4)    =VALRES(3)
      CSTPM(10)   =VALRES(4)
      CSTPM(5)    =VALRES(5)
      CSTPM(6)    =VALRES(6)
      CSTPM(7)    =VALRES(7)
      CSTPM(8)    =VALRES(8)
      CSTPM(9)    =VALRES(9)
      CSTPM(11)   =VALRES(10)
      CSTPM(12)    =VALRES(11)
      CSTPM(13)   =VALRES(12)
C
      ENDIF
C
      END
