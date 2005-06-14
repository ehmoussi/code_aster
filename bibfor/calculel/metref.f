      SUBROUTINE METREF(MATE,NOMA,EXITRF,CHTREF)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 15/05/96   AUTEUR CIBHHRA R.MEDDOURI 
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
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*8 NOMA
      CHARACTER*24 CHTREP,CHTREF
      CHARACTER*(*) MATE
      COMPLEX*16 CBID
      LOGICAL EXITRF
C
      CHTREF = '&&METREF.TEMPE_REFE'
      CHTREP = MATE(1:8)//'.TEMPE_REF .DESC'
      CALL JEEXIN(CHTREP,IRET)
      IF (IRET.NE.0) THEN
         EXITRF = .TRUE.
         CHTREF = CHTREP
      ELSE
         CALL MECACT('V',CHTREF,'MAILLA',NOMA,'TEMP_R',1,'TEMP',1,0.0D0,
     +               CBID,' ')
         EXITRF = .FALSE.
      END IF
      END
