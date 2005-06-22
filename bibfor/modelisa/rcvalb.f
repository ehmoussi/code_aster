      SUBROUTINE RCVALB(KPGVRC,POUM,JMAT,NOMAT,PHENOM,NBPAR,NOMPAR,
     &                  VALPAR,NBRES,NOMRES,VALRES,CODRET,ARRET)
      IMPLICIT NONE
      INTEGER            JMAT, NBPAR, NBRES,KPGVRC
      REAL*8             VALPAR(NBPAR), VALRES(NBRES)
      CHARACTER*2        CODRET(NBRES)
      CHARACTER*(*)      NOMAT,PHENOM,ARRET,NOMPAR(NBPAR),NOMRES(NBRES)
      CHARACTER*(*)      POUM
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 23/06/2005   AUTEUR VABHHTS J.PELLET 
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
C ----------------------------------------------------------------------
C  BUT : CHAPEAU A LA ROUTINE RCVALA POUR AJOUTER A LA LISTE DES
C        PARAMETRES DES FONCTIONS LES VARIABLES DE COMMANDE
C ----------------------------------------------------------------------
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER  ZI
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
C ----------------------------------------------------------------------
      INTEGER NBCVRC,JVCNOM
      COMMON /CAII14/NBCVRC,JVCNOM

      INTEGER NBPAMX,NBPAR2,IPAR,NBPART,IBID
      PARAMETER (NBPAMX=10)
      REAL*8             VALPA2(NBPAMX),VALVRC
      CHARACTER*(8)      NOMPA2(NBPAMX),NOVRC
C DEB ------------------------------------------------------------------

      IF (NBCVRC.EQ.0) THEN
        CALL RCVALA( JMAT, NOMAT, PHENOM, NBPAR, NOMPAR, VALPAR,
     &                   NBRES, NOMRES, VALRES, CODRET, ARRET )
      ELSE
        NBPAR2=NBCVRC
        NBPART=NBPAR+NBPAR2
        CALL ASSERT(NBPART.LE.NBPAMX)
        DO 1, IPAR=1,NBPAR
          NOMPA2(IPAR)=NOMPAR(IPAR)
          VALPA2(IPAR)=VALPAR(IPAR)
1       CONTINUE
        DO 2, IPAR=1,NBPAR2
          NOVRC=ZK8(JVCNOM-1+IPAR)
          NOMPA2(NBPAR+IPAR)=NOVRC
          CALL RCVARC('F',NOVRC,POUM,KPGVRC,VALVRC,IBID)
          VALPA2(NBPAR+IPAR)=VALVRC
2       CONTINUE
        CALL RCVALA( JMAT, NOMAT, PHENOM, NBPART, NOMPA2, VALPA2,
     &                   NBRES, NOMRES, VALRES, CODRET, ARRET )
      END IF
      END
