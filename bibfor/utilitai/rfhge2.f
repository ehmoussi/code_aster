      SUBROUTINE RFHGE2 ( TRANGE )
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*(*)       TRANGE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 30/01/2006   AUTEUR LEBOUVIE F.LEBOUVIER 
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
C
C     OPERATEUR "RECU_FONCTION"  MOT CLE "HARM_GENE"
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
      CHARACTER*32     JEXNUM, JEXNOM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*1  TYPE,COLI,K1BID
      CHARACTER*4  INTERP(2)
      CHARACTER*8  K8B, CRIT, NOEUD, CMP, NOMA, NOMMOT, BASEMO
      CHARACTER*8  MONMOT(2), NOGNO, MATPRO, K8BID, INTRES
      CHARACTER*14 NUME
      CHARACTER*16 NOMCMD, TYPCON, NOMCHA, NOMSY,TYPBAS
      CHARACTER*19 NOMFON, KNUME, KINST, RESU, MATRAS, FONCT
      CHARACTER*24 CHAMP
      COMPLEX*16   CREP,CBID
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
C
      CALL GETRES ( NOMFON , TYPCON , NOMCMD )
C
      RESU = TRANGE
      INTERP(1) = 'NON '
      INTERP(2) = 'NON '
      INTRES    = 'NON '
C
      CALL GETVTX ( ' ', 'CRITERE'     ,1,1,1, CRIT  , N1 )
      CALL GETVR8 ( ' ', 'PRECISION'   ,1,1,1, EPSI  , N1 )
      CALL GETVTX ( ' ', 'INTERP_NUME' ,1,1,1, INTRES, N1 )
      CALL GETVTX ( ' ', 'INTERPOL'    ,1,1,2, INTERP, N1 )
      IF ( N1 .EQ. 1 ) INTERP(2) = INTERP(1)
C
      NOEUD = ' '
      CMP   = ' '
      CALL GETVTX ( ' ', 'NOM_CMP',  1,1,1, CMP,    N1  )
      CALL GETVTX ( ' ', 'NOM_CHAM', 1,1,1, NOMCHA, N2  )
      CALL GETVID ( ' ', 'NOEUD',    1,1,1, NOEUD,  N3  )
      CALL GETVID ( ' ', 'GROUP_NO', 1,1,1, NOGNO,  NGN )
C
      KNUME = '&&RFHGE2.NUME_ORDR'
      KINST = '&&RFHGE2.FREQUENCE'
      CALL RSHARM ( INTRES, RESU, ' ', 1, KINST, KNUME, NBORDR, IE )
      IF (IE.NE.0) THEN
         CALL UTMESS('F','RFHGE2','PROBLEME(S) RENCONTRE(S) LORS'//
     +                        ' DE LA LECTURE DES FREQUENCES.' )
      ENDIF
      CALL JEEXIN(KINST,IRET)
      IF (IRET.GT.0) THEN
        CALL JEVEUO(KINST,'L',JINST)
        CALL JEVEUO(KNUME,'L',LORDR)
      END IF
