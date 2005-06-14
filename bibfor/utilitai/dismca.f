      SUBROUTINE DISMCA(CODMES,QUESTI,NOMOBZ,REPI,REPKZ,IERD)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 16/05/2005   AUTEUR VABHHTS J.PELLET 
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
C     --     DISMOI(CARTE)
C     ARGUMENTS:
C     ----------
      INTEGER REPI,IERD
      CHARACTER*(*) NOMOBZ,REPKZ
      CHARACTER*(*) QUESTI,CODMES
      CHARACTER*24 QUESTL
      CHARACTER*32 REPK
      CHARACTER*19 NOMOB
C ----------------------------------------------------------------------
C     IN:
C       CODMES : CODE DES MESSAGES A EMETTRE : 'F', 'A', ...
C       QUESTI : TEXTE PRECISANT LA QUESTION POSEE
C       NOMOBZ : NOM D'UN OBJET DE TYPE CARTE
C     OUT:
C       REPI   : REPONSE ( SI ENTIERE )
C       REPKZ  : REPONSE ( SI CHAINE DE CARACTERES )
C       IERD   : CODE RETOUR (0--> OK, 1 --> PB)
C
C ----------------------------------------------------------------------
C     VARIABLES LOCALES:
C     ------------------
C --------------- COMMUNS NORMALISES  JEVEUX  --------------------------
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
C --------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------
      CHARACTER*19 NOMFON, NOMCAR
      CHARACTER*8  K8B,TYPFON,NOMPF(10),GRAND,TYPE,NOGD
C
C
C
      CALL JEMARQ()
      NOMOB = NOMOBZ
      REPK  = REPKZ
      QUESTL = QUESTI
C
      IF (QUESTI.EQ.'NOM_MAILLA') THEN
         CALL JEVEUO(NOMOB//'.NOMA','L',JNOMA)
         REPK = ZK8(JNOMA-1+1)
C
      ELSE IF (QUESTI.EQ.'TYPE_CHAMP') THEN
         REPK = 'CART'
C
      ELSE IF (QUESTI.EQ.'TYPE_SUPERVIS') THEN
         CALL JEVEUO(NOMOB//'.DESC','L',IADESC)
         CALL JENUNO(JEXNUM('&CATA.GD.NOMGD',ZI(IADESC)),NOGD)
         REPK='CART_'//NOGD

      ELSE IF (QUESTL(1:7).EQ.'NOM_GD ') THEN
         CALL JEVEUO(NOMOB//'.DESC','L',JDESC)
         CALL JENUNO(JEXNUM('&CATA.GD.NOMGD',ZI(JDESC)),REPK)
C
      ELSE IF (QUESTI.EQ.'PARA_INST') THEN
         REPK = ' '
         NOMCAR = NOMOB
         CALL JEVEUO(NOMCAR//'.VALE','L',JVALE)
         CALL JELIRA(NOMCAR//'.VALE','TYPE',IBID,TYPE)
         IF (TYPE(1:1).EQ.'K') THEN
           CALL JELIRA(NOMCAR//'.VALE','LONMAX',LONG,K8B)
           CALL JELIRA(NOMCAR//'.VALE','LTYP',LTYP,K8B)
           DO 10 K=1,LONG
             IF (LTYP.EQ.8) THEN
               NOMFON = ZK8(JVALE+K-1)
             ELSE IF (LTYP.EQ.24) THEN
               NOMFON = ZK24(JVALE+K-1)
             ELSE
               CALL ASSERT(.FALSE.)
             END IF


             IF ( NOMFON(1:8) .NE. '        ' ) THEN
               CALL JEEXIN(NOMFON//'.PROL',IRET)
               IF ( IRET .GT. 0 ) THEN
                 CALL JEVEUO(NOMFON//'.PROL','L',JPROL)
                 CALL FONBPA(NOMFON,ZK16(JPROL),TYPFON,10,NBPF,NOMPF)
                 DO 101 L=1,NBPF
                   IF ( NOMPF(L)(1:4) .EQ. 'INST' ) THEN
                     REPK = 'OUI'
                     GOTO 11
                   ENDIF
 101             CONTINUE
               ENDIF
             ENDIF
 10        CONTINUE
 11        CONTINUE
        ENDIF


      ELSE
         REPK = QUESTI
         CALL UTMESS(CODMES,'DISMCA:',
     +                       'LA QUESTION : "'//REPK//'" EST INCONNUE')
         IERD=1
         GO TO 9999
      END IF
C
 9999 CONTINUE
      REPKZ = REPK
      CALL JEDEMA()
      END
