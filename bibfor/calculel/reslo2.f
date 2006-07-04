      SUBROUTINE RESLO2(MODELE,LIGREL,LCHAR,CHVOIS,IATYMA,IAGD,IACMP,
     &                  ICONX1,ICONX2)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 03/07/2006   AUTEUR MEUNIER S.MEUNIER 
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
C
C     BUT:
C         PREPARER LE CALCUL DE L'ESTIMATEUR D'ERREUR EN RESIDU.
C         RECHERCHER LES VOISINS DE CHAQUE ELEMENT ET RECUPERER
C         DES ADRESSES.


C     ARGUMENTS:
C     ----------
C
C      ENTREE :
C-------------
C IN   MODELE : NOM DU MODELE
C IN   LIGREL : NOM DU LIGREL
C IN   LCHAR  : LISTE DES CHARGEMENTS
C
C      SORTIE :
C-------------
C OUT  CHVOIS : NOM DU CHAMP DES VOISINS
C OUT  IATYMA : ADRESSE DU VECTEUR TYPE MAILLE (NUMERO <-> NOM)
C OUT  IAGD   : ADRESSE DU VECTEUR GRANDEUR (NUMERO <-> NOM)
C OUT  IACMP  : ADRESSE DU VECTEUR NOMBRE DE COMPOSANTES 
C                     (NUMERO DE GRANDEUR <-> NOMBRE DE COMPOSANTES)
C OUT  ICONX1 : ADRESSE DE LA COLLECTION CONNECTIVITE
C OUT  ICONX2 : ADRESSE DU POINTEUR DE LONGUEUR DE LA CONNECTIVITE
C
C ......................................................................
      IMPLICIT NONE
C DECLARATION PARAMETRES D'APPELS
      INTEGER       IATYMA,IAGD,IACMP,ICONX1,ICONX2
      CHARACTER*8   MODELE,LCHAR(*)
      CHARACTER*24  CHVOIS
      CHARACTER*(*) LIGREL

C --------- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------
      CHARACTER*32 JEXNUM,JEXATR
      INTEGER        ZI
      COMMON /IVARJE/ZI(1)
      REAL*8         ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16     ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL        ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8    ZK8
      CHARACTER*16          ZK16
      CHARACTER*24                  ZK24
      CHARACTER*32                          ZK32
      CHARACTER*80                                  ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C --------- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------
C
C DECLARATION VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'RESLO2' )

      INTEGER      IRET,IBID,IER,NBTM,ITY,NBGD,IGD,NCMP

      CHARACTER*1  BASE
      CHARACTER*8  LPAIN(1),LPAOUT(1),MA,TYPEMA,GD
      CHARACTER*16 OPT
      CHARACTER*24 LCHIN(1),LCHOUT(1),CHGEOM,KBID

      LOGICAL EXIGEO

C ----------------------------------------------------------------------

      BASE = 'V'
      CALL MEGEOM(MODELE,LCHAR(1),EXIGEO,CHGEOM)
      IF (.NOT.EXIGEO) CALL UTMESS('F',NOMPRO,'PAS DE CHGEOM')

C ------- RECHERCHE DES VOISINS ----------------------------------------

      LPAIN(1) = 'PGEOMER'
      LCHIN(1) = CHGEOM

      LPAOUT(1) = 'PVOISIN'
      CHVOIS = '&&RESLO2.CH_VOISIN'
      LCHOUT(1) = CHVOIS
      OPT = 'INIT_MAIL_VOIS'
      CALL CALCUL('C',OPT,LIGREL,1,LCHIN,LPAIN,1,LCHOUT,LPAOUT,BASE)
      CALL EXISD('CHAMP_GD',LCHOUT(1),IRET)
      IF (IRET.EQ.0) THEN
          CALL UTMESS('A','CALC_ELEM','OPTION '//OPT//' NON '//
     &         'DISPONIBLE SUR LES ELEMENTS DU MODELE'//
     &         '- PAS DE CHAMP CREE ')
           GOTO 9999
      END IF

      CALL DISMOI('F','NOM_MAILLA',MODELE,'MODELE',IBID,MA,IER)
      CALL RESVOI(MODELE,MA,CHVOIS)

C ----- CALCUL DE 5 ADRESSES : -----------------------------------------
C      IATYMA : ADRESSE DU VECTEUR TYPE MAILLE (NUMERO <-> NOM)
C      IAGD   : ADRESSE DU VECTEUR GRANDEUR (NUMERO <-> NOM)
C      IANCMP : ADRESSE DU VECTEUR NOMBRE DE COMPOSANTES 
C                     (NUMERO DE GRANDEUR <-> NOMBRE DE COMPOSANTES)
C      ICONX1 : ADRESSE DE LA COLLECTION CONNECTIVITE
C      ICONX2 : ADRESSE DU POINTEUR DE LONGUEUR DE LA CONNECTIVITE
C
      CALL JELIRA('&CATA.TM.NOMTM','NOMMAX',NBTM,KBID)
      CALL WKVECT('&&RESLO2.TYPEMA','V V K8',NBTM,IATYMA)
      DO 1 ITY=1,NBTM
        CALL JENUNO (JEXNUM('&CATA.TM.NOMTM',ITY),TYPEMA)
        ZK8(IATYMA-1+ITY) = TYPEMA
1     CONTINUE
C
      CALL JELIRA('&CATA.GD.NOMGD','NOMMAX',NBGD,KBID)
      CALL WKVECT('&&RESLO2.GD','V V K8',NBGD,IAGD)
      DO 2 IGD=1,NBGD
        CALL JENUNO (JEXNUM('&CATA.GD.NOMGD',IGD),GD)
        ZK8(IAGD-1+IGD) = GD
2     CONTINUE
C        
      CALL WKVECT('&&RESLO2.NBCMP','V V I',NBGD,IACMP)
      DO 3 IGD=1,NBGD
        CALL JELIRA (JEXNUM('&CATA.GD.NOMCMP',IGD),'LONMAX',NCMP,KBID)
        ZI(IACMP-1+IGD) = NCMP
3     CONTINUE
C        
      CALL JEVEUO(MA//'.CONNEX','L',ICONX1)
      CALL JEVEUO(JEXATR(MA//'.CONNEX','LONCUM'),'L',ICONX2)
C
9999  CONTINUE      
      END
