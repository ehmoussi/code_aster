      SUBROUTINE CAPOCO ( CHAR, MOTFAC, NOMA )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 04/04/2006   AUTEUR CIBHHLV L.VIVAN 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT NONE
      CHARACTER*8  CHAR, NOMA
      CHARACTER*16 MOTFAC
C
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : CALICO
C ----------------------------------------------------------------------
C
C LECTURE DES CARACTERISTIQUES DE POUTRE
C REMPLISSAGE DE LA SD 'DEFICO'
C
C IN  CHAR   : NOM UTILISATEUR DU CONCEPT DE CHARGE
C IN  MOTFAC : MOT-CLE FACTEUR (VALANT 'CONTACT')
C IN  NOMA   : NOM DU MAILLAGE
C IN  NZOCO  : 
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*32 JEXNOM, JEXNUM
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      IRET,NOC,JDIM,IJPOU,NBNMA,IACNEX,NNOCO,JNOCO
      INTEGER      ICESC,ICESD,ICESL,ICESV,NPMAX,ISEC,JMAIL,NUMMA
      INTEGER      INDIK8,RANGR0,RANGR1,RANGR2,IAD1,IAD2,IOC,NBMA,IMA
      INTEGER      NZOCO,IDESC,NUMNO,INDIIS,INO1,INO2
      REAL*8       R1,R2
      LOGICAL      YA
      CHARACTER*8  K8B,TYPM,CARAEL
      CHARACTER*16 LIMOCL(2),TYMOCL(2)
      CHARACTER*24 NDIMCO,NOEUCO,JEUPOU,MESMAI
      CHARACTER*19 CARSD,CARTE
C ----------------------------------------------------------------------
C
      CALL JEMARQ
C
C --- INITIALISATIONS
C
      CALL GETFAC ( MOTFAC, NZOCO )
      LIMOCL(1) = 'GROUP_MA_ESCL'
      LIMOCL(2) = 'MAILLE_ESCL'
      TYMOCL(1) = 'GROUP_MA'
      TYMOCL(2) = 'MAILLE'
      MESMAI    = '&&CAPOCO.MES_MAILLES'
C
      NDIMCO = CHAR(1:8)//'.CONTACT.NDIMCO'
      NOEUCO = CHAR(1:8)//'.CONTACT.NOEUCO'
      JEUPOU = CHAR(1:8)//'.CONTACT.JEUPOU'
C
      CALL JEVEUO ( NOEUCO, 'L', JNOCO )
      CALL JEVEUO ( NDIMCO, 'L', JDIM  )
      NNOCO  = ZI(JDIM+4)
C
      CALL WKVECT ( JEUPOU, 'G V R', NNOCO+1, IJPOU )
C
C --- RECUPERATION DU CARA_ELEM   
C 
      YA = .FALSE.
      DO 10 IOC = 1 , NZOCO
C
         TYPM = 'NON'
         CALL GETVTX ( MOTFAC, 'DIST_POUTRE', IOC,1,1, TYPM,   NOC )
         IF (TYPM(1:3) .EQ. 'NON') GOTO 10
         YA = .TRUE.
         CALL GETVID ( MOTFAC, 'CARA_ELEM'  , IOC,1,1, CARAEL, NOC )
C
 10   CONTINUE
C
      IF ( .NOT. YA ) GOTO 999
C
      CARTE = CARAEL//'.CARGEOPO'
      CARSD = '&&CAPOCO.CARGEOPO'
      CALL CARCES ( CARTE, 'ELEM', ' ', 'V', CARSD, IRET )
C
C --- RECUPERATION DES GRANDEURS (TSEC, R1, R2)  ---
C --- REFERENCEE PAR LA CARTE CARGEOPO           ---
C
      CALL JEVEUO(CARSD//'.CESC','L',ICESC)
      CALL JEVEUO(CARSD//'.CESD','L',ICESD)
      CALL JEVEUO(CARSD//'.CESL','L',ICESL)
      CALL JEVEUO(CARSD//'.CESV','L',ICESV)
C
C --- ON RECUPERE LE RAYON EXTERIEUR DE LA POUTRE
C 
      NPMAX = ZI(ICESD-1+2)
      RANGR0 = INDIK8(ZK8(ICESC),'TSEC    ',1,NPMAX)
      RANGR1 = INDIK8(ZK8(ICESC),'R1      ',1,NPMAX)
      RANGR2 = INDIK8(ZK8(ICESC),'R2      ',1,NPMAX)
C
      ZR(IJPOU-1+NNOCO+1) = 1.D0
C
      DO 20 IOC = 1 , NZOCO
C
         TYPM = 'NON'
         CALL GETVTX ( MOTFAC, 'DIST_POUTRE', IOC,1,1, TYPM,   NOC )
         IF (TYPM(1:3) .EQ. 'NON') GOTO 20
C
         CALL RELIEM(' ',NOMA,'NU_MAILLE',MOTFAC,IOC,2,LIMOCL,TYMOCL,
     &                                                 MESMAI,NBMA)
         CALL JEVEUO ( MESMAI, 'L', JMAIL )
C
         DO 30 IMA = 1 , NBMA
            NUMMA = ZI(JMAIL+IMA-1)
C
            ISEC = 0
            CALL CESEXI('C',ICESD,ICESL,NUMMA,1,1,RANGR0,IAD1)
            IF (IAD1.GT.0) ISEC = NINT( ZR(ICESV-1+ABS(IAD1)) )
            IF (ISEC.NE.2) 
     +        CALL UTMESS('F','CAPOCO','QUE DES SECTIONS CIRCULAIRES !')
C
            CALL CESEXI('C',ICESD,ICESL,NUMMA,1,1,RANGR1,IAD1)
            CALL CESEXI('C',ICESD,ICESL,NUMMA,1,1,RANGR2,IAD2)
C
            IF (IAD1.GT.0) THEN
               R1 = ZR(ICESV-1+IAD1)
            ELSE
               CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',NUMMA),K8B)
               CALL UTMESS('F','CAPOCO',
     +              'PB POUR RECUPERER "R1" POUR LA MAILLE '//K8B)
            ENDIF
C
            IF (IAD2.GT.0) THEN
               R2 = ZR(ICESV-1+IAD2)
            ELSE
               CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',NUMMA),K8B)
               CALL UTMESS('F','CAPOCO',
     +              'PB POUR RECUPERER "R2" POUR LA MAILLE '//K8B)
            ENDIF
C
            CALL JEVEUO(JEXNUM(NOMA//'.CONNEX',NUMMA),'L',IACNEX)
           CALL JELIRA(JEXNUM(NOMA//'.CONNEX',NUMMA),'LONMAX',NBNMA,K8B)
C
            NUMNO = ZI(IACNEX-1+1)
            INO1 = INDIIS(ZI(JNOCO),NUMNO,1,NNOCO)
            IF (INO1.GT.0)  ZR(IJPOU-1+INO1) = R1
C
            NUMNO = ZI(IACNEX-1+NBNMA)
            INO2 = INDIIS(ZI(JNOCO),NUMNO,1,NNOCO)
            IF (INO2.GT.0)  ZR(IJPOU-1+INO2) = R2
C
 30      CONTINUE
C
         CALL JEDETR ( MESMAI )
C
 20   CONTINUE
C
      CALL DETRSD ( 'CHAM_ELEM_S', CARSD )
C
 999  CONTINUE
C
      CALL JEDEMA
C
      END
