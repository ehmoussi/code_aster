      SUBROUTINE SRMEDO(MODELE,MATE,CARA,KCHA,NCHA,CTYP,
     &                  RESULT,NUORD,NBORDR,BASE,NPASS,LIGREL)
      IMPLICIT NONE
      INTEGER       NCHA,NUORD,NBORDR,NPASS
      CHARACTER*1   BASE
      CHARACTER*4   CTYP
      CHARACTER*8   MODELE,CARA,RESULT
      CHARACTER*19  KCHA
      CHARACTER*24  MATE,LIGREL
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 05/02/2013   AUTEUR DELMAS J.DELMAS 
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
C
C     BUT: APPEL DE MEDOM1 AVEC CONSTRUCTION DU BON LIGREL
C          POUR LE CALCUL DE L'OPTION SIRO_ELEM
C
C
C OUT    : MODELE : NOM DU MODELE
C OUT    : MATE   : CHAMP MATERIAU
C OUT    : CARA   : NOM DU CHAMP DE CARACTERISTIQUES
C IN     : KCHA   : NOM JEVEUX POUR STOCKER LES CHARGES
C OUT    : NCHA   : NOMBRE DE CHARGES
C OUT    : CTYP   : TYPE DE CHARGE
C IN     : RESULT : NOM DE LA SD RESULTAT
C IN     : NUORD  : NUMERO D'ORDRE
C IN     : BASE   : 'G' OU 'V' POUR LA CREATION DU LIGREL
C IN/OUT : NPASS  : NOMBRE DE PASSAGE DANS LA ROUTINE
C OUT    : LIGREL : NOM DU LIGREL
C
C ----------------------------------------------------------------------
C
      INCLUDE 'jeveux.h'
C
      INTEGER NBMXBA
      PARAMETER (NBMXBA=2)
C
      INTEGER NBLIGR,I,KMOD,NBMATO,NBMA2D
      INTEGER ILIGRS,IMODLS,INDIK8,IBASES,JLISMA
C
      CHARACTER*1  BASLIG
      CHARACTER*24 LIGR1
      CHARACTER*24 MAIL2D,MAIL3D,MAILTO,NOOBJ
C
C ----------------------------------------------------------------------
C
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
        CALL JEDETR('&&SRMEDO.LIGRS    ')
        CALL JEDETR('&&SRMEDO.MODELS   ')
        CALL JEDETR('&&SRMEDO.BASES    ')
        CALL WKVECT('&&SRMEDO.LIGRS    ','V V K24',NBORDR*NBMXBA,ILIGRS)
        CALL WKVECT('&&SRMEDO.MODELS   ','V V K8' ,NBORDR,IMODLS)
        CALL WKVECT('&&SRMEDO.BASES    ','V V K8' ,NBORDR*NBMXBA,IBASES)
        CALL JEVEUT('&&SRMEDO.LIGRS    ','L',ILIGRS)
        CALL JEVEUT('&&SRMEDO.MODELS   ','L',IMODLS)
        CALL JEVEUT('&&SRMEDO.BASES    ','L',IBASES)
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
        MAIL2D='&&SRMEDO.MAILLE_FACE'
        MAIL3D='&&SRMEDO.MAILLE_3D_SUPP'
        MAILTO='&&SRMEDO.MAILLE_2D_3D'
C
C       RECUPERATION DES MAILLES DE FACES ET DES MAILLES 3D SUPPORT
        CALL SRLIMA(MODELE,MAIL2D,MAIL3D,MAILTO,NBMA2D)
        NBMATO = 2*NBMA2D
        CALL JEVEUO(MAILTO,'L',JLISMA)
C
        NOOBJ='12345678.LIGR000000.LIEL'
        CALL GNOMSD(' ',NOOBJ,14,19)
        LIGR1=NOOBJ(1:19)
        CALL ASSERT(LIGR1.NE.' ')
C
        CALL EXLIM1(ZI(JLISMA),NBMATO,MODELE,BASE,LIGR1)
C
        CALL JEDETR(MAIL2D)
        CALL JEDETR(MAIL3D)
        CALL JEDETR(MAILTO)
C
        NBLIGR=NBLIGR+1
        ZK24(ILIGRS-1+NBLIGR)=LIGR1
        ZK8( IMODLS-1+NBLIGR)=MODELE
        ZK8( IBASES-1+NBLIGR)=BASE
        LIGREL=LIGR1
      END IF
C
      CALL JEDEMA()
C
      END
