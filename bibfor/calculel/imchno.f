      SUBROUTINE IMCHNO ( CHAMNO )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 16/06/2004   AUTEUR DURAND C.DURAND 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C----------------------------------------------------------------------
      IMPLICIT REAL*8 (A-H,O-Z)
C     HISTOR : CHAMNO EN K*(*) AVEC COPIE DANS K*19 ET NON K*24
C----------------------------------------------------------------------
      CHARACTER*(*) CHAMNO
C----------------------------------------------------------------------
C OBJET :
C      IMPRESSION DES OBJETS JEVEUX COMPOSANT UNE STRUCTURE DE DONNEES
C      DE TYPE CHAMNO
C----------------------------------------------------------------------
C IN   CHAMNO  K*19  : NOM D'UN CHAM_NO
C----------------------------------------------------------------------
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      CHARACTER*32       JEXNUM , JEXNOM , JEXR8 , JEXATR
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
      CHARACTER*19 CHNO
C
C   STRUCTURE DE DONNEES CHAMNO
C
        IFR = IUNIFI( 'RESULTAT' )
        CHNO = CHAMNO
        CALL JEIMPO(IFR,CHNO//'.DESC',' ','DESCRIPTEUR')
        CALL JEIMPA(IFR,CHNO//'.DESC','DESCRIPTEUR')
C
        CALL JEIMPO(IFR,CHNO//'.REFE',' ','REFERENCE')
        CALL JEIMPA(IFR,CHNO//'.REFE','REFERENCE')
C
        CALL JEIMPO(IFR,CHNO//'.VALE',' ','VALEURS')
        CALL JEIMPA(IFR,CHNO//'.VALE','VALEURS')
C
      END
