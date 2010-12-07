      SUBROUTINE TE0530 ( OPTION , NOMTE )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 11/10/2010   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT NONE
C
      CHARACTER*16 OPTION, NOMTE
C
C ......................................................................
C  CALCUL DES VARIABLES DE COMMANDE UTILISEES DANS LES CALCULS
C  MECANIQUES
C ......................................................................
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX --------------------

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
      REAL*8 R1,R8VIDE,RVID,R8NNAN
      INTEGER NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO,IPG,IRET
      INTEGER JPVARC
C
C ---------------------------------------------------------------------

      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)
      CALL JEVECH('PVARC_R','E',JPVARC)
      RVID=R8VIDE()


C     VARC_R   = R    TEMP HYDR SECH IRRA CORR NEUT1 NEUT2

      DO 1, IPG = 1, NPG
C        -- TEMP :
         CALL RCVARC(' ','TEMP','+','RIGI',IPG,1,R1,IRET)
         IF (IRET.EQ.0) THEN
           ZR(JPVARC-1+7*(IPG-1)+1)=R1
         ELSE
           ZR(JPVARC-1+7*(IPG-1)+1)=RVID
         ENDIF

C        -- HYDR :
         CALL RCVARC(' ','HYDR','+','RIGI',IPG,1,R1,IRET)
         IF (IRET.EQ.0) THEN
           ZR(JPVARC-1+7*(IPG-1)+2)=R1
         ELSE
           ZR(JPVARC-1+7*(IPG-1)+2)=RVID
         ENDIF

C        -- SECH :
         CALL RCVARC(' ','SECH','+','RIGI',IPG,1,R1,IRET)
         IF (IRET.EQ.0) THEN
           ZR(JPVARC-1+7*(IPG-1)+3)=R1
         ELSE
           ZR(JPVARC-1+7*(IPG-1)+3)=RVID
         ENDIF

C        -- IRRA :
         CALL RCVARC(' ','SECH','+','RIGI',IPG,1,R1,IRET)
         IF (IRET.EQ.0) THEN
           ZR(JPVARC-1+7*(IPG-1)+4)=R1
         ELSE
           ZR(JPVARC-1+7*(IPG-1)+4)=RVID
         ENDIF

C        -- CORR :
         CALL RCVARC(' ','SECH','+','RIGI',IPG,1,R1,IRET)
         IF (IRET.EQ.0) THEN
           ZR(JPVARC-1+7*(IPG-1)+5)=R1
         ELSE
           ZR(JPVARC-1+7*(IPG-1)+5)=RVID
         ENDIF

C        -- NEUT1 :
         CALL RCVARC(' ','SECH','+','RIGI',IPG,1,R1,IRET)
         IF (IRET.EQ.0) THEN
           ZR(JPVARC-1+7*(IPG-1)+6)=R1
         ELSE
           ZR(JPVARC-1+7*(IPG-1)+6)=RVID
         ENDIF

C        -- NEUT2 :
         CALL RCVARC(' ','SECH','+','RIGI',IPG,1,R1,IRET)
         IF (IRET.EQ.0) THEN
           ZR(JPVARC-1+7*(IPG-1)+7)=R1
         ELSE
           ZR(JPVARC-1+7*(IPG-1)+7)=RVID
         ENDIF


1     CONTINUE

      END
