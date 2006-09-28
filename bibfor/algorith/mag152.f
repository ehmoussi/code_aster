      SUBROUTINE MAG152(N9,N10,NOMRES,NUGENE,MODMEC,MODGEN,NBLOC,
     &                  INDICE)
      IMPLICIT NONE
C---------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C---------------------------------------------------------------------
C AUTEUR : G.ROUSSEAU
C CREATION DE LA MATRICE ASSEMBLEE GENERALISEE AU FORMAT LDLT :
C      - OBJET    .UALF
C      - STOCKAGE .SLCS
C ET REMPLISSAGE DE SES OBJETS AUTRES QUE LE .UALF
C---------------------------------------------------------------------
C--------- DEBUT DES COMMUNS JEVEUX ----------------------------------
      CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
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
C     --- FIN DES COMMUNS JEVEUX ------------------------------------
      LOGICAL VRAI,EXIGEO
      INTEGER LDBLO,IBID,NPREC,MATER,NBVALE,NBREFE,NBDESC,JBID
      INTEGER NBMO,NBMODE,INDICE,IMODEG
      INTEGER IAVALE,IADESC,JREFA,I,J,IMODE,ISCBL,IACONL
      INTEGER ISCDI,IADIRG,IALIME,IBLO,IBLODI,IERD,IERR
      INTEGER IEXEC,ISCHC,ILIRES,IMADE,IMDG,IND,INEQU
      INTEGER IPHI1,IPHI2,IPRSTO,IRANG,IREFE,IRET,ITXSTO,SOMME
      INTEGER ITYSTO,ITZSTO,IVALK,JMDG,JND,JRANG,KCOMPT,JSCBL
      INTEGER JSCDI,JSCDE,JSCHC,JSCIB,MUN,N1BLOC,N2BLOC
      INTEGER NBID,NBLOC,NBMODT,NSTOC,NTBLOC,NTERM,NUEQ,IMPR,NHMAX
      INTEGER N1,N2,N3,N4,N5,N6,N7,N8,N9,N10,N11,N12,N13
      REAL*8 TPS(6),EPS,R8BID,MIJ,CIJ,KIJ,KIJ1,CIJ1,CIJ2
      REAL*8 BID,EBID
      CHARACTER*1 DIR
      CHARACTER*2 MODEL
      CHARACTER*3 INCR
      CHARACTER*8 NOMRES,K8BID,MODMEC,REP,PHIBAR,NUMMOD
      CHARACTER*8 MOFLUI,MOINT,MA,MATERI,NOMCMP(6)
      CHARACTER*8 CHAR,NUMGEN,MODGEN,NOMTMP,MATGEN,LPAIN(2),LPAOUT(1)
      CHARACTER*9 OPTION
      CHARACTER*14 NU,NUM,NUDDL,NUM14,NUGENE
      CHARACTER*16 TYPE(3),RK16
      CHARACTER*16 TYPRES,NOMCOM
      CHARACTER*19 CH19
      CHARACTER*19 MAX,MAY,MAZ,CHAMNO,PHIB19
      CHARACTER*19 CHAINE,NOMSTO
      CHARACTER*24 CHGEOM,LCHIN(2)
      CHARACTER*24 NOMCHA,CH24,CARELE,TIME,NOCHAM
      CHARACTER*24 MATE,LIGRMO,PHIB24,MADE
      CHARACTER*72 K72B
      COMPLEX*16 C16B,CBID
