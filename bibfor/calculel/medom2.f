      SUBROUTINE MEDOM2(MODELE,MATE,CARA,KCHA,NCHA,CTYP,
     &                  RESULT,NUORD,NBORDR,BASE,NPASS,LIGREL)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      INTEGER       NCHA,NUORD
      CHARACTER*1   BASE
      CHARACTER*4   CTYP
      CHARACTER*8   MODELE,CARA,RESULT
      CHARACTER*24  MATE
      CHARACTER*(*) KCHA
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 10/09/2012   AUTEUR SELLENET N.SELLENET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     CHAPEAU DE LA ROUTINE MEDOM1
C     ON DETERMINE LE BON LIGREL DANS LE CAS OU ON PASSE POUR LA
C     PREMIERE FOIS
C
C ----------------------------------------------------------------------
C
C OUT : MODELE : NOM DU MODELE
C OUT : MATE   : CHAMP MATERIAU
C OUT : CARA   : NOM DU CHAMP DE CARACTERISTIQUES
C IN  : KCHA   : NOM JEVEUX POUR STOCKER LES CHARGES
C OUT : NCHA   : NOMBRE DE CHARGES
C OUT : CTYP   : TYPE DE CHARGE
C IN  : RESULT : NOM DE LA SD RESULTAT
C IN  : NUORD  : NUMERO D'ORDRE
C IN  : NBORDR : NOMBRE TOTAL DE NUMEROS D'ORDRE
C IN  : BASE   : 'G' OU 'V' POUR LA CREATION DU LIGREL
C IN/OUT : NPASS  : NOMBRE DE PASSAGE DANS LA ROUTINE
C OUT : LIGREL   : NOM DU LIGREL
C
C ----------------------------------------------------------------------
C
C
C
C ----------------------------------------------------------------------
C
      INTEGER NBMXBA
      PARAMETER (NBMXBA=2)
      
      INTEGER NBORDR,NPASS,NBLIGR,I,KMOD,JMAILL,NBMAMO,NBMAAL,IMA
      INTEGER ILIGRS,IMODLS,INDIK8,IBASES,JLISMA,GETEXM,N1,N2

      CHARACTER*1  BASLIG,K1B
      CHARACTER*24 LIGREL,LIGR1,NOOJB
C
C ----------------------------------------------------------------------
C
C PERSISTANCE PAR RAPPORT A OP0058
      SAVE NBLIGR, ILIGRS, IMODLS, IBASES
C
      CALL JEMARQ()

C     RECUPERATION DU MODELE, CARA, CHARGES A PARTIR DU RESULTAT ET DU
C     NUMERO ORDRE
      CALL MEDOM1(MODELE,MATE,CARA,KCHA,NCHA,CTYP,RESULT,NUORD)

C     RECUPERATION DU LIGREL DU MODELE

C     POUR LE PREMIER PASSAGE ON INITIALISE LES TABLEAUX SAUVES
      IF (NPASS.EQ.0) THEN
        NPASS=NPASS+1
        NBLIGR=0
        CALL JEDETR('&&MEDOM2.LIGRS    ')
        CALL JEDETR('&&MEDOM2.MODELS   ')
        CALL JEDETR('&&MEDOM2.BASES    ')
        CALL WKVECT('&&MEDOM2.LIGRS    ','V V K24',NBORDR*NBMXBA,ILIGRS)
        CALL WKVECT('&&MEDOM2.MODELS   ','V V K8' ,NBORDR,IMODLS)
        CALL WKVECT('&&MEDOM2.BASES    ','V V K8' ,NBORDR*NBMXBA,IBASES)
        CALL JEVEUT('&&MEDOM2.LIGRS    ','L',ILIGRS)
        CALL JEVEUT('&&MEDOM2.MODELS   ','L',IMODLS)
        CALL JEVEUT('&&MEDOM2.BASES    ','L',IBASES)
      END IF

C     ON REGARDE SI LE MODELE A DEJA ETE RENCONTRE
      KMOD=INDIK8(ZK8(IMODLS-1),MODELE,1,NBLIGR+1)
      BASLIG=' '
      DO 10,I = 1,NBLIGR
        IF (ZK8(IMODLS-1+I).EQ.MODELE) THEN
          KMOD=1
          BASLIG=ZK8(IBASES-1+I)(1:1)
        ENDIF
   10 CONTINUE

C     SI OUI, ON REGARDE SI LE LIGREL A ETE CREE SUR LA MEME BASE 
C     QUE LA BASE DEMANDEE
      IF ((KMOD.GT.0).AND.(BASLIG.EQ.BASE)) THEN
C
C     SI OUI ALORS ON LE REPREND
        LIGREL=ZK24(ILIGRS-1+NBLIGR)
        
C     SI NON ON CREE UN NOUVEAU LIGREL
      ELSE
        N1 = GETEXM(' ','GROUP_MA')
        N2 = GETEXM(' ','MAILLE')
        IF ( N1+N2.NE.0 ) THEN
          CALL EXLIMA(' ',0,BASE,MODELE,LIGR1)
        ELSE
          CALL JEVEUO(MODELE//'.MAILLE','L',JMAILL)
          CALL JELIRA(MODELE//'.MAILLE','LONMAX',NBMAMO,K1B)
          CALL WKVECT('&&MEDOM2.LISTE_MAILLES','V V I',NBMAMO,JLISMA)
          NBMAAL=0
          DO 20 IMA=1,NBMAMO
            IF ( ZI(JMAILL+IMA-1).NE.0 ) THEN
              ZI(JLISMA+NBMAAL)=IMA
              NBMAAL=NBMAAL+1
            ENDIF
  20      CONTINUE
          NOOJB='12345678.LIGR000000.LIEL'
          CALL GNOMSD(NOOJB,14,19)
          LIGR1=NOOJB(1:19)
          CALL ASSERT(LIGR1.NE.' ')
          CALL EXLIM1(ZI(JLISMA),NBMAAL,MODELE,BASE,LIGR1)
          CALL JEDETR('&&MEDOM2.LISTE_MAILLES')
        ENDIF
        NBLIGR=NBLIGR+1
        ZK24(ILIGRS-1+NBLIGR)=LIGR1
        ZK8( IMODLS-1+NBLIGR)=MODELE
        ZK8( IBASES-1+NBLIGR)=BASE
        LIGREL=LIGR1
      END IF
C      
      CALL JEDEMA()
      END
