      SUBROUTINE CFIMPD(IFM   ,NIV   ,SUBAPP,IMESG , 
     &                  VALI  ,VALR  ,VALK  )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 01/04/2008   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT     NONE
      CHARACTER*6   SUBAPP
      INTEGER       IFM,NIV
      INTEGER       IMESG
      CHARACTER*(*) VALK(*)
      INTEGER       VALI(*)
      REAL*8        VALR(*)
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODES DISCRETES)
C
C CENTRALISATION DES ROUTINES D'AFFICHAGE EN MODE DEBUG
C AFFICHAGE DETAILLE AVEC FORMATAGE
C
C ----------------------------------------------------------------------
C
C
C IN  IFM    : UNITE D'IMPRESSION (EN GENERAL 6: FICHIER MESSAGE)
C IN  NIV    : NIVEAU D'AFFICHAGE PROVENANT MOT-CLEF INFO
C IN  SUBAPP : SOUS-ROUTINE D'APPEL
C IN  IMESG  : NUMERO DE MESSAGE DANS LA SOUS-ROUTINE
C IN  VALI   : LISTE D'ENTIERS POUR AFFICHAGE
C IN  VALR   : LISTE DE REELS POUR AFFICHAGE
C IN  VALK   : LISTE DE CHAINES DE CHARACTERE POUR AFFICHAGE
C
C ----------------------------------------------------------------------
C
      IF (NIV.LT.2) THEN
        GOTO 999
      ENDIF
C      
      IF (SUBAPP.EQ.'CFSUPM') THEN
        IF (IMESG.EQ.1) THEN
          CALL U2MESK('I','CONTACTDEBG_11',2,VALK)
        ELSEIF (IMESG.EQ.2) THEN
          CALL U2MESK('I','CONTACTDEBG_12',1,VALK)
        ELSEIF (IMESG.EQ.3) THEN
          CALL U2MESK('I','CONTACTDEBG_13',1,VALK)        
        ELSE
          CALL U2MESS('I','CONTACTDEBG_99')
        ENDIF
        
      ELSEIF (SUBAPP.EQ.'RECHCO') THEN
        IF (IMESG.EQ.1) THEN
          CALL U2MESI('I','CONTACTDEBG_7',2,VALI)
        ELSEIF (IMESG.EQ.2) THEN
          CALL U2MESI('I','CONTACTDEBG_8',1,VALI)
        ELSE
          CALL U2MESS('I','CONTACTDEBG_99')
        ENDIF  
          
      ELSEIF (SUBAPP.EQ.'RECHNO') THEN
        IF (IMESG.EQ.1) THEN
          CALL U2MESI('I','CONTACTDEBG_10',1,VALI)
        ELSE
          CALL U2MESS('I','CONTACTDEBG_99')
        ENDIF  
        
      ELSEIF (SUBAPP.EQ.'RECHME') THEN
        IF (IMESG.EQ.1) THEN
          CALL U2MESI('I','CONTACTDEBG_14',1,VALI)
        ELSE
          CALL U2MESS('I','CONTACTDEBG_99')
        ENDIF 

      ELSEIF (SUBAPP.EQ.'NMCOFR') THEN
        IF (IMESG.EQ.2) THEN
          CALL U2MESR('I','CONTACTDEBG_20',1,VALR)   
        ELSEIF (IMESG.EQ.3) THEN
          CALL U2MESR('I','CONTACTDEBG_21',1,VALR)           
        ELSE
          CALL U2MESS('I','CONTACTDEBG_99')
        ENDIF         
                                 
      ELSE
        CALL U2MESS('I','CONTACTDEBG_99')
      ENDIF
C
 999  CONTINUE
C
      END
