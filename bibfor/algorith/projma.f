      SUBROUTINE PROJMA(DEFICO,IZONE ,MATYP ,NDIM  ,COORMA,
     &                  COORDP,NORMMA,PROJ  ,MOYEN ,LISSA ,
     &                  DIAGNO,TOLEIN,TOLEOU,ENORM ,
     &                  NORM  ,TANG  ,COORDM,COEFNO,JEUPM ,
     &                  JEU   ,PROYES)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 10/09/2007   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE ABBAS M.ABBAS
C TOLE CRP_21
C
      IMPLICIT     NONE
      INTEGER      IZONE
      CHARACTER*24 DEFICO    
      CHARACTER*4  MATYP
      INTEGER      NDIM
      REAL*8       COORMA(27)
      REAL*8       COORDP(3)
      INTEGER      PROJ
      INTEGER      MOYEN
      INTEGER      LISSA
      CHARACTER*19 NORMMA      
      INTEGER      DIAGNO
      REAL*8       TOLEIN
      REAL*8       TOLEOU
      REAL*8       NORM(3),ENORM(3)
      REAL*8       TANG(6)
      REAL*8       COEFNO(9)
      REAL*8       COORDM(3)
      REAL*8       JEUPM
      REAL*8       JEU
      INTEGER      PROYES      
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODES DISCRETES - APPARIEMENT - MAIT/ESCL)
C
C RECHERCHE DE LA MAILLE (OU DU NOEUD) MAITRE ASSOCIEE A CHAQUE 
C NOEUD ESCLAVE
C
C ----------------------------------------------------------------------
C
C
C IN  DEFICO : SD DE DEFINITION DU CONTACT (ISSUE D'AFFE_CHAR_MECA)
C IN  IZONE  : ZONE DE CONTACT
C IN  MATYP  : TYPE DE LA MAILLE MAITRE
C                -> SEG2,SEG3,TRI3,TRI6,QUA4,QUA8,QUA9
C IN  NDIM   : DIMENSION DE L'ESPACE (2 OU 3)
C IN  COORMA : COORDONNEES DES NOEUDS DE LA MAILLE MAITRE
C IN  COORDP : COORDONNEES DU NOEUD ESCLAVE P
C IN  PROJ   : TYPE DE PROJECTION
C               1 PROJECTION LINEAIRE
C               2 PROJECTION QUADRATIQUE
C IN  MOYEN  : NORMALES D'APPARIEMENT
C               0 MAIT
C               1 MAIT_ESCL
C IN  LISSA  : LISSAGE DES NORMALES
C               0 PAS DE LISSAGE
C               1 LISSAGE
C IN  NORMMA : NOM DE L'OBJET CONTENANT LES NORMALES AUX NOEUDS MAITRES
C IN  DIAGNO : FLAG POUR DETECTION PROJECTION SUR ENTITES GEOMETRIQUES
C IN  TOLEIN : TOLERANCE POUR DETECTION PROJECTION SUR ENTITES GEO.
C IN  TOLEOU : TOLERANCE POUR DETECTION PROJECTION EN DEHORS
C              MAILLE MAITRE
C IN  ENORM  : NORMALE AU NOEUD ESCLAVE
C OUT NORM   : NORMALE LISSEE/MOYENNE (OPTIONS LISSA/MOYEN)
C OUT TANG   : VECTEUR TANGENTS SUR REPERE NORM/MAILLE
C OUT COORDM : COORDONNEES DE LA "PROJECTION" M
C OUT COEFNO : VALEURS EN M DES FONCTIONS DE FORME ASSOCIEES AUX NOEUDS
C               MAITRES
C OUT JEUPM  : JEU DANS LA DIRECTION PM
C OUT JEU    : JEU DANS LA DIRECTION DE LA NORMALE CHOISIE (PM.NORM)
C OUT PROYES : TYPE DE PROJECTION
C              -1000  PROJECTION EN DEHORS
C                   DE LA MAILLE MAITRE (TOLERANCE TOLEOU ET DEBORD)
C              -30X   PROJECTION SUR
C                   ENTITE GEOMETRIQUE NOEUD
C                   DE LA MAILLE MAITRE (TOLERANCE TOLEIN ET NOEUD)
C                      X EST LE NUMERO DE NOEUD (1 A 4)
C              -20X   PROJECTION SUR
C                   ENTITE GEOMETRIQUE ARETE
C                   DE LA MAILLE MAITRE (TOLERANCE TOLEIN ET ARETE)
C                      X EST LE NUMERO D'ARETE (1 A 4)
C              -10X   PROJECTION SUR
C                   ENTITE GEOMETRIQUE DIAG (PSEUDO SUR QUADRANGLE)
C                   DE LA MAILLE MAITRE (TOLERANCE TOLEIN ET DIAG)
C                      X EST LE NUMERO DE DIAGONALE (1 A 2)
C               0     PROJECTION NORMALE
C
C ----------------------------------------------------------------------
C
      REAL*8        DEBORD,LAMBDA(3),LAMOLD(3)
      REAL*8        MNORM(3),UNORM(3)
      INTEGER       ARETE(4),NOEUD(4),DIAG(2),ITRIA         
C
C ----------------------------------------------------------------------
C

C
C --- INITIALISATIONS
C
      IF (PROJ.EQ.0) THEN
        CALL U2MESS('F','CONTACT_13')
      END IF
C      
C --- PREPARATION DES NORMALES    
C       
      CALL CFNOMA(DEFICO,IZONE ,NDIM  ,MOYEN ,MATYP ,
     &            COORMA(1),COORMA(4),COORMA(7),ENORM ,MNORM ,
     &            UNORM)
C
C --- PROJECTION SUIVANT TYPE DE MAILLE
C
      IF (MATYP(1:3).EQ.'SEG') THEN
        CALL PROJSE(MATYP  ,NDIM   ,PROJ  ,MOYEN ,
     &              UNORM  ,MNORM  ,
     &              COORMA(1),COORMA(4),COORMA(7),COORDP,
     &              COORDM ,LAMBDA ,DEBORD)
      ELSE IF (MATYP(1:3).EQ.'TRI') THEN
        CALL PROJTR(MATYP  ,PROJ   ,MOYEN  ,
     &              UNORM  ,MNORM  ,
     &              COORMA(1),COORMA(4),COORMA(7),COORDP,
     &              COORDM ,LAMOLD ,LAMBDA ,DEBORD)
      ELSE IF (MATYP(1:3).EQ.'QUA') THEN
        CALL PROJQU(MATYP  ,NDIM   ,PROJ   ,MOYEN   ,
     &              ENORM  ,MNORM  ,TOLEIN ,TOLEOU ,
     &              COORMA(1),COORMA(4),COORMA(7),COORMA(10),
     &              COORDP ,COORDM ,LAMBDA ,DEBORD,
     &              ITRIA  ,NOEUD  ,ARETE  ,DIAG)
        
      ELSE
        CALL U2MESS('F','CONTACT_30')
      END IF
C
C --- CALCUL DU JEU SUR VECTEUR PM
C     
      CALL CFOLDJ(COORDP,COORDM,JEUPM)
C
C --- CALCUL DES COEFFICIENTS DE LA RELATION LINEAIRE SUR NOEUDS MAITRES
C      
      CALL CFRELI(MATYP ,PROJ  ,ITRIA,LAMBDA,COORDM,
     &            COORMA,COEFNO)
C
C --- LISSAGE DES NORMALES MAITRES (SI DEMANDE PAR LISSA)
C
      CALL CFLISN(MATYP ,NORMMA,LAMBDA,ITRIA ,COEFNO,
     &            PROJ  ,LISSA ,MNORM )
C
C --- MOYENNAGE DES NORMALES (SI DEMANDE PAR MOYEN)
C
      CALL CFMOYN('MAIT_ESCL',MOYEN,MNORM,ENORM,NORM)       
C
C --- RECALCUL DES TANGENTES
C
      CALL CFTANG(DEFICO,IZONE,NDIM,NORM,TANG)            
C
C --- CALCUL DU JEU SUIVANT NORMALE MOYENNE/LISSEE OU PAS
C
      CALL CFNEWJ(NDIM,COORDP,COORDM,NORM,JEU)               
C
C --- VERIFICATIONS DES PROJECTIONS SUR ENTITES GEOMETRIQUES
C
      IF (DIAGNO.EQ.1) THEN
        CALL PRDIMA(MATYP ,LAMBDA,LAMOLD,TOLEIN,
     &              ARETE ,NOEUD)
      ENDIF
C
C --- VERIFICATIONS DES DEBORDEMENTS ET PROJECTION SUR ENTITES
C
      CALL PROJIN(DIAGNO,TOLEOU,DIAG  ,ARETE ,NOEUD ,
     &            DEBORD,PROYES)
      END
