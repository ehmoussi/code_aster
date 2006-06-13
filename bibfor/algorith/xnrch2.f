      SUBROUTINE XNRCH2(IFM,NIV,NOMA,CNSLT,CNSLN,CNSEN,CNSENR,
     &                  RAYON,FISS,NMAEN1,NMAEN2,NMAEN3)
      IMPLICIT NONE
      INTEGER       IFM,NIV,NMAEN1,NMAEN2,NMAEN3
      CHARACTER*8   NOMA,FISS
      CHARACTER*19  CNSLT,CNSLN,CNSEN,CNSENR
      REAL*8 RAYON
         

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 27/03/2006   AUTEUR GENIAUT S.GENIAUT 
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
C RESPONSABLE GENIAUT S.GENIAUT
C     TOLE CRP_20
C
C
C         CALCUL DE L'ENRICHISSEMENT ET DES POINTS DU FOND DE FISSURE
C
C
C    ENTREE :
C              IFM    :   FICHIER D'IMPRESSION
C              NOMA   :   OBJET MAILLAGE
C              CNSLT  :   LEVEL-SET TANGENTE (TRACE DE LA FISSURE)
C              CNSLN  :   LEVEL-SET NORMALE  (PLAN DE LA FISSURE)
C
C    SORTIE : 
C              FISS   :   SD_FISS
C              NMAEN1 :   NOMBRE DE MAILLES 'HEAVISIDE'
C              NMAEN2 :   NOMBRE DE MAILLES 'CRACKTIP'
C              NMAEN3 :   NOMBRE DE MAILLES 'HEAVISIDE-CRACKTIP'
C     ------------------------------------------------------------------
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
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      INTEGER       IRET,NBNO,INO,IMAE,IMA,EN,EM,NMAFON,JFON,J,NFON,JMA3
      INTEGER       JCOOR,JCONX1,JCONX2,JLTSV,JLNSV,JSTANO,JABSC,JINDIC
      INTEGER       JENSV,JENSL,NBMA,JMA,ITYPMA,NNOS
      INTEGER       JENSVR,JENSLR
      INTEGER       NMAABS,NBNOMA,I,IA,AR(12,2),NMAFIS,EM1,EM2,JMAEN1
      INTEGER       NUNO,JMAFIS,NXMAFI,JMAFON,JFO,K,JMA1,JMA2,NXPTFF
      INTEGER       IM1,IM2,IM3,IN,JMAEN2,JMAEN3
      CHARACTER*8   K8BID,TYPMA
      CHARACTER*12  K12
      CHARACTER*19  MAI
      CHARACTER*24  MAFIS,LISNO,STANO
      CHARACTER*32  JEXATR,JEXNUM
      REAL*8        M(3),P(3),D,DIMIN,Q(4),ARMIN,PADIST
      LOGICAL       DEBUG
      PARAMETER    (NXMAFI=20000)
      PARAMETER    (NXPTFF=500)
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
      CALL JEVEUO(NOMA//'.COORDO    .VALE','L',JCOOR)
      CALL JEVEUO(NOMA//'.CONNEX','L',JCONX1)
      CALL JEVEUO(JEXATR(NOMA//'.CONNEX','LONCUM'),'L',JCONX2)
C
      CALL DISMOI('F','NB_NO_MAILLA',NOMA,'MAILLAGE',NBNO,K8BID,IRET)
      CALL DISMOI('F','NB_MA_MAILLA',NOMA,'MAILLAGE',NBMA,K8BID,IRET)
C
      CALL JEVEUO(CNSLT//'.CNSV','L',JLTSV)
      CALL JEVEUO(CNSLN//'.CNSV','L',JLNSV)
C
C     VOIR ALGORITHME D�TAILL� DANS BOOK II (16/12/03)
C
C-------------------------------------------------------------------
C    1) ON RESTREINT LA ZONE D'ENRICHISSEMENT AUTOUR DE LA FISSURE
C-------------------------------------------------------------------

      WRITE(IFM,*)'XENRCH-1) RESTRICTION DE LA ZONE D ENRICHISSEMENT'

      MAFIS='&&XENRCH.MAFIS'
      CALL WKVECT(MAFIS,'V V I',NXMAFI,JMAFIS)
C     ATTENTION, MAFIS EST LIMIT� � NXMAFI MAILLES

      CALL XMAFIS(NOMA,CNSLN,NXMAFI,MAFIS,NMAFIS)
      WRITE(IFM,*)'NOMBRE DE MAILLES DE LA ZONE FISSURE :',NMAFIS
      IF (NIV.GT.2) THEN
        WRITE(IFM,*)'NUMERO DES MAILLES DE LA ZONE FISSURE'
        DO 110 IMAE=1,NMAFIS
          WRITE(6,*)' ',ZI(JMAFIS-1+IMAE)
 110    CONTINUE
      ENDIF
      
C--------------------------------------------------------------------
C    2�) ON ATTRIBUE LE STATUT DES NOEUDS DE GROUP_ENRI
C--------------------------------------------------------------------

      WRITE(IFM,*)'XENRCH-2) ATTRIBUTION DU STATUT DES NOEUDS '//
     &                          'DE GROUPENRI'

C     CREATION DU VECTEUR STATUT DES NOEUDS
      STANO='&&XENRCH.STANO'
      CALL WKVECT(STANO,'V V I',NBNO,JSTANO)

C     ON INITIALISE POUR TOUS LES NOEUDS DU MAILLAGE ENR � 0
      DO 200 INO=1,NBNO
        ZI(JSTANO-1+(INO-1)+1)=0
 200  CONTINUE

      CALL XSTANO(NOMA,LISNO,NMAFIS,JMAFIS,CNSLT,CNSLN,RAYON,STANO)

C     ENREGISTREMENT DU CHAM_NO SIMPLE : STATUT DES NOEUDS
      CALL CNSCRE(NOMA,'NEUT_I',1,'X1','V',CNSEN)
      CALL JEVEUO(CNSEN//'.CNSV','E',JENSV)
      CALL JEVEUO(CNSEN//'.CNSL','E',JENSL)
      DO 210 INO=1,NBNO
        ZI(JENSV-1+(INO-1)+1)=ZI(JSTANO-1+(INO-1)+1)
        ZL(JENSL-1+(INO-1)+1)=.TRUE.
 210  CONTINUE
C     ENREGISTREMENT DU CHAM_NO SIMPLE REEL (POUR VISUALISATION)
      CALL CNSCRE(NOMA,'NEUT_R',1,'X1','V',CNSENR)
      CALL JEVEUO(CNSENR//'.CNSV','E',JENSVR)
      CALL JEVEUO(CNSENR//'.CNSL','E',JENSLR)
      DO 211 INO=1,NBNO
        ZR(JENSVR-1+(INO-1)+1)=ZI(JSTANO-1+(INO-1)+1)
        ZL(JENSLR-1+(INO-1)+1)=.TRUE.
 211  CONTINUE

C--------------------------------------------------------------------
C    3�) ON ATTRIBUE LE STATUT DES MAILLES VOLUMIQUES DU MAILLAGE
C        ET ON CONSTRUIT LES MAILLES DE MAFOND (NB MAX = NMAFIS)
C--------------------------------------------------------------------

      WRITE(IFM,*)'XENRCH-3) ATTRIBUTION DU STATUT DES MAILLES'

      IF (NMAFIS.EQ.0) THEN
        CALL UTMESS('A','XENRCH','AUCUNE MAILLE DE FISSURE N''A ETE '//
     &              'TROUVEE. SUITE DES CALCULS RISQUEE.')
        NMAFON=0
        NMAEN1=0
        NMAEN2=0
        NMAEN3=0
        GOTO 333
      ENDIF

      CALL WKVECT('&&XENRCH.MAFOND','V V I',NMAFIS,JMAFON)
      CALL WKVECT('&&XENRCH.MAENR1','V V I',NBMA,JMAEN1)      
      CALL WKVECT('&&XENRCH.MAENR2','V V I',NBMA,JMAEN2)      
      CALL WKVECT('&&XENRCH.MAENR3','V V I',NBMA,JMAEN3)

      I=0
      IM1=0
      IM2=0
      IM3=0

      MAI=NOMA//'.TYPMAIL'
      CALL JEVEUO(MAI,'L',JMA)

C     BOUCLE SUR LES MAILLES DU MAILLAGE
      DO 310 IMA=1,NBMA
        ITYPMA=ZI(JMA-1+IMA)
        CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ITYPMA),TYPMA)
C       SI MAILLE NON SURFACIQUE ON CONTINUE � 310
        IF (TYPMA(1:4).NE.'TRIA'.AND.TYPMA(1:4).NE.'QUAD'
     &     ) GOTO 310          

        EM=0
        EM1=0
        EM2=0
        NMAABS=IMA
        NBNOMA=ZI(JCONX2+NMAABS) - ZI(JCONX2+NMAABS-1)
        IF (TYPMA(1:5).EQ.'TRIA6'.OR.TYPMA(1:5).EQ.'QUAD8') THEN
C         MAILLE QUADRATIQUE : NB NOEUDS SOMMETS = NB NOEUDS TOTAL /2
          NNOS=NBNOMA/2
        ELSE
          NNOS=NBNOMA
        ENDIF
C       BOUCLE SUR LES NOEUDS SOMMETS DE LA MAILLE
        DO 311 IN=1,NNOS
          NUNO=ZI(JCONX1-1+ZI(JCONX2+NMAABS-1)+IN-1)
          EN=ZI(JSTANO-1+(NUNO-1)+1)
          IF (EN.EQ.1.OR.EN.EQ.3) EM1=EM1+1
          IF (EN.EQ.2.OR.EN.EQ.3) EM2=EM2+1
 311    CONTINUE
        IF (EM1.GE.1) EM=1
        IF (EM2.GE.1) EM=2
        IF (EM1.GE.1.AND.EM2.GE.1) EM=3
        IF (EM2.EQ.NNOS) THEN
C         MAILLE RETENUE POUR MAFOND (TS LS NOEUDS SOMMET SONT 'CARR�S')
          I=I+1
          ZI(JMAFON-1+I)=NMAABS
        ENDIF
C       ON R�CUP�RE LES NUMEROS DES MAILLES ENRICHIES
        IF (EM.EQ.1)   THEN
          IM1=IM1+1     
          ZI(JMAEN1-1+IM1)=NMAABS
        ELSEIF (EM.EQ.2)   THEN
          IM2=IM2+1
          ZI(JMAEN2-1+IM2)=NMAABS
        ELSEIF (EM.EQ.3)   THEN
          IM3=IM3+1
          ZI(JMAEN3-1+IM3)=NMAABS
        ENDIF
 310  CONTINUE

      NMAFON=I
      NMAEN1=IM1
      NMAEN2=IM2
      NMAEN3=IM3

C     REPRISE SI NMAFIS=0
 333  CONTINUE

      IF (NIV.GT.2) THEN
        WRITE(IFM,*)'NOMBRE DE MAILLES DE MAFON :',NMAFON
        DO 320 IMA=1,NMAFON
          WRITE(IFM,*)'MAILLE NUMERO ',ZI(JMAFON-1+IMA)
 320    CONTINUE
        WRITE(IFM,*)'NOMBRE DE MAILLES DE MAENR1 :',NMAEN1     
        DO 321 IMA=1,NMAEN1
          WRITE(IFM,*)'MAILLE NUMERO ',ZI(JMAEN1-1+IMA)
 321    CONTINUE
        WRITE(IFM,*)'NOMBRE DE MAILLES DE MAENR2 :',NMAEN2    
        DO 322 IMA=1,NMAEN2
          WRITE(IFM,*)'MAILLE NUMERO ',ZI(JMAEN2-1+IMA)
 322    CONTINUE
        WRITE(IFM,*)'NOMBRE DE MAILLES DE MAENR3 :',NMAEN3      
        DO 323 IMA=1,NMAEN3
          WRITE(IFM,*)'MAILLE NUMERO ',ZI(JMAEN3-1+IMA)
 323    CONTINUE
      ENDIF 

C--------------------------------------------------------------------
C    4�) RECHERCHES DES POINTS DE FONFIS (ALGO BOOK I 18/12/03)
C--------------------------------------------------------------------

      WRITE(IFM,*)'XENRCH-4) RECHERCHE DES POINTS DE FONFIS'

      CALL WKVECT('&&XENRCH.FONFIS','V V R',4*NXPTFF,JFON)

      CALL XPTFON(NOMA,NMAFON,CNSLT,CNSLN,JMAFON,NXPTFF,JFON,NFON,ARMIN)
      WRITE(K12,'(E12.5)') ARMIN 
      WRITE(IFM,*)'LA LONGUEUR DE LA PLUS PETITE ARETE '//
     &      'DU MAILLAGE EST '//K12//'.'
      WRITE(IFM,*)'NOMBRE DE POINTS DE FONFIS',NFON
      IF (NFON.EQ.0) THEN
        CALL UTMESS('A','XENRCH','AUCUN POINT DU '//
     &  'FOND DE FISSURE N''A ETE TROUVE. VERIFIER LES DEFINITIONS '//
     &  'DES LEVEL SETS. SUITE DES CALCULS RISQUEE...')
     
       IF (RAYON.GT.0.D0) CALL UTMESS('F','XNRCH2','NE PAS UTILISER '//
     &  'LE MOT-CLE RAYON_ENRI LORSQUE LE FOND DE FISSURE EST EN '//
     &  'DEHORS DE LA STRUCTURE')

        CALL ASSERT(NMAEN2+NMAEN3.EQ.0)
         
     
C       CR�ATION DE DEUX POINTS BIDONS DU FOND DE FISSURE
        NFON=2
        ZR(JFON-1+1)=0.D0
        ZR(JFON-1+2)=0.D0
        ZR(JFON-1+3)=0.D0    
        ZR(JFON-1+4)=0.D0 
        ZR(JFON-1+5)=100.D0
        ZR(JFON-1+6)=100.D0
        ZR(JFON-1+7)=100.D0    
        ZR(JFON-1+8)=100.D0 
      ENDIF

      WRITE(IFM,*)'COORDONNEES DES POINTS DE FONFIS'
      WRITE(6,697)
      DO 699 I=1,NFON
        Q(1)=ZR(JFON-1+4*(I-1)+1)
        Q(2)=ZR(JFON-1+4*(I-1)+2)
        Q(3)=ZR(JFON-1+4*(I-1)+3)
        Q(4)=ZR(JFON-1+4*(I-1)+4)
        WRITE(6,698)(Q(K),K=1,4)
 699  CONTINUE
 697  FORMAT(7X,'X',13X,'Y',13X,'Z',13X,'S')
 698  FORMAT(2X,4(E12.5,2X))


C------------------------------------------------------------------
C     FIN
C------------------------------------------------------------------

C     CREATION D'UN INDICATEUR : PRESENCE GR_ENR (0 OU 1) +  NMAEN
      CALL WKVECT(FISS//'.MAILFISS .INDIC','G V I',6,JINDIC)
      DO 750 I=1,6
        ZI(JINDIC-1+I)=0
 750  CONTINUE
C     ENREGISTREMENT DES GROUP_MA DE SORTIE SI NON VIDE
      IF (NMAEN1.NE.0) THEN
        CALL WKVECT(FISS//'.MAILFISS  .HEAV','G V I',NMAEN1,JMA1)
        ZI(JINDIC)=1
        ZI(JINDIC+1)=NMAEN1
        DO 700 I=1,NMAEN1
           ZI(JMA1-1+I)=ZI(JMAEN1-1+I)
 700    CONTINUE
      ENDIF
      IF (NMAEN2.NE.0) THEN
        CALL WKVECT(FISS//'.MAILFISS  .CTIP','G V I',NMAEN2,JMA2)
        ZI(JINDIC+2)=1
        ZI(JINDIC+3)=NMAEN2
        DO 710 I=1,NMAEN2
           ZI(JMA2-1+I)=ZI(JMAEN2-1+I)
 710    CONTINUE
      ENDIF
      IF (NMAEN3.NE.0) THEN
        CALL WKVECT(FISS//'.MAILFISS  .HECT','G V I',NMAEN3,JMA3)
        ZI(JINDIC+4)=1
        ZI(JINDIC+5)=NMAEN3
        DO 720 I=1,NMAEN3
           ZI(JMA3-1+I)=ZI(JMAEN3-1+I)
 720    CONTINUE
      ENDIF

C     ENREGISTREMENT DES COORD ET DES ABS CURV
      CALL WKVECT(FISS//'.FONDFISS','G V R',4*NFON,JFO)
      DO 800 I=1,NFON
        DO 810 K=1,4
          ZR(JFO-1+4*(I-1)+K)=ZR(JFON-1+4*(I-1)+K)
 810    CONTINUE
 800  CONTINUE

      CALL JEDETR ('&&XENRCH.FONFIS')
      CALL JEDETR ('&&XENRCH.FONFIS')
      CALL JEDETR ('&&XENRCH.MAFOND')
      CALL JEDETR ('&&XENRCH.MAENR1')
      CALL JEDETR ('&&XENRCH.MAENR2')
      CALL JEDETR ('&&XENRCH.MAENR3')      

      WRITE(IFM,*)'XENRCH-7) FIN DE XENRCH'

      CALL JEDEMA()
      END
