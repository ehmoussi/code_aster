      SUBROUTINE TE0514(OPTION,NOMTE)
      IMPLICIT   NONE
      CHARACTER*16 OPTION,NOMTE

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C.......................................................................
C
C       CALCUL DES DONN�ES TOPOLOGIQUES CONCERNANT CONCERNANT
C       LA D�COUPE DES �L�MENTS POUR L'INT�GRATION AVEC X-FEM
C                   (VOIR BOOK IV 27/10/04)
C
C  OPTION : 'TOPOSE' (X-FEM TOPOLOGIE DES SOUS-�L�MENTS)
C
C  ENTREES  ---> OPTION : OPTION DE CALCUL
C           ---> NOMTE  : NOM DU TYPE ELEMENT
C
C......................................................................
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX --------------------
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

C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX --------------------

      CHARACTER*8   ELP,NOMA
      CHARACTER*24  PINTER,AINTER,COORSE,HEAV
      REAL*8        NEWPT(3),P(3),PADIST,LONREF,CRIT
      INTEGER       IGEOM,JLSN,JGRLSN,JOUT1,JOUT2,JOUT3,JOUT4,JOUT5
      INTEGER       JPTINT,JHEAV,IADZI,IAZK24,JDIM
      INTEGER       NINTER,NFACE,CFACE(5,3),CONNEC(6,4),NIT,NSE,NSETOT
      INTEGER       NPTS,CNSE(6,4),I,J,IT,NP,IPT,ISE,IN,NI,NSEMX,CPT
      LOGICAL       DEJA
      INTEGER       NDIM,IBID,NDIME
C......................................................................

      CALL JEMARQ()

