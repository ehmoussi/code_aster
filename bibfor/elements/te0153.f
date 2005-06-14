      SUBROUTINE TE0153(OPTION,NOMTE)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*(*)     OPTION,NOMTE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 29/04/2004   AUTEUR JMBHH01 J.M.PROIX 
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
C     CALCULE LES MATRICES ELEMENTAIRES DES ELEMENTS DE BARRE
C     ------------------------------------------------------------------
C IN  OPTION : K16 : NOM DE L'OPTION A CALCULER
C        'RIGI_MECA'      : CALCUL DE LA MATRICE DE RAIDEUR
C        'MASS_MECA'      : CALCUL DE LA MATRICE DE MASSE
C IN  NOMTE  : K16 : NOM DU TYPE ELEMENT
C        'MECA_BARRE' : ELEMENT BARRE
C        'MECA_2D_BARRE' : ELEMENT BARRE
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      CHARACTER*32       JEXNUM , JEXNOM , JEXR8 , JEXATR
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      CHARACTER*2         CODRES
      CHARACTER*16 CH16
      REAL*8       E, NU, G, RHO, PGL(3,3), MAT(21),MATR(21)
      REAL*8       A, XL, XRIG, XMAS
C     ------------------------------------------------------------------
C
CC     --- RECUPERATION DES CARACTERISTIQUES GENERALES DES SECTIONS ---
      CALL JEVECH ('PCAGNBA', 'L',LSECT)
      A  =  ZR(LSECT)
      NNO = 2
      NC  = 3
C
C     --- RECUPERATION DES COORDONNEES DES NOEUDS ---
      CALL JEVECH ('PGEOMER', 'L',LX)
      LX = LX - 1
      IF (NOMTE.EQ.'MECA_BARRE') THEN
        CALL LONELE( ZR(LX),3,XL)
C
      ELSE IF (NOMTE.EQ.'MECA_2D_BARRE') THEN
        CALL LONELE(ZR(LX),2,XL)
C
      ENDIF
C
      IF( XL .EQ. 0.D0 ) THEN
         CH16 = ' ?????????'
         CALL UTMESS('F','ELEMENTS DE BARRE (TE0153)',
     +                  'NOEUDS CONFONDUS POUR UN ELEMENT: '//CH16(:8))
      ENDIF
C
C     --- RECUPERATION DES ORIENTATIONS ALPHA,BETA,GAMMA ---
      CALL JEVECH ('PCAORIE', 'L',LORIEN)
C
      CALL JEVECH ('PMATUUR', 'E', LMAT)
      DO 20 I = 1,21
         MAT(I) = 0.D0
 20   CONTINUE
C
C     --- CALCUL DES MATRICES ELEMENTAIRES ----
      CALL JEVECH ('PMATERC', 'L', IMATE)
      IF ( OPTION.EQ.'RIGI_MECA'  ) THEN
         CALL RCVALA(ZI(IMATE),' ','ELAS',0,' ',R8B,1,'E',E,
     &               CODRES,'FM')
         XRIG = E * A / XL
         MAT( 1) =  XRIG
         MAT( 7) = -XRIG
         MAT(10) =  XRIG
C
      ELSE IF ( OPTION.EQ.'MASS_MECA'  ) THEN
         CALL RCVALA(ZI(IMATE),' ','ELAS',0,' ',R8B,1,'RHO',RHO,
     &               CODRES,'FM')
         XMAS = RHO * A * XL / 6.D0
         MAT( 1) = XMAS * 2.D0
         MAT( 7) = XMAS
         MAT(10) = XMAS * 2.D0
C
      ELSE
         CH16 = OPTION
         CALL UTMESS('F','ELEMENTS DE BARRE (TE0153)',
     +                   'L''OPTION "'//CH16//'" EST INCONNUE')
      ENDIF
C
C     --- PASSAGE DU REPERE LOCAL AU REPERE GLOBAL ---
C
      CALL MATROT ( ZR(LORIEN) , PGL )
      CALL UTPSLG ( NNO, NC, PGL, MAT, MATR )
C
C ECRITURE DANS LE VECTEUR PMATTUR SUIVANT L'ELEMENT
C
      IF (NOMTE.EQ.'MECA_BARRE') THEN
        DO 30 I=1,21
          ZR(LMAT+I-1) = MATR(I)
 30     CONTINUE
      ELSE IF (NOMTE.EQ.'MECA_2D_BARRE') THEN
        ZR(LMAT)     = MATR(1)
        ZR(LMAT+1)   = MATR(2)
        ZR(LMAT+2)   = MATR(3)
        ZR(LMAT+3)   = MATR(7)
        ZR(LMAT+4)   = MATR(8)
        ZR(LMAT+5)   = MATR(10)
        ZR(LMAT+6)   = MATR(11)
        ZR(LMAT+7)   = MATR(12)
        ZR(LMAT+8)   = MATR(14)
        ZR(LMAT+9)   = MATR(15)
      ENDIF
C
      END
