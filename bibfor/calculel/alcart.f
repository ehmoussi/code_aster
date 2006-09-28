      SUBROUTINE ALCART(BASE,CHINZ,MAZ,NOMGDZ)
      IMPLICIT REAL*8 (A-H,O-Z)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
      CHARACTER*19 CHIN
      CHARACTER*(*) CHINZ, MAZ, NOMGDZ
      CHARACTER*8 MA,NOMGD
      CHARACTER*(*) BASE
C ----------------------------------------------------------------------
C     ENTREES:
C       BASE : BASE DE CREATION POUR LA CARTE : G/V/L
C      CHINZ : NOM DE LA CARTE A CREER
C        MAZ : NOM DU MAILLAGE ASSOCIE
C     NOMGDZ : NOM DE LA GRANDEUR
C     NGDMX  : NOMBRE MAXIMUM DE COUPLES ( ENTITE,VALE) A STOCKER
C     NMAMX  : DIMEMSION MAXIMUM DE L'OBJET LIMA
C                  (I.E. SOMME DES NOMBRES DE MAILLES DES GROUPES
C                    TARDIFS DE MAILLES)
C
C     SORTIES:
C     ON ALLOUE CHIN.DESC , CHIN.VALE , CHIN.NOMA ,CHIN.NOLI
C     ET CHIN.LIMA
C
C      SUR LA VOLATILE CHIN.NOMCMP ET CHIN.VALV
C
C ----------------------------------------------------------------------
C
C     FONCTIONS EXTERNES:
C     -------------------
      INTEGER NBEC
      CHARACTER*8 SCALAI
      CHARACTER*32 JEXNUM,JEXNOM
C
C     VARIABLES LOCALES:
C     ------------------
      INTEGER NEC,JDESC,GD,NCMPMX,NGDMX,NMAMX
      CHARACTER*8 SCAL
      CHARACTER*1 BAS2
      INTEGER NOMA
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      CHARACTER*1 K1BID
C-----------------------------------------------------------------------
      CALL JEMARQ()
C     NGDMX ET NMAMX : SERVENT A DIMENSIONNER LES OBJETS
C      CES OBJETS SERONT AGRANDIS SI NECESSAIRE PAR NOCART
C     LE PARAMETRE NGDMX EST DELIBEREMENT MIS A 1 CAR IL Y A UN PROBLEME
C     AVEC LES CARTES CONSTANTES DANS CALCUL SI CELLE-CI ONT UNE
C     DIMENSION SUPERIEURE A 1
      NGDMX=1
      NMAMX=1

      CHIN  = CHINZ
      MA    = MAZ
      NOMGD = NOMGDZ
C
      BAS2 = BASE
C
C     STOCKAGE DE MA:
C
      CALL WKVECT(CHIN//'.NOMA',BAS2//' V K8',1,NOMA)
      ZK8(NOMA-1+1) = MA
C
C
      CALL JENONU(JEXNOM('&CATA.GD.NOMGD',NOMGD),GD)
      IF (GD.EQ.0) CALL U2MESK('F','CALCULEL_3',1,NOMGD)
      NEC = NBEC(GD)
      CALL JELIRA(JEXNUM('&CATA.GD.NOMCMP',GD),'LONMAX',NCMPMX,K1BID)
      SCAL = SCALAI(GD)
C
C     ALLOCATION DE DESC:
C
      CALL WKVECT(CHIN//'.DESC',BAS2//' V I',3+NGDMX*(2+NEC),JDESC)
      CALL JEECRA(CHIN//'.DESC','DOCU',IBID,'CART')
      ZI(JDESC-1+1) = GD
      ZI(JDESC-1+2) = NGDMX
      ZI(JDESC-1+3) = 0
C
C     ALLOCATION DE VALE:
C
      CALL WKVECT(CHIN//'.VALE',BAS2//' V '//SCAL(1:4),NGDMX*NCMPMX,J1)

C     ALLOCATION DE NOLI
C
      CALL WKVECT(CHIN//'.NOLI',BAS2//' V K24',NGDMX,J1)


C     ALLOCATION DE LIMA :
C     --------------------
      CALL JECREC(CHIN//'.LIMA',BAS2//' V I','NU','CONTIG',
     &               'VARIABLE',NGDMX)
C -- ON SURDIMENSIONNE A CAUSE DE JEVEUX : PAS D'OBJET DE LONGUEUR 0
      CALL JEECRA(CHIN//'.LIMA','LONT',NMAMX+NGDMX,' ')

C     ALLOCATION DES OBJETS DE TRAVAIL NECESSAIRES A NOCART:
      CALL WKVECT(CHIN//'.NCMP','V V K8',NCMPMX,J1)
      CALL WKVECT(CHIN//'.VALV','V V '//SCAL(1:4),NCMPMX,J1)
      CALL JEDEMA()
      END
