      SUBROUTINE TE0113(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 16/10/2004   AUTEUR D6BHHJP J.P.LEFEBVRE 
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
C                          EN 2D (CPLAN ET DPLAN) ET AXI
C                          POUR ELEMENTS NON LOCAUX  A GRAD. DE DEF.
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................

      CHARACTER*8 TYPMOD(2),NOMAIL,ELREFE,ELREF2
      INTEGER NNO,NNOB,NPG,IMATUU,LGPG,LGPG1,LGPG2
      INTEGER IPOIDS,IVF,IDFDE,IGEOM,IMATE
      INTEGER IVFB,IDFDEB,NNOS,JGANO
      INTEGER ITREF,ICONTM,IVARIM,ITEMPM,ITEMPP,IPHASM,IPHASP
      INTEGER IINSTM,IINSTP,IDPLGM,IDDPLG,ICOMPO,ICARCR
      INTEGER IVECTU,ICONTP,IVARIP,IDEFAM,IDEFAP
      INTEGER IHYDRM,IHYDRP,ISECHM,ISECHP,ISREF,IVARIX
      INTEGER JTAB(7),IADZI,IAZK24,NZ,JCRET,CODRET
      INTEGER NDIM,IRET,ICAMAS
      LOGICAL DEFANE
      REAL*8  TRAV1(81), TRAV2(486), TRAV3(81),ANGMAS(3),R8VIDE,R8DGRD

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
C
      CALL ELREF1(ELREFE)
      IF ( ELREFE.EQ.'TR6') THEN
        ELREF2 = 'TR3'
      ELSEIF ( ELREFE .EQ. 'QU8'  ) THEN
        ELREF2 = 'QU4'
      ELSE
        CALL UTMESS('F','TE0113','ELEMENT:'//NOMTE(5:8)//
     +                'NON IMPLANTE')
      ENDIF
      CALL ELREF4(ELREFE,'RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,
     +                                            IDFDE,JGANO)

      CALL ELREF4(ELREF2,'RIGI',NDIM,NNOB,NNOS,NPG,IPOIDS,IVFB,
     +                                             IDFDEB,JGANO)
   
C - TYPE DE MODELISATION

      IF (NOMTE(3:4).EQ.'AX') THEN
        TYPMOD(1) = 'AXIS    '
      ELSE IF (NOMTE(3:4).EQ.'CP') THEN
        TYPMOD(1) = 'C_PLAN  '
      ELSE IF (NOMTE(3:4).EQ.'DP') THEN
        TYPMOD(1) = 'D_PLAN  '
      ELSE
        CALL UTMESS('F','TE0113','NOM D''ELEMENT ILLICITE')
      END IF

      CODRET = 0
      TYPMOD(2) = 'GRADEPSI'


C - PARAMETRES EN ENTREE

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PCONTMR','L',ICONTM)
      CALL JEVECH('PVARIMR','L',IVARIM)
      CALL JEVECH('PDEPLMR','L',IDPLGM)
      CALL JEVECH('PDEPLPR','L',IDDPLG)
      CALL JEVECH('PCOMPOR','L',ICOMPO)
      CALL JEVECH('PCARCRI','L',ICARCR)



C - ON VERIFIE QUE PVARIMR ET PVARIPR ONT LE MEME NOMBRE DE V.I. :

      CALL TECACH('OON','PVARIMR',7,JTAB,IRET)
      LGPG1 = MAX(JTAB(6),1)*JTAB(7)

      IF ((OPTION.EQ.'RAPH_MECA').OR.(OPTION(1:9).EQ.'FULL_MECA')) THEN
        CALL TECACH('OON','PVARIPR',7,JTAB,IRET)
        LGPG2 = MAX(JTAB(6),1)*JTAB(7)

        IF (LGPG1.NE.LGPG2) THEN
          CALL TECAEL(IADZI,IAZK24)
          NOMAIL = ZK24(IAZK24-1+3) (1:8)
          CALL UTDEBM('A','TE0113','VARIABLES INTERNES '//
     &                'EN NOMBRE DIFFERENT AUX INSTANTS "+" ET "-".')
          CALL UTIMPK('S',' POUR LA MAILLE ',1,NOMAIL)
          CALL UTIMPI('S',' INSTANT "-": ',1,LGPG1)
          CALL UTIMPI('S',' INSTANT "+": ',1,LGPG2)
          CALL UTFINM
        END IF
      END IF

      LGPG = LGPG1
C --- ORIENTATION DU MASSIF     
      CALL TECACH('NNN','PCAMASS',1,ICAMAS,IRET)
      CALL R8INIR(3, R8VIDE(), ANGMAS ,1)
      IF (IRET.EQ.0) THEN
        IF (ZR(ICAMAS).GT.0.D0) THEN
         ANGMAS(1) = ZR(ICAMAS+1)*R8DGRD()
         ANGMAS(2) = ZR(ICAMAS+2)*R8DGRD()
         ANGMAS(3) = ZR(ICAMAS+3)*R8DGRD()
        ENDIF
      ENDIF

C - VARIABLES DE COMMANDE

      CALL JEVECH('PTEREF','L',ITREF)
      CALL JEVECH('PTEMPMR','L',ITEMPM)
      CALL JEVECH('PTEMPPR','L',ITEMPP)
      CALL JEVECH('PINSTMR','L',IINSTM)
      CALL JEVECH('PINSTPR','L',IINSTP)
      CALL TECACH('ONN','PDEFAMR',1,IDEFAM,IRET)
      CALL TECACH('ONN','PDEFAPR',1,IDEFAP,IRET)
      DEFANE = IDEFAM .NE. 0
      CALL TECACH('NNN','PPHASMR',1,IPHASM,IRET)
      CALL TECACH('NNN','PPHASPR',1,IPHASP,IRET)
      IF (IPHASP.NE.0) THEN
        CALL TECACH('OON','PPHASPR',7,JTAB,IRET)
        NZ = JTAB(6)
      END IF

      CALL JEVECH('PHYDRMR','L',IHYDRM)
      CALL JEVECH('PHYDRPR','L',IHYDRP)
      CALL JEVECH('PSECHMR','L',ISECHM)
      CALL JEVECH('PSECHPR','L',ISECHP)
      CALL JEVECH('PSECREF','L',ISREF)


C PARAMETRES EN SORTIE

      IF (OPTION(1:14).EQ.'RIGI_MECA_TANG' .OR.
     &    OPTION(1:14).EQ.'RIGI_MECA_ELAS' .OR.
     &    OPTION(1:9).EQ.'FULL_MECA') THEN
        CALL JEVECH('PMATUNS','E',IMATUU)
      END IF

      IF (OPTION(1:9).EQ.'RAPH_MECA' .OR.
     &    OPTION(1:9).EQ.'FULL_MECA') THEN
        CALL JEVECH('PVECTUR','E',IVECTU)
        CALL JEVECH('PCONTPR','E',ICONTP)
        CALL JEVECH('PVARIPR','E',IVARIP)

C      ESTIMATION VARIABLES INTERNES A L'ITERATION PRECEDENTE
        CALL JEVECH('PVARIMP','L',IVARIX)
        CALL R8COPY(NPG*LGPG,ZR(IVARIX),1,ZR(IVARIP),1)
      END IF



C - HYPO-ELASTICITE


        IF (ZK16(ICOMPO+2) (1:5).EQ.'PETIT') THEN

          CALL NMPL2G(NNO,NNOB,NPG,IPOIDS,IVF,IVFB,IDFDE,IDFDEB,
     &                ZR(IGEOM),TYPMOD,NDIM,OPTION,ZI(IMATE),
     &                ZK16(ICOMPO),LGPG,ZR(ICARCR),
     &                ZR(IINSTM),ZR(IINSTP),
     &                ZR(ITEMPM),ZR(ITEMPP),ZR(ITREF),
     &                ZR(IHYDRM),ZR(IHYDRP),
     &                ZR(ISECHM),ZR(ISECHP),ZR(ISREF),
     &                NZ,ZR(IPHASM),ZR(IPHASP),
     &                ZR(IDPLGM),ZR(IDDPLG),ZR(IDEFAM),ZR(IDEFAP),
     &                DEFANE,
     &                ANGMAS,
     &                ZR(ICONTM),ZR(IVARIM),TRAV1,TRAV2,TRAV3,
     &                ZR(ICONTP),ZR(IVARIP),
     &                ZR(IMATUU),ZR(IVECTU),CODRET)

      ELSE
          CALL UTMESS('F','TE0113','COMPORTEMENT:'//ZK16(ICOMPO+2)//
     &                'NON IMPLANTE')
        END IF

      IF (OPTION(1:9).EQ.'FULL_MECA' .OR.
     &    OPTION(1:9).EQ.'RAPH_MECA') THEN
        CALL JEVECH('PCODRET','E',JCRET)
        ZI(JCRET) = CODRET
      END IF
      END