C
C     --- CREATION DE LA FONCTION ---
C
      CALL WKVECT ( NOMFON//'.PROL', 'G V K16', 5, LPRO )
      ZK16(LPRO)   = 'FONCT_C         '
      ZK16(LPRO+1) = INTERP(1)//INTERP(2)
      ZK16(LPRO+2) = 'FREQ            '
      ZK16(LPRO+3) = NOMCHA
      ZK16(LPRO+4) = 'EE              '
C
      CALL WKVECT ( NOMFON//'.VALE', 'G V R', 3*NBORDR, LVAR )
      LFON = LVAR + NBORDR
C
      CALL JEVEUO(RESU//'.REFD','L',LREFE)
      MATPRO = ZK24(LREFE)(1:8)
      CALL JEVEUO(MATPRO//'           .REFA','L',IAREF2)
      BASEMO = ZK24(IAREF2)(1:8)
      CALL JEVEUO(BASEMO//'           .REFD','L',LREFE)
      MATRAS = ZK24(LREFE)
      CALL RSORAC(BASEMO,'LONUTI',IBID,RBID,K8BID,CBID,RBID,
     &            'ABSOLU',NBMODE,1,IBID)
      NOMSY = 'DEPL'
      
      IF (MATRAS.NE.' ') THEN
        CALL VPRECU ( BASEMO, NOMSY,-1,IBID, '&&RFHGE2.VECT.PROPRE',
     +                0, K8B, K8B,  K8B, K8B,
     +                NEQ, MXMODE, TYPE, NBPARI, NBPARR, NBPARK )
        CALL JEVEUO('&&RFHGE2.VECT.PROPRE','L',IDBASE)
        IF ( TYPE .NE. 'R' ) THEN
           CALL UTMESS('F','RFHGE2',
     +            ' ON NE TRAITE PAS LE TYPE DE MODES "'//TYPE//'".')
        ENDIF
C
        CALL DISMOI('F','NOM_NUME_DDL',MATRAS,'MATR_ASSE',IBID,NUME,IE)
        CALL DISMOI('F','NOM_MAILLA'  ,MATRAS,'MATR_ASSE',IBID,NOMA,IE)
      ELSE
        NUME = ZK24(LREFE+3)(1:14)
        CALL DISMOI('F','NOM_MAILLA',NUME,'NUME_DDL',IBID,NOMA,IE)
        CALL DISMOI('F','NB_EQUA'   ,NUME,'NUME_DDL',NEQ ,K8B ,IE)
        CALL WKVECT('&&RFHGE2.VECT.PROPRE','V V R',NEQ*NBMODE,IDBASE)
        CALL COPMO2(BASEMO,NEQ,NUME,NBMODE,ZR(IDBASE))
      ENDIF

      IF (NGN.NE.0) THEN
        CALL JENONU(JEXNOM(NOMA//'.GROUPENO',NOGNO),IGN2)
        IF (IGN2.LE.0)  CALL UTMESS('F','RFHGE2','LE GROUP_NO : '//
     +                                     NOGNO//'N''EXISTE PAS.')
        CALL JEVEUO(JEXNUM(NOMA//'.GROUPENO',IGN2),'L',IAGNO)
        INO = ZI(IAGNO)
        CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',INO),NOEUD)
      ENDIF
      CALL POSDDL('NUME_DDL',NUME,NOEUD,CMP,INOEUD,IDDL)
      IF ( INOEUD .EQ. 0 ) THEN
         LG1 = LXLGUT(NOEUD)
         CALL UTMESS('F','RFHGE2',
     +               'LE NOEUD "'//NOEUD(1:LG1)//'" N''EXISTE PAS.')
      ELSEIF ( IDDL .EQ. 0 ) THEN
         LG1 = LXLGUT(NOEUD)
         LG2 = LXLGUT(CMP)
         CALL UTMESS('F','RFHGE2','LA COMPOSANTE "'//CMP(1:LG2)//'" '//
     +               'DU NOEUD "'//NOEUD(1:LG1)//'" N''EXISTE PAS.')
      ENDIF
C
C     --------------------------------------------------------------
      JJ = 0
      IF ( INTRES(1:3) .NE. 'NON' ) THEN
         CALL JEVEUO(RESU//'.FREQ','L',IDINSG)
         CALL JELIRA(RESU//'.FREQ','LONMAX',NBINSG,K8B)
         CALL WKVECT('&&RFHGE2.VECTGENE','V V C',NBMODE,IDVECG)
         DO 50 IORDR = 0, NBORDR-1
            CALL ZXTRAC(INTRES,EPSI,CRIT,NBINSG,ZR(IDINSG),
     +                  ZR(JINST+IORDR),NOMCHA(1:4),RESU(1:8),NBMODE,
     +                  ZC(IDVECG),IERD)
            CALL MDGEP5(NEQ,NBMODE,ZR(IDBASE),ZC(IDVECG),IDDL,CREP)
            ZR(LVAR+IORDR) = ZR(JINST+IORDR)
            ZR(LFON+JJ) = DBLE(CREP)
            JJ = JJ +1
            ZR(LFON+JJ) = DIMAG(CREP)
            JJ = JJ +1
 50      CONTINUE
         CALL JEDETR('&&RFHGE2.VECTGENE')
C
      ELSE
         DO 52 IORDR = 0, NBORDR-1
            II = ZI(LORDR+IORDR)
            CALL RSEXCH(RESU,'DEPL',II,CHAMP,IRET)
            CALL JEVEUO(CHAMP(1:19)//'.VALE','L',ITRESU)
            CALL MDGEP5(NEQ,NBMODE,ZR(IDBASE),ZC(ITRESU),IDDL,CREP)
            ZR(LVAR+IORDR) = ZR(JINST+IORDR)
            ZR(LFON+JJ) = DBLE(CREP)
            JJ = JJ +1
            ZR(LFON+JJ) = DIMAG(CREP)
            JJ = JJ +1
            CALL JELIBE(CHAMP(1:19)//'.VALE')
 52      CONTINUE
      ENDIF
      CALL JEDETR( '&&RFHGE2.VECT.PROPRE' )
C
C     ---------------------------------------------------------------
 9999 CONTINUE
      CALL JEDETR( KNUME )
      CALL JEDETR( KINST )
C
      CALL JEDEMA()
      END
