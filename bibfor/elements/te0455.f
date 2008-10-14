      SUBROUTINE TE0455(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 14/10/2008   AUTEUR LEBOUVIER F.LEBOUVIER 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
      CHARACTER*16 OPTION,NOMTE
C ----------------------------------------------------------------------
C FONCTION REALISEE:  CALCUL DE L'OPTION FORC_NODA POUR LES ELEMENTS
C                     INCOMPRESSIBLES GRANDES DEFORMATIONS 
C                     EN 3D/D_PLAN/AXI

C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................

C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------


      CHARACTER*8 LIELRF(10),TYPMOD(2)
      INTEGER NDIM,NNO1,NNO2,NNO3,NNOS,NPG,JGN,NTROU,IMATE
      INTEGER IW,IVF1,IVF2,IVF3,IDF1,IDF2,IDF3
      INTEGER VU(3,27),VG(27),VP(27)
      INTEGER IGEOM,ICONTM,IDDLM,ICOMPO,IVECTU
      REAL*8 DFF1(4*27),DFF2(3*27)
      LOGICAL LTEATT
C ----------------------------------------------------------------------

C - FONCTIONS DE FORME
      CALL ELREF2(NOMTE,10,LIELRF,NTROU)
      CALL ASSERT(NTROU.GE.3)
      CALL ELREF4(LIELRF(3),'RIGI',NDIM,NNO3,NNOS,NPG,IW,IVF3,IDF3,JGN)
      CALL ELREF4(LIELRF(2),'RIGI',NDIM,NNO2,NNOS,NPG,IW,IVF2,IDF2,JGN)
      CALL ELREF4(LIELRF(1),'RIGI',NDIM,NNO1,NNOS,NPG,IW,IVF1,IDF1,JGN)

C - TYPE DE MODELISATION
      IF (NDIM.EQ.2 .AND. LTEATT(' ','AXIS','OUI')) THEN
        TYPMOD(1) = 'AXIS  '
      ELSE IF (NDIM.EQ.2 .AND. NOMTE(3:4).EQ.'PL') THEN
        TYPMOD(1) = 'D_PLAN  '
      ELSE IF (NDIM .EQ. 3) THEN
        TYPMOD(1) = '3D'
      ELSE
        CALL U2MESK('F','ELEMENTS_34',1,NOMTE)
      END IF
      TYPMOD(2) = 'INCO'

C - ACCES AUX COMPOSANTES DU VECTEUR DDL
      CALL NIINIT(NOMTE,TYPMOD,NDIM,NNO1,NNO2,NNO3,VU,VG,VP)
      
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PCONTMR','L',ICONTM)
      CALL JEVECH('PDEPLMR','L',IDDLM)
      CALL JEVECH('PCOMPOR','L',ICOMPO)
      CALL JEVECH('PVECTUR','E',IVECTU)


      IF (ZK16(ICOMPO+2) (1:10).NE.'SIMO_MIEHE') 
     &  CALL U2MESK('F','ELEMENTS3_16', 1, ZK16(ICOMPO+2))
      
      CALL NIFORC(NDIM,NNO1,NNO2,NNO3,NPG,IW,ZR(IVF1),ZR(IVF2),
     &              ZR(IVF3),IDF1,IDF2,DFF1,DFF2,VU,VG,VP,ZK16(ICOMPO),
     &              TYPMOD,ZI(IMATE),ZR(IGEOM),ZR(ICONTM),
     &              ZR(IDDLM),ZR(IVECTU))


      END
