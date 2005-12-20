      SUBROUTINE NMASFR ( DEFICO, RESOCO, MATASS )
      

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 29/06/2004   AUTEUR MABBAS M.ABBAS 
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
      IMPLICIT NONE
      CHARACTER*14 RESOCO
      CHARACTER*19 MATASS
      CHARACTER*24 DEFICO

C ======================================================================
C ROUTINE APPELEE PAR : NMMATR
C ======================================================================
C CREATION DE LA MATRICE DE FROTTEMENT
C IN  DEFICO  : SD DE DEFINITION DU CONTACT (ISSUE D'AFFE_CHAR_MECA)
C IN  RESOCO  : SD CONTACT
C VAR  MATASS 
C      IN/JXIN  : MATR_ASSE TANGENTE
C      OUT/JXOUT: MATR_ASSE TANGENTE + FROTTEMENT (EVENTUEL)
C ======================================================================


C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
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
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
      CHARACTER*14 NUMEDF,NT
      CHARACTER*24 APPARI
      INTEGER      ICONTA,TYPALC,TYPALF,FROT3D,MATTAN,IBID,IER
      CHARACTER*19 MAFROT,KT
      CHARACTER*24 LIMAT(2)
      REAL*8       COEFMU(2)
      CHARACTER*1  TYPMAT(2),TYPCST(2)
C     ----------------------------------------------------------------
      CALL JEMARQ()

      APPARI = RESOCO(1:14)//'.APPARI'
      CALL JEEXIN (APPARI,ICONTA)
      IF ( ICONTA .EQ. 0 ) THEN
         GO TO 9999
      ELSE
         CALL CFDISC(DEFICO,RESOCO,TYPALC,TYPALF,FROT3D,MATTAN)
         IF(TYPALC.LE.0) THEN
           GO TO 9999
         ENDIF
         IF (MATTAN.EQ.0) THEN
             GO TO 9999   
         ENDIF
      ENDIF
 111  CONTINUE
C
      MAFROT = RESOCO(1:8)//'.MAFR'
C
      LIMAT(1) = MATASS
      LIMAT(2) = MAFROT
      COEFMU(1) = 1.D0
      COEFMU(2) = 1.D0
      TYPCST(1) = 'R'
      TYPCST(2) = 'R'
      TYPMAT(1) = 'R'
      TYPMAT(2) = 'R'
      KT = '&&NMASFR.MATANG'
      NT = '&&NMASFR.NUTANG'
C

      CALL DETRSD('NUME_DDL',NT)
      CALL DETRSD('MATR_ASSE',KT)
C    ON REND LE CODE MUET QUAND INFO=1
      CALL INFMUE()
      CALL MTCMBL(2,TYPCST,COEFMU,TYPMAT,LIMAT,'R',KT,' ','V',NT,.TRUE.)
      CALL INFBAV()
      CALL DISMOI('F','NOM_NUME_DDL',MAFROT,'MATR_ASSE',
     &                IBID,NUMEDF,IER)
      CALL DETRSD('MATR_ASSE',MATASS)
      CALL DETRSD('MATR_ASSE',MAFROT)
      CALL DETRSD('NUME_DDL',NUMEDF)
C
      MATASS = KT
C
 9999 CONTINUE
      CALL JEDEMA()
    
      END
