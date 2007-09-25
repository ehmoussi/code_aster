      SUBROUTINE MMREND(DEFICO,NEWGEO,IZONE,COORPT,DIRAPP,
     &                  DIR   ,POSMIN)
C    
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 24/09/2007   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*24 DEFICO
      CHARACTER*24 NEWGEO
      INTEGER      IZONE
      REAL*8       COORPT(3)
      LOGICAL      DIRAPP
      REAL*8       DIR(3)
      INTEGER      POSMIN
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - APPARIEMENT)
C
C RECHERCHER LE NOEUD MAITRE LE PLUS PROCHE DU POINT DE CONTACT 
C SELON UNE DIRECTION DE RECHERCHE DONNEE
C      
C ----------------------------------------------------------------------
C
C
C IN  DEFICO : SD POUR LA DEFINITION DE CONTACT
C IN  NEWGEO : NOUVELLE GEOMETRIE (AVEC DEPLACEMENT GEOMETRIQUE)
C IN  IZONE  : NUMERO DE LA ZONE DE CONTACT
C IN  COORPT : COORDONNEES DU POINT DE CONTACT (SUR MAILLE ESCLAVE)
C IN  DIRAPP : VAUT .TRUE. SI APPARIEMENT DANS UNE DIRECTION DE
C              RECHERCHE DONNEE (PAR DIR)
C IN  DIR    : DIRECTION DE RECHERCHE
C OUT POSMIN : POSITION (DANS CONTANO) DU NOEUD MAITRE LE PLUS PROCHE
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
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
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER ISURF2,NBNO2,JDEC2,K2
      INTEGER POSNO2,NUMNO2
      INTEGER      IFM,NIV      
      INTEGER JZONE,JNOCO,JSUNO
      INTEGER JCOOR
      REAL*8 COOR2(3),DMIN,DIST,NORMD,NORMV,R8GAEM
      CHARACTER*24 PZONE,CONTNO,PSURNO
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('CONTACT',IFM,NIV)              
C      
C --- RECUPERATION DE QUELQUES DONNEES      
C
      PZONE  = DEFICO(1:16)//'.PZONECO'
      CONTNO = DEFICO(1:16)//'.NOEUCO'
      PSURNO = DEFICO(1:16)//'.PSUNOCO'
      CALL JEVEUO(PZONE,'L',JZONE)
      CALL JEVEUO(CONTNO,'L',JNOCO)
      CALL JEVEUO(PSURNO,'L',JSUNO)
      CALL JEVEUO(NEWGEO(1:19)//'.VALE','L',JCOOR)
C
C --- INFOS SUR LA SURFACE MAITRE
C
      ISURF2 = ZI(JZONE+IZONE)
      NBNO2  = ZI(JSUNO+ISURF2) - ZI(JSUNO+ISURF2-1)
      JDEC2  = ZI(JSUNO+ISURF2-1)
C
C --- RECHERCHE BRUTE: BOUCLE SUR LES NOEUDS
C
      DMIN = R8GAEM()
      DO 10 K2 = 1,NBNO2
        POSNO2 = JDEC2 + K2
        NUMNO2 = ZI(JNOCO+POSNO2-1)
        COOR2(1) = ZR(JCOOR+3*(NUMNO2-1))
        COOR2(2) = ZR(JCOOR+3*(NUMNO2-1)+1)
        COOR2(3) = ZR(JCOOR+3*(NUMNO2-1)+2)
        IF (DIRAPP) THEN
          NORMD    = SQRT(DIR(1)*DIR(1)+DIR(2)*DIR(2)+DIR(3)*DIR(3))
          NORMV    = SQRT((COORPT(1)-COOR2(1))**2+
     &                    (COORPT(2)-COOR2(2))**2+
     &                    (COORPT(3)-COOR2(3))**2)
          IF (NORMD.EQ.0.D0) THEN
            CALL U2MESS('F','CONTACT3_15')
          ENDIF
          IF (NORMV.EQ.0.D0) THEN
            DIST = 1.D0
          ELSE
            DIST = ABS((COORPT(1)-COOR2(1))*DIR(1)+ 
     &                 (COORPT(2)-COOR2(2))*DIR(2)+
     &                 (COORPT(3)-COOR2(3))*DIR(3))/(NORMD*NORMV)
          ENDIF
        ELSE
          DIST = SQRT((COORPT(1)-COOR2(1))**2+ 
     &                (COORPT(2)-COOR2(2))**2+
     &                (COORPT(3)-COOR2(3))**2)
        ENDIF
        IF (DIST.LT.DMIN) THEN
          POSMIN = POSNO2
          DMIN   = DIST
        END IF
   10 CONTINUE

      CALL JEDEMA()
      END
