      SUBROUTINE RECUGD(CAELEM,NOMCMP,VALRES,NBGD,IASSEF)
      IMPLICIT REAL*8 (A-H,O-Z)
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C-----------------------------------------------------------------------
C     PERMET D'EXTRAIRE D'UNE STRUCTURE "CARTE", LES VALEURS DES
C     COMPOSANTES POUR CHAQUE ASSOCIATION.
C-----------------------------------------------------------------------
C IN : CAELEM  : NOM DE LA CARTE.
C IN : NOMCMP  : NOM DES COMPOSANTES DE LA GRANDEUR RECHERCHEE
C                VECTEUR DE LONG. NBGD
C IN  : NBGD   : NOMBRE DE COMPOSANTES RECHERCHEES.
C IN  : IASSEF : NOMBRE D'ASSOCIATIONS DE LA STRUCTURE CARTE.
C OUT : VALRES : VALEURS DES COMPOSANTES.
C-----------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
        REAL*8       VALRES(NBGD*IASSEF)
        CHARACTER*8  NOMCMP(NBGD)
      CHARACTER*1  K1BID
      CHARACTER*19 CAELEM
        CHARACTER*24 CARAV, CARAD
        CHARACTER*32 JEXNOM,JEXNUM
C
C-----------------------------------------------------------------------
C
      CALL JEMARQ()
      CARAV = CAELEM(1:19)//'.VALE'
      CARAD = CAELEM(1:19)//'.DESC'
      CALL JEVEUO(CARAV,'L',ICARV)
      CALL JEVEUO(CARAD,'L',ICARD)
C
      IGD = ZI(ICARD)
C
      CALL JELIRA(JEXNUM('&CATA.GD.NOMCMP',IGD),'LONMAX',NBCMP,K1BID)
      IF (NBCMP . GE. 31) THEN
        CALL U2MESS('F','UTILITAI4_7')
      ENDIF
      CALL WKVECT('&&RECUGD.TEMP.TABL','V V I',NBCMP,ITAB)
      DO 5  IJ=1,NBCMP
         ZI(ITAB+IJ-1) = 0
 5    CONTINUE
C
      CALL JEVEUO(JEXNOM('&CATA.GD.NOMCMP','CAGEPO'),'L',ICMP)
C
C     RECHERCHE DE LA LONGUEUR SUR UN GROUPE DE SEG2
      IDECA=0
      DO 8 II=1,IASSEF
        ICODE = ZI(ICARD+3-1+2*IASSEF+II)
C
        CALL DEC2PN(ICODE,ZI(ITAB),NBCMP)
        DO 50 I = 1,NBCMP
          IDECA = IDECA + ZI(ITAB+I-1)
  50    CONTINUE
      IF (IDECA.NE.0) GOTO 9
    8 CONTINUE
    9 CONTINUE
C
      IDECAL = 0
C
      DO 10 II=1,IASSEF
        ICODE = ZI(ICARD+3-1+2*IASSEF+II)
C
        CALL DEC2PN(ICODE,ZI(ITAB),NBCMP)
C
C
        DO 20 JJ=1,NBGD
          IRANG = 0
          DO 30 KK=1,NBCMP
            IF (NOMCMP(JJ) .EQ. ZK8(ICMP+KK-1)) THEN
              IRANG = KK
            ENDIF
  30      CONTINUE
          IF (IRANG .EQ. 0) THEN
            CALL U2MESK('E','UTILITAI4_8',1,NOMCMP(JJ))
          ENDIF
          IRANV = 0
          DO 40 LL=1,IRANG
            IF (ZI(ITAB+LL-1) .EQ. 1) THEN
              IRANV = IRANV+1
            ENDIF
  40      CONTINUE
C    ON MET A ZERO SI INEXISTANT
          IF (IRANV.EQ.0) THEN
          VALRES(NBGD*(II-1)+JJ) = 0
          ELSE
          VALRES(NBGD*(II-1)+JJ) = ZR(ICARV+IDECAL+IRANV-1)
          ENDIF
  20    CONTINUE
        IDECAL=IDECAL+IDECA
  10  CONTINUE
C
      CALL JEDETR('&&RECUGD.TEMP.TABL')
      CALL JEDEMA()
      END