C -----------------------------------------------------------------
C
C        CAS NUME_DDL_GENE  PRESENT
C
      CALL JEMARQ()

      CALL WKVECT(NOMRES//'           .REFA','G V K24',10,JREFA)
      NOMSTO=NUGENE//'.SLCS'

      IF ((N9.GT.0)) THEN
        CALL JEVEUO(NOMSTO//'.SCDE','L',JSCDE)
        NUEQ = ZI(JSCDE-1+1)
        NTBLOC = ZI(JSCDE-1+2)
        NBLOC = ZI(JSCDE-1+3)
        NHMAX = ZI(JSCDE-1+4)


C TEST SUR LE MODE DE STOCKAGE : SI ON N EST PAS EN STOCKAGE
C LIGNE DE CIEL PLEIN ON PLANTE

        IF (NUEQ.NE.NHMAX) THEN
          CALL U2MESS('A','ALGORITH5_16')
        END IF

        IF ((NUEQ* (NUEQ+1)/2).GT. (NBLOC*NTBLOC)) THEN
          CALL U2MESS('F','ALGORITH5_17')
        END IF

C CALCUL DU NOMBRE DE TERME PAR BLOC ET TOTAL

        CALL JEVEUO(NOMSTO//'.SCBL','L',ISCBL)
        CALL JEVEUO(NOMSTO//'.SCHC','L',ISCHC)

        SOMME = 0

        DO 20 IBLO = 1,NBLOC

C----------------------------------------------------------------
C
C         BOUCLE SUR LES COLONNES DE LA MATRICE ASSEMBLEE
C
          N1BLOC = ZI(ISCBL+IBLO-1) + 1
          N2BLOC = ZI(ISCBL+IBLO)
C
C
          DO 10 I = N1BLOC,N2BLOC
            SOMME = SOMME + ZI(ISCHC+I-1)
   10     CONTINUE
   20   CONTINUE

        WRITE (6,*) 'SOMME=',SOMME
        IF ((NUEQ* (NUEQ+1)/2).NE.SOMME) THEN
          CALL U2MESS('F','ALGORITH5_18')
        END IF



        CALL JECREC(NOMRES//'           .UALF','G V R','NU','DISPERSE',
     &              'CONSTANT',NBLOC)
        CALL JEECRA(NOMRES//'           .UALF','LONMAX',NTBLOC,K8BID)


        CALL WKVECT(NOMRES//'           .LIME','G V K8',1,IALIME)
        CALL WKVECT(NOMRES//'           .CONL','G V R',NUEQ,IACONL)
C
C       CAS DU CHAM_NO
C
      ELSE
C
        CALL JEVEUO(NOMSTO//'.SCDE','L',JSCDE)
        NUEQ = ZI(JSCDE-1+1)
        NBLOC = 1
        NTBLOC = NUEQ* (NUEQ+1)/2

        CALL JECREC(NOMRES//'           .UALF','G V R','NU','DISPERSE',
     &              'CONSTANT',NBLOC)
        CALL JEECRA(NOMRES//'           .UALF','LONMAX',NTBLOC,K8BID)
        CALL WKVECT(NOMRES//'           .LIME','G V K8',1,IALIME)
        CALL WKVECT(NOMRES//'           .CONL','G V R',NUEQ,IACONL)

      END IF

C ----------- REMPLISSAGE DU .REFA ET DU .LIME---------------
C---------------------ET DU .CONL ---------------------------


      IF (N10.GT.0) THEN
        ZK24(JREFA-1+1) = ' '

      ELSE IF (INDICE.EQ.1) THEN
        CALL GETVID(' ','NUME_DDL_GENE',0,1,1,NUMMOD,NBID)
        NUM14 = NUMMOD
        CALL JEVEUO(NUM14//'.NUME.REFN','L',IMODEG)
        ZK24(JREFA-1+1) = ZK24(IMODEG)

      ELSE
        ZK24(JREFA-1+1) = MODMEC
      END IF

      ZK24(JREFA-1+2) = NUGENE
      ZK24(JREFA-1+9) = 'MS'
      ZK24(JREFA-1+10) = 'GENE'

      IF (N10.GT.0) THEN
        ZK8(IALIME) = MODGEN

      ELSE
        ZK8(IALIME) = '  '
      END IF

      DO 30 I = 1,NUEQ
        ZR(IACONL+I-1) = 1.0D0
   30 CONTINUE

      CALL JEDEMA()
      END