C   INFO: LE NB DE SOUS-TETRAS MAX POUR CHAQUE TETRA EST NSEMX=6 (3D)
C   INFO: LE NB DE SOUS-TRIAS MAX POUR CHAQUE TRIA EST NSEMX=3 (2D)

      CALL ELREF1(ELP)
      CALL ELREF4(' ','RIGI',NDIME,IBID,IBID,IBID,IBID,IBID,IBID,IBID)

      CALL TECAEL(IADZI,IAZK24)
      NOMA=ZK24(IAZK24)
      CALL JEVEUO(NOMA//'.DIME','L',JDIM)
      NDIM=ZI(JDIM-1+6)

C     ATTENTION, NE PAS CONFONDRE NDIM ET NDIME  !!
C     NDIM EST LA DIMENSION DU MAILLAGE
C     NDIME EST DIMENSION DE L'ELEMENT FINI
C     PAR EXEMPLE, POUR LES ELEMENT DE BORDS D'UN MAILLAGE 3D :
C     NDIME = 2 ALORS QUE NDIM = 3

      IF (NDIME.EQ. 3) THEN
         NSEMX=6
      ELSEIF (NDIME.EQ. 2) THEN
         NSEMX=3
      ENDIF

C
C     RECUPERATION DES ENTREES / SORTIE
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PLEVSET','L',JLSN)

      CALL JEVECH('PPINTTO','E',JOUT1)
      CALL JEVECH('PCNSETO','E',JOUT2)
      CALL JEVECH('PHEAVTO','E',JOUT3)
      CALL JEVECH('PLONCHA','E',JOUT4)
      IF (NDIME.EQ.3) THEN
        CALL JEVECH('PCRITER','E',JOUT5)
      ENDIF

      NP=0
      CPT=0
      NSETOT=0

C     CALCUL D'UNE LONGUEUR CARACTERISTIQUE DE L'ELEMENT
      CALL LONCAR(ELP,ZR(IGEOM),LONREF)

C     ON SUBDIVISE L'ELEMENT PARENT EN NIT TETRAS
      CALL XDIVTE(ELP,CONNEC,NIT)

C     ARCHIVAGE DE LONCHAM
      ZI(JOUT4-1+1)=NIT

C     BOUCLE SUR LES NIT TETRAS
      DO 100 IT=1,NIT

C       DECOUPAGE EN NSE SOUS-ELEMENTS
        PINTER='&&TE0514.PTINTER'
        AINTER='&&TE0514.ATINTER'
        CALL XDECOU(IT,CONNEC,ZR(JLSN),IGEOM,PINTER,NINTER,NPTS,AINTER)
        COORSE='&&TE0514.COORSE'
        HEAV='&&TE0514.HEAV'
        CALL XDECOV(IT,CONNEC,ZR(JLSN),IGEOM,PINTER,NINTER,NPTS,
     &                                    AINTER,NSE,CNSE,COORSE,HEAV)

        CALL JEVEUO(HEAV,'L',JHEAV)

C       ARCHIVAGE DE LONCHAM
        NSETOT=NSETOT+NSE

        IF (NSETOT.GT.32) CALL U2MESS('F','ELEMENTS4_12')
        ZI(JOUT4-1+IT+1)=NSE

C       BOUCLE SUR LES NINTER POINTS D'INTERSETION
        CALL JEVEUO(PINTER,'L',JPTINT)
        DO 200 IPT=1,NINTER
          DO 210 J=1,NDIM
            NEWPT(J)=ZR(JPTINT-1+NDIM*(IPT-1)+J)
 210      CONTINUE

C         VERIF SI EXISTE DEJA DANS PINTERTO
          DEJA=.FALSE.
          DO 220 I=1,NP
            DO 221 J=1,NDIM
              P(J) = ZR(JOUT1-1+NDIM*(I-1)+J)
 221        CONTINUE
            IF (PADIST(NDIM,P,NEWPT) .LT. (LONREF*1.D-3)) THEN
              DEJA = .TRUE.
              NI=I
            ENDIF
 220      CONTINUE
          IF (.NOT.DEJA) THEN
            NP=NP+1
            IF (NP.GT.11) CALL U2MESS('F','ELEMENTS4_13')
C           ARCHIVAGE DE PINTERTO
            DO 230 J=1,NDIM
              ZR(JOUT1-1+NDIM*(NP-1)+J)=ZR(JPTINT-1+NDIM*(IPT-1)+J)
 230        CONTINUE

C           MISE A JOUR DU CNSE (TRANSFORMATION DES 100 EN 1000...)
            DO 240 ISE=1,NSE
              DO 241 IN=1,NDIME+1
                IF (CNSE(ISE,IN).EQ.100+IPT) CNSE(ISE,IN)=1000+NP
 241          CONTINUE
 240        CONTINUE
          ELSE
            DO 114 ISE=1,NSE
              DO 115 IN=1,NDIME+1
                IF (CNSE(ISE,IN).EQ.100+IPT) CNSE(ISE,IN)=1000+NI
 115          CONTINUE
 114        CONTINUE
          ENDIF

 200    CONTINUE

C       BOUCLE SUR LES NSE SOUS-�L�MENTS
        DO 120 ISE=1,NSE
          CPT=CPT+1
C         ARCHIVAGE DE PHEAVTO
          ZI(JOUT3-1+NSEMX*(IT-1)+ISE)=ZR(JHEAV-1+ISE)
C         ARCHIVAGE DE PCNSETO
          DO 121 IN=1,NDIME+1
            ZI(JOUT2-1+(NDIME+1)*(CPT-1)+IN)=CNSE(ISE,IN)
 121      CONTINUE
 120    CONTINUE

        CALL JEDETR(PINTER)
        CALL JEDETR(AINTER)
        CALL JEDETR(COORSE)
        CALL JEDETR(HEAV)

 100  CONTINUE

C     ARCHIVAGE DE LONCHAM
      ZI(JOUT4-1+NIT+2)=NP
      IF (NDIME .EQ. 3) THEN
        CALL XCRVOL(IGEOM,ZR(JOUT1),ZI(JOUT2),ZI(JOUT3),ZI(JOUT4),CRIT)
        ZR(JOUT5)=CRIT
      ENDIF
C ----------------------------------------------------------------------

      CALL JEDEMA()
      END
