      SUBROUTINE TE0414 ( OPTIOZ , NOMTZ )
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*(*)   OPTIOZ , NOMTZ
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 15/01/2013   AUTEUR DELMAS J.DELMAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     ----------------------------------------------------------------
C     CALCUL DES OPTIONS DES ELEMENTS DE COQUE : COQUE_3D
C     ----------------------------------------------------------------
C
      INTEGER       NB1, JCRET, CODRET
      REAL*8        MATLOC(51,51), PLG(9,3,3)
      LOGICAL       MATRIC
      CHARACTER*16  OPTION , NOMTE
C ----------------------------------------------------------------------

C-----------------------------------------------------------------------
      INTEGER I ,I1 ,I2 ,IBID ,ICOMPO ,IDEPLM ,IDEPLP 
      INTEGER JGEOM ,JMATR ,LZI ,LZR ,NB2 ,NDDLET 
C-----------------------------------------------------------------------
      OPTION = OPTIOZ
      NOMTE  = NOMTZ

      CALL JEVEUO ('&INEL.'//NOMTE(1:8)//'.DESI', 'L' , LZI )
      NB2 = ZI(LZI-1+2)

      IF (OPTION.EQ.'RAPH_MECA'.OR.OPTION(1:9).EQ.'FULL_MECA'.OR.
     &    OPTION(1:9).EQ.'RIGI_MECA')THEN
C        -- PASSAGE DES CONTRAINTES DANS LE REPERE INTRINSEQUE :
         CALL COSIRO (NOMTE,'PCONTMR','L','UI','G',IBID,'S')
      ENDIF


      MATRIC = ( OPTION(1:9) .EQ.'FULL_MECA'  .OR.
     &           OPTION(1:10).EQ.'RIGI_MECA_' )

      CALL JEVECH ('PGEOMER', 'L', JGEOM )
      CALL JEVECH ('PDEPLMR', 'L', IDEPLM)
      CALL JEVECH ('PDEPLPR', 'L', IDEPLP)
      CALL JEVECH ('PCOMPOR', 'L', ICOMPO)

      IF ( ZK16(ICOMPO+3)(1:9) .EQ. 'COMP_ELAS' ) THEN
C          ------------------------------------
C       SEULE RELATION ADMISE : ELAS
        IF ( ZK16(ICOMPO)(1:5) .NE. 'ELAS ' ) THEN
           CALL U2MESK('F','ELEMENTS5_46',1,ZK16(ICOMPO))
        ENDIF

C
C ------ HYPER-ELASTICITE
C
         IF ( ZK16 ( ICOMPO + 2 ) . EQ . 'GROT_GDEP' ) THEN
C
C --------- DEFORMATION DE GREEN
C
            CALL VDGNLR ( OPTION , NOMTE )
C
            GO TO 9999
C
         ELSE
C
C --------- AUTRES MESURES DE DEFORMATIONS
C
           CALL U2MESK('F','ELEMENTS3_93',1,ZK16(ICOMPO+2))
C
         ENDIF
C
      ELSEIF ( ZK16(ICOMPO+3)(1:9) .EQ. 'COMP_INCR' ) THEN
C              ------------------------------------

         IF ( ZK16(ICOMPO+2).EQ. 'GROT_GDEP') THEN
C
C --------- HYPO-ELASTICITE
C
            CALL VDPNLR ( OPTION , NOMTE, CODRET )
C
            GO TO 9999
C
         ELSE IF( ZK16(ICOMPO+2)(6:10) .EQ. '_REAC') THEN
C
            CALL U2MESS('A','ELEMENTS3_94')
C
            DO 90 I=1,NB2-1
               I1=3*(I-1)
               I2=6*(I-1)
               ZR(JGEOM+I1)   = ZR(JGEOM+I1)  +ZR(IDEPLM+I2)
     &                                        +ZR(IDEPLP+I2)
               ZR(JGEOM+I1+1) = ZR(JGEOM+I1+1)+ZR(IDEPLM+I2+1)
     &                                        +ZR(IDEPLP+I2+1)
               ZR(JGEOM+I1+2) = ZR(JGEOM+I1+2)+ZR(IDEPLM+I2+2)
     &                                        +ZR(IDEPLP+I2+2)
 90         CONTINUE
         ENDIF
C
         CALL VDXNLR (OPTION,NOMTE,ZR(JGEOM),MATLOC,NB1,CODRET)

         IF ( MATRIC ) THEN
C
            CALL JEVECH ('PMATUUR' , 'E' , JMATR)
C
C --------- MATRICE DE PASSAGE REPERE GLOBAL REPERE LOCAL
C
            CALL JEVETE('&INEL.'//NOMTE(1:8)//'.DESR',' ', LZR )
            CALL MATPGL ( NB2, ZR(LZR), PLG )
C
C --------- OPERATION DE TRANFORMATION DE MATLOC DANS LE REPERE GLOBAL
C           ET STOCKAGE DANS ZR
C
            NDDLET = 6*NB1+3
            CALL TRANLG ( NB1 , 51 , NDDLET , PLG , MATLOC , ZR(JMATR) )
         ENDIF

      ENDIF
C
      IF ( OPTION(1:9) .EQ. 'RAPH_MECA'  .OR.
     &     OPTION(1:9) .EQ. 'FULL_MECA'  ) THEN
         CALL JEVECH ( 'PCODRET', 'E', JCRET )
         ZI(JCRET) = CODRET
      ENDIF
C
 9999 CONTINUE

      IF (OPTION.EQ.'RAPH_MECA'.OR.OPTION(1:9).EQ.'FULL_MECA') THEN
C        -- PASSAGE DES CONTRAINTES DANS LE REPERE UTILISATEUR :
         CALL COSIRO (NOMTE,'PCONTPR','E','IU','G',IBID,'R')
      ENDIF
C
      END
