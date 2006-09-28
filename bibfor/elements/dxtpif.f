      SUBROUTINE DXTPIF ( TEMP,LTEMP)
      IMPLICIT   NONE
      REAL*8   TEMP(3)
      LOGICAL LTEMP(3)
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C
C     GESTION DE TEMP_INF ET TEMP_SUP DANS LES COQUES / TUYAUX :
C
C     IN LTEMP(3) :
C        LTEMP(1) = .T. / .F.   TEMP     EST AFFECTE
C        LTEMP(2) = .T. / .F.   TEMP_INF EST AFFECTE
C        LTEMP(3) = .T. / .F.   TEMP_SUP EST AFFECTE

C     IN/OUT TEMP(3) :
C        TEMP(1) =  VALEUR DE TEMP
C        TEMP(2) =  VALEUR DE TEMP_INF
C        TEMP(3) =  VALEUR DE TEMP_SUP
C
C        SI TEMP_INF (OU TEMP_SUP) N'EST PAS AFFECTE :
C          SI TEMP EST AFFECTE : TEMP_INF = TEMP
C          SINON : ERREUR 'F'
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
      INTEGER IADZI, IAZK24
      CHARACTER*8 NOMAIL


      IF (.NOT.LTEMP(1)) THEN
        CALL TECAEL(IADZI,IAZK24)
        NOMAIL=ZK24(IAZK24-1+3)
        CALL U2MESK('E','ELEMENTS_53',1,NOMAIL)
      END IF

      IF (.NOT.LTEMP(2))  TEMP(2)=TEMP(1)
      IF (.NOT.LTEMP(3))  TEMP(3)=TEMP(1)

      END
