      SUBROUTINE CMLQND(NBNO  , NBNOMI, PREFIX, NDINIT, NOMIPE,
     &                  NOMNOE, COOR)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2003  EDF R&D                  WWW.CODE-ASTER.ORG
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

      IMPLICIT NONE

      INTEGER      NBNO, NBNOMI, NOMIPE(2,NBNOMI), NDINIT
      REAL*8       COOR(3,*)
      CHARACTER*8  PREFIX
      CHARACTER*24 NOMNOE


C ----------------------------------------------------------------------
C         CREATION DES NOEUDS MILIEUX (CREA_MAILLAGE LINE_QUAD)
C ----------------------------------------------------------------------
C IN        NBNO    NOMBRE TOTAL DE NOEUDS DU MAILLAGE
C IN        NBNOMI  NOMBRE DE NOEUDS CREES
C IN        PREFIX  PREFIXE POUR LE NOM DES NOEUDS (EX : N, NS, ...)
C IN        NDINIT  NUMERO INITIAL DES NOEUDS CREES
C IN        NOMIPE  LISTE DES PERES PAR NOEUDS CREES (NOEUDS SOMMETS)
C IN/JXVAR  NOMNOE  REPERTOIRE DE NOMS DES NOEUDS
C VAR       COOR    COORDONNEES DES NOEUDS
C ----------------------------------------------------------------------

C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*32 JEXNUM,JEXNOM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------

      INTEGER NO,NO1,NO2, LGPREF,LGND, IRET
      INTEGER LXLGUT

      CHARACTER*8  NOMND
      CHARACTER*80 KNUME
C ----------------------------------------------------------------------



C - INSERTION DES NOUVEAUX NOEUDS

      LGPREF = LXLGUT(PREFIX)
      DO 10 NO = 1, NBNOMI

C      NOM DU NOEUD CREE
        CALL CODENT(NDINIT-1+NO,'G',KNUME)
        LGND = LXLGUT(KNUME)
        IF (LGND+LGPREF.GT.8) CALL U2MESS('F','ALGELINE_16')
        NOMND = PREFIX(1:LGPREF) // KNUME

C      DECLARATION DU NOEUD CREE
        CALL JEEXIN(JEXNOM(NOMNOE,NOMND),IRET)
        IF (IRET.EQ.0) THEN
          CALL JECROC(JEXNOM(NOMNOE,NOMND))
        ELSE
          CALL UTDEBM('F','CMLQND','ERREUR DONNEES')
          CALL UTIMPK('L','NOEUD DEJA EXISTANT : ',1,NOMND)
          CALL UTFINM
        END IF

 10   CONTINUE


C - CALCUL DES COORDONNEES DES NOUVEAUX NOEUDS
      DO 20 NO = 1, NBNOMI
        NO1 = NOMIPE(1,NO)
        NO2 = NOMIPE(2,NO)
        COOR(1,NO+NBNO) = (COOR(1,NO1) + COOR(1,NO2))/2
        COOR(2,NO+NBNO) = (COOR(2,NO1) + COOR(2,NO2))/2
        COOR(3,NO+NBNO) = (COOR(3,NO1) + COOR(3,NO2))/2
 20   CONTINUE

      END
