      SUBROUTINE MMMBCA(NOMA  ,DEFICO,RESOCO,INST  ,VALPLU,
     &                  MMCVCA)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 01/04/2008   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*8   NOMA
      CHARACTER*24  DEFICO,RESOCO
      CHARACTER*24  VALPLU(8)
      LOGICAL       MMCVCA 
      REAL*8        INST(*)
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE)
C
C ALGO. DES CONTRAINTES ACTIVES POUR LE CONTACT METHODE CONTINUE
C      
C ----------------------------------------------------------------------
C
C      
C  POUR LES POINTS POSTULES CONTACTANTS ON REGARDE LE SIGNE DE LAMBDA
C  POUR LES POINTS POSTULES NON CONTACTANTS ON REGARDE L'INTEPENETRATION
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  DEFICO : SD DE DEFINITION DU CONTACT
C IN  RESOCO : SD DE RESOLUTION DU CONTACT
C IN  INST   : INST(1) - INSTANT COURANT
C              INST(2) - INCREMENT DE TEMPS
C              INST(3) - VALEUR DU THETA (INTEGRATION PAR THETA METHODE)
C IN  VALPLU : ETAT EN T+
C OUT MMCVCA : INDICATEUR DE CONVERGENCE POUR BOUCLE DES 
C              CONTRAINTES ACTIVES
C               .TRUE. SI LA BOUCLE DES CONTRAINTES ACTIVES A CONVERGE
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
      CHARACTER*32  JEXNUM,JEXNOM
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
C
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      INTEGER      CFMMVD,ZMAES,ZTABF
      INTEGER      IFM,NIV,NBNO,IER,NDIM,GD
      INTEGER      XAINI,XSINI,XSEND,NTMAE,K,XA,XS,IBID
      INTEGER      NTPC,IMAE,NBPC,IPC,IZONE,NEQ
      INTEGER      POSMAE,NUMMAE,NUMMAM,VALI(2)
      REAL*8       KSIPR1,KSIPR2,KSIPC1,KSIPC2
      REAL*8       GEOMM(3),GEOME(3),NORM(3),TAU1(3),TAU2(3)
      REAL*8       ASPERI,LAMBDC
      REAL*8       R8BID,NOOR,R8PREM
      REAL*8       JEU,JEUVIT,JEUSUP,JEUUSU
      CHARACTER*8  NOMGD,K8BID,NOMMAI
      CHARACTER*24 COTAMA,MAESCL,TABFIN,NDIMCO,JEUCON,FLIFLO,MDECOL
      INTEGER      JMACO ,JMAESC,JTABF ,JDIM  ,JJEU  ,JFLIP ,JMDECO
      CHARACTER*24 NEWGEO,OLDGEO,CHAVIT
      CHARACTER*24 K24BID,K24BLA,DEPPLU,VITPLU
      LOGICAL      LCOMPL,LGLISS,LVITES,LBID,LUSURE,EXNOE,LPIVAU,SCOTCH
      INTEGER      FLINBR,FLIPOI,FLIMAI,FLIMAX
      INTEGER      NCMPMX,POSNOE
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('CONTACT',IFM,NIV)  
C
C --- AFFICHAGE
C      
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<CONTACT> ALGORITHME DES CONTRAINTES ACTIVES' 
      ENDIF           
C
C --- ACCES OBJETS
C
      COTAMA = DEFICO(1:16)//'.MAILCO'
      NDIMCO = DEFICO(1:16)//'.NDIMCO'
      MAESCL = DEFICO(1:16)//'.MAESCL'
      TABFIN = DEFICO(1:16)//'.TABFIN'      
      JEUCON = DEFICO(1:16)//'.JEUCON'
      CALL JEVEUO(COTAMA,'L',JMACO)
      CALL JEVEUO(MAESCL,'L',JMAESC)
      CALL JEVEUO(TABFIN,'E',JTABF)
      CALL JEVEUO(NDIMCO,'L',JDIM)
      CALL JEVEUO(JEUCON,'E',JJEU)
      ZMAES = CFMMVD('ZMAES')
      ZTABF = CFMMVD('ZTABF') 
