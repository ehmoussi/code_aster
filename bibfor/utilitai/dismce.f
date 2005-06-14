      SUBROUTINE DISMCE ( CODMES, QUESTI, NOMOBZ, REPI, REPKZ, IERD )
      IMPLICIT   NONE
      INTEGER             REPI, IERD
      CHARACTER*(*)       QUESTI, CODMES, NOMOBZ, REPKZ
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 17/06/2003   AUTEUR VABHHTS J.PELLET 
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
C     --     DISMOI(CHAM_ELEM)
C
C IN  : CODMES : CODE DES MESSAGES A EMETTRE : 'F', 'A', ...
C       QUESTI : TEXTE PRECISANT LA QUESTION POSEE
C       NOMOBZ : NOM D'UN OBJET DE TYPE LIGREL
C
C OUT : REPI   : REPONSE ( SI ENTIERE )
C       REPKZ  : REPONSE ( SI CHAINE DE CARACTERES )
C       IERD   : CODE RETOUR (0--> OK, -1 --> CHAMP INEXISTANT)
C
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
      CHARACTER*32     JEXNUM, JEXNOM
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER       IBID, IRET, GD, JCELD, IACELK, L, LXLGUT
      CHARACTER*8   K8BID, NOGD
      CHARACTER*19  NOMOB
      CHARACTER*24 QUESTL
      CHARACTER*32  REPK
C DEB-------------------------------------------------------------------
C
      CALL JEMARQ()
C
      IERD   = 0
      NOMOB  = NOMOBZ
      REPK   = REPKZ
      QUESTL = QUESTI
      CALL JEEXIN ( NOMOB//'.CELD', IRET )
      IF ( IRET .EQ. 0 ) THEN
          IERD = -1
          GOTO 9999
      END IF
C
      CALL JEVEUO ( NOMOB//'.CELD', 'L', JCELD )
      GD = ZI(JCELD)
      CALL JENUNO ( JEXNUM('&CATA.GD.NOMGD',GD), NOGD )
C
      IF ( QUESTI .EQ. 'TYPE_CHAMP' ) THEN
         CALL JELIRA ( NOMOB//'.CELD', 'DOCU', IBID, K8BID )
         IF ( K8BID(1:4) .EQ. 'CHML' ) THEN
            CALL JEVEUO ( NOMOB//'.CELK', 'L', IACELK )
            REPK = ZK24(IACELK-1+3)(1:4)
         ELSE
            CALL UTMESS ( 'F', 'DISMCE', '1' )
            IERD = 1
            GOTO 9999
         ENDIF
C
      ELSEIF ( QUESTI .EQ. 'TYPE_SUPERVIS' ) THEN
         CALL JELIRA ( NOMOB//'.CELD', 'DOCU', IBID, K8BID )
         IF ( K8BID(1:4) .EQ. 'CHML' ) THEN
            REPK = 'CHAM_ELEM_'//NOGD
         ELSE
            CALL UTMESS ( 'F', 'DISMCE', '2' )
            IERD = 1
            GOTO 9999
         ENDIF
C
      ELSEIF ( QUESTI .EQ. 'NOM_OPTION' ) THEN
         CALL JEVEUO ( NOMOB//'.CELK', 'L', IACELK )
         REPK = ZK24(IACELK-1+2)(1:16)
C
      ELSEIF ( QUESTI .EQ. 'NOM_MAILLA') THEN
         CALL JEVEUO ( NOMOB//'.CELK', 'L', IACELK )
         CALL DISMLG ( CODMES, QUESTI, ZK24(IACELK), REPI, REPK, IERD )
C
      ELSEIF ( QUESTL(1:6) .EQ. 'NUM_GD' ) THEN
         REPI = GD
C
      ELSEIF ( QUESTL(1:6) .EQ. 'NOM_GD' ) THEN
         REPK = NOGD
C
      ELSEIF ( QUESTI .EQ. 'NOM_LIGREL' ) THEN
         CALL JEVEUO ( NOMOB//'.CELK', 'L', IACELK )
         REPK = ZK24(IACELK)
C
      ELSEIF ( QUESTI .EQ. 'NOM_MODELE' ) THEN
         CALL JEVEUO ( NOMOB//'.CELK','L', IACELK )
         CALL DISMLG ( CODMES, QUESTI, ZK24(IACELK), REPI, REPK, IERD )
C
      ELSEIF ( QUESTI .EQ. 'MXVARI' ) THEN
        REPI=MAX(1,ZI(JCELD-1+4))
C
      ELSEIF ( QUESTI .EQ. 'TYPE_SCA' ) THEN
          L    = LXLGUT(NOGD)
          REPK = NOGD(L:L)
C
      ELSE
         REPK = QUESTI
         CALL UTMESS ( CODMES, 'DISMCE:',
     +                 'LA QUESTION : "'//REPK//'" EST INCONNUE')
         IERD = 1
         GOTO 9999
      ENDIF
C
 9999 CONTINUE
      REPKZ = REPK
C
      CALL JEDEMA()
      END
