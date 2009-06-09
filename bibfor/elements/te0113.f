      SUBROUTINE TE0113(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 09/06/2009   AUTEUR SFAYOLLE S.FAYOLLE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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

      IMPLICIT NONE
      CHARACTER*16 OPTION,NOMTE
C ......................................................................
C    - FONCTION REALISEE:  CALCUL DES OPTIONS NON-LINEAIRES MECANIQUES
C                          EN 2D (CPLAN ET DPLAN) ET 3D
C                          POUR ELEMENTS NON LOCAUX  A GRAD. DE DEF.
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................

      INTEGER DLNS
      INTEGER NNO,NNOB,NNOS,NPG,IMATUU,LGPG,LGPG1,LGPG2
      INTEGER IPOIDS,IVF,IDFDE,IGEOM,IMATE
      INTEGER IVFB,IDFDEB,JGANO
      INTEGER ICONTM,IVARIM
      INTEGER IINSTM,IINSTP,IDPLGM,IDDPLG,ICOMPO,ICARCR
      INTEGER IVECTU,ICONTP,IVARIP
      INTEGER IVARIX
      INTEGER JTAB(7),IADZI,IAZK24,JCRET,CODRET
      INTEGER NDIM,IRET,NTROU,IDIM,I,VALI(2)

      REAL*8 TRAV1(3*8),ANGMAS(7),BARY(3),RBID

      CHARACTER*2 CODRT1
      CHARACTER*8 TYPMOD(2),LIELRF(10),NOMAIL
      CHARACTER*16 PHENOM

C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

C - FONCTIONS DE FORME
      CALL ELREF2(NOMTE,10,LIELRF,NTROU)
      CALL ASSERT(NTROU.GE.2)

      IF (OPTION(1:9).EQ.'MASS_MECA') THEN
        CALL ELREF4(LIELRF(1),'MASS',NDIM,NNO, NNOS,NPG,IPOIDS,IVF,
     &              IDFDE,JGANO)
      ELSE
        CALL ELREF4(LIELRF(1),'RIGI',NDIM,NNO, NNOS,NPG,IPOIDS,IVF,
     &              IDFDE,JGANO)
        CALL ELREF4(LIELRF(2),'RIGI',NDIM,NNOB,NNOS,NPG,IPOIDS,IVFB,
     &              IDFDEB,JGANO)
      ENDIF

C - TYPE DE MODELISATION
      IF (NDIM.EQ.2 .AND. NOMTE(3:4).EQ.'CP') THEN
        TYPMOD(1) = 'C_PLAN  '
      ELSE IF (NDIM.EQ.2 .AND. NOMTE(3:4).EQ.'DP') THEN
        TYPMOD(1) = 'D_PLAN  '
      ELSE IF (NDIM .EQ. 3) THEN
        TYPMOD(1) = '3D'
      ELSE
C       NOM D'ELEMENT ILLICITE
        CALL ASSERT(NDIM .EQ. 3)
      END IF

      TYPMOD(2) = 'GRADEPSI'
      CODRET = 0

C - PARAMETRES EN ENTREE

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)

      IF (OPTION(1:9).EQ.'MASS_MECA') THEN
C---------------- CALCUL MATRICE DE MASSE ------------------------

        CALL JEVECH('PMATUUR','E',IMATUU)

        IF (NDIM.EQ.2) THEN
C - 2 DEPLACEMENTS + 4 DEF
          DLNS = 6
        ELSEIF (NDIM.EQ.3) THEN
C - 3 DEPLACEMENTS + 6 DEF
          DLNS = 9
        ELSE
          CALL ASSERT(NDIM .EQ. 3)
        ENDIF

        CALL MASSGD(OPTION,NDIM,DLNS,NNO,NNOS,ZI(IMATE),PHENOM,
     &              NPG,IPOIDS,IDFDE,ZR(IGEOM),
     &              ZR(IVF),IMATUU,CODRT1)

C--------------- FIN CALCUL MATRICE DE MASSE -----------------------
      ELSE
C---------------- CALCUL OPTION DE RIGIDITE ------------------------
        CALL JEVECH('PCONTMR','L',ICONTM)
        CALL JEVECH('PVARIMR','L',IVARIM)
        CALL JEVECH('PDEPLMR','L',IDPLGM)
        CALL JEVECH('PDEPLPR','L',IDDPLG)
        CALL JEVECH('PCOMPOR','L',ICOMPO)
        CALL JEVECH('PCARCRI','L',ICARCR)