C
C --- DECOMPACTION DES VARIABLES CHAPEAUX
C       
      CALL DESAGG(VALPLU,DEPPLU,K24BID,K24BID,K24BID,
     &            VITPLU,K24BID,K24BID,K24BID) 
      CALL JELIRA(DEPPLU(1:19)//'.VALE','LONMAX',NEQ,K8BID)        
C
C --- INDICATEUR DE DECOLLEMENT DANS COMPLIANCE
C
      MDECOL = RESOCO(1:14)//'.MDECOL'
      CALL JEVEUO(MDECOL,'E',JMDECO)  
      SCOTCH = ZL(JMDECO+1-1)                             
C
C --- REACTUALISATION DE LA GEOMETRIE
C       
      OLDGEO = NOMA//'.COORDO'
      NEWGEO = '&&MMMBCA.ACTUGEO'
      CALL VTGPLD(OLDGEO,1.0D0,DEPPLU,'V',NEWGEO)
C
C --- POUR LA FORMULATION VITESSE, ON CREEE UN CHAMP DE VITESSE
C     CE N'EST PAS TRES ELEGANT, MAIS CA MARCHE, EN ATTENDANT MIEUX...
C
      CALL MMINFP(0,DEFICO,K24BLA,'FORMUL_VITE',
     &            IBID,R8BID,K24BID,LVITES)
      CHAVIT = '&&MMMBCA.ACTUVIT'
      IF (LVITES) THEN    
        CALL VTGPLK(OLDGEO,1.0D0,VITPLU,'V',CHAVIT)
      ENDIF
C
C --- INITIALISATIONS
C      
      NDIM   = ZI(JDIM)
      NTMAE  = ZI(JMAESC)
      NBNO   = ZR(JTABF)      
      NTPC   = 0 
      K24BLA = ' '
      MMCVCA = .TRUE.  
      NOMGD  = 'NEUT_R'
      CALL JENONU(JEXNOM('&CATA.GD.NOMGD',NOMGD),GD)
      CALL JELIRA(JEXNUM('&CATA.GD.NOMCMP',GD),'LONMAX',NCMPMX,K8BID)
C     
C --- ACCES SD POUR LE FLIP-FLOP
C
      FLINBR = 0
      FLIPOI = 0 
      FLIMAI = 0            
      CALL MMINFP(0,DEFICO,K24BLA,'FLIP_FLOP_IMAX',
     &            FLIMAX,R8BID,K24BID,LBID)
      FLIFLO = RESOCO(1:14)//'.FLIPFLOP '
      CALL JEEXIN(FLIFLO,IER)
      IF (IER.EQ.0) THEN
        CALL WKVECT(FLIFLO,'V V I',NBNO,JFLIP)
      ELSE
        CALL JEVEUO(FLIFLO,'E',JFLIP)
      ENDIF  
C      
C --- BOUCLE SUR LES MAILLES ESCLAVES
C
      DO 30 IMAE = 1,NTMAE
C
C --- OPTIONS SUR LA ZONE DE CONTACT
C    
        IZONE  = ZI(JMAESC+ZMAES*(IMAE-1)+2)          
        CALL MMINFP(IZONE,DEFICO,K24BLA,'COMPLIANCE',
     &              IBID,R8BID,K24BID,LCOMPL)        
        CALL MMINFP(IZONE,DEFICO,K24BLA,'FORMUL_VITE',
     &              IBID,R8BID,K24BID,LVITES) 
        CALL MMINFP(IZONE,DEFICO,K24BLA,'ASPERITE',
     &              IBID,ASPERI,K24BID,LBID)                 
        CALL MMINFP(IZONE,DEFICO,K24BLA,'GLISSIERE',
     &              IBID,R8BID,K24BID,LGLISS)
        CALL MMINFP(IZONE,DEFICO,K24BLA,'USURE',
     &              IBID,R8BID,K24BID,LUSURE)  
        CALL MMINFP(IZONE,DEFICO,K24BLA,'EXCLUSION_PIV_NUL',
     &              IBID,R8BID,K24BID,LPIVAU)
C
C --- INFOS SUR LA MAILLE ESCLAVE COURANTE
C 
        POSMAE = ZI(JMAESC+ZMAES*(IMAE-1)+1)
        NBPC   = ZI(JMAESC+ZMAES*(IMAE-1)+3)
        NUMMAE = ZI(JMACO+POSMAE-1)     
C      
C --- BOUCLE SUR LES POINTS DE CONTACT
C              
        DO 20 IPC = 1,NBPC
C
C --- COORDONNEES ACTUALISEES DU POINT DE CONTACT (SUR MAILLE ESCLAVE)
C
          KSIPC1    = ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+3)
          KSIPC2    = ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+12)
          CALL MCOPCO(NOMA,NEWGEO,NUMMAE,KSIPC1,KSIPC2,GEOME)
