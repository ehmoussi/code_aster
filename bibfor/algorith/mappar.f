      SUBROUTINE MAPPAR(PREMIE,NOMA  ,NUMEDD,DEFICO,RESOCO)
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
      LOGICAL      PREMIE
      CHARACTER*8  NOMA
      CHARACTER*24 DEFICO,RESOCO
      CHARACTER*24 NUMEDD
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE)
C
C REALISE L'APPARIEMENT ENTRE SURFACE ESCLAVE ET SURFACE MAITRE POUR 
C LE CONTACT METHODE CONTINUE
C      
C ----------------------------------------------------------------------
C
C
C METHODE : POUR CHAQUE POINT DE CONTACT (SUR UNE MAILLE ESCLAVE ET
C AVEC UN SCHEMA D'INTEGRATION DONNE), ON RECHERCHE LE NOEUD MAITRE LE
C PLUS PROCHE ET ON PROJETTE SUR LES MAILLES QUI L'ENTOURE
C
C STOCKAGE DES POINTS  DE CONTACT DES SURFACES  ESCLAVES ET APPARIEMENT
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  PREMIE : VAUT .TRUE. SI PREMIER INSTANT DE STAT/DYNA_NON_LINE
C IN  DEFICO : SD POUR LA DEFINITION DE CONTACT
C IN  NUMEDD : NOM DE LA NUMEROTATION MECANIQUE
C IN  RESOCO : SD POUR LA RESOLUTION DE CONTACT
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
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      ZBEXFR
      PARAMETER    (ZBEXFR=3)
      INTEGER      NBEXFR,NDEXFR(ZBEXFR)      
      INTEGER IFM,NIV
      INTEGER ZTABF,CFMMVD,ZMAES
      INTEGER IMAE,IPC,ISURFM
      INTEGER NTMAE,NDIM,NTPC,NBPC
      INTEGER IZONE,TYCO,IRET,NEQ
      INTEGER POSMAE,POSNOM,POSMAM,POSNOE
      INTEGER NUMMAE,NUMMAM
      INTEGER ITEMAX,IBID
      REAL*8       KSI1,KSI2
      REAL*8       TAU1M(3),TAU2M(3),TAU1(3),TAU2(3)
      REAL*8       COORPC(3),LAMBDA
      REAL*8       KSIPC1,KSIPC2,WPC
      REAL*8       DIR(3),TOLEOU,JEU 
      REAL*8       CFDISR,R8BID(3),EPSMAX
      CHARACTER*8  ALIAS,K8BID
      CHARACTER*24 COTAMA,MAESCL,TABFIN,NDIMCO
      INTEGER      JMACO,JMAESC,JTABF,JDIM
      CHARACTER*24 NOMACO,PNOMA,PZONE
      INTEGER      JNOMA,JPONO,JZONE
      CHARACTER*24 K24BLA,K24BID
      LOGICAL      PROJIN,LLISS,LBID,LFROTT,LSSRAC
      LOGICAL      COMPLI,CTCINI,DIRAPP,LPIVAU,LFFISS,LSSCON
      LOGICAL      EXNOEC,EXNOEF,EXNOER,EXNOEB
      INTEGER      CFDISI,TYPBAR
      INTEGER      NUNOBA(3),NUNFBA(2)   
      CHARACTER*24 DEPGEO,OLDGEO,NEWGEO    
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('CONTACT',IFM,NIV) 
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<CONTACT> APPARIEMENT' 
      ENDIF             
C      
C --- RECUPERATION DE QUELQUES DONNEES      
C
      NOMACO = DEFICO(1:16)//'.NOMACO'
      PNOMA  = DEFICO(1:16)//'.PNOMACO'
      COTAMA = DEFICO(1:16)//'.MAILCO'
      MAESCL = DEFICO(1:16)//'.MAESCL'
      TABFIN = DEFICO(1:16)//'.TABFIN'
      NDIMCO = DEFICO(1:16)//'.NDIMCO'
      PZONE  = DEFICO(1:16)//'.PZONECO'
      CALL JEVEUO(PZONE, 'L',JZONE )      
      CALL JEVEUO(NOMACO,'L',JNOMA)
      CALL JEVEUO(PNOMA ,'L',JPONO)
      CALL JEVEUO(COTAMA,'L',JMACO)
      CALL JEVEUO(MAESCL,'L',JMAESC)
      CALL JEVEUO(TABFIN,'E',JTABF)
      CALL JEVEUO(NDIMCO,'E',JDIM)
C
      ZTABF = CFMMVD('ZTABF')  
      ZMAES = CFMMVD('ZMAES')
C
C --- INITIALISATIONS
C

      IZONE  = 0
      EXNOEB = .FALSE.
      EXNOER = .FALSE.
      NTMAE  = ZI(JMAESC)
      NTPC   = 0
      NDIM   = ZI(JDIM)
      K24BLA = ' '  
      OLDGEO = NOMA(1:8)//'.COORDO'
      DEPGEO = RESOCO(1:14)//'.DEPG' 
      NEWGEO = '&&MAPPAR.ACTUGEO'  
      CALL DISMOI('F','NB_EQUA',NUMEDD,'NUME_DDL',NEQ,K8BID,IRET)       
C
C --- INFOS GENERIQUES POUR L'ALGORITHME D'APPARIEMENT
C         
      TOLEOU = CFDISR(DEFICO,'TOLE_PROJ_EXT' ,IZONE )
      EPSMAX = CFDISR(DEFICO,'PROJ_NEWT_RESI',IZONE )
      ITEMAX = CFDISI(DEFICO,'PROJ_NEWT_ITER',IZONE )     
C
C --- REACTUALISATION DE LA GEOMETRIE
C       
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<CONTACT> ... REACTUALISATION DES DEPLACEMENTS' 
      ENDIF      
      CALL VTGPLD(OLDGEO,1.D0,DEPGEO,'V',NEWGEO)       
C
C --- GESTION AUTOMATIQUE DES RELATIONS REDONDANTES     
C     
      CALL REDNEX(NUMEDD,NEQ   ,RESOCO)                     
C
C --- CALCUL DES NORMALES/TANGENTES EN CHAQUE NOEUD (SI NECESSAIRE)
C     
      CALL CFCALN(NOMA  ,DEFICO,NEWGEO,'CONTINUE',ITEMAX,
     &            EPSMAX)
C    
C --- BOUCLE SUR LES MAILLES ESCLAVES
C
      DO 20 IMAE = 1,NTMAE
C
C --- ZONE DE CONTACT 
C
        IZONE  = ZI(JMAESC+ZMAES*(IMAE-1)+2)   
        ISURFM = ZI(JZONE+IZONE)   
C
C --- OPTIONS SUR LA ZONE DE CONTACT
C    
        CALL MMINFP(IZONE ,DEFICO,K24BLA,'SEUIL_INIT'       ,
     &              IBID  ,LAMBDA,K24BID,LBID)
        LAMBDA = -ABS(LAMBDA)
        CALL MMINFP(IZONE ,DEFICO,K24BLA,'INTEGRATION'      ,
     &              TYCO  ,R8BID ,K24BID,LBID)
        CALL MMINFP(IZONE ,DEFICO,K24BLA,'LISSAGE'          ,
     &              IBID  ,R8BID ,K24BID,LLISS)        
        CALL MMINFP(IZONE ,DEFICO,K24BLA,'TYPE_APPA'        ,
     &              IBID  ,DIR   ,K24BID,DIRAPP)         
        CALL MMINFP(IZONE ,DEFICO,K24BLA,'COMPLIANCE'       ,
     &              IBID  ,R8BID ,K24BID,COMPLI)  
        CALL MMINFP(IZONE ,DEFICO,K24BLA,'CONTACT_INIT'     ,
     &              IBID  ,R8BID ,K24BID,CTCINI)
        CALL MMINFP(IZONE ,DEFICO,K24BLA,'EXCLUSION_PIV_NUL',
     &              IBID  ,R8BID ,K24BID,LPIVAU)
        CALL MMINFP(IZONE ,DEFICO,K24BLA,'FOND_FISSURE'     ,
     &              IBID  ,R8BID ,K24BID,LFFISS)     
        CALL MMINFP(IZONE ,DEFICO,K24BLA,'FROTTEMENT'       ,
     &              IBID  ,R8BID ,K24BID,LFROTT)   
        CALL MMINFP(IZONE ,DEFICO,K24BLA,'SANS_GROUP_NO'    ,
     &              IBID  ,R8BID ,K24BID,LSSCON) 
        CALL MMINFP(IZONE ,DEFICO,K24BLA,'RACCORD_LINE_QUAD',
     &              IBID  ,R8BID ,K24BID,LSSRAC)
C
C --- INFOS SUR LA MAILLE ESCLAVE COURANTE
C       
        POSMAE = ZI(JMAESC+ZMAES*(IMAE-1)+1)
        NUMMAE = ZI(JMACO +POSMAE-1)
        NBPC   = ZI(JMAESC+ZMAES*(IMAE-1)+3)      
        CALL MMELTY(NOMA,NUMMAE,ALIAS,IBID,IBID)              
C
C --- ON TESTE SI LA MAILLE EST UNE MAILLE DE FISSURE
C --- GROUP_MA_FOND OU MAILLE_FOND
C
        IF (LFFISS) THEN
          CALL MMFOND(NOMA  ,DEFICO,IZONE ,NBPC  ,POSMAE,
     &                TYPBAR,NUNOBA,NUNFBA,EXNOEB)
        ENDIF 
C
C --- ON TESTE SI LA MAILLE ESCLAVE CONTIENT DES NOEUDS INTERDITS DANS
C --- SANS_GROUP_NO_FR OU SANS_NOEUD_FR
C
        IF (LFROTT) THEN
          CALL MMFREX(DEFICO,IZONE ,POSMAE,NBPC   ,NBEXFR,
     &                NDEXFR)
        ENDIF               
C
C --- APPARIEMENT - BOUCLE SUR LES POINTS DE CONTACT
C              
        DO 10 IPC = 1,NBPC        
C
C --- COORDONNEES DANS ELEMENT DE REFERENCE ET POIDS DU POINT DE CONTACT
C
          CALL MMGAUS(ALIAS ,TYCO  ,IPC   ,KSIPC1,KSIPC2,
     &                WPC)
C
C --- CALCUL DES COORDONNEES REELLES DU POINT DE CONTACT          
C 
          CALL MCOPCO(NOMA  ,NEWGEO,NUMMAE,KSIPC1,KSIPC2,
     &                COORPC)
C
C --- RECHERCHE DU NOEUD MAITRE LE PLUS PROCHE DU POINT DE CONTACT
C
          CALL MMREND(DEFICO,NEWGEO,ISURFM,COORPC,DIRAPP,
     &                DIR   ,POSNOM)
C
C --- PROJECTION DU POINT DE CONTACT SUR LA MAILLE MAITRE
C
          CALL MMREMA(NOMA  ,DEFICO,NEWGEO,IZONE ,COORPC,
     &                POSNOM,ITEMAX,EPSMAX,TOLEOU,DIRAPP,
     &                DIR   ,POSMAM,NUMMAM,JEU   ,TAU1M ,
     &                TAU2M ,KSI1  ,KSI2  ,PROJIN)
C
C --- NOEUD ESCLAVE COURANT
C
          IF (TYCO.EQ.1) THEN
            POSNOE = ZI(JNOMA+ZI(JPONO+POSMAE-1)+IPC-1)
          ELSE
            POSNOE = 0  
          ENDIF      
C
C --- EXCLUE LES NOEUDS SUIVANT OPTIONS   
C  
          CALL MMEXCR(DEFICO,LFROTT,LSSCON,LSSRAC,IZONE ,
     &                POSMAE,IPC   ,EXNOEC,EXNOEF,EXNOER)
C          
C --- RE-DEFINITION BASE TANGENTE SUIVANT OPTIONS    
C          
          CALL MMTANR(NOMA  ,NDIM  ,NEQ   ,DEFICO,RESOCO,
     &                IZONE ,LLISS ,LPIVAU,LFROTT,POSMAE,
     &                POSMAM,NUMMAM,POSNOE,IPC   ,KSIPC1,
     &                KSIPC2,KSI1  ,KSI2  ,TAU1M ,TAU2M ,
     &                EXNOEC,EXNOEF,NBEXFR,NDEXFR,TAU1  ,
     &                TAU2) 
C          
C --- STOCKAGE DES VALEURS DANS LA CARTE (VOIR MMCART)
C   
          ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+1)  = NUMMAE
          ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+2)  = NUMMAM
          ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+3)  = KSIPC1
          ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+12) = KSIPC2          
          ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+4)  = KSI1
          ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+5)  = KSI2
          ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+6)  = TAU1(1)
          ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+7)  = TAU1(2)
          ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+8)  = TAU1(3)
          ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+9)  = TAU2(1)
          ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+10) = TAU2(2)
          ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+11) = TAU2(3)
          ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+15) = IZONE
          ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+16) = WPC
          ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+23) = IMAE 
          IF (PREMIE) THEN
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+14) = LAMBDA
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+21) = 0.D0
          END IF
