      SUBROUTINE VLAXPY(ALPHA,CHAMNA,CHAMNB)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 14/01/2013   AUTEUR TARDIEU N.TARDIEU 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.         
C ======================================================================
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*(*) CHAMNA,CHAMNB
      REAL*8        ALPHA
C-----------------------------------------------------------------------
C    - FONCTION REALISEE:  ENCAPSULATION DAXPY SUR LES .VALE DES CHAM_NO
C                    CHAMN1 ET CHAMN2 UNIQUEMENT SUR LES DDL DE LAGRANGE
C                       CHAMN2.VALE = ALPHA * CHAMN1.VALE + CHAMN2.VALE
C     ------------------------------------------------------------------
C     IN  ALPHA     :  R8  : COEFF. MULTIPLICATEUR
C     IN  CHAMNA    :  K*  : CHAM_NO MAITRE 1
C     IN/OUT CHAMNB :  K*  : CHAM_NO MAITRE 2
C----------------------------------------------------------------------
      INTEGER      NEQ,IVAL1,IVAL2,IRET1,
     &             IRET2,I,IBID,JNUM
      CHARACTER*8  K8BID
      CHARACTER*19 PRNO
      CHARACTER*24 CHAMN1,CHAMN2
      LOGICAL      LFETI
C----------------------------------------------------------------------

      CALL JEMARQ()
      CHAMN1=CHAMNA
      CHAMN2=CHAMNB
      
C --- NUMEROTATION POUR TRIER LES LAGRANGE ET LES DDLS PHYSIQUES
      CALL DISMOI('F','PROF_CHNO',CHAMN1,'CHAM_NO',IBID,PRNO,IRET1)
      CALL JEVEUO(PRNO(1:14)// '.NUME.DELG','L',JNUM)

C --- TEST POUR SAVOIR SI LE SOLVEUR EST DE TYPE FETI
      CALL JEEXIN(CHAMN1(1:19)//'.FETC',IRET1)
      IF (IRET1.NE.0) THEN
        CALL JEEXIN(CHAMN2(1:19)//'.FETC',IRET2)
        IF (IRET2.EQ.0)
     &    CALL U2MESS('F','ALGELINE3_91')
        LFETI=.TRUE.
      ELSE
        LFETI=.FALSE.
      ENDIF
      CALL ASSERT(.NOT.LFETI)

C --- MISE A JOUR DES VALEURS DES LAGRANGE
      CALL JEVEUO(CHAMN1(1:19)//'.VALE','L',IVAL1)
      CALL JEVEUO(CHAMN2(1:19)//'.VALE','E',IVAL2)
      CALL JELIRA(CHAMN2(1:19)//'.VALE','LONMAX',NEQ,K8BID)
      DO 10 I=1,NEQ
        IF (ZI(JNUM-1+I).NE.0)
     &         ZR(IVAL2-1+I)=ALPHA*ZR(IVAL1-1+I) + ZR(IVAL2-1+I)
   10 CONTINUE

      CALL JEDEMA()
      END