C
C --- COORDONNEES ACTUALISEES DE LA PROJECTION DU POINT DE CONTACT
C --- (SUR MAILLE MAITRE)
C
          KSIPR1     = ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+4)
          KSIPR2     = ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+5)
          NUMMAM     = ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+2)
          CALL MCOPCO(NOMA,NEWGEO,NUMMAM,KSIPR1,KSIPR2,GEOMM)
C            
C --- TANGENTES AU POINT DE CONTACT PROJETE SUR MAILLE MAITRE
C
          TAU1(1) = ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+6)
          TAU1(2) = ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+7)
          TAU1(3) = ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+8)
          TAU2(1) = ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+9)
          TAU2(2) = ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+10)
          TAU2(3) = ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+11)
C            
C --- CALCUL DE LA NORMALE
C
          CALL MMNORM(NDIM,TAU1,TAU2,NORM,NOOR)
          IF (NOOR.LE.R8PREM()) THEN
            CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',NUMMAM),NOMMAI) 
            CALL U2MESG('F','CONTACT3_23',1,NOMMAI,0,0,3,GEOMM) 
          ENDIF             
C                               
C --- COMPLIANCE   (XA=0: ON NE TOUCHE PAS LES ASPERITES) 
C --- SI PAS DE COMPLIANCE ACTIVEE: XA VAUT TOUJOURS 1        
C
          XA     = NINT(ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+21))
          XAINI  = XA
C
C --- INDICATEUR DE CONTACT (XS=0: PAS DE CONTACT)
C --- ON SAUVE L'ETAT INITIAL DE CE POINT DANS XSINI
C
          XS     = NINT(ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+13))
          XSINI  = XS 
C
C --- CALCUL DU JEU ACTUALISE AU POINT DE CONTACT 
C            
          JEU = 0.D0
          DO 10 K = 1,3
           JEU = JEU + (GEOME(K)-GEOMM(K))*NORM(K)
   10     CONTINUE
C
          CALL MMUSUR(DEFICO,RESOCO,NCMPMX,IZONE ,IMAE  ,
     &                IPC   ,NBPC  ,JEUUSU)
C GLUTE POUR BUG DIST_*
          POSNOE = IZONE
          CALL CFDIST(DEFICO,IZONE ,POSNOE,GEOME ,INST(1),
     &                JEUSUP)
C   
          ZR(JJEU-1+NTPC+IPC) = -JEU-JEUSUP-JEUUSU
          JEU = -ZR(JJEU-1+NTPC+IPC)
C  
C --- NOEUDS EXCLUS PAR PROJECTION HORS ZONE: ON SORT DIRECT 
C         
          IF (ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+22) .EQ. 1.D0) THEN
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+13) = 0.D0
            GOTO 20
          END IF
C  
C --- NOEUDS EXCLUS PAR DETECTION AUTOMATIQUE DE REDONDANCES
C
          EXNOE=.FALSE.
          IF (LPIVAU) THEN 
            CALL REDCEX(NEQ   ,NOMA  ,DEFICO,RESOCO,NORM  ,
     &                  IPC   ,POSMAE,EXNOE)
          END IF
          IF (EXNOE) THEN
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+13) = 0.D0
            GOTO 20
          END IF
C          
C --- CALCUL DU MULTIPLICATEUR DE LAGRANGE LAMBDA DE CONTACT DU POINT
C 
          CALL CALLAM(NOMA  ,DEFICO,RESOCO,DEPPLU,POSMAE,
     &                KSIPC1,KSIPC2,LAMBDC)      
