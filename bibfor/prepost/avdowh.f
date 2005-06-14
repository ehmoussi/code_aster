      SUBROUTINE AVDOWH( NBVEC, NBORDR, NOMMAT, NCYCL, SIGEQ,
     &                   DOMEL, NRUPT )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 24/11/2003   AUTEUR F1BHHAJ J.ANGLES 
C ======================================================================
C COPYRIGHT (C) 1991 - 2003  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE F1BHHAJ J.ANGLES
      IMPLICIT    NONE
      INTEGER     NBVEC, NBORDR, NCYCL(NBVEC)
      REAL*8      SIGEQ(NBVEC*NBORDR)
      REAL*8      NRUPT(NBVEC*NBORDR), DOMEL(NBVEC*NBORDR)
      CHARACTER*8 NOMMAT
C ----------------------------------------------------------------------
C BUT: CALCULER LE DOMMAGE ELEMENTAIRE DE WOHLER POUR TOUS LES CYCLES
C      ELEMETAIRES DE CHAQUE VECTEUR NORMAL.
C ----------------------------------------------------------------------
C ARGUMENTS :
C  NBVEC    IN   I  : NOMBRE DE VECTEURS NORMAUX.
C  NBORDR   IN   I  : NOMBRE DE NUMEROS D'ORDRE.
C  NOMMAT   IN   K  : NOM DU MATERIAU.
C  NCYCL    IN   I  : NOMBRE DE CYCLES ELEMENTAIRES POUR TOUS LES
C                     VECTEURS NORMAUX.
C  SIEQ     IN   R  : VECTEUR CONTENANT LES VALEURS DE LA CONTRAINTE
C                     EQUIVALENTE, POUR TOUS LES SOUS CYCLES
C                     DE CHAQUE VECTEUR NORMAL.
C  DOMEL    OUT  R  : VECTEUR CONTENANT LES VALEURS DES DOMMAGES
C                     ELEMENTAIRES, POUR TOUS LES SOUS CYCLES
C                     DE CHAQUE VECTEUR NORMAL.
C  NRUPT    OUT  R  : VECTEUR CONTENANT LES NOMBRES DE CYCLES
C                     ELEMENTAIRES, POUR TOUS LES SOUS CYCLES
C                     DE CHAQUE VECTEUR NORMAL.
C ----------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C     ------------------------------------------------------------------
      INTEGER       I, IVECT, ICYCL, ADRS
      REAL*8        R8MAEM
      CHARACTER*2   CODRET, CODWO
      CHARACTER*16  PHENOM
      LOGICAL       ENDUR
C     ------------------------------------------------------------------
C
C234567                                                              012
C
      CALL JEMARQ()
C
      DO 10 IVECT=1, NBVEC
         DO 20 ICYCL=1, NCYCL(IVECT)
            ADRS = (IVECT-1)*NBORDR + ICYCL
C
            CALL RCCOME ( NOMMAT, 'FATIGUE', PHENOM, CODRET )
            IF ( CODRET .EQ. 'NO' ) CALL UTMESS('F','AVDOWH.1',
     &         'POUR CALCULER LE DOMMAGE IL FAUT DEFINIR LE '//
     &         'COMPORTEMENT "FATIGUE" DANS DEFI_MATERIAU' )
C
            CALL RCPARE( NOMMAT, 'FATIGUE', 'WOHLER', CODWO )
            IF ( CODWO .EQ. 'OK' ) THEN
               CALL LIMEND( NOMMAT, SIGEQ(ADRS), ENDUR)
               IF (ENDUR) THEN
                  NRUPT(ADRS)=R8MAEM()
               ELSE
                  CALL RCVALE(NOMMAT,'FATIGUE',1,'SIGM',SIGEQ(ADRS),1,
     &                       'WOHLER',NRUPT(ADRS),CODRET,'F')
               ENDIF
            ENDIF
C
            DOMEL(ADRS) = 1.D0/NRUPT(ADRS)
            NRUPT(ADRS) = NINT(NRUPT(ADRS))
C
 20      CONTINUE
 10   CONTINUE
C
      CALL JEDEMA()
C
      END
