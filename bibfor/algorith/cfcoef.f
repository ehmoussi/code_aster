      SUBROUTINE CFCOEF(NDIM,DEFICO,RESOCO,NEWGEO,
     &                  NBDDLE,NBNO,POSNO,POSMA,COEFNO,
     &                  NORM,TANG,
     &                  COEF,COFX,COFY,
     &                  NBDDL,DDL)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
      IMPLICIT     NONE
      INTEGER      NDIM
      CHARACTER*24 DEFICO
      CHARACTER*24 RESOCO
      CHARACTER*24 NEWGEO
      INTEGER      NBDDLE
      INTEGER      NBNO
      INTEGER      POSNO(10)
      INTEGER      POSMA
      REAL*8       COEFNO(9)
      REAL*8       NORM(3)
      REAL*8       TANG(6)
      REAL*8       COEF(30)
      REAL*8       COFX(30)
      REAL*8       COFY(30)
      INTEGER      NBDDL
      INTEGER      DDL(30)
C
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : PROJEC
C ----------------------------------------------------------------------
C
C CETTE ROUTINE CALCULE LES COEFFICIENTS POUR APPARIEMENT NOEUD-FACETTE
C   ET L'APPARIEMENT NODAL
C
C IN  NDIM   : DIMENSION DE L'ESPACE (2 OU 3)
C IN  DEFICO : SD DE CONTACT (DEFINITION)
C IN  RESOCO : SD DE CONTACT (RESULTAT)
C IN  NEWGEO : COORDONNEES REACTUALISEES DES NOEUDS DU MAILLAGE
C IN  NBDDLE : NOMBRE DE DDL SUR LE NOEUD ESCLAVE
C IN  NBNO   : NOMBRE DE NOEUDS MAITRES CONCERNES
C IN  POSNO  : INDICES DANS CONTNO DES NOEUDS ESCLAVE ET MAITRES
C IN  POSMA  : INDICE DE LA MAILLE MAITRE
C                SI NEGATIF -> APPARIEMENT NODAL
C IN  COEFNO : COEFFICIENTS DES FONCTIONS DE FORME APRES PROJECTION
C                SUR LA MAILLE MAITRE
C IN  NORM   : LE VECTEUR NORMAL
C IN  TANG   : LES DEUX VECTEURS TANGENTS
C OUT COEF   : COEFFICIENTS LIES AU NOEUD ESCLAVE ET AUX NOEUDS MAITRES
C              (DIRECTION NORMALE)
C OUT COEFX  : COEFFICIENTS LIES AU NOEUD ESCLAVE ET AUX NOEUDS MAITRES
C              (PROJECTION SUR LA PREMIERE TANGENTE)
C OUT COEFY  : COEFFICIENTS LIES AU NOEUD ESCLAVE ET AUX NOEUDS MAITRES
C              (PROJECTION SUR LA SECONDE TANGENTE)
C OUT NBDDL  : NOMBRE DE DDLS CONCERNES (ESCLAVES + MAITRES)
C OUT DDL    : NUMEROS DES DDLS ESCLAVE ET MAITRES CONCERNES
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
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
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      K,INO
      INTEGER      JDECAL,NBDDLM,JDECDL
      CHARACTER*24 PDDL,DDLCO
      INTEGER      JPDDL,JDDL
C ----------------------------------------------------------------------
C
      CALL JEMARQ ()
C
      PDDL   = DEFICO(1:16)//'.PDDLCO'
      DDLCO  = DEFICO(1:16)//'.DDLCO'
C
      CALL JEVEUO (PDDL,  'L',JPDDL)
      CALL JEVEUO (DDLCO, 'L',JDDL)
C
      JDECAL = 0
      JDECDL = ZI(JPDDL+POSNO(1)-1)
C
C --- CAS DE L'APPARIEMENT NODAL
C
      IF (POSMA.LE.0) THEN
        NBDDLM = ZI(JPDDL+POSNO(2)) - ZI(JPDDL+POSNO(2)-1)
        IF (NBDDLM.GT.3) THEN
          CALL U2MESS('F','ALGORITH_76')
        END IF
        JDECDL = ZI(JPDDL+POSNO(2)-1)
        DO 25 K = 1,NBDDLM
          COEF(K) = -1.D0 * NORM(K)
          DDL(K) = ZI(JDDL+JDECDL+K-1)
25      CONTINUE
        GOTO 999
      ENDIF
C
C --- CAS DE L'APPARIEMENT MAITRE/ESCLAVE
C

      DO 5 K = 1,NBDDLE
        COEF(JDECAL+K) = 1.D0 * NORM(K)
        COFX(JDECAL+K) = 1.D0 * TANG(K)
        IF(NDIM.EQ.3) THEN
          COFY(JDECAL+K)=1.D0 * TANG(K+3)
        ENDIF
        DDL(JDECAL+K) = ZI(JDDL+JDECDL+K-1)
5     CONTINUE
      JDECAL = JDECAL + NBDDLE
C


      DO 80 INO = 1,NBNO
        NBDDLM = ZI(JPDDL+POSNO(INO+1)) - ZI(JPDDL+POSNO(INO+1)-1)
        IF (NBDDLM.GT.3) THEN
          CALL U2MESS('F','ALGORITH_76')
        END IF
        JDECDL = ZI(JPDDL+POSNO(INO+1)-1)
        DO 85 K = 1,NBDDLM
         COEF(JDECAL+K) = COEFNO(INO) * NORM(K)
         COFX(JDECAL+K) = COEFNO(INO) * TANG(K)
         IF(NDIM.EQ.3) THEN
          COFY(JDECAL+K) = COEFNO(INO) * TANG(K+3)
         ENDIF

         DDL(JDECAL+K) = ZI(JDDL+JDECDL+K-1)
 85     CONTINUE
        JDECAL = JDECAL + NBDDLM
 80   CONTINUE
C
 999  CONTINUE
C --- NOMBRE TOTAL DE DDL (NOEUD ESCLAVE+NOEUDS MAITRES)
      NBDDL = JDECAL
C
      CALL JEDEMA()
C ----------------------------------------------------------------------
      END