C 
C --- FORMULATION EN VITESSE
C
          IF (LVITES) THEN
C
C --- COORDONNEES ACTUALISEES DU POINT DE CONTACT
C     (SUR MAILLES ESCLAVE PUIS MAITRE)
C
            CALL MCOPCO(NOMA,CHAVIT,NUMMAE,KSIPC1,KSIPC2,GEOME)
            CALL MCOPCO(NOMA,CHAVIT,NUMMAM,KSIPR1,KSIPR2,GEOMM)
C
C --- CALCUL DU GAP DES VITESSES NORMALES 
C
            JEUVIT=0.D0
            DO 11 K=1,3
              JEUVIT = JEUVIT + (GEOME(K)-GEOMM(K)) * NORM(K)
   11       CONTINUE

          ENDIF
C
C --- ALGORITHME DES CONTRAINTES ACTIVES (PC: POINT DE CONTACT)
C
          CALL MMALGO(JTABF ,IPC   ,NTPC  ,XA    ,XS    ,
     &                LVITES,LGLISS,LCOMPL,JEU   ,JEUVIT,
     &                ASPERI,LAMBDC,MMCVCA,SCOTCH)
C
C --- TRAITEMENT DU FLIP_FLOP
C               
          IF (FLIMAX .GE. 0) THEN
            XSEND = NINT(ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+13))
            IF (XSEND .NE. XSINI) THEN       
              ZI(JFLIP+NTPC+IPC-1) = ZI(JFLIP+NTPC+IPC-1) + 1
            END IF      
            IF (ZI(JFLIP+NTPC+IPC-1) .GT. FLINBR) THEN
              FLINBR = ZI(JFLIP+NTPC+IPC-1)
              FLIPOI = IPC
              FLIMAI = NUMMAE
            ENDIF    
          ENDIF                    
C
C --- AFFICHAGE ETAT DU CONTACT
C
          IF (NIV.GE.2) THEN
            XA     = NINT(ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+21))
            XS     = NINT(ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+13))
            CALL MMIMP4(IFM   ,NOMA  ,NUMMAE,IPC   ,NTPC,
     &                  XAINI ,XSINI ,XA    ,XS    ,LVITES,
     &                  LGLISS,LCOMPL,JEU   ,JEUVIT,LAMBDC)     
          ENDIF
   20   CONTINUE
        NTPC = NTPC + NBPC
   30 CONTINUE
C
C --- ON MET LE POINT EN GLISSIERE SI LGLISS=.TRUE. ET
C     SI LA CONVERGENCE EN CONTRAINTE ACTIVE EST ATTEINTE
C
      IF (LGLISS .AND. MMCVCA) THEN
        NTPC = 0
        DO 35 IMAE = 1, NTMAE
          NBPC = ZI(JMAESC+ZMAES*(IMAE-1)+3)
          DO 25 IPC = 1, NBPC
            XA = NINT(ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+21))
            XS = NINT(ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+13))
            IF ((XA.EQ.1) .AND. (XS.EQ.1))
     &        ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+30) = 1.D0
   25       CONTINUE
          NTPC = NTPC + NBPC
   35     CONTINUE

      ENDIF
C
C --- SI FLIP-FLOP: ON FORCE LE PASSAGE A L'ITERATION SUIVANTE
C
      IF (FLIMAX .GT. 0) THEN
        IF (FLINBR .GE. FLIMAX) THEN
          CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',FLIMAI),NOMMAI) 
          VALI(1) = FLINBR
          VALI(2) = FLIPOI
          CALL U2MESG('I','CONTACT3_28',1,NOMMAI,2,VALI,0,0.D0)
          MMCVCA = .TRUE.  
        ENDIF
      ENDIF    
C
C --- SAUVEGARDE DECOLLEMENT DANS COMPLIANCE
C 
      ZL(JMDECO+1-1) =  SCOTCH
C
      IF (MMCVCA) CALL JEDETR(FLIFLO)
      CALL JEDETR(NEWGEO)
      CALL JEDETR(CHAVIT)
C
      CALL JEDEMA()
      END
