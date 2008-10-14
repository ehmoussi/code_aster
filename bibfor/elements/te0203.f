      SUBROUTINE TE0203(OPTION,NOMTE)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 14/10/2008   AUTEUR LEBOUVIER F.LEBOUVIER 
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
C                                                                       
C                                                                       
C ======================================================================

      IMPLICIT NONE
      CHARACTER*16  NOMTE, OPTION
      
C-----------------------------------------------------------------------
C
C     BUT: PILOTAGE POUR LES ELEMENTS DE JOINT
C
C     OPTION : PILO_PRED_ELAS
C
C-----------------------------------------------------------------------


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
C------------FIN  COMMUNS NORMALISES  JEVEUX  --------------------------

      INTEGER IGEOM , IMATER, IDEPLM, IVARIM  ,NPG, JTAB(7), IRET, LGPG
      INTEGER IDDEPL, IDEPL0, IDEPL1, ICTAU ,ICOPIL
      CHARACTER*8 TYPMOD(2)
      LOGICAL LTEATT
      
C    PARAMETRES DE L'ELEMENT FINI
      NPG=2

C - PARAMETRES EN ENTREE
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATER)
      CALL JEVECH('PDEPLMR','L',IDEPLM)
      CALL JEVECH('PVARIMR','L',IVARIM)
      CALL JEVECH('PDDEPLR','L',IDDEPL)
      CALL JEVECH('PDEPL0R','L',IDEPL0)
      CALL JEVECH('PDEPL1R','L',IDEPL1)
      CALL JEVECH('PCDTAU' ,'L',ICTAU)

      IF (LTEATT(' ','AXIS','OUI')) THEN
        TYPMOD(1) = 'AXIS'
      ELSE
        TYPMOD(1) = 'PLAN'
      END IF
      TYPMOD(2) = 'ELEMJOIN'
      
C RECUPERATION DU NOMBRE DE VARIABLES INTERNES PAR POINTS DE GAUSS : 
      CALL TECACH('OON','PVARIMR',7,JTAB,IRET)
      LGPG = MAX(JTAB(6),1)*JTAB(7)      
   
C PARAMETRE EN SORTIE

      CALL JEVECH('PCOPILO','E',ICOPIL)
                          
      CALL PIPEFI( NPG, LGPG, ZI(IMATER) , ZR(IGEOM)  , ZR(IVARIM) ,
     &             ZR(IDDEPL) , ZR(IDEPLM) , ZR(IDEPL0) , ZR(IDEPL1) ,
     &             ZR(ICTAU)  , ZR(ICOPIL) , TYPMOD )
      
      END
