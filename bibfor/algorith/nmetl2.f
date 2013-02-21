      SUBROUTINE NMETL2(MOTFAC,SDIETO,ICHAM )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 18/02/2013   AUTEUR SELLENET N.SELLENET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT     NONE
      INCLUDE 'jeveux.h'
      CHARACTER*24 SDIETO
      CHARACTER*16 MOTFAC
      INTEGER      ICHAM
C
C ----------------------------------------------------------------------
C
C ROUTINE GESTION IN ET OUT
C
C LECTURE D'UN CHAMP - CAS CHAMP PAR CHAMP DANS ETAT_INIT
C
C ----------------------------------------------------------------------
C
C
C IN  MOTFAC : MOT-CLEF FACTEUR POUR LIRE ETAT_INIT
C IN  SDIETO : SD GESTION IN ET OUT
C IN  ICHAM  : INDEX DU CHAMP DANS SDIETO
C
C
C
C
      CHARACTER*24 IOINFO,IOLCHA
      INTEGER      JIOINF,JIOLCH
      INTEGER      ZIOCH
      CHARACTER*24 CHAMP1,CHAMP2
      INTEGER      ILECC,IRET,IBID
      CHARACTER*24 CHETIN,LOCCHA,LOCHIN
      CHARACTER*24 MOTCEI,STATUT
      CHARACTER*24 NOMCHA,NOMCH0,NOMCHS,VALK(2)
      INTEGER      IARG
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATION
C
      CHAMP2 = '&&NMETL2.CHAMP.CONVER'
      ILECC  = 0
C
C --- ACCES AUX SDS
C
      IOINFO = SDIETO(1:19)//'.INFO'
      IOLCHA = SDIETO(1:19)//'.LCHA'
      CALL JEVEUO(IOINFO,'L',JIOINF)
      CALL JEVEUO(IOLCHA,'E',JIOLCH)
      ZIOCH  = ZI(JIOINF+4-1)
C
C --- CHAMP A LIRE ?
C
      CHETIN = ZK24(JIOLCH+ZIOCH*(ICHAM-1)+8-1)
      IF (CHETIN.EQ.'NON') GOTO 999
C
C --- NOM DU CHAMP DANS SD RESULTAT
C
      NOMCHS = ZK24(JIOLCH+ZIOCH*(ICHAM-1)+1-1)
C
C --- NOM DU CHAMP NUL
C
      NOMCH0 = ZK24(JIOLCH+ZIOCH*(ICHAM-1)+2-1)
C
C --- NOM DU CHAMP DANS OPERATEUR
C
      CALL NMETNC(SDIETO,ICHAM ,NOMCHA)
C
C --- STATUT DU CHAMP
C
      STATUT = ZK24(JIOLCH+ZIOCH*(ICHAM-1)+4-1)
C
C --- LOCALISATION DU CHAMP
C
      LOCCHA = ZK24(JIOLCH+ZIOCH*(ICHAM-1)+5-1)
C
C --- MOT-CLEF POUR RECUPERER LE CHAMP DANS ETAT_INIT
C
      MOTCEI = ZK24(JIOLCH+ZIOCH*(ICHAM-1)+3-1)
      IF (MOTCEI.NE.' ') THEN
        CALL GETVID(MOTFAC,MOTCEI,1,IARG,1,CHAMP1,ILECC)
      ENDIF
C
C --- TRAITEMENT DU CHAMP
C
      IF (ILECC.EQ.0) THEN
        IF ((STATUT(1:6).NE.'SDRESU').AND.(NOMCH0.NE.' ')) THEN
          CALL COPISD('CHAMP_GD','V',NOMCH0,NOMCHA)
          ZK24(JIOLCH+ZIOCH*(ICHAM-1)+4-1) = 'ZERO'
        ENDIF
      ELSE
C
C ----- TYPE DU CHAMP DONNE
C
        CALL DISMOI('C'   ,'TYPE_CHAMP',CHAMP1,'CHAMP',IBID  ,
     &              LOCHIN,IRET)
C
C ----- CONVERSION EVENTUELLE DU CHAMP
C
        CALL NMETCV(NOMCHS,NOMCH0,LOCHIN,LOCCHA,CHAMP1,
     &              CHAMP2)
C
C ----- RECOPIE DU CHAMP EN LOCAL
C
        IF (LOCCHA.EQ.'NOEU') THEN
          CALL VTCOPY(CHAMP2,NOMCHA,' ',IRET)
          IF ( IRET.NE.0 ) THEN
            VALK(1) = CHAMP1
            VALK(2) = NOMCHA
            CALL U2MESK('A','MECANONLINE_2',2,VALK)
          ENDIF
        ELSEIF ((LOCCHA.EQ.'ELGA').OR.(LOCCHA.EQ.'ELEM')) THEN
          CALL COPISD('CHAMP_GD','V',CHAMP2,NOMCHA)
        ELSE
          WRITE(6,*) 'LOCCHA: ',LOCCHA
          CALL ASSERT(.FALSE.)
        ENDIF
C
C ----- STATUT DU CHAMP: LU CHAMP PAR CHAMP
C
        ZK24(JIOLCH+ZIOCH*(ICHAM-1)+4-1) = 'CHAMP'
      ENDIF
C
 999  CONTINUE
C
      CALL DETRSD('CHAMP',CHAMP2)
C
      CALL JEDEMA()
      END
