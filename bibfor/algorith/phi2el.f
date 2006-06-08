      SUBROUTINE PHI2EL(MODELE,CARELE,MATE,ACCEL,PHIBAR,INSTAP,VE)
      IMPLICIT REAL*8 (A-H,O-Z)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 11/09/2002   AUTEUR VABHHTS J.PELLET 
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
      CHARACTER*(*) MODELE,CARELE,MATE,ACCEL,PHIBAR,VE
      REAL*8 INSTAP
C ---------------------------------------------------------------------
C     CALCUL DES VECTEURS ELEMENTAIRES DES FLUX FLUIDES

C IN  MODELE  : NOM DU MODELE
C IN  CARELE  : CARACTERISTIQUES DES POUTRES ET COQUES
C IN  MATE    : MATERIAU
C IN  ACCEL  : CHAM_NO DE OU DE DEPL
C IN  INSTAP  : INSTANT DU CALCUL
C VAR VE  : VECTEUR ELEMENTAIRE DE CHARGEMENT THERMIQUE

C               & & V E C T ? ? .
C               1 2 3 4 5 6 7 8 9

C               POSITION 7-8  : NUMERO DE LA CHARGE

C -- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------

      CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
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

C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
      CHARACTER*8 VECEL,LPAIN(5),LPAOUT(1),K8BID,KBID
      CHARACTER*8 NOMA
      CHARACTER*16 OPTION
      CHARACTER*24 CHGEOM,CHMATE,CHCARA(15),CHTIME,CHTREF,CHDEPL
      CHARACTER*24 LIGRMO,LCHIN(5),LCHOUT(1),PHIB24
      INTEGER IBID,IRET,NBPARA
      LOGICAL EXIGEO,PREM
      COMPLEX*16 CBID

      CALL JEMARQ()
      CALL JEEXIN(VE,IRET)
      VECEL = '&&PHI2M'
      IF (IRET.EQ.0) THEN
        PREM = .TRUE.
        VE = VECEL//'.LISTE_RESU'
        CALL MEMARE('V',VECEL,MODELE(1:8),MATE,CARELE,'CHAR_THER')
        CALL WKVECT(VE,'V V K24',1,JLVE)
        IF (ACCEL(9:14).EQ.'.BIDON') THEN
          CALL JEECRA(VE,'LONUTI',0,K8BID)
          GO TO 10
        END IF
      ELSE
        PREM = .FALSE.
        CALL JELIRA(VE,'LONUTI',NBCHTE,K8BID)
        IF (NBCHTE.EQ.0) THEN
          GO TO 10
        END IF
        CALL JEVEUO(VE,'E',JLVE)
      END IF

      LIGRMO = MODELE(1:8)//'.MODELE'

      CALL MEGEOM(MODELE(1:8),ACCEL,EXIGEO,CHGEOM)

      PHIB24 = PHIBAR


      LPAIN(1) = 'PGEOMER'
      LCHIN(1) = CHGEOM
      CHTIME = '&&VECHME.CH_INST_R'
      CALL MECACT('V',CHTIME,'MODELE',LIGRMO,'INST_R  ',1,'INST   ',
     &            IBID,INSTAP,CBID,KBID)
      CALL MECACT('V','&PHI2M.VEC','MODELE',LIGRMO,'TEMP_R  ',1,
     &            'TEMP   ',IBID,0.D0,CBID,KBID)
      LPAIN(2) = 'PTEMPSR'
      LCHIN(2) = CHTIME
      LPAIN(3) = 'PACCELR'
      LCHIN(3) = ACCEL
      LPAIN(4) = 'PMATERC'
      LCHIN(4) = MATE
      LPAOUT(1) = 'PVECTTR'
      OPTION = 'CHAR_THER_PHID_R'
      LPAIN(5) = 'PTEMPER'
      LCHIN(5) = PHIB24


      IF (PREM) THEN

C ----- CREATION DU VECT_ELEM

        LCHOUT(1) = VECEL//'.VE'
        CALL CODENT(1,'D0',LCHOUT(1) (7:8))
        CALL CALCUL('S',OPTION,LIGRMO,5,LCHIN,LPAIN,1,LCHOUT,LPAOUT,'V')
        ZK24(JLVE) = LCHOUT(1)
        CALL JEECRA(VE,'LONUTI',1,K8BID)
      ELSE

C ----- LE VECT_ELEM EXISTE DEJA

        LCHOUT(1) = ZK24(JLVE)
        CALL CALCUL('S',OPTION,LIGRMO,5,LCHIN,LPAIN,1,LCHOUT,LPAOUT,'V')
      END IF
   10 CONTINUE

C FIN ---------------------------------------------------------------
      CALL JEDEMA()
      END
