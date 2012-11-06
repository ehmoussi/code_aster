      SUBROUTINE NMARPC(RESULT,SDENER,NUMREU,INSTAN)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 05/11/2012   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
      INCLUDE 'jeveux.h'
      REAL*8       INSTAN
      CHARACTER*8  RESULT
      CHARACTER*19 SDENER
      INTEGER      NUMREU
C
C ----------------------------------------------------------------------
C
C ROUTINE *_NON_LINE (STRUCTURES DE DONNES)
C
C ARCHIVAGE DES PARAMETRES DANS LA TABLE DES PARAMETRES CALCULES
C
C ----------------------------------------------------------------------
C
C IN  RESULT : NOM SD RESULTAT
C IN  SDENER : NOM SD ENERGIE
C IN  INSTAN : VALEUR DE L'INSTANT DE CALCUL
C IN  NUMREU : NUMERO DE REUSE
C
C ----------------------------------------------------------------------
C
      INTEGER      NBPAR
      PARAMETER   (NBPAR=8)
      CHARACTER*10 NOMPAR(NBPAR)
C ----------------------------------------------------------------------
      INTEGER      IFM,NIV
      INTEGER      JENER,IPARAR
      CHARACTER*19 TABLPC
      INTEGER      VALI
      CHARACTER*8  K8BID
      COMPLEX*16   C16BID
      REAL*8       VALR(7)
C
      DATA         NOMPAR / 'NUME_REUSE','INST'      ,'TRAV_EXT  ',
     &                      'ENER_CIN'  ,'ENER_TOT'  ,'TRAV_AMOR ',
     &                      'TRAV_LIAI' ,'DISS_SCH'/
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- RECUPERATION DU NOM DE LA TABLE CORRESPONDANT
C     AUX PARAMETRE CALCULES
C
      CALL LTNOTB(RESULT,'PARA_CALC',TABLPC)
C
C --- CONSTRUCTION DES LISTES DES PARAMETRES
C
      CALL JEVEUO(SDENER//'.VALE','L',JENER)
      VALR(1) = INSTAN
      DO 10 IPARAR=1,6 
        VALR(1+IPARAR) = ZR(JENER-1+IPARAR)
 10   CONTINUE
      VALI    = NUMREU
C
C --- CONSTRUCTION DES LISTES DE PARAMETRES A SAUVEGARDER PAR TYPE
C
      CALL TBAJLI(TABLPC,NBPAR,NOMPAR,VALI,VALR,C16BID,K8BID,0)

      CALL JEDEMA()

      END
