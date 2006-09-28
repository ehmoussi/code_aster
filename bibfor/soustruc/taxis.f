      SUBROUTINE TAXIS(NOMA,INDIC,NBMA)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF SOUSTRUC  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C
C     ARGUMENTS:
C     ----------
      CHARACTER*8 NOMA
      INTEGER INDIC(*)
      INTEGER NBMA
C ----------------------------------------------------------------------
C     BUT: VERIFIER QUE LES COORDONNEES SONT POSITIVES
C
C     IN: NOMA   : NOM DU MAILLAGE
C         INDIC  : INDICATEUR DES MAILLES A TRAITER.
C           NBMA : NOMBRE DE MAILLES
C
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*32 JEXNUM,JEXNOM,JEXATR,JEXR8
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C ---------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------
C     VARIABLES LOCALES:
C     ------------------
      CHARACTER*8  K8BID,NOMMA,NOMNO,K8B,K8A
C
      CALL JEMARQ()
C
C     -- ON PARCOURE LA LISTE DES MAILLES ET ON TESTE LES NOEUDS
C
      CALL JEVEUO(NOMA//'.COORDO    .VALE','L',JVALE)
      IER=0
      DO 2 IMA=1,NBMA
      IF (INDIC(IMA).NE.0) THEN
         CALL JEVEUO(JEXNUM(NOMA//'.CONNEX',IMA),'L',IACNEX)
         CALL JELIRA(JEXNUM(NOMA//'.CONNEX',IMA),'LONMAX',NBNOMA,K8BID)
         DO 3 INO =1,NBNOMA
            NUMNO=ZI(IACNEX-1+INO)-1
            IF ( ZR(JVALE+3*NUMNO) .LT. 0.0D0 ) THEN
               CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',NUMNO+1),K8B)
               CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',IMA    ),K8A)
               IF ( IER .EQ. 0 ) THEN
                  CALL UTDEBM('A','OP0018',' VERIFIER VOTRE MAILLAGE ')
               ENDIF
               CALL UTIMPK('L',' COORDONNEE X < 0 POUR LE NOEUD ',1,K8B)
               CALL UTIMPK('S',' MAILLE ',1,K8A)
               IER  = IER + 1
            ENDIF
 3       CONTINUE
      ENDIF
 2    CONTINUE
      IF ( IER .NE. 0 ) THEN
         CALL UTFINM( )
         CALL U2MESS('F','SOUSTRUC_78')
      ENDIF
C
 9999 CONTINUE
      CALL JEDEMA()
      END