C - ON VERIFIE QUE PVARIMR ET PVARIPR ONT LE MEME NOMBRE DE V.I. :

        CALL TECACH('OON','PVARIMR',7,JTAB,IRET)
        LGPG1 = MAX(JTAB(6),1)*JTAB(7)

        IF((OPTION.EQ.'RAPH_MECA').OR.(OPTION(1:9).EQ.'FULL_MECA'))THEN
          CALL TECACH('OON','PVARIPR',7,JTAB,IRET)
          LGPG2 = MAX(JTAB(6),1)*JTAB(7)

          IF (LGPG1.NE.LGPG2) THEN
            CALL TECAEL(IADZI,IAZK24)
            NOMAIL = ZK24(IAZK24-1+3) (1:8)
            VALI(1)=LGPG1
            VALI(2)=LGPG2
            CALL U2MESG('A','CALCULEL6_64',1,NOMAIL,2,VALI,0,RBID)
          END IF
        END IF
        LGPG = LGPG1

C --- ORIENTATION DU MASSIF
C     COORDONNEES DU BARYCENTRE ( POUR LE REPRE CYLINDRIQUE )

        BARY(1) = 0.D0
        BARY(2) = 0.D0
        BARY(3) = 0.D0
        DO 150 I = 1,NNO
          DO 140 IDIM = 1,NDIM
            BARY(IDIM) = BARY(IDIM)+ZR(IGEOM+IDIM+NDIM*(I-1)-1)/NNO
 140      CONTINUE
 150    CONTINUE
        CALL RCANGM ( NDIM, BARY, ANGMAS )

C - VARIABLES DE COMMANDE

        CALL JEVECH('PINSTMR','L',IINSTM)
        CALL JEVECH('PINSTPR','L',IINSTP)

C PARAMETRES EN SORTIE

        IF (OPTION(1:14).EQ.'RIGI_MECA_TANG' .OR.
     &      OPTION(1:14).EQ.'RIGI_MECA_ELAS' .OR.
     &      OPTION(1:9).EQ.'FULL_MECA') THEN
          CALL JEVECH('PMATUNS','E',IMATUU)
        END IF

        IF (OPTION(1:9).EQ.'RAPH_MECA' .OR.
     &      OPTION(1:9).EQ.'FULL_MECA') THEN
          CALL JEVECH('PVECTUR','E',IVECTU)
          CALL JEVECH('PCONTPR','E',ICONTP)
          CALL JEVECH('PVARIPR','E',IVARIP)

C      ESTIMATION VARIABLES INTERNES A L'ITERATION PRECEDENTE
          CALL JEVECH('PVARIMP','L',IVARIX)
          CALL DCOPY(NPG*LGPG,ZR(IVARIX),1,ZR(IVARIP),1)
        END IF

C - HYPO-ELASTICITE

        IF (ZK16(ICOMPO+2).NE.'PETIT') CALL U2MESK('F','ELEMENTS3_16',1
     &  ,ZK16(ICOMPO+2))

        CALL NMPLGE(NDIM,NNO,ZR(IVF),IDFDE,NNOB,ZR(IVFB),IDFDEB,NPG,
     &  IPOIDS,ZR(IGEOM),TYPMOD,OPTION,ZI(IMATE),ZK16(ICOMPO),
     &  ZR(ICARCR),ZR(IINSTM),ZR(IINSTP),
     &  ANGMAS,ZR(IDPLGM),ZR(IDDPLG),ZR(ICONTM),LGPG,
     &  ZR(IVARIM),ZR(ICONTP),ZR(IVARIP),ZR(IMATUU),ZR(IVECTU),
     &  CODRET,TRAV1)

        IF (OPTION(1:9).EQ.'FULL_MECA' .OR.
     &    OPTION(1:9).EQ.'RAPH_MECA') THEN
          CALL JEVECH('PCODRET','E',JCRET)
          ZI(JCRET) = CODRET
        END IF
C---------------- FIN CALCUL OPTION DE RIGIDITE ------------------------
      END IF
      END
