      SUBROUTINE PROJMA(MATYP,NBNO,NDIM,
     &                  COOR,COORDP,
     &                  PROJ,MOYEN,LISSA,TANGDF,JLISSA,DIAGNO,
     &                  TOLEIN,TOLEOU,
     &                  NORM,TANG,
     &                  COORDM,COEFNO,OLDJEU,JEU,PROYES)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C TOLE CRP_21
C
      IMPLICIT     NONE
      CHARACTER*4  MATYP
      INTEGER      NBNO
      INTEGER      NDIM
      REAL*8       COOR(27)
      REAL*8       COORDP(3)
      INTEGER      PROJ
      INTEGER      MOYEN
      INTEGER      LISSA
      INTEGER      TANGDF
      INTEGER      JLISSA
      INTEGER      DIAGNO
      REAL*8       TOLEIN
      REAL*8       TOLEOU
      REAL*8       NORM(3)
      REAL*8       TANG(6)
      REAL*8       COEFNO(9)
      REAL*8       COORDM(3)
      REAL*8       OLDJEU
      REAL*8       JEU
      INTEGER      PROYES
C
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : PROJEC
C ----------------------------------------------------------------------
C
C CETTE ROUTINE REALISE L'APPARIEMENT NOEUD-FACETTE
C CALCUL DE LA "PROJECTION" M DU NOEUD ESCLAVE P SUR LA MAILLE MAITRE.
C COEFFICIENTS DES FONCTIONS DE FORME POUR REPERER M SUR LA MAILLE
C   MAITRE
C
C IN  MATYP  : TYPE DE LA MAILLE MAITRE
C                -> POI1,SEG2,SEG3,TRI3,TRI6,QUA4,QUA8,QUA9
C IN  NBNO   : NOMBRE DE NOEUDS MAITRES CONCERNES
C IN  NDIM   : DIMENSION DE L'ESPACE (2 OU 3)
C IN  COOR   : COORDONNEES DES NOEUDS DE LA MAILLE MAITRE
C IN  COORDP : COORDONNEES DU NOEUD ESCLAVE P
C IN  PROJ   : 0 -> INTERDIT POUR L'INSTANT (SEUL JEU RECALCULE)
C              1 -> PROJECTION LINEAIRE
C              2 -> PROJECTION QUADRATIQUE
C IN  MOYEN  : NORMALES D'APPARIEMENT
C               0 MAIT
C               1 MAIT_ESCL
C IN  LISSA  : LISSAGE DES NORMALES
C               0 PAS DE LISSAGE
C               1 LISSAGE
C IN  TANGDF : INDICATEUR DE PRESENCE D'UN VECT_Y DEFINI PAR
C              L'UTILISATEUR
C               0 PAS DE VECT_Y
C               1 UN VECT_Y EST DEFINI
C IN  JLISSA : POINTEUR JEVEUX VERS NORMALES LISSEES (SI LISSA.NE.0)
C IN  DIAGNO : FLAG POUR DETECTION PROJECTION SUR ENTITES GEOMETRIQUES
C IN  TOLEIN : TOLERANCE POUR DETECTION PROJECTION SUR ENTITES GEO.
C IN  TOLEOU : TOLERANCE POUR DETECTION PROJECTION EN DEHORS
C              MAILLE MAITRE
C I/O NORM   : DIRECTION DE PROJECTION (DIRECTION PM NORMEE)
C I/O TANG   : VECTEURS TANGENTS
C OUT COORDM : COORDONNEES DE LA "PROJECTION" M
C OUT COEFNO : VALEURS EN M DES FONCTIONS DE FORME ASSOCIEES AUX NOEUDS
C               MAITRES
C OUT OLDJEU : JEU PM DANS LA DIRECTION PM
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
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
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
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER       DIAG(2)
      INTEGER       ARETE(4)
      INTEGER       NOEUD(4)
      REAL*8        DEBORD,R8PREM
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ ()

      DEBORD = R8PREM()

      IF ((MATYP.EQ.'SEG2').OR.(MATYP.EQ.'SEG3')) THEN
        CALL PROJSE(MATYP,NDIM,
     &              COOR(1),COOR(4),COOR(7),COORDP,
     &              PROJ,MOYEN,LISSA,TANGDF,ZR(JLISSA),DIAGNO,TOLEIN,
     &              NORM,TANG,
     &              COORDM,COEFNO,OLDJEU,JEU,
     &              NOEUD,DEBORD)
      ELSE IF ((MATYP.EQ.'TRI3').OR.(MATYP.EQ.'TRI6').OR.
     &                              (MATYP.EQ.'TRI7')) THEN
        CALL PROJTR(MATYP,NBNO,NDIM,
     &              COOR(1),COOR(4),COOR(7),COORDP,
     &              PROJ,MOYEN,LISSA,TANGDF,ZR(JLISSA),DIAGNO,TOLEIN,
     &              NORM,TANG,
     &              COORDM,COEFNO,OLDJEU,JEU,
     &              ARETE,NOEUD,DEBORD)
      ELSE IF ((MATYP.EQ.'QUA4').OR.(MATYP.EQ.'QUA8').OR.
     &                              (MATYP.EQ.'QUA9')) THEN
        CALL PROJQU(MATYP,NBNO,NDIM,'TRIANG',
     &              COOR(1),COOR(4),COOR(7),COOR(10),COORDP,
     &              PROJ,MOYEN,LISSA,TANGDF,ZR(JLISSA),DIAGNO,TOLEIN,
     &              TOLEOU,
     &              NORM,TANG,
     &              COORDM,COEFNO,OLDJEU,JEU,
     &              DIAG,ARETE,NOEUD,DEBORD)
      ELSE
        CALL U2MESS('F','ALGORITH10_4')
      END IF
C
C --- VERIFICATIONS DES DEBORDEMENTS ET PROJECTION SUR ENTITES
C
      CALL PROJIN(DIAGNO,TOLEOU,DIAG,ARETE,NOEUD,DEBORD,
     &            PROYES)
C

      CALL JEDEMA()
C ----------------------------------------------------------------------
      END
