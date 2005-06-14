      SUBROUTINE CNOCNO(CNO1,BASE,PRFCHN,CNO2)
C RESPONSABLE VABHHTS J.PELLET
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 14/03/2005   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
      CHARACTER*(*) CNO1,CNO2,BASE,PRFCHN
C ------------------------------------------------------------------
C BUT : TRANSFORMER UN CHAM_NO (CNO1) EN UN AUTRE CHAM_NO (CNO2)
C       POUR RESPECTER L'ORDRE DES EQUATIONS DU PROF_CHNO PRFCHN
C ------------------------------------------------------------------
C     ARGUMENTS:
C CNO1    IN/JXIN  K19 : SD CHAM_NO A TRANSFORMER
C BASE    IN       K1  : BASE DE CREATION POUR CNO2 : G/V
C PRFCHN  IN/JXIN  K19 : SD PROF_CHNO SUR LAQUELLE S'APPUIERA CNO2
C CNO2    IN/JXOUT K19 : SD CHAM_NO A CREER
C     ------------------------------------------------------------------
C     VARIABLES LOCALES:
C     ------------------
      CHARACTER*19 CNS1
C     ------------------------------------------------------------------

      CNS1 = '&&CNOCNO.CNS1'

      CALL CNOCNS(CNO1,'V',CNS1)
      CALL CNSCNO(CNS1,PRFCHN,BASE,CNO2)
      CALL DETRSD('CHAM_NO_S',CNS1)

      END
