      SUBROUTINE OP0142 (IER)
      IMPLICIT REAL*8 (A-H,O-Z)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 05/10/2004   AUTEUR REZETTE C.REZETTE 
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
C      DEFINITION D'UN PROFIL DE VITESSE LE LONG D'UNE STRUCTURE
C      EN FONCTION D'UNE ABSCISSE CURVILIGNE.
C     STOCKAGE DANS UN OBJET DE TYPE FONCTION
C ----------------------------------------------------------------------
C     ----------- COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER       ZI
      COMMON/IVARJE/ZI(1)
      REAL*8        ZR
      COMMON/RVARJE/ZR(1)
      COMPLEX*16    ZC
      COMMON/CVARJE/ZC(1)
      LOGICAL       ZL
      COMMON/LVARJE/ZL(1)
      CHARACTER*8   ZK8
      CHARACTER*16         ZK16
      CHARACTER*24                 ZK24
      CHARACTER*32                         ZK32
      CHARACTER*80                                 ZK80
      COMMON/KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     ----------- FIN COMMUNS NORMALISES  JEVEUX  ----------------------
      INTEGER      PNOE , PTCH
      CHARACTER*2  PROLGD
      CHARACTER*4  INTERP(2)
      CHARACTER*8  NOMMAI,  K8BID, NOD, NOF
      CHARACTER*16 NOMCMD, K16BID, TPROF, TYPFON
      CHARACTER*19 NOMFON
      CHARACTER*24 COOABS, NOMNOE, NOMMAS, TYPMAI, CONNEX
      CHARACTER*24 CONSEG, TYPSEG
      CHARACTER*32 JEXNOM,JEXNUM
      CHARACTER*10 CMD
      CHARACTER*8 TYPM
      CHARACTER*1 K1BID
      DATA CMD/'OP0142_01'/
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- RECUPERATION DU NIVEAU D'IMPRESSION
      CALL INFMAJ
      CALL INFNIV(IFM,NIV)
C
      CALL GETRES(NOMFON,TYPFON,NOMCMD)
C
      CALL GETVID(' ','MAILLAGE',0,1,1,NOMMAI,L)
      CALL GETVEM(NOMMAI,'NOEUD',' ','NOEUD_INIT',
     +      0,1,1,NOD,IBID)
      CALL GETVEM(NOMMAI,'NOEUD',' ','NOEUD_FIN',
     +     0,1,1,NOF,IBID)
C
C     --- CONSTRUCTION DES OBJETS DU CONCEPT MAILLAGE ---
C
      NOMNOE = NOMMAI//'.NOMNOE'
      COOABS = NOMMAI//'.ABS_CURV  .VALE'
      NOMMAS = NOMMAI//'.NOMMAI'
      CONNEX = NOMMAI//'.CONNEX'
      TYPMAI = NOMMAI//'.TYPMAIL'
C
      IER = 0
      CALL JENONU(JEXNOM(NOMNOE,NOD),NUM1)
      IF (NUM1.EQ.0) THEN
        IER = IER+1
      ENDIF
      CALL JENONU(JEXNOM(NOMNOE,NOF),NUM2)
      IF (NUM2.EQ.0) THEN
         IER = IER+1
      ENDIF
C
      IF (IER .NE. 0) THEN
        CALL UTMESS('F',CMD,'LES NOEUDS DEBUT ET FIN' //
     +              ' N APPARTIENNENT PAS AU MAILLAGE.')
      ENDIF
C
      CALL JEEXIN(COOABS,IEXI)
      IF (IEXI .EQ. 0) THEN
        CALL UTMESS('F',CMD,'LA FONCTION DOIT S APPUYEE SUR UN'//
     +               ' MAILLAGE POUR LEQUEL UNE ABSCISSE'//
     +              ' CURVILIGNE EST DEFINIE.')
      ENDIF
C
      CALL GETVTX(' ','INTERPOL'   ,0,1,2,INTERP      ,N3)
      IF ( N3 .EQ. 1 ) INTERP(2) = INTERP(1 )
      CALL GETVTX(' ','PROL_GAUCHE',0,1,1,PROLGD(1:1) ,N3)
      CALL GETVTX(' ','PROL_DROITE',0,1,1,PROLGD(2:2) ,N3)
