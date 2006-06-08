      SUBROUTINE CHPVER(KSTOP,NOCHAM,LOCHAM,GDCHAM,IER)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 21/02/2006   AUTEUR REZETTE C.REZETTE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
C ======================================================================
C     VERIFICATIONS DE LA GRANDEUR ET DE LA LOCALISATION DES CHAMPS.
C
C  IN  KSTOP  : TYPE DE MESSAGE  (A/F)
C  IN  NOCHAM : NOM DU CHAMP 
C  IN  LOCHAM : LOCALISATION DU CHAMP (*/CART/NOEU/ELGA/ELNO/ELEM/ELXX)
C               SI LOCHAM='*' : ON LEVE CETTE VERIFICATION
C  IN  GDCHAM : GRANDEUR DU CHAMP (*/DEPL_R/TEMP_R/...)
C               SI GDCHAM='*' : ON LEVE CETTE VERIFICATION
C  OUT   IERD  : CODE RETOUR  (0--> OK, 1--> PB )
C ======================================================================
      IMPLICIT NONE
C
      INTEGER IER
      CHARACTER*1 KSTOP
      CHARACTER*(*) NOCHAM,LOCHAM,GDCHAM
C
      INTEGER IBID
      CHARACTER*19 NOCH
      CHARACTER*4  LOCH,TYCH
      CHARACTER*8  GDCH,NOMGD

      CALL JEMARQ()

      NOCH=NOCHAM
      
C     VERIFICATION DU TYPE
      IF(LOCHAM(1:1).NE.'*')THEN
         LOCH=LOCHAM
         CALL DISMOI(KSTOP,'TYPE_CHAMP',NOCH,'CHAMP',IBID,TYCH,IER)
         IF( (LOCH(3:4).NE.'XX'  .AND.   LOCH.NE.TYCH ) .OR. 
     &       (LOCH(3:4).EQ.'XX'  .AND.   LOCH(1:2).NE.TYCH(1:2)))THEN
            IER=1
            CALL UTDEBM(KSTOP,'CHPVER','LE CHAMP')
            CALL UTIMPK('S',' ',1,NOCH(1:8))
            CALL UTIMPK('S','N''EST PAS DE TYPE ',1,LOCH)
            CALL UTFINM()
         ENDIF
      ENDIF

C     VERIFICATION DE LA GRANDEUR
      IF(GDCHAM(1:1).NE.'*')THEN
         GDCH=GDCHAM
         CALL DISMOI(KSTOP,'NOM_GD',NOCH,'CHAMP',IBID,NOMGD,IER)
         IF(GDCH.NE.NOMGD)THEN
            IER=1
            CALL UTDEBM(KSTOP,'CHPVER','LE CHAMP')
            CALL UTIMPK('S',' ',1,NOCH(1:8))
            CALL UTIMPK('S','N''A PAS LA GRANDEUR ',1,GDCH)
            CALL UTFINM()
         ENDIF
      ENDIF

      CALL JEDEMA()

      END
