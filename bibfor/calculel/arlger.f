      FUNCTION ARLGER(NOMARL,NOMDAT)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 09/01/2007   AUTEUR ABBAS M.ABBAS 
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
      IMPLICIT NONE
      REAL*8      ARLGER
      CHARACTER*6 NOMDAT
      CHARACTER*8 NOMARL      
C      
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN
C
C RECUPERATION INFORMATIONS GENERALES SUR ARLEQUIN - LECTURE REEL
C
C ----------------------------------------------------------------------
C
C
C IN  NOMARL : NOM DE LA SD PRINCIPALE ARLEQUIN
C IN  NOMDAT : QUESTION
C                
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C      
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      INTEGER      JARLIR   
C      
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
      CALL JEVEUO(NOMARL(1:8)//'.INFOR','L',JARLIR )
      IF (NOMDAT(1:6).EQ.'GAMMA0') THEN
        ARLGER = ZR(JARLIR   ) 
      ELSE IF (NOMDAT(1:6).EQ.'GAMMA1') THEN
        ARLGER = ZR(JARLIR+1 )  
      ELSE IF (NOMDAT(1:6).EQ.'PRECAR') THEN
        ARLGER = ZR(JARLIR+2 )  
      ELSE IF (NOMDAT(1:6).EQ.'PRECBO') THEN
        ARLGER = ZR(JARLIR+3 )    
      ELSE IF (NOMDAT(1:6).EQ.'PRECCP') THEN
        ARLGER = ZR(JARLIR+4 )  
      ELSE IF (NOMDAT(1:6).EQ.'PRECTR') THEN
        ARLGER = ZR(JARLIR+5 ) 
      ELSE IF (NOMDAT(1:6).EQ.'PRECIT') THEN
        ARLGER = ZR(JARLIR+6 ) 
      ELSE IF (NOMDAT(1:6).EQ.'PRECVM') THEN
        ARLGER = ZR(JARLIR+7 )     
      ELSE IF (NOMDAT(1:6).EQ.'PRECFR') THEN
        ARLGER = ZR(JARLIR+8 ) 
      ELSE IF (NOMDAT(1:6).EQ.'PRECVV') THEN
        ARLGER = ZR(JARLIR+9 ) 
      ELSE IF (NOMDAT(1:6).EQ.'PRECBB') THEN
        ARLGER = ZR(JARLIR+10)
      ELSE
        WRITE(6,*) 'ARLGER: ',NOMARL(1:8)//'.INFOR',NOMDAT
        CALL ASSERT(.FALSE.)
      ENDIF     
C
      CALL JEDEMA()
      END