C
C     --- CREATION ET REMPLISSAGE DE L'OBJET NOMFON//'.PROL'
C
      CALL WKVECT(NOMFON//'.PROL','G V K16',5,LPRO)
C
      ZK16(LPRO) = 'FONCTION'
      ZK16(LPRO+1) = INTERP(1)//INTERP(2)
      ZK16(LPRO+2) = 'ABSC '
      ZK16(LPRO+3) = 'VITE'
      ZK16(LPRO+4) = PROLGD
C
C     --- LECTURE DES CARACTERISTIQUES DU GROUPE DE MAILLES : ADRESSE
C                   ET NOMBRE DE MAILLES
C
      CALL JELIRA(NOMMAS,'NOMUTI',NBRMA,K1BID)
      CALL WKVECT('&&OP0142.MAILL.TEMP','V V I',NBRMA,IAGM)
      DO 10 IJ=1,NBRMA
        ZI(IAGM+IJ-1) = IJ
 10   CONTINUE
      NBRMA2 = 2*NBRMA
      NBRMA1 = NBRMA + 1
C     --- CREATION D OBJETS TEMPORAIRES ---
C
      CALL WKVECT('&&OP0142.TEMP.VOIS1','V V I',NBRMA,IAV1)
      CALL WKVECT('&&OP0142.TEMP.VOIS2','V V I',NBRMA,IAV2)
      CALL WKVECT('&&OP0142.TEMP.CHM  ','V V I',NBRMA1,PTCH)
      CALL WKVECT('&&OP0142.TEMP.LNOE ','V V I',NBRMA1,LNOE)
      CALL WKVECT('&&OP0142.TEMP.NNOE ','V V K8',NBRMA1,NNOE)
      CALL WKVECT('&&OP0142.TEMP.PNOE ','V V I',NBRMA1,PNOE)
      CALL WKVECT('&&OP0142.TEMP.IABS ','V V R8',NBRMA1,IABS)
      CALL WKVECT('&&OP0142.TEMP.IACHM','V V I',NBRMA2,IACH)
      CALL WKVECT('&&OP0142.TEMP.IPOI1','V V I',NBRMA,IMA1)
      CALL WKVECT('&&OP0142.TEMP.ISEG2','V V I',NBRMA,IMA2)
C
C     TRI DES MAILLES POI1 ET SEG2
      NBSEG2=0
      NBPOI1=0
      KSEG=0
      DO 12 IM=1,NBRMA
        CALL JEVEUO (TYPMAI,'L',ITYPM)
        CALL JENUNO (JEXNUM('&CATA.TM.NOMTM',ZI(ITYPM+IM-1)),TYPM)
        IF      (TYPM .EQ. 'SEG2') THEN
           KSEG=ZI(ITYPM+IM-1)
           NBSEG2=NBSEG2+1
           ZI(IMA2+NBSEG2-1)=IM
        ELSE IF (TYPM .EQ. 'POI1') THEN
           NBPOI1=NBPOI1+1
           ZI(IMA1+NBPOI1-1)=IM
        ELSE
          CALL UTMESS('F',CMD,'IL EST POSSIBLE DE DEFINIR UNE'//
     +                ' ABSCISSE CURVILIGNE UNIQUEMENT POUR DES'//
     +                ' MAILLES DE TYPE: POI1 OU SEG2')
        ENDIF
 12   CONTINUE
      CONSEG='&&OP0142.CONNEX'
      TYPSEG='&&OP0142.TYPMAI'
      CALL WKVECT(TYPSEG,'V V I',NBRMA,ITYM)
      DO 13 IM=1,NBRMA
        ZI(ITYM-1+IM)=KSEG
 13   CONTINUE
C     IL FAUT CREER UNE TABLE DE CONNECTIVITE POUR LES SEG2
C
      NBNOMA=2*NBSEG2
      NBRSEG=NBSEG2
      NBRSE1=NBSEG2+1
      NBRSE2=NBSEG2*2
      CALL JECREC(CONSEG,'V V I','NU','CONTIG','VARIABLE',NBSEG2)
      CALL JEECRA(CONSEG,'LONT',NBNOMA,' ')
      DO 14 ISEG2=1,NBSEG2
        IM=ZI(IMA2+ISEG2-1)
        CALL JELIRA(JEXNUM(CONNEX,IM   ),'LONMAX',NBNOMA,K8BID)
        CALL JEVEUO(JEXNUM(CONNEX,IM   ),'L',IACNEX)
        CALL JEECRA(JEXNUM(CONSEG,ISEG2),'LONMAX',NBNOMA,' ')
        CALL JEVEUO(JEXNUM(CONSEG,ISEG2),'E',JGCNX)
        DO 3 INO =1,NBNOMA
           NUMNO=ZI(IACNEX-1+INO)
           ZI(JGCNX+INO-1)=NUMNO
  3     CONTINUE
 14   CONTINUE

      CALL I2VOIS(CONSEG,TYPSEG,ZI(IAGM),NBRSEG,ZI(IAV1),ZI(IAV2))
      CALL I2TGRM(ZI(IAV1),ZI(IAV2),NBRSEG,ZI(IACH),ZI(PTCH),NBCHM)
      CALL I2SENS(ZI(IACH),NBRSE2,ZI(IAGM),NBRSEG,CONSEG,TYPSEG)
C
C     --- CREATION D UNE LISTE ORDONNEE DE NOEUDS ---
      DO 20 I = 1,NBRSEG
        ISENS = 1
        MI = ZI(IACH+I-1)
        IF (MI .LT. 0) THEN
          MI = -MI
          ISENS = -1
        ENDIF
        CALL I2EXTF(MI,1,CONSEG,TYPSEG,ING,IND)
        IF (ISENS .EQ. 1) THEN
          ZI(LNOE+I-1) = ING
          ZI(LNOE+I)   = IND
        ELSE
          ZI(LNOE+I)   = ING
          ZI(LNOE+I-1) = IND
        ENDIF
  20  CONTINUE
C
      DO 30 I=1,NBRSE1
        IF (ZI(LNOE+I-1).EQ.NUM1) THEN
          IPLAC1 = I
        ENDIF
        IF (ZI(LNOE+I-1).EQ.NUM2) THEN
          IPLAC2 = I
        ENDIF
  30  CONTINUE
      IF (IPLAC1.GE.IPLAC2) THEN
        CALL UTMESS('F', CMD,'MAUVAISE DEFINITION DES NOEUDS '
     +          //'DEBUT ET FIN')
      ENDIF
C
C     --- CREATION DE L OBJET .VALE SUR LA GLOBALE ---
C
      CALL JEVEUO(COOABS,'L',LABS)
      NBRM21 = NBRSE1*2
      CALL WKVECT(NOMFON//'.VALE','G V R8',NBRM21,LVAL)
C
      DO 40 I = 1,NBRSEG
        ZR(LVAL+(I-1)) = ZR(LABS+3*(I-1))
   40 CONTINUE
C
      ZR(LVAL+NBRSEG) = ZR(LABS+3*(NBRSEG-1)+1)
C
      CALL GETVTX('VITE ','PROFIL',1,1,1,TPROF,IBID)
      IF (TPROF.EQ.'UNIFORME') THEN
        CALL GETVR8('VITE ','VALE',1,1,1,RVALE,IBID)
        DO 50 I=1,NBRSE1
          IF (I.GE.IPLAC1 .AND. I.LE.IPLAC2) THEN
            ZR(LVAL+NBRSE1+I-1) = RVALE
          ELSE
            ZR(LVAL+NBRSE1+I-1) = 0.D0
          ENDIF
  50    CONTINUE
      ELSE
        CALL GETVIS('VITE ','NB_BAV',1,1,1,NBBAV,IBID)
        IF     (NBBAV .EQ. 0) THEN
          ITP = 1
        ELSEIF (NBBAV .EQ. 2) THEN
          ITP = 2
        ELSEIF (NBBAV .EQ. 3) THEN
          ITP = 3
        ENDIF
C
        CALL PRVITE(ZR(LVAL),NBRM21,IPLAC1,IPLAC2,ITP)
C
      ENDIF
C
C
C     --- VERIFICATION QU'ON A BIEN CREER UNE FONCTION ---
C         ET REMISE DES ABSCISSES EN ORDRE CROISSANT
      CALL ORDONN(NOMFON,NOMCMD,0)
C
C     --- CREATION D'UN TITRE ---
      CALL TITRE()
C
C     --- IMPRESSIONS ---
      IF (NIV.GT.1) CALL FOIMPR(NOMFON,NIV,IFM,0,' ')
      CALL JEDEMA()
      END