C          
C --- CONTACT_INIT
C 
          IF (PREMIE) THEN
            IF (CTCINI) THEN
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+13) = 1.D0
            ELSE
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+13) = 0.D0
            END IF
          ENDIF  
C
C --- COMPLIANCE
C          
          IF (.NOT.COMPLI) THEN 
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+21) = 1.D0
          END IF
C
C --- NOEUDS EXCLUS PAR PROJECTION HORS ZONE
C              
          IF (.NOT. PROJIN) THEN
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+22) = 1.D0
          ELSE
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+22) = 0.D0
          ENDIF
C
C --- NOEUDS EXCLUS PAR SANS_GROUP_NO_FR
C           
          IF (EXNOEF) THEN
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+17) = NBEXFR
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+18) = NDEXFR(1)
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+19) = NDEXFR(2)
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+20) = NDEXFR(3)   
          ELSE
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+17) = 0.D0
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+18) = 0.D0
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+19) = 0.D0
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+20) = 0.D0          
          ENDIF         
C
C --- NOEUDS EXCLUS PAR GROUP_NO_FOND
C     
          IF (EXNOEB) THEN
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+24) = IMAE
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+27) = TYPBAR
            IF (IPC .EQ. NUNOBA(1)) THEN
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+25) = NUNOBA(1)
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+26) = NUNFBA(1)
            ELSEIF (IPC .EQ. NUNOBA(2)) THEN
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+25) = NUNOBA(2)
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+26) = NUNFBA(2)
            ELSEIF (IPC .EQ. NUNOBA(3)) THEN
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+25) = NUNOBA(3)
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+26) = (NUNOBA(1)*
     &                                                NUNOBA(2))
            ELSE
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+25) = 0.D0
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+26) = 0.D0      
            ENDIF            
          ELSE
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+24) = 0.D0
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+25) = 0.D0
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+26) = 0.D0
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+27) = 0.D0
          END IF
C
C --- NOEUDS EXCLUS PAR GROUP_NO_RACC
C   
          IF (EXNOER) THEN
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+28) = IPC
          ELSE
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+28) = 0.D0
          END IF   
C
C --- NOEUDS EXCLUS PAR GESTION AUTOMATIQUE DES 
C --- RELATIONS SURABONDANTES AVEC LE CONTACT OU SANS_GROUP_NO
C
          IF (EXNOEC) THEN
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+29) = 1.D0
          END IF
                                
 10     CONTINUE
        NTPC = NTPC + NBPC
 20   CONTINUE
C
      ZR(JTABF-1+1) = NTPC
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        CALL MMIMP1(IFM   ,NOMA  ,DEFICO)
      ENDIF   
      CALL JEDETR(NEWGEO)    
C      
      CALL JEDEMA()
      END
