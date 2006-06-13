      SUBROUTINE POSDDL ( TYPE, RESU, NOEUD, CMP, NUNOE, NUDDL )
      IMPLICIT  NONE
      CHARACTER*(*)       TYPE, RESU, NOEUD, CMP
      INTEGER             NUNOE, NUDDL
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 14/01/98   AUTEUR VABHHTS J.PELLET 
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
C     ------------------------------------------------------------------
C     DONNE LE NUMERO DU NOEUD
C           NUNOE = 0 SI LE NOEUD N'EXISTE PAS
C     DONNE LE NUMERO DU DDL ASSOCIE AU NOEUD ET A SA COMPOSANTE
C           NUDDL = 0 SI LE COUPLE (NOEUD,COMPOSANTE) N'EXISTE PAS
C     ------------------------------------------------------------------
C IN  TYPE   : TYPE DU RESU
C IN  RESU   : NOM D'UN NUME_DDL OU D'UN CHAM_NO
C IN  NOEUD  : NOM DU NOEUD
C IN  CMP    : NOM DE LA COMPOSANTE
C OUT NUNOE  : NUMERO LOCAL DU NOEUD
C OUT NUDDL  : NUMERO DU DDL ASSOCIE AU NOEUD DE COMPOSANTE CMP
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
      CHARACTER*16            ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*32     JEXNUM, JEXNOM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER       IBID, IER, GD, NBEC, IEC, NEC, NCMPMX, ICMPRE,
     +              ICMP, JPRNO, JNUEQ, IAD, TABEC(10)
      CHARACTER*8   K8B, NOMMA, NOMCMP, NCMP
      CHARACTER*19  PRNO
      LOGICAL       EXISDG
C     ------------------------------------------------------------------
      CALL JEMARQ()
C
      IF ( TYPE(1:8) .EQ. 'NUME_DDL' ) THEN
         CALL DISMOI('F','NOM_MAILLA',RESU,'NUME_DDL',IBID,NOMMA,IER)
         CALL DISMOI('F','NUM_GD_SI', RESU,'NUME_DDL',GD  ,K8B  ,IER)
         PRNO( 1:14) = RESU
         PRNO(15:19) = '.NUME'
C
      ELSEIF ( TYPE(1:7) .EQ. 'CHAM_NO' ) THEN
         CALL DISMOI('F','NOM_MAILLA', RESU, 'CHAM_NO',IBID,NOMMA,IER)
         CALL DISMOI('F','PROF_CHNO' , RESU, 'CHAM_NO',IBID,PRNO ,IER)
         CALL DISMOI('F','NUM_GD'    , RESU, 'CHAM_NO',GD  ,K8B  ,IER)
C
      ELSE
         CALL UTMESS('F','POSDDL',' TYPE INCONNU')
      ENDIF
C
      CALL JENONU ( JEXNOM(NOMMA//'.NOMNOE',NOEUD) , NUNOE )
      IF ( NUNOE .EQ. 0 ) GOTO 9999
C
      NCMP  = CMP
      NUDDL = 0
C
      CALL JENONU(JEXNOM(PRNO//'.LILI','&MAILLA'),IBID)
      CALL JEVEUO(JEXNUM(PRNO//'.PRNO',IBID), 'L', JPRNO )
      CALL JEVEUO ( PRNO//'.NUEQ', 'L', JNUEQ )
C
      NEC = NBEC( GD )
      IF ( NEC .GT. 10 ) CALL UTMESS('F','POSDDL','NEC TROP GRAND')
      CALL JEVEUO(JEXNUM('&CATA.GD.NOMCMP',GD),'L',IAD)
      CALL JELIRA(JEXNUM('&CATA.GD.NOMCMP',GD),'LONMAX',NCMPMX,K8B)
      DO 10 IEC = 1 , NEC
         TABEC(IEC)= ZI(JPRNO-1+(NUNOE-1)*(NEC+2)+2+IEC )
 10   CONTINUE
C
      ICMPRE = 0
      DO 20 ICMP = 1 , NCMPMX
         IF ( EXISDG(TABEC,ICMP) ) THEN
            ICMPRE = ICMPRE + 1
            NOMCMP = ZK8(IAD-1+ICMP)
            IF ( NOMCMP .EQ. NCMP ) THEN
               NUDDL = ZI(JNUEQ+ZI(JPRNO+(NEC+2)*(NUNOE-1))-1)+ICMPRE-1
               GOTO 22
            ENDIF
         ENDIF
 20   CONTINUE
 22   CONTINUE
C
 9999 CONTINUE
      CALL JEDEMA()
      END
