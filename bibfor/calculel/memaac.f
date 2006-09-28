      SUBROUTINE MEMAAC(MODELE,MATE,MATEL)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*8 MODELE,MATEL
      CHARACTER*(*) MATE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================

C     CALCUL DES MATRICES ELEMENTAIRES DE MASSE_ACOUSTIQUE
C                ( 'MASS_ACOU', ISO )

C     ENTREES:

C     LES NOMS QUI SUIVENT SONT LES PREFIXES UTILISATEUR K8:
C        MODELE : NOM DU MODELE
C*       MATE   : CARTE DE MATERIAU CODE
C        MATEL  : NOM DU MAT_ELE(N RESUELEM) PRODUIT

C     SORTIES:
C        MATEL  : EST CALCULE

C ----------------------------------------------------------------------

C     FONCTIONS EXTERNES:
C     -------------------
      CHARACTER*32 JEXNUM,JEXNOM,JEXATR

C     VARIABLES LOCALES:
C     ------------------
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
C*
      LOGICAL ZL,EXIGEO
C*
      CHARACTER*8 ZK8,LPAIN(4),LPAOUT(1),BLANC,LIPARA(1)
      CHARACTER*16 ZK16,OPTION
C*
      CHARACTER*24 ZK24,CHGEOM,LCHIN(4),LCHOUT(1)
      CHARACTER*24 LIGRMO
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80


      CALL JEMARQ()
      IF (MODELE(1:1).EQ.' ') THEN
        CALL U2MESS('F','CALCULEL3_50')
      END IF

      BLANC = '        '
      CALL MEGEOM(MODELE,BLANC,EXIGEO,CHGEOM)

      CALL JEEXIN(MATEL//'.REFE_RESU',IRET)
      IF (IRET.GT.0) THEN
        CALL JEDETR(MATEL//'.REFE_RESU')
        CALL JEDETR(MATEL//'.LISTE_RESU')
      END IF
      CALL MEMARE('G',MATEL,MODELE,MATE,' ','MASS_ACOU')
      CALL JECREO(MATEL//'.LISTE_RESU','G V K24')
      CALL JEECRA(MATEL//'.LISTE_RESU','LONMAX',1,' ')
      CALL JEVEUO(MATEL//'.LISTE_RESU','E',JLIRES)

      LPAOUT(1) = 'PMATTTC'
      LCHOUT(1) = MATEL//'.ME000'
      LPAIN(1) = 'PGEOMER'
      LCHIN(1) = CHGEOM
C**
      LPAIN(2) = 'PMATERC'
      LCHIN(2) = MATE
C**

      LIGRMO = MODELE//'.MODELE'
      OPTION = 'MASS_ACOU'
      ILIRES = 0
      ILIRES = ILIRES + 1
      CALL CODENT(ILIRES,'D0',LCHOUT(1) (12:14))
      CALL CALCUL('S',OPTION,LIGRMO,2,LCHIN,LPAIN,1,LCHOUT,LPAOUT,'G')
      CALL EXISD('CHAMP_GD',LCHOUT(1) (1:19),IRET)
      IF (IRET.NE.0) THEN
        ZK24(JLIRES-1+1) = LCHOUT(1)
        CALL JEECRA(MATEL//'.LISTE_RESU','LONUTI',1,' ')
      ELSE
        ILIRES = ILIRES - 1
      END IF

   10 CONTINUE
      CALL JEDEMA()
      END
